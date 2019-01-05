resource "aws_lb" "alb" {
  name               = "${lookup(var.app, "${terraform.env}.name", var.app["default.name"])}-lb"
  load_balancer_type = "application"

  security_groups = [
    "${lookup(var.vpc, "default_sg_id")}",
    "${aws_security_group.firewall_http.id}",
    "${aws_security_group.firewall_https.id}",
  ]

  subnets = [
    "${lookup(var.vpc, "public_subnet_a_id")}",
    "${lookup(var.vpc, "public_subnet_c_id")}",
  ]

  tags {
    Name = "${var.vpc["name"]} alb"
    Env  = "${terraform.env}"
  }
}

# target group
resource "aws_lb_target_group" "alb_tg" {
  name                 = "${lookup(var.app, "${terraform.env}.name", var.app["default.name"])}-tg"
  protocol             = "HTTP"
  port                 = 80
  target_type          = "instance"
  vpc_id               = "${lookup(var.vpc, "id")}"
  deregistration_delay = 300

  health_check {
    protocol            = "HTTP"
    path                = "${lookup(var.app_alb, "health_check_path")}"
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
  }

  tags {
    Name = "${var.vpc["name"]} target-group"
    Env  = "${terraform.env}"
  }
}

# LB Lister
resource "aws_lb_listener" "alb_listener_http" {
  port              = "80"
  protocol          = "HTTP"
  load_balancer_arn = "${aws_lb.alb.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.alb_tg.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "alb_listener_https" {
  port              = "443"
  protocol          = "HTTPS"
  load_balancer_arn = "${aws_lb.alb.arn}"

  ssl_policy      = "${lookup(var.app_alb, "ssl_policy")}"
  certificate_arn = "${lookup(var.acm, "main_arn")}"

  default_action {
    target_group_arn = "${aws_lb_target_group.alb_tg.arn}"
    type             = "forward"
  }
}

# LB security group
resource "aws_security_group" "firewall_http" {
  name        = "${terraform.env}-firewall_http"
  description = "Allow API Request to verification of ${lookup(var.app, "${terraform.env}.name", var.app["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "id")}"

  ingress {
    from_port   = "80"
    to_port     = "80"
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
    Name = "${var.vpc["name"]} alb security group http"
    Env  = "${terraform.env}"
  }
}

resource "aws_security_group" "firewall_https" {
  name        = "${terraform.env}-firewall_https"
  description = "Allow API Request to verification of ${lookup(var.app, "${terraform.env}.name", var.app["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "id")}"

  ingress {
    from_port   = "443"
    to_port     = "443"
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
    Name = "${var.vpc["name"]} alb security group https"
    Env  = "${terraform.env}"
  }
}
