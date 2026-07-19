variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "alert_email" {
  description = "Email address that receives security alerts"
  type        = string
  default     = ""
}