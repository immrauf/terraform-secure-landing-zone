output "security_alert_topic_arn" {
  description = "ARN of the security alert SNS topic"
  value       = aws_sns_topic.security_alerts.arn
}