provider "aws" {
  version                 = "~> 1.21"
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
}
