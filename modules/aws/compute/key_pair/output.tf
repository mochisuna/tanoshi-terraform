output "outputs" {
  value = "${
    map(
      "ssh_auth_id", "${aws_key_pair.ssh_auth.id}",
    )
  }"
}
