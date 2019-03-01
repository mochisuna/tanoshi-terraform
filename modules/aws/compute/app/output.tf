output "outputs" {
  value = "${
    map(
      "alb_arn", "${aws_lb.alb.arn}",
      "alb_dns", "${aws_lb.alb.dns_name}",
      "alb_name", "${aws_lb.alb.name}"
    )
  }"
}
