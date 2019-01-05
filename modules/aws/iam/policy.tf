data "aws_iam_policy_document" "webserver_policy" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "monitoring_rds_policy" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "deployment_policy" {
  "statement" {
    effect = "Allow"

    actions = [
      "s3:*",
      "codedeploy:Batch*",
      "codedeploy:CreateDeployment",
      "codedeploy:Get*",
      "codedeploy:List*",
      "codedeploy:RegisterApplicationRevision",
    ]

    resources = ["*"]
  }
}
