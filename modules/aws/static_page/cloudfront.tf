resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${lookup(var.static_page, "${terraform.env}.site_domain_name")}"
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled     = true
  comment     = "${lookup(var.static_page, "${terraform.env}.site_domain_name")}"
  aliases     = ["${lookup(var.static_page, "${terraform.env}.site_domain_name")}"]
  price_class = "${lookup(var.static_page, "${terraform.env}.price_class")}"

  default_root_object = "index.html"
  is_ipv6_enabled     = true

  origin {
    domain_name = "${aws_s3_bucket.bucket.bucket_domain_name}"
    origin_id   = "S3-${lookup(var.static_page, "${terraform.env}.site_domain_name")}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${lookup(var.static_page, "${terraform.env}.site_domain_name")}"

    compress = true

    min_ttl     = 0
    max_ttl     = 31536000
    default_ttl = 86400

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association = [
      {
        event_type = "origin-request"
        lambda_arn = "${aws_lambda_function.test_edge.qualified_arn}"
      },
    ]
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${lookup(var.acm, "main_arn")}"
    ssl_support_method       = "${lookup(var.static_page, "${terraform.env}.ssl_support_method")}"
    minimum_protocol_version = "${lookup(var.static_page, "${terraform.env}.minimum_protocol_version")}"
  }

  tags {
    Name   = "${terraform.env}.name"
    Domain = "${lookup(var.static_page, "${terraform.env}.site_domain_name")}"
  }
}