resource "aws_launch_configuration" "app_lc" {
  name_prefix                 = "${lookup(var.app, "${terraform.env}.name", var.app["default.name"])}."
  image_id                    = "${lookup(var.app, "${terraform.env}.ami", var.app["default.ami"])}"
  instance_type               = "${lookup(var.app, "${terraform.env}.instance_type", var.app["default.instance_type"])}"
  key_name                    = "${lookup(var.key_pair, "ssh_auth_id")}"
  associate_public_ip_address = false

  root_block_device {
    volume_type = "${lookup(var.app, "${terraform.env}.volume_type", var.app["default.volume_type"])}"
    volume_size = "${lookup(var.app, "${terraform.env}.volume_size", var.app["default.volume_size"])}"
  }

  iam_instance_profile = "${lookup(var.iam, "webserver_instance_profile_name")}"

  security_groups = [
    "${lookup(var.vpc, "default_sg_id")}",
  ]

  enable_monitoring = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_out_cpu_policy" {
  name                    = "Scale-OUT by CPU"
  autoscaling_group_name  = "${aws_autoscaling_group.app_autoscaling_group.name}"
  adjustment_type         = "ChangeInCapacity"
  policy_type             = "StepScaling"
  metric_aggregation_type = "Average"

  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 0
  }
}

resource "aws_autoscaling_policy" "scale_in_cpu_policy" {
  name                    = "Scale-IN by CPU"
  autoscaling_group_name  = "${aws_autoscaling_group.app_autoscaling_group.name}"
  adjustment_type         = "ChangeInCapacity"
  policy_type             = "StepScaling"
  metric_aggregation_type = "Average"

  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_upper_bound = 0
  }
}

resource "aws_autoscaling_policy" "scale_out_request_policy" {
  name                      = "Scale-OUT by Request"
  autoscaling_group_name    = "${aws_autoscaling_group.app_autoscaling_group.name}"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "180"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_lb.alb.arn_suffix}/${aws_lb_target_group.alb_tg.arn_suffix}"
    }

    target_value     = 100
    disable_scale_in = false
  }
}

resource "aws_autoscaling_group" "app_autoscaling_group" {
  vpc_zone_identifier = [
    "${lookup(var.vpc, "public_subnet_a_id")}",
    "${lookup(var.vpc, "public_subnet_c_id")}",
  ]

  name                      = "${lookup(var.app, "${terraform.env}.name", var.app["default.name"])}-asg"
  max_size                  = 9
  min_size                  = 1
  health_check_grace_period = 300
  desired_capacity          = 2
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.app_lc.name}"
  target_group_arns         = ["${aws_lb_target_group.alb_tg.arn}"]

  tag {
    key                 = "Name"
    value               = "${var.vpc["name"]}-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Env"
    value               = "${terraform.env}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
