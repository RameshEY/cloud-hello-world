module "iam_roles" {
    source = "../iam_roles"
    
    app_name                = "${var.app_name}"
    enviroment              = "${var.enviroment}"
}

module "ec2" {
    source = "../ec2"
    
    app_name                = "${var.app_name}"
    enviroment              = "${var.enviroment}"
    instance_type           = "${var.instance_type}"
    ecs_aws_ami             = "${var.ecs_aws_ami}"
    security_group_id       = "${module.network.sg_elb_to_app_id}"
    iam_instance_profile    = "${module.iam_roles.ecs_instance_profile_arn}"
    ecs_cluster_name        = "${aws_ecs_cluster.cluster.name}"
    max_size                = "${var.max_size}"
    min_size                = "${var.min_size}"
    desired_capacity        = "${var.desired_capacity}"
    private_subnet_ids      = "${module.network.private_subnet_ids}"
}

module "network" {
    source = "../network"

    app_name                = "${var.app_name}"
    enviroment              = "${var.enviroment}"
    vpc_cidr                = "${var.vpc_cidr}"
    public_subnet_cidrs     = "${var.public_subnet_cidrs}"
    private_subnet_cidrs    = "${var.private_subnet_cidrs}"
    availibility_zones      = "${var.availibility_zones}"
}

module "alb" {
    source = "../alb"

    enviroment              = "${var.enviroment}"
    app_name                = "${var.app_name}"
    route53_name            = "${var.route53_name}"
    vpc_id                  = "${module.network.vpc_id}"
    security_group_id       = "${module.network.elb_https_http_id}"
    public_subnet_ids       = "${module.network.public_subnet_ids}"
    certificate_arn         = "${var.certificate_arn}"
}



resource "aws_ecs_cluster" "cluster" {
    name = "${var.app_name}-${var.enviroment}"
}

resource "aws_ecs_task_definition" "hello" {
    family = "${var.enviroment}"

    container_definitions = <<DEFINITION
[
  {
    "cpu": 128,
    "environment": [{
      "name": "ENV",
      "value": "${var.enviroment}"
    }],
    "portMappings": [
        {
          "hostPort": 0,
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
    "essential": true,
    "image": "156161676080.dkr.ecr.eu-central-1.amazonaws.com/hello-world",
    "memory": 256,
    "name": "${var.enviroment}"
  }
]
DEFINITION
}

resource "aws_ecs_service" "service" {
    name          = "${var.enviroment}"
    cluster       = "${aws_ecs_cluster.cluster.id}"
    desired_count = 2
    iam_role      = "${module.iam_roles.ecs_service_role_arn}"

  load_balancer {
        target_group_arn  = "${aws_alb_target_group.target_group.arn}"
        container_name    = "${var.enviroment}"
        container_port    = 8080
  }

    task_definition = "${aws_ecs_task_definition.hello.family}:${aws_ecs_task_definition.hello.revision}"

}

resource "aws_alb_target_group" "target_group" {
    name     = "tg-${var.app_name}-${var.enviroment}"
    port     = 8080
    protocol = "HTTP"
    vpc_id   = "${module.network.vpc_id}"
    deregistration_delay = 60
}

resource "aws_alb_listener_rule" "host_based_routing" {
    listener_arn = "${module.alb.alb_listener_arn}"
        priority     = 99
    
        action {
            type             = "forward"
            target_group_arn = "${aws_alb_target_group.target_group.arn}"
        }
    
        condition {
            field  = "host-header"
            values = ["${var.enviroment}.mvlbarcelos.com"]
        }
}