data "aws_iam_policy_document" "s3_policy" {
  "statement" {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }

    resources = ["arn:aws:s3:::${lookup(var.static_page, "${terraform.env}.bucket_name")}/*"]
  }
}

resource "aws_iam_role" "lambda_edge_assume_role" {
  name               = "${terraform.workspace}-lambda-edge-function-role"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_edge_assume_policy.json}"
}

data "aws_iam_policy_document" "lambda_edge_assume_policy" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy" "sample-lambda-log-output" {
  name   = "${terraform.workspace}-lambda-edge-function-policy"
  role   = "${aws_iam_role.lambda_edge_assume_role.id}"
  policy = "${data.aws_iam_policy_document.lambda_edge_function_policy.json}"
}

data "aws_iam_policy_document" "lambda_edge_function_policy" {
  "statement" {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }

  "statement" {
    effect = "Allow"

    actions = [
      "lambda:GetFunction",
      "lambda:EnableReplication*",
      "iam:CreateServiceLinkedRole",
      "cloudfront:CreateDistribution",
      "cloudfront:UpdateDistribution",
    ]

    resources = ["*"]
  }
}
