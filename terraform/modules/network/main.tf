module "vpc" {
    source = "../vpc"

    cidr          = "${var.vpc_cidr}"
    app_name      = "${var.app_name}"
}

module "private_subnet" {
    source = "../subnet"

    name                = "${var.app_name}_private_subnet"
    app_name            = "${var.app_name}"
    vpc_id              = "${module.vpc.id}"
    cidrs               = "${var.private_subnet_cidrs}"
    availibility_zones  = "${var.availibility_zones}"
}

module "public_subnet" {
    source = "../subnet"

    name                = "${var.app_name}_public_subnet"
    app_name            = "${var.app_name}"
    vpc_id              = "${module.vpc.id}"
    cidrs               = "${var.public_subnet_cidrs}"
    availibility_zones  = "${var.availibility_zones}"
}

module "nat" {
    source = "../nat_gateway"

    subnet_ids   = "${module.public_subnet.ids}"
    subnet_count = "${length(var.public_subnet_cidrs)}"
}

resource "aws_route" "public_igw_route" {
    count                  = "${length(var.public_subnet_cidrs)}"
    route_table_id         = "${element(module.public_subnet.route_table_ids, count.index)}"
    gateway_id             = "${module.vpc.igw}"
    destination_cidr_block = "${var.destination_cidr_block}"
}

resource "aws_route" "private_nat_route" {
    count                  = "${length(var.private_subnet_cidrs)}"
    route_table_id         = "${element(module.private_subnet.route_table_ids, count.index)}"
    nat_gateway_id         = "${element(module.nat.ids, count.index)}"
    destination_cidr_block = "${var.destination_cidr_block}"
}

module "security_group" {
    source = "../security_group"

    vpc_id                = "${module.vpc.id}"
    public_subnet_cidrs   = "${var.public_subnet_cidrs}"
}

resource "null_resource" "dummy_dependency" {
    depends_on = ["module.nat"]
}