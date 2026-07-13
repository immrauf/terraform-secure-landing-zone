variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID that owns the KMS key"
  type        = string
}

variable "aws_region" {
  description = "AWS region where the KMS key is created"
  type        = string
}

variable "cloudtrail_name" {
  description = "Name of the CloudTrail trail that will use the KMS key"
  type        = string
}