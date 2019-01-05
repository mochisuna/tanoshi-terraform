resource "aws_key_pair" "ssh_auth" {
  key_name   = "${lookup(var.key_pair, "${terraform.env}.key_pair_name", var.key_pair["default.key_pair_name"])}"
  public_key = "${file("~/.ssh/${lookup(var.key_pair, "${terraform.env}.key_pair_name", var.key_pair["default.key_pair_name"])}.pub")}"
}
