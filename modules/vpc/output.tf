output "outputs" {
  value = "${
    map(
      "id",                  "${aws_vpc.vpc.id}",
      "default_sg_id",       "${aws_default_security_group.default.id}",
      "public_subnet_a_id",  "${aws_subnet.public-subnet-a.id}",
      "public_subnet_c_id",  "${aws_subnet.public-subnet-c.id}",
    )
  }"
}
