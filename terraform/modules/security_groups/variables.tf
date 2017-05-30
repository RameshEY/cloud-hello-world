variable "public_subnet_cidrs" {
    type        = "list"
    description = "List of public cidrs: 172.16.0.0/24 and 172.16.1.0/24"
}

variable "vpc_id" {}