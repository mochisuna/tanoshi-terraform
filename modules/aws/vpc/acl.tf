# network acl settings
## public: allow - all
resource "aws_network_acl" "public_network_acl" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress = {
    rule_no    = 100
    action     = "allow"
    protocol   = "all"
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "all"
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
  }

  subnet_ids = [
    "${aws_subnet.public_subnet_a.id}",
    "${aws_subnet.public_subnet_b.id}",
    "${aws_subnet.public_subnet_c.id}",
  ]

  tags {
    Name = "${var.vpc["name"]} public network acl"
    Env  = "${terraform.env}"
  }
}

## private: allow - 80, 443, 
## 22は・・・一旦なしで
resource "aws_network_acl" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    rule_no    = 110
    action     = "allow"
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    rule_no    = 120
    action     = "allow"
    protocol   = "tcp"
    from_port  = 3306
    to_port    = 3306
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  # default
  ingress {
    rule_no    = 130
    action     = "allow"
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no    = 110
    action     = "allow"
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no    = 120
    action     = "allow"
    protocol   = "tcp"
    from_port  = 3306
    to_port    = 3306
    cidr_block = "0.0.0.0/0"
  }

  # default
  egress {
    rule_no    = 130
    action     = "allow"
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  subnet_ids = [
    "${aws_subnet.private_subnet_a.id}",
    "${aws_subnet.private_subnet_b.id}",
    "${aws_subnet.private_subnet_c.id}",
  ]

  tags {
    Name = "${var.vpc["name"]} private network acl"
    Env  = "${terraform.env}"
  }
}
