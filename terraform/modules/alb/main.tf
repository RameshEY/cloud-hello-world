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

data "aws_route53_zone" "selected" {
  name         = "${var.route53_name}"
  private_zone = false
}

resource "aws_route53_record" "development" {
    zone_id = "${data.aws_route53_zone.selected.zone_id}"
    name    = "development.${data.aws_route53_zone.selected.name}"
    type    = "CNAME"
    ttl     = "300"
    records = ["${aws_alb.alb.dns_name}"]
}

resource "aws_route53_record" "test" {
    zone_id = "${data.aws_route53_zone.selected.zone_id}"
    name    = "test.${data.aws_route53_zone.selected.name}"
    type    = "CNAME"
    ttl     = "300"
    records = ["${aws_alb.alb.dns_name}"]
}

resource "aws_route53_record" "production" {
    zone_id = "${data.aws_route53_zone.selected.zone_id}"
    name    = "production.${data.aws_route53_zone.selected.name}"
    type    = "CNAME"
    ttl     = "300"
    records = ["${aws_alb.alb.dns_name}"]
}