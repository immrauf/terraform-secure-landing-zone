variable "aws_region" {
  description = "AWS region used for the landing zone"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the landing zone VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "application_port" {
  description = "Port used by the private application"
  type        = number
  default     = 8080
}

variable "database_port" {
  description = "Port used by the PostgreSQL database"
  type        = number
  default     = 5432
}

variable "flow_log_retention_days" {
  description = "Number of days to retain VPC Flow Logs in CloudWatch"
  type        = number
  default     = 30
}

variable "cloudtrail_cloudwatch_retention_days" {
  description = "Number of days to retain CloudTrail events in CloudWatch"
  type        = number
  default     = 30
}

variable "cloudtrail_s3_retention_days" {
  description = "Number of days to retain CloudTrail log files in S3"
  type        = number
  default     = 365
}

variable "guardduty_finding_publishing_frequency" {
  description = "Frequency for publishing updates to GuardDuty findings"
  type        = string
  default     = "FIFTEEN_MINUTES"
}

variable "enable_guardduty_s3_protection" {
  description = "Whether GuardDuty S3 Protection is enabled"
  type        = bool
  default     = true
}

variable "enable_guardduty_rds_protection" {
  description = "Whether GuardDuty RDS Protection is enabled"
  type        = bool
  default     = true
}

variable "enable_security_hub_fsbp" {
  description = "Whether to enable AWS Foundational Security Best Practices"
  type        = bool
  default     = true
}

variable "enable_security_hub_cis" {
  description = "Whether to enable the CIS AWS Foundations Benchmark"
  type        = bool
  default     = true
}