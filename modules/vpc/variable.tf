variable region {}

variable vpc_name {
  default = "tano-tf"
}

variable root_block {
  default = "10.0.0.0/21"
}

variable public_block_a {
  default = "10.0.0.0/24"
}

variable public_block_c {
  default = "10.0.1.0/24"
}
