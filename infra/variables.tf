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

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH into bastion host"
  type        = list(string)
  default     = ["183.98.148.29/32"]
}

variable "acm_certificate_arn" {
  type    = string
  default = "arn:aws:acm:ap-northeast-2:725929716696:certificate/cb1dc81e-c5cb-4527-a87e-61de376a9b85"
}


## DB 전용 변수
#variable "username" {
#  description = "RDS master username"
#  type        = string
#}
#
#variable "password" {
#  description = "RDS master password"
#  type        = string
#  sensitive   = true
#}