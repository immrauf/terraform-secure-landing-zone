variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID that owns the AWS Config resources"
  type        = string
}

variable "snapshot_delivery_frequency" {
  description = "Frequency at which AWS Config delivers configuration snapshots"
  type        = string
  default     = "TwentyFour_Hours"

  validation {
    condition = contains([
      "One_Hour",
      "Three_Hours",
      "Six_Hours",
      "Twelve_Hours",
      "TwentyFour_Hours"
    ], var.snapshot_delivery_frequency)

    error_message = "Use a supported AWS Config snapshot delivery frequency."
  }
}

variable "retention_period_days" {
  description = "Number of days AWS Config retains historical configuration information"
  type        = number
  default     = 90

  validation {
    condition = (
      var.retention_period_days >= 30 &&
      var.retention_period_days <= 2557
    )

    error_message = "AWS Config retention must be between 30 and 2557 days."
  }
}