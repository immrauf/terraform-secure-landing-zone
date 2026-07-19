output "metric_filter_names" {
  description = "Names of the CloudWatch security metric filters"

  value = {
    for key, filter in aws_cloudwatch_log_metric_filter.security_detection :
    key => filter.name
  }
}

output "alarm_names" {
  description = "Names of the CloudWatch security alarms"

  value = {
    for key, alarm in aws_cloudwatch_metric_alarm.security_detection :
    key => alarm.alarm_name
  }
}
