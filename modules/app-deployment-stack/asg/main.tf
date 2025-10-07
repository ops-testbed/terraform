resource "aws_autoscaling_group" "this" {
  name                = "${var.service_name}-${var.environment}-asg"
  vpc_zone_identifier = [var.private_subnet_id]
  target_group_arns   = var.target_group_arns
  health_check_type   = "EC2"

  min_size         = var.asg_min_capacity
  max_size         = var.asg_max_capacity
  desired_capacity = var.asg_desired_capacity

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Owner"
    propagate_at_launch = false
    value               = var.owner
  }

  tag {
    key                 = "Service"
    propagate_at_launch = false
    value               = var.service_name
  }

  tag {
    key                 = "Environment"
    propagate_at_launch = false
    value               = var.environment
  }

  tag {
    key                 = "Name"
    propagate_at_launch = false
    value               = "${var.service_name}-${var.environment}-asg"
  }
}
