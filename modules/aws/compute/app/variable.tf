variable "app" {
  default = {}
}

variable "app_alb" {
  default = {}
}

variable "acm" {
  default = {}
}

variable iam {
  type = "map"
}

variable vpc {
  type = "map"
}

variable "key_pair" {
  type = "map"
}
