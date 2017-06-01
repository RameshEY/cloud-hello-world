module "ec2" {
    source = "../ec2"
    
    app_name                = "${var.app_name}"
    instance_type           = "${var.instance_type}"
    ecs_aws_ami             = "${var.ecs_aws_ami}"
    security_group_id       = "${module.network.sg_elb_to_app_id}"
    iam_instance_profile    = "${module.iam_roles.ecs_instance_profile_arn}"
    ecs_cluster_name        = "${aws_ecs_cluster.cluster_development.name}"
    max_size                = "${var.max_size}"
    min_size                = "${var.min_size}"
    desired_capacity        = "${var.desired_capacity}"
    private_subnet_ids      = "${module.network.private_subnet_ids}"
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
    
    app_name    = "${var.app_name}"
}

module "alb" {
    source = "../alb"

    route53_name            = "${var.route53_name}"
    vpc_id                  = "${module.network.vpc_id}"
    app_name                = "${var.app_name}"
    security_group_id       = "${module.network.elb_https_http_id}"
    public_subnet_ids       = "${module.network.public_subnet_ids}"
    certificate_arn         = "${var.certificate_arn}"
}

module "code_build" {
    source = "../code_build"

    iam_role    = "${module.iam_roles.codebuild_role_arn}"
    app_name              = "${var.app_name}"
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

# Simply specify the family to find the latest ACTIVE revision in that family.
data "aws_ecs_task_definition" "hello" {
  task_definition = "${aws_ecs_task_definition.hello.family}"
}

resource "aws_ecs_task_definition" "hello" {
  family = "development"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 128,
    "environment": [{
      "name": "ENV",
      "value": "development"
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
    "name": "development"
  }
]
DEFINITION
}

resource "aws_ecs_service" "development" {
  name          = "development"
  cluster       = "${aws_ecs_cluster.cluster_development.id}"
  desired_count = 2
  iam_role      = "${module.iam_roles.ecs_service_role_arn}"

  load_balancer {
      target_group_arn  = "${aws_alb_target_group.development.arn}"
      container_name    = "development"
      container_port    = 8080
  }

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.hello.family}:${max("${aws_ecs_task_definition.hello.revision}", "${data.aws_ecs_task_definition.hello.revision}")}"
}

resource "aws_alb_target_group" "development" {
  name     = "tg-${var.app_name}-development"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${module.network.vpc_id}"
}

resource "aws_alb_listener_rule" "host_based_routing" {
  listener_arn = "${module.alb.alb_listener_arn}"
    priority     = 99
  
    action {
      type             = "forward"
      target_group_arn = "${aws_alb_target_group.development.arn}"
    }
  
    condition {
      field  = "host-header"
      values = ["development.mvlbarcelos.com"]
    }
}