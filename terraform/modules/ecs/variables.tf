variable "vpc_cidr" {
    description = "VPC cidr block. Example: 172.16.0.0/16"
}

variable "app_name" {
    description = "The name of the application"
}

variable "destination_cidr_block" {
    default     = "0.0.0.0/0"
    description = "Specify all traffic to be routed either trough Internet Gateway or NAT to access the internet"
}

variable "private_subnet_cidrs" {
    type        = "list"
    description = "List of private cidrs: 172.16.21.0/24 and 172.16.22.0/24"
}

variable "public_subnet_cidrs" {
    type        = "list"
    description = "List of public cidrs: 172.16.0.0/24 and 172.16.1.0/24"
}

variable "availibility_zones" {
    type        = "list"
    description = "List of avalibility zones you want. eu-central-1a and eu-central-1b"
}

variable "instance_type" {}
variable "ecs_aws_ami" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}


