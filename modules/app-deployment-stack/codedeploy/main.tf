resource "aws_codedeploy_app" "this" {
  compute_platform = "Server" # EC2/OnPrem: "Server", Lambda: "Lambda", ECS: "ECS"
  name             = "${var.service_name}-${var.environment}-codedeploy-app"

  tags = merge(var.common_tags, {
    Name = "${var.service_name}-${var.environment}-codedeploy"
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codedeploy_service_role" {
  name               = "CodeDeployServiceRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "codedeploy_service_policy" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_codedeploy_deployment_group" "example_group" {
  app_name              = aws_codedeploy_app.this.name
  deployment_group_name = "${var.service_name}-${var.environment}-dg"
  service_role_arn      = aws_iam_role.codedeploy_service_role.arn

  autoscaling_groups = ["${var.service_name}-${var.environment}-asg"]

  deployment_config_name = "CodeDeployDefault.AllAtOnce"
}
