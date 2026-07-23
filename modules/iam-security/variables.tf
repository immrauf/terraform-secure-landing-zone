variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "trusted_principal_arn" {
  description = "ARN allowed to assume the emergency access role"
  type        = string
  default     = ""
}