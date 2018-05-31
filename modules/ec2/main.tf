resource "aws_instance" "web" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  monitoring    = true
  key_name      = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = [
    "${aws_security_group.allowed.id}",
    "${lookup(var.vpc, "default_sg_id")}",
  ]

  subnet_id = "${lookup(var.vpc, "public_subnet_a_id")}"

  tags {
    Name = "tano-tf"
  }
}

resource "aws_eip" "ec2_eip" {
  vpc      = true
  instance = "${aws_instance.web.id}"

  tags {
    Name = "tano-tf-eip"
    Env  = "tano-tf"
  }
}

resource "aws_security_group" "allowed" {
  name        = "${var.sg_name}"
  description = "Allow all inbound traffic from localhost"
  vpc_id      = "${lookup(var.vpc, "id")}"

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "tano-tf-sg"
    Env  = "tano-tf"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_pair_name}"
  public_key = "${file("~/.ssh/${var.key_pair_name}.pub")}"
}
