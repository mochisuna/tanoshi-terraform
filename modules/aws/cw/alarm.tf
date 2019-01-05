resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "High-CPU-Utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"

  dimensions {
    AutoScalingGroupName = "${lookup(var.app, "scale_out_policy_name")}"
  }

  alarm_actions = ["${lookup(var.app, "scale_out_policy_arn")}"]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_utilization" {
  alarm_name          = "Low-CPU-Utilization"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"

  dimensions {
    AutoScalingGroupName = "${lookup(var.app, "scale_in_policy_name")}"
  }

  alarm_actions = ["${lookup(var.app, "scale_in_policy_arn")}"]
}
