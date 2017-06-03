provider "aws" {
    region = "eu-central-1"
}

module "network" {
    source = "modules/network"

    app_name                = "${var.app_name}"
    vpc_cidr                = "${var.vpc_cidr}"
    public_subnet_cidrs     = "${var.public_subnet_cidrs}"
    private_subnet_cidrs    = "${var.private_subnet_cidrs}"
    availibility_zones      = "${var.availibility_zones}"
}

module "alb" {
    source = "modules/alb"

    route53_name            = "${var.route53_name}"
    vpc_id                  = "${module.network.vpc_id}"
    app_name                = "${var.app_name}"
    security_group_id       = "${module.network.elb_https_http_id}"
    public_subnet_ids       = "${module.network.public_subnet_ids}"
    certificate_arn         = "${var.certificate_arn}"
}

module "ec2" {
    source = "modules/ec2"
    
    app_name                = "${var.app_name}"
    instance_type           = "${var.instance_type}"
    ecs_aws_ami             = "${var.ecs_aws_ami}"
    security_group_id       = "${module.network.sg_elb_to_app_id}"
    iam_instance_profile    = "${module.iam_roles.ecs_instance_profile_arn}"
    ecs_cluster_name        = "bla"
    max_size                = "${var.max_size}"
    min_size                = "${var.min_size}"
    desired_capacity        = "${var.desired_capacity}"
    private_subnet_ids      = "${module.network.private_subnet_ids}"
}

module "iam_roles" {
    source = "modules/iam_roles"

    app_name                = "${var.app_name}"
}



module "ecs" {
    source = "modules/ecs"

    app_name              = "${var.app_name}"
    alb_arn                 = "${module.alb.alb_listener_arn}"
    ecs_service_role_iam_role= "${module.iam_roles.ecs_service_role_arn}"
    alb_listener_arn = "${module.alb.alb_listener_arn}"
    vpc_id = "${module.network.vpc_id}"
    #vpc_cidr              = "${var.vpc_cidr}"
    #public_subnet_cidrs   = "${var.public_subnet_cidrs}"
    #private_subnet_cidrs  = "${var.private_subnet_cidrs}"
    #availibility_zones    = "${var.availibility_zones}"
    #instance_type         = "${var.instance_type}"
    #ecs_aws_ami           = "${var.ecs_aws_ami}"
    #max_size              = "${var.max_size}"
    #min_size              = "${var.min_size}"
    #desired_capacity      = "${var.desired_capacity}"
    #route53_name          = "${var.route53_name}"
    #certificate_arn       = "${var.certificate_arn}"
}

variable "vpc_cidr" {}
variable "app_name" {}
variable "instance_type" {}
variable "ecs_aws_ami" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "route53_name" {}
variable "certificate_arn" {}

variable "private_subnet_cidrs" {
  type = "list"
}

variable "public_subnet_cidrs" {
  type = "list"
}

variable "availibility_zones" {
  type = "list"
}
