provider "aws" {
    region = "eu-west-1"
}

module "vpc" {
    source = "modules/vpc"

    app_name          = "${var.app_name}"
    cidr             = "${var.vpc_cidr}"
}

variable "vpc_cidr" {}
variable "app_name" {}