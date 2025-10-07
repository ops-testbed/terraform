terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.16"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "ap-northeast-2"
}

module "network" {
  source = "./network"

  owner            = var.owner
  project_name     = var.project_name
  vpc_cidr         = "10.23.0.0/16"
  environment      = var.environment
  allowed_ssh_cidr = var.allowed_ssh_cidrs[0]
}

module "external_alb" {
  source = "./lb"

  owner               = var.owner
  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.network.vpc_id
  isInternal          = false
  subnet_ids          = module.network.public_subnet_ids
  target_group_port   = "80"
  acm_certificate_arn = var.acm_certificate_arn
}

module "bastion" {
  source = "./bastion"

  owner             = var.owner
  project_name      = var.project_name
  environment       = var.environment
  public_subnet_id  = module.network.public_subnet_ids[0]
  vpc_id            = module.network.vpc_id
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
}

#module "db" {
#  source = "./db"
#
#  service_name   = var.service_name
#  environment    = var.environment
#  vpc_id         = module.network.vpc_id
#  allowed_sg_ids = {
#    bastion = module.bastion.bastion_security_group_id
#  }
#  allowed_cidr_blocks = module.network.was_private_subnet_cidrs
#  private_subnet_ids  = module.network.db_private_subnet_ids
#  username            = var.username
#  password            = var.password
#}