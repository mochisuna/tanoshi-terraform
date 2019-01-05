resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "tanoshi-tf-state"

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name           = "tfstate-lock-tanoshi-tf"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
