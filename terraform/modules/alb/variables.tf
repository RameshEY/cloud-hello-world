variable "app_name" {}
variable "environment" {}
variable "route53_name" {}
variable "vpc_id" {}
variable "security_group_id" {}
variable "certificate_arn" {}

variable "deregistration_delay" {
  default     = "60"
}

variable "health_check_path" {
  default     = "/"
}

variable "public_subnet_ids" {
  type        = "list"
}


