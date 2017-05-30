variable "name" {
    description = "Name of the subnet"
}

variable "app_name" {
    description = "The name of the application name"
}

variable "cidrs" {
    type        = "list"
    description = "List of cidrs."
}

variable "availibility_zones" {
    type        = "list"
}

variable "vpc_id" {
    description = "VPC id to place to subnet into"
}
