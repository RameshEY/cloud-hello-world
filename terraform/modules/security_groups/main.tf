resource "aws_security_group" "allow_elb_https_http" {
    name        = "allow-https-http-${var.enviroment}"
    description = "Allow https and http inbound traffic"
    vpc_id      = "${var.vpc_id}"

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "allow_elb_to_app" {
    name        = "allow-elb-to-app-${var.enviroment}"
    description = "Allow elb to app"
    vpc_id      = "${var.vpc_id}"

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["${var.public_subnet_cidrs}"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}