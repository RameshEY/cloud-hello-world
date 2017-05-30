provider "aws" {
    region = "eu-central-1"
}

module "ecs" {
    source = "modules/ecs"

    app_name              = "${var.app_name}"
    vpc_cidr              = "${var.vpc_cidr}"
    public_subnet_cidrs   = "${var.public_subnet_cidrs}"
    private_subnet_cidrs  = "${var.private_subnet_cidrs}"
    availibility_zones    = "${var.availibility_zones}"
    instance_type         = "${var.instance_type}"
    ecs_aws_ami           = "${var.ecs_aws_ami}"
    max_size              = "${var.max_size}"
    min_size              = "${var.min_size}"
    desired_capacity      = "${var.desired_capacity}"
}

variable "vpc_cidr" {}
variable "app_name" {}
variable "instance_type" {}
variable "ecs_aws_ami" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}

variable "private_subnet_cidrs" {
  type = "list"
}

variable "public_subnet_cidrs" {
  type = "list"
}

variable "availibility_zones" {
  type = "list"
}
