resource "aws_s3_bucket" "bucket" {
  bucket = "${lookup(var.static_page, "${terraform.env}.bucket_name")}"
  acl    = "private"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = "${aws_s3_bucket.bucket.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

resource "aws_s3_bucket_public_access_block" "accsess_config" {
  bucket = "${aws_s3_bucket.bucket.id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
