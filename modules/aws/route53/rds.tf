resource "aws_route53_zone" "rds_local_domain_name" {
  name    = "${lookup(var.route53, "${terraform.env}.rds_local_domain_name", var.route53["default.rds_local_domain_name"])}"
  vpc_id  = "${lookup(var.vpc, "id")}"
  comment = "${terraform.env} RDS Local Domain"
}

resource "aws_route53_record" "rds_local_master_domain_name" {
  name    = "${lookup(var.route53, "${terraform.env}.rds_local_master_domain_name", var.route53["default.rds_local_master_domain_name"])}"
  type    = "CNAME"
  zone_id = "${aws_route53_zone.rds_local_domain_name.zone_id}"

  ttl     = "5"
  records = ["${lookup(var.rds, "endpoint")}"]
}

resource "aws_route53_record" "rds_local_slave_domain_name" {
  name    = "${lookup(var.route53, "${terraform.env}.rds_local_slave_domain_name", var.route53["default.rds_local_slave_domain_name"])}"
  type    = "CNAME"
  zone_id = "${aws_route53_zone.rds_local_domain_name.zone_id}"

  ttl     = "5"
  records = ["${lookup(var.rds, "reader_endpoint")}"]
}
