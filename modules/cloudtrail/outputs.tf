output "trail_id" {
  description = "Name of the CloudTrail trail"
  value       = aws_cloudtrail.main.id
}

output "trail_arn" {
  description = "ARN of the CloudTrail trail"
  value       = aws_cloudtrail.main.arn
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket storing CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket storing CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail.arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group receiving CloudTrail events"
  value       = aws_cloudwatch_log_group.cloudtrail.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group receiving CloudTrail events"
  value       = aws_cloudwatch_log_group.cloudtrail.arn
}

output "cloudwatch_role_arn" {
  description = "ARN of the IAM role CloudTrail uses for CloudWatch delivery"
  value       = aws_iam_role.cloudtrail_cloudwatch.arn
}