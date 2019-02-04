data "archive_file" "lambda_edge" {
  type        = "zip"
  source_file = "${path.module}/files/index.js"
  output_path = "${path.module}/files/lambda_edge_function.zip"
}

resource "aws_lambda_function" "test_edge" {
  filename         = "${data.archive_file.lambda_edge.output_path}"
  source_code_hash = "${data.archive_file.lambda_edge.output_base64sha256}"
  function_name    = "${lookup(var.static_page, "${terraform.env}.function_name")}"
  role             = "${aws_iam_role.lambda_edge_assume_role.arn}"
  handler          = "index.handler"

  runtime = "${lookup(var.static_page, "${terraform.env}.runtime")}"
  publish = "true"
}
