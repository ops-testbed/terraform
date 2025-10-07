variable "service_name" {
  description = "Service Name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "platform" {
  type = string
}

variable "github_url" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "key_name" {
  type = string
}