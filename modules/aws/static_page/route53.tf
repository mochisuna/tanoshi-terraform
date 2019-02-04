resource "aws_route53_zone" "static_page_zone" {
  name    = "${var.main_domain_name}"
  comment = "${terraform.env} Static Page Local Domain"
}

resource "aws_route53_record" "cloudfront_domain_name" {
  zone_id = "${aws_route53_zone.static_page_zone.zone_id}"
  name    = "${lookup(var.static_page, "${terraform.env}.site_domain_name")}"
  type    = "CNAME"
  ttl     = "5"
  records = ["${aws_cloudfront_distribution.distribution.domain_name}"]
}
