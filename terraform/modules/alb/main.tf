# Default ALB implementation that can be used connect ECS instances to it

resource "aws_alb_target_group" "default" {
  name                 = "elb-target-${var.app_name}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path     = "${var.health_check_path}"
    protocol = "HTTP"
  }
}

resource "aws_alb" "alb" {
  name            = "elb-${var.app_name}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${var.security_group_id}"]

}

resource "aws_alb_listener" "https" {
  load_balancer_arn = "${aws_alb.alb.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.id}"
    type             = "forward"
  }
}