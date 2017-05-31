resource "aws_key_pair" "mvlbarcelos" {
    key_name   = "key-${var.app_name}"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC93cB0pFLdcRqRMEp2EST/lTpm5YIVTUU3BbXisShYb2nEuooHME9A3h1/GSG1YdEZy8I9SzDOOgSZEK5CrPhr1p2jvB8XzEVTJZX2Gqc9BF0rB0inNhTIEKZqgeFnuzdR8UGVRIWqLel3E1BDviTlleffpAloWsWF0ZdvI1I63usHXMpBrG9giU71jr5v9p81h4GfNG0ckqMdpScBANhUlemFbLaRLtkn7SNplrhd6/0yJ7nwMH+T/7RcedwP1YkI0zHNHHCDd6pPtsDcHuhMjU04GUr51P+/loLwWDGN8RazlDkFE7n15SfjrJKTE4BBVFFW1Nj4Qc309FHxb69r mvlbarcelos@gmail.com"
}

resource "aws_launch_configuration" "launch_development" {
    name_prefix             = "lc_${var.app_name}_development"
    image_id                = "${var.ecs_aws_ami}"  
    instance_type           = "${var.instance_type}"  
    security_groups         = ["${var.security_group_id}"]
    user_data               = "${data.template_file.user_data.rendered}"
    iam_instance_profile    = "${var.iam_instance_profile}"
    key_name                = "${aws_key_pair.mvlbarcelos.key_name}"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "asg_development" {
    name                 = "asg_${var.app_name}_development"
    max_size             = "${var.max_size}"
    min_size             = "${var.min_size}"
    desired_capacity     = "${var.desired_capacity}"
    force_delete         = true
    launch_configuration = "${aws_launch_configuration.launch_development.id}"
    vpc_zone_identifier  = ["${var.private_subnet_ids}"]

    tag {
        key                 = "Name"
        value               = "${var.app_name}_development"
        propagate_at_launch = "true"
    }
}

data "template_file" "user_data" {
    template = "${file("${path.module}/templates/user_data_development.sh")}"
    vars {
        cluster_name    = "${var.ecs_cluster_name}"
    }
}
