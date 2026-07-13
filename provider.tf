provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "terraform-secure-landing-zone"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}