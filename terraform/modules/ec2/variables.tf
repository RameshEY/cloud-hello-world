variable "app_name" {}
variable "instance_type" {}
variable "ecs_aws_ami" {}
variable "security_group_id" {}
variable "iam_instance_profile" {}
variable "ecs_cluster_name" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "enviroment" {}

variable "private_subnet_ids" {
  type        = "list"
}