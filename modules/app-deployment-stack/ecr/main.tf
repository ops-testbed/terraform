resource "aws_ecr_repository" "this" {
  name                 = "${var.environment}/${var.service_name}"
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(var.common_tags, {
    Name = "${var.service_name}-${var.environment}-ecr"
  })
}
