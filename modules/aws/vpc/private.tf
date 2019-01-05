# nat gateway settings
resource "aws_nat_gateway" "nat_gw_a" {
  allocation_id = "${aws_eip.eip_nat_a.id}"
  subnet_id     = "${aws_subnet.public_subnet_a.id}"

  tags {
    Name = "${var.vpc["name"]} nat gateway-a"
    Env  = "${terraform.env}"
  }
}

resource "aws_nat_gateway" "nat_gw_b" {
  allocation_id = "${aws_eip.eip_nat_b.id}"
  subnet_id     = "${aws_subnet.public_subnet_b.id}"

  tags {
    Name = "${var.vpc["name"]} nat gateway-b"
    Env  = "${terraform.env}"
  }
}

resource "aws_nat_gateway" "nat_gw_c" {
  allocation_id = "${aws_eip.eip_nat_c.id}"
  subnet_id     = "${aws_subnet.public_subnet_c.id}"

  tags {
    Name = "${var.vpc["name"]} nat gateway-c"
    Env  = "${terraform.env}"
  }
}

# NAT EIP settings
resource "aws_eip" "eip_nat_a" {
  tags {
    Name = "${var.vpc["name"]} eip of nat gateway-a"
    Env  = "${terraform.env}"
  }
}

resource "aws_eip" "eip_nat_b" {
  tags {
    Name = "${var.vpc["name"]} eip of nat gateway-b"
    Env  = "${terraform.env}"
  }
}

resource "aws_eip" "eip_nat_c" {
  tags {
    Name = "${var.vpc["name"]} eip of nat gateway-c"
    Env  = "${terraform.env}"
  }
}

# subnet settings
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc_cider_blocks, "${terraform.env}.private_subnet_a", var.vpc_cider_blocks["default.private_subnet_a"])}"
  availability_zone = "${var.region}a"

  tags {
    Name = "${var.vpc["name"]} private subnet-a"
    Env  = "${terraform.env}"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc_cider_blocks, "${terraform.env}.private_subnet_b", var.vpc_cider_blocks["default.private_subnet_b"])}"
  availability_zone = "${var.region}b"

  tags {
    Name = "${var.vpc["name"]} private subnet-b"
    Env  = "${terraform.env}"
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc_cider_blocks, "${terraform.env}.private_subnet_c", var.vpc_cider_blocks["default.private_subnet_c"])}"
  availability_zone = "${var.region}c"

  tags {
    Name = "${var.vpc["name"]} private subnet-c"
    Env  = "${terraform.env}"
  }
}

# route table settings

resource "aws_route_table" "private_rt_a" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw_a.id}"
  }

  tags {
    Name = "${var.vpc["name"]} private route table nat-a"
    Env  = "${terraform.env}"
  }
}

resource "aws_route_table" "private_rt_b" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw_b.id}"
  }

  tags {
    Name = "${var.vpc["name"]} private route table nat-b"
    Env  = "${terraform.env}"
  }
}

resource "aws_route_table" "private_rt_c" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw_c.id}"
  }

  tags {
    Name = "${var.vpc["name"]} private route table nat-c"
    Env  = "${terraform.env}"
  }
}

# route table associations

resource "aws_route_table_association" "private_rta_a" {
  subnet_id      = "${aws_subnet.private_subnet_a.id}"
  route_table_id = "${aws_route_table.private_rt_a.id}"
}

resource "aws_route_table_association" "private_rta_b" {
  subnet_id      = "${aws_subnet.private_subnet_b.id}"
  route_table_id = "${aws_route_table.private_rt_b.id}"
}

resource "aws_route_table_association" "private_rta_c" {
  subnet_id      = "${aws_subnet.private_subnet_c.id}"
  route_table_id = "${aws_route_table.private_rt_c.id}"
}
