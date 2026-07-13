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