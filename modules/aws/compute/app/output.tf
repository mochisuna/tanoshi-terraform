output "outputs" {
  value = "${
    map(
      "scale_in_policy_name", "${aws_autoscaling_policy.scale_in_cpu_policy.name}",
      "scale_in_policy_arn", "${aws_autoscaling_policy.scale_in_cpu_policy.arn}",
      "scale_out_policy_name", "${aws_autoscaling_policy.scale_out_cpu_policy.name}",
      "scale_out_policy_arn", "${aws_autoscaling_policy.scale_out_cpu_policy.arn}",
      "alb_arn", "${aws_lb.alb.arn}"
    )
  }"
}
