variable "bastion" {
  default = {}
}

variable vpc {
  type = "map"
}

variable "key_pair" {
  type = "map"
}
