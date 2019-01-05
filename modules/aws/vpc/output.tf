output "outputs" {
  value = "${
    map(
      "id", "${aws_vpc.vpc.id}",
      "name", "${lookup(var.vpc, "name")}",
      
      "public_subnet_a_id", "${aws_subnet.public_subnet_a.id}",
      "public_subnet_b_id", "${aws_subnet.public_subnet_b.id}",
      "public_subnet_c_id", "${aws_subnet.public_subnet_c.id}",
      
      "private_subnet_a_id", "${aws_subnet.private_subnet_a.id}",
      "private_subnet_b_id", "${aws_subnet.private_subnet_b.id}",
      "private_subnet_c_id", "${aws_subnet.private_subnet_c.id}",

      "cidr_block_public_subnet_a", "${lookup(var.vpc_cider_blocks, "${terraform.env}.public_subnet_a", var.vpc_cider_blocks["default.public_subnet_a"])}",
      "cidr_block_public_subnet_b", "${lookup(var.vpc_cider_blocks, "${terraform.env}.public_subnet_b", var.vpc_cider_blocks["default.public_subnet_b"])}",
      "cidr_block_public_subnet_c", "${lookup(var.vpc_cider_blocks, "${terraform.env}.public_subnet_c", var.vpc_cider_blocks["default.public_subnet_c"])}",

      "cidr_block_private_subnet_a", "${lookup(var.vpc_cider_blocks, "${terraform.env}.private_subnet_a", var.vpc_cider_blocks["default.private_subnet_a"])}",
      "cidr_block_private_subnet_b", "${lookup(var.vpc_cider_blocks, "${terraform.env}.private_subnet_b", var.vpc_cider_blocks["default.private_subnet_b"])}",
      "cidr_block_private_subnet_c", "${lookup(var.vpc_cider_blocks, "${terraform.env}.private_subnet_c", var.vpc_cider_blocks["default.private_subnet_c"])}",

      "eip_nat_a", "${aws_eip.eip_nat_a.public_ip}",
      "eip_nat_b", "${aws_eip.eip_nat_b.public_ip}",
      "eip_nat_c", "${aws_eip.eip_nat_c.public_ip}",

      "default_sg_id", "${aws_default_security_group.default.id}",
    )
  }"
}
