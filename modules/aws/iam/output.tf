output "outputs" {
  value = "${
    map(
      "webserver_instance_profile_name", "${aws_iam_instance_profile.webserver_instance_profile.name}",
      "monitoring_rds_role_arn", "${aws_iam_role.monitoring_rds.arn}",
      "webserver_role_arn", "${aws_iam_role.webserver_role.arn}"
    )
  }"
}
