output "ecs_instance_profile_arn" {
    value = "${aws_iam_instance_profile.ecs.arn}"
}

output "ecs_service_role_arn" {
    value = "${aws_iam_role.ecs_service_role.arn}"
}

