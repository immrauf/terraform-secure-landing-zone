variable "vpc_id" {
  description = "ID of the VPC where flow logging will be enabled"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region containing the VPC"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID that owns the VPC"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain VPC Flow Logs in CloudWatch"
  type        = number
  default     = 30

  validation {
    condition = contains([
      1,
      3,
      5,
      7,
      14,
      30,
      60,
      90,
      120,
      150,
      180,
      365,
      400,
      545,
      731,
      1096,
      1827,
      2192,
      2557,
      2922,
      3288,
      3653
    ], var.log_retention_days)

    error_message = "The retention period must be supported by CloudWatch Logs."
  }
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt VPC Flow Logs"
  type        = string
}