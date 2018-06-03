variable "port" {
  default = 80
}

variable "app_name" {
  default = "tanoshi-tf"
}

variable "vpc_id" {}

variable "subnets" {
  type = "list"
}

variable "default_security_group_id" {}
