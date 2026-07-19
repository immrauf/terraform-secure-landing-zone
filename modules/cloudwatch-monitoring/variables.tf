variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "cloudtrail_log_group_name" {
  description = "Name of the CloudWatch log group receiving CloudTrail events"
  type        = string
}

variable "security_alert_topic_arn" {
  description = "SNS topic ARN that receives security alerts"
  type        = string
}
