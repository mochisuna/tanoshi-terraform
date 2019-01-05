# vpc setting
resource "aws_vpc" "vpc" {
  cidr_block = "${lookup(var.vpc_cider_blocks, "${terraform.env}.cidr", var.vpc_cider_blocks["default.cidr"])}"

  tags {
    Name = "${var.vpc["name"]}"
    Env  = "${terraform.env}"
  }
}

# gateway settings
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.vpc["name"]} internet gateway"
    Env  = "${terraform.env}"
  }
}

# subnet settings
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${lookup(var.vpc_cider_blocks, "${terraform.env}.public_subnet_a", var.vpc_cider_blocks["default.public_subnet_a"])}"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc["name"]} public subnet-a"
    Env  = "${terraform.env}"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${lookup(var.vpc_cider_blocks, "${terraform.env}.public_subnet_b", var.vpc_cider_blocks["default.public_subnet_b"])}"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc["name"]} public subnet-b"
    Env  = "${terraform.env}"
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${lookup(var.vpc_cider_blocks, "${terraform.env}.public_subnet_c", var.vpc_cider_blocks["default.public_subnet_c"])}"
  availability_zone       = "${var.region}c"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc["name"]} public subnet-c"
    Env  = "${terraform.env}"
  }
}

# route table settings
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${var.vpc["name"]} public route table"
    Env  = "${terraform.env}"
  }
}

# route table association settings
resource "aws_route_table_association" "public_rta_a" {
  subnet_id      = "${aws_subnet.public_subnet_a.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "public_rta_b" {
  subnet_id      = "${aws_subnet.public_subnet_b.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "public_rta_c" {
  subnet_id      = "${aws_subnet.public_subnet_c.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

# security group settings
resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.vpc["name"]} default_security_group"
    Env  = "${terraform.env}"
  }
}
