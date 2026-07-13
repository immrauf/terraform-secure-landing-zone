variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "finding_publishing_frequency" {
  description = "Frequency at which GuardDuty publishes updated findings"
  type        = string
  default     = "FIFTEEN_MINUTES"

  validation {
    condition = contains([
      "FIFTEEN_MINUTES",
      "ONE_HOUR",
      "SIX_HOURS"
    ], var.finding_publishing_frequency)

    error_message = "Publishing frequency must be FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS."
  }
}

variable "enable_s3_protection" {
  description = "Whether GuardDuty monitors S3 data events"
  type        = bool
  default     = true
}

variable "enable_rds_protection" {
  description = "Whether GuardDuty monitors supported RDS login activity"
  type        = bool
  default     = true
}