variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID that owns the CloudTrail trail"
  type        = string
}

variable "aws_region" {
  description = "AWS region where the primary trail resources are created"
  type        = string
}

variable "cloudwatch_retention_days" {
  description = "Number of days to retain CloudTrail events in CloudWatch Logs"
  type        = number
  default     = 30
}

variable "s3_log_retention_days" {
  description = "Number of days to retain CloudTrail log objects in S3"
  type        = number
  default     = 365

  validation {
    condition     = var.s3_log_retention_days >= 90
    error_message = "CloudTrail S3 logs must be retained for at least 90 days."
  }
}