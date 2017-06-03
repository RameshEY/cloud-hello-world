resource "aws_key_pair" "hello" {
    key_name   = "key-${var.app_name}-${var.enviroment}"
    public_key = "${data.template_file.ssh_pub_key.rendered}"
}

resource "aws_launch_configuration" "launch" {
    name_prefix             = "lc_${var.app_name}-${var.enviroment}"
    image_id                = "${var.ecs_aws_ami}"  
    instance_type           = "${var.instance_type}"  
    security_groups         = ["${var.security_group_id}"]
    user_data               = "${data.template_file.user_data.rendered}"
    iam_instance_profile    = "${var.iam_instance_profile}"
    key_name                = "${aws_key_pair.hello.key_name}"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "asg" {
    name                 = "asg_${var.app_name}-${var.enviroment}"
    max_size             = "${var.max_size}"
    min_size             = "${var.min_size}"
    desired_capacity     = "${var.desired_capacity}"
    force_delete         = true
    launch_configuration = "${aws_launch_configuration.launch.id}"
    vpc_zone_identifier  = ["${var.private_subnet_ids}"]

    tag {
        key                 = "Name"
        value               = "${var.app_name}-${var.enviroment}"
        propagate_at_launch = "true"
    }
}

data "template_file" "ssh_pub_key" {
    template = "${file("${path.module}/templates/id_rsa_${var.enviroment}.pub")}"
}

data "template_file" "user_data" {
    template = "${file("${path.module}/templates/user_data.sh")}"
    vars {
        cluster_name    = "${var.ecs_cluster_name}"
    }
}
