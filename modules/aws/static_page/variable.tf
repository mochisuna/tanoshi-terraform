variable acm {
  type = "map"
}

variable "main_domain_name" {
  type = "string"

  default = ""
}

variable "static_page" {
  type = "map"

  default = {}
}
