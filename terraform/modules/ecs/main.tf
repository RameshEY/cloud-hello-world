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

    app_name                = "${var.app_name}"
}

module "alb" {
    source = "../alb"

    vpc_id                  = "${module.network.vpc_id}"
    app_name                = "${var.app_name}"
    security_group_id       = "${module.network.elb_https_http_id}"
    public_subnet_ids      = "${module.network.public_subnet_ids}"
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
      "name": "SECRET",
      "value": "KEY"
    }],
    "portMappings": [
        {
          "hostPort": 0,
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
    "essential": true,
    "image": "gazgeek/springboot-helloworld",
    "memory": 1024,
    "name": "development"
  }
]
DEFINITION
}

resource "aws_ecs_service" "development" {
  name          = "development"
  cluster       = "${aws_ecs_cluster.cluster_development.id}"
  desired_count = 2
  iam_role      = "arn:aws:iam::156161676080:role/hello-world_ecs_service_role"

  load_balancer {
      target_group_arn  = "${aws_alb_target_group.test.name}"
      container_name    = "development"
      container_port    = 8080
  }

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.hello.family}:${max("${aws_ecs_task_definition.hello.revision}", "${data.aws_ecs_task_definition.hello.revision}")}"
}

resource "aws_alb_target_group" "test" {
  name     = "tf-example-ecs-ghost"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${module.network.vpc_id}"
}