output "vpc_id" {
    value = "${module.vpc.id}"
}

output "vpc_cidr" {
    value = "${module.vpc.cidr_block}"
}

output "private_subnet_ids" {
    value = "${module.private_subnet.ids}"
}

output "public_subnet_ids" {
    value = "${module.public_subnet.ids}"
}

output "sg_elb_to_app_id" {
    value = "${module.security_groups.elb_to_app_id}"
}

output "elb_https_http_id" {
    value = "${module.security_groups.elb_https_http_id}"
}