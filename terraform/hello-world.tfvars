vpc_cidr = "172.16.0.0/16"

route53_name = "mvlbarcelos.com"

app_name = "hello-world"

public_subnet_cidrs = ["172.16.0.0/24", "172.16.1.0/24"]

private_subnet_cidrs = ["172.16.21.0/24", "172.16.22.0/24"]

availibility_zones = ["eu-central-1a", "eu-central-1b"]

instance_type = "t2.micro"

ecs_aws_ami = "ami-085e8a67"

max_size = 3

min_size = 2

desired_capacity = 2

certificate_arn = "arn:aws:acm:eu-central-1:156161676080:certificate/92ce5ffd-b075-477d-bd58-6547237de699"

ecr_image = "156161676080.dkr.ecr.eu-central-1.amazonaws.com/hello-world"