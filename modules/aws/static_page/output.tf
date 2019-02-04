output "outputs" {
  value = "${
    map(
      "bucket_name", "${aws_s3_bucket.bucket.bucket}",
      "bucket_domain_name",  "${aws_s3_bucket.bucket.bucket_domain_name}",
      "cloudfont_domain_name", "${aws_cloudfront_distribution.distribution.domain_name}",
      "aws_lambda_function_arn", "${aws_lambda_function.test_edge.qualified_arn}",
    )
  }"
}
