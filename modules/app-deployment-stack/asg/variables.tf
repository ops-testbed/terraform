variable "owner" {
  type = string
}

variable "service_name" {
  description = "Service Name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "private_subnet_id" {
  type = string
}

variable "launch_template_id" {
  type = string
}

variable "target_group_arns" {
  type = list(string)
}

variable "asg_min_capacity" {
  type    = number
  default = 1
}

variable "asg_max_capacity" {
  type    = number
  default = 1
}

variable "asg_desired_capacity" {
  type    = number
  default = 1
}
