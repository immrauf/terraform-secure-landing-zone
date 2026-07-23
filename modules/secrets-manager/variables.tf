variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used to encrypt the secret"
  type        = string
}