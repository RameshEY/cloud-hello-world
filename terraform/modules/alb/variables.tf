variable "app_name" {}
variable "environment" {}
variable "route53_name" {}
variable "vpc_id" {}
variable "security_group_id" {}
variable "certificate_arn" {}
variable "deregistration_delay" {}
variable "health_check_path" {}

variable "public_subnet_ids" {
  type        = "list"
}


