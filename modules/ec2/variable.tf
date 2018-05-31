variable "ami" {
  default = "ami-6b8cef13"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "sg_name" {}

variable "key_pair_name" {}

variable vpc {
  type = "map"
}
