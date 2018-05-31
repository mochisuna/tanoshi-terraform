resource "aws_vpc" "vpc" {
  cidr_block = "${var.root_block}"

  tags {
    Name = "${var.vpc_name}"
    Env  = "${terraform.env}"
  }
}

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
    Name = "${var.vpc_name} default-security-group"
    Env  = "${terraform.env}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.vpc_name} internet-gateway"
    Env  = "${terraform.env}"
  }
}

resource "aws_subnet" "public-subnet-a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_block_a}"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc_name} public-subnet-a"
    Env  = "${terraform.env}"
  }
}

resource "aws_subnet" "public-subnet-c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_block_c}"
  availability_zone       = "${var.region}c"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc_name} public-subnet-c"
    Env  = "${terraform.env}"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${var.vpc_name} public route-table"
    Env  = "${terraform.env}"
  }
}

resource "aws_route_table_association" "public-rta-a" {
  subnet_id      = "${aws_subnet.public-subnet-a.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table_association" "public-rta-c" {
  subnet_id      = "${aws_subnet.public-subnet-c.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}
