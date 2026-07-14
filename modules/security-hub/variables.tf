variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS Region where Security Hub CSPM is enabled"
  type        = string
}

variable "enable_fsbp_standard" {
  description = "Whether to enable AWS Foundational Security Best Practices"
  type        = bool
  default     = true
}

variable "enable_cis_standard" {
  description = "Whether to enable the CIS AWS Foundations Benchmark"
  type        = bool
  default     = true
}
