terraform {
  backend "s3" {
    bucket         = "tanoshi-tf-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-lock-tanoshi-tf"
  }
}

data "terraform_remote_state" "tfsetting" {
  backend = "s3"

  config {
    bucket = "tanoshi-tf-state"
    key    = "tfsetting/terraform.tfstate"
    region = "us-east-1"
  }
}
