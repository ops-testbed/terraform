locals {
  common_tags = {
    Owner       = var.owner
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.project_name}-${var.environment}-deployment-bucket"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-deployment-bucket"
  })
}
