variable "app_name" {
    description = "The name of the application"
}

variable "route53_name" {}

variable "deregistration_delay" {
  default     = "300"
  description = "The default deregistration delay"
}

variable "health_check_path" {
  default     = "/"
  description = "The default health check path"
}

variable "vpc_id" {}
variable "security_group_id" {}

variable "public_subnet_ids" {
  type        = "list"
  description = "The list of public subnets to place the instances in"
}
