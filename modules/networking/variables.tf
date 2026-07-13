variable "vpc_cidr" {
  description = "CIDR block assigned to the VPC"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "The VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}