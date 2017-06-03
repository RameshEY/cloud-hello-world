variable "name" {}
variable "vpc_id" {}
variable "app_name" {}

variable "cidrs" {
    type        = "list"
}

variable "availibility_zones" {
    type        = "list"
}


