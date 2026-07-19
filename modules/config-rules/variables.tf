variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "rule_name_prefix" {
  description = "Prefix applied to AWS Config rule names"
  type        = string
  default     = "secure-landing-zone"
}