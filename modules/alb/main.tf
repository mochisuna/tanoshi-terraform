resource "aws_lb" "alb" {
  name               = "${terraform.env}-${var.app_name}-alb"
  load_balancer_type = "application"

  security_groups = [
    "${var.default_security_group_id}",
  ]

  subnets = ["${var.subnets}"]

  tags {
    Name = "${var.app_name}-alb"
    Env  = "${terraform.env}"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name                 = "${terraform.env}-tg"
  protocol             = "HTTP"
  port                 = "${var.port}"
  target_type          = "ip"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = 300

  health_check {
    protocol            = "HTTP"
    path                = "/health"
    port                = "${var.port}"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
  }

  tags {
    Name = "${var.app_name} target-group"
    Env  = "${terraform.env}"
  }
}

resource "aws_lb_listener" "alb_listener" {
  port              = "${var.port}"
  protocol          = "HTTP"
  load_balancer_arn = "${aws_lb.alb.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.alb_tg.arn}"
    type             = "forward"
  }

  depends_on = ["aws_lb.alb", "aws_lb_target_group.alb_tg"]
}

resource "aws_security_group" "firewall" {
  name        = "${terraform.env}_firewall"
  description = "Allow API Request to verification of ${var.app_name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.port}"
    to_port     = "${var.port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.app_name}-alb-sg"
    Env  = "${terraform.env}"
  }
}
