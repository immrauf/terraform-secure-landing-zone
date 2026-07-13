output "detector_id" {
  description = "ID of the GuardDuty detector"
  value       = aws_guardduty_detector.main.id
}

output "detector_arn" {
  description = "ARN of the GuardDuty detector"
  value       = aws_guardduty_detector.main.arn
}

output "s3_protection_status" {
  description = "Status of GuardDuty S3 Protection"
  value       = aws_guardduty_detector_feature.s3_data_events.status
}

output "rds_protection_status" {
  description = "Status of GuardDuty RDS Protection"
  value       = aws_guardduty_detector_feature.rds_login_events.status
}