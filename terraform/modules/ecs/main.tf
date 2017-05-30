module "ec2" {
    source = "../ec2"
    
    app_name                = "${var.app_name}"
    instance_type           = "${var.instance_type}"
    ecs_aws_ami             = "${var.ecs_aws_ami}"
    security_group_id       = "${module.network.sg_elb_to_app_id}"
    iam_instance_profile    = "${module.iam_roles.ecs_instance_profile_arn}"
}

module "network" {
    source = "../network"

    app_name                = "${var.app_name}"
    vpc_cidr                = "${var.vpc_cidr}"
    public_subnet_cidrs     = "${var.public_subnet_cidrs}"
    private_subnet_cidrs    = "${var.private_subnet_cidrs}"
    availibility_zones      = "${var.availibility_zones}"
}

module "iam_roles" {
    source = "../iam_roles"

    app_name                = "${var.app_name}"
}

resource "aws_ecs_cluster" "cluster_development" {
    name = "${var.app_name}_development"
}

resource "aws_ecs_cluster" "cluster_test" {
    name = "${var.app_name}_test"
}

resource "aws_ecs_cluster" "cluster_production" {
    name = "${var.app_name}_production"
}