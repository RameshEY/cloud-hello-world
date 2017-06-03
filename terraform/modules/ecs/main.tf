resource "aws_ecs_cluster" "cluster_development" {
    name = "${var.app_name}_development"
}

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
  iam_role      = "${var.ecs_service_role_iam_role}"

  load_balancer {
      target_group_arn = "${var.alb_arn}"
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
  vpc_id   = "${var.vpc_id}"
  deregistration_delay = 60
}

resource "aws_alb_listener_rule" "host_based_routing" {
  listener_arn = "${var.alb_listener_arn}"
    priority     = 99
  
    action {
      type             = "forward"
      target_group_arn = "${var.alb_arn}"
    }
  
    condition {
      field  = "host-header"
      values = ["development.mvlbarcelos.com"]
    }
}