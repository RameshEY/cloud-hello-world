output "alb_listener_arn" {
    value = "${aws_alb_listener.https.arn}"
}

output "alb_name" {
    value = "${aws_alb.alb.name}"
}