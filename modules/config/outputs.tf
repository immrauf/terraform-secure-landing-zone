output "configuration_recorder_name" {
  description = "Name of the AWS Config configuration recorder"
  value       = aws_config_configuration_recorder.main.name
}

output "delivery_channel_name" {
  description = "Name of the AWS Config delivery channel"
  value       = aws_config_delivery_channel.main.name
}

output "config_bucket_name" {
  description = "Name of the S3 bucket storing AWS Config history and snapshots"
  value       = aws_s3_bucket.config.id
}

output "config_bucket_arn" {
  description = "ARN of the AWS Config S3 bucket"
  value       = aws_s3_bucket.config.arn
}

output "config_role_arn" {
  description = "ARN of the AWS Config service-linked role"
  value       = aws_iam_service_linked_role.config.arn
}

output "retention_period_days" {
  description = "AWS Config historical data retention period"
  value       = aws_config_retention_configuration.main.retention_period_in_days
}