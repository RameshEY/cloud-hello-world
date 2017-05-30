module "ec2" {
    source = "../ec2"
    
    app_name                = "${var.app_name}"
}

module "network" {
    source = "../network"

    app_name                = "${var.app_name}"
    vpc_cidr                = "${var.vpc_cidr}"
    public_subnet_cidrs     = "${var.public_subnet_cidrs}"
    private_subnet_cidrs    = "${var.private_subnet_cidrs}"
    availibility_zones      = "${var.availibility_zones}"
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