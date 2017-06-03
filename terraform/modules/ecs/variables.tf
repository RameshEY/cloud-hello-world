variable "vpc_cidr" {}
variable "app_name" {}
variable "instance_type" {}
variable "ecs_aws_ami" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "route53_name" {}
variable "certificate_arn" {}
variable "enviroment" {}

variable "destination_cidr_block" {
    default     = "0.0.0.0/0"
}

variable "private_subnet_cidrs" {
    type        = "list"
}

variable "public_subnet_cidrs" {
    type        = "list"
}

variable "availibility_zones" {
    type        = "list"
}

