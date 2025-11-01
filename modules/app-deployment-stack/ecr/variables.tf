variable "service_name" {
  description = "Service Name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "common_tags" {
  type = map(string)
}
