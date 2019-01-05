resource "aws_iam_role" "monitoring_rds" {
  name = "${terraform.workspace}-monitoring-rds"
  path = "/"

  assume_role_policy = "${data.aws_iam_policy_document.monitoring_rds_policy.json}"
}

resource "aws_iam_role_policy_attachment" "attach_monitoring_rds" {
  role       = "${aws_iam_role.monitoring_rds.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_iam_role" "webserver_role" {
  name               = "${terraform.workspace}-webserver-default-role"
  assume_role_policy = "${data.aws_iam_policy_document.webserver_policy.json}"
}

resource "aws_iam_role_policy" "webserver_role_policy" {
  name   = "${terraform.workspace}-webserver-default-role-policy"
  role   = "${aws_iam_role.webserver_role.id}"
  policy = "${data.aws_iam_policy_document.deployment_policy.json}"
}

resource "aws_iam_instance_profile" "webserver_instance_profile" {
  name = "${terraform.workspace}-webserver-instance-profile"
  role = "${aws_iam_role.webserver_role.name}"
}
