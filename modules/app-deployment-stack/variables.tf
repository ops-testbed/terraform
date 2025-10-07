variable "owner" {
  description = "The team responsible for managing this resource"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "ops-testbed"
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "service_name" {
  description = "Service Name"
  type        = string
}

variable "platform" {
  description = "Platform(Spring Boot, Node.js, ...)"
  type        = string
}

variable "github_url" {
  description = "Github URL"
  type        = string
}

variable "ec2_instance_type" {
  type = string
}

variable "is_apigw" {
  type = bool
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
