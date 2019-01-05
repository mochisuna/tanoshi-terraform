output "outputs" {
  value = "${
    map(
      "main_arn", "${data.aws_acm_certificate.main.arn}"
    )
  }"
}
