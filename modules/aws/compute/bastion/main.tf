resource "aws_instance" "bastion" {
  instance_type = "${lookup(var.bastion, "instance_type")}"
  ami           = "${lookup(var.bastion, "ami")}"
  key_name      = "${lookup(var.key_pair, "ssh_auth_id")}"

  vpc_security_group_ids = [
    "${aws_security_group.allowed.id}",
    "${lookup(var.vpc, "default_sg_id")}",
  ]

  subnet_id = "${lookup(var.vpc, "public_subnet_b_id")}"

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "${lookup(var.bastion, "volume_type")}"
    volume_size = "${lookup(var.bastion, "volume_size")}"
  }

  lifecycle {
    ignore_changes = [
      "*",
    ]
  }

  tags {
    Name = "${var.vpc["name"]} bastion server"
    Env  = "${terraform.env}"
  }
}

resource "aws_eip" "bastion_eip" {
  vpc      = true
  instance = "${aws_instance.bastion.id}"

  tags {
    Name = "${var.vpc["name"]} bastion eip"
    Env  = "${terraform.env}"
  }
}

resource "aws_security_group" "allowed" {
  name        = "${lookup(var.bastion, "sg_name")}"
  description = "Allow all inbound traffic from localhost"
  vpc_id      = "${lookup(var.vpc, "id")}"

  ingress {
    from_port = 22
    to_port   = 22
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
    Name = "${var.vpc["name"]} bastion security group"
    Env  = "${terraform.env}"
  }
}
