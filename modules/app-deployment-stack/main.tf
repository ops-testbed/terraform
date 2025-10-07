locals {
  common_tags = {
    Owner       = var.owner
    Service     = var.service_name
    Environment = var.environment
  }
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-${var.environment}-vpc"]
  }
}

data "aws_subnets" "was_private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-${var.environment}-was-private-subnet"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

data "aws_lb_target_group" "tg" {
  name = "${var.project_name}-${var.environment}-external-tg"
}

data "aws_security_group" "alb" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-${var.environment}-external-alb-sg"]
  }
  vpc_id = data.aws_vpc.this.id
}

data "aws_security_group" "bastion" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-${var.environment}-bastion-sg"]
  }
  vpc_id = data.aws_vpc.this.id
}

data "aws_ami" "standard" {
  most_recent = true

  filter {
    name   = "tag:Name"
    values = ["standard-ami"]
  }
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }

  owners = ["self"]
}

resource "aws_security_group" "was" {
  name   = "${var.service_name}-${var.environment}-was-sg"
  vpc_id = data.aws_vpc.this.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb.id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [data.aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.service_name}-${var.environment}-was-sg"
  })
}

module "lt" {
  source = "./lt"

  service_name      = var.service_name
  environment       = var.environment
  platform          = var.platform
  github_url        = var.github_url
  ec2_instance_type = var.ec2_instance_type
  key_name          = "dummy"
  security_group_id = aws_security_group.was.id
  ami_id            = data.aws_ami.standard.id
  common_tags       = local.common_tags
}

module "asg" {
  source = "./asg"

  owner                = var.owner
  service_name         = var.service_name
  environment          = var.environment
  private_subnet_id    = element(data.aws_subnets.was_private_subnet.ids, 0)
  launch_template_id   = module.lt.launch_template_id
  target_group_arns    = var.is_apigw ? [data.aws_lb_target_group.tg.arn] : []
  asg_min_capacity     = var.asg_min_capacity
  asg_max_capacity     = var.asg_max_capacity
  asg_desired_capacity = var.asg_desired_capacity
}

module "ecr" {
  source = "./ecr"

  service_name = var.service_name
  environment  = var.environment
  common_tags  = local.common_tags
}

module "codedeploy" {
  source = "./codedeploy"

  service_name = var.service_name
  environment  = var.environment
  common_tags  = local.common_tags
}