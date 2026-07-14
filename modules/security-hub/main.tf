resource "aws_securityhub_account" "main" {
  enable_default_standards = false
}

locals {
  fsbp_standard_arn = "arn:aws:securityhub:${var.aws_region}::standards/aws-foundational-security-best-practices/v/1.0.0"

  cis_standard_arn = "arn:aws:securityhub:${var.aws_region}::standards/cis-aws-foundations-benchmark/v/5.0.0"
}

resource "aws_securityhub_standards_subscription" "fsbp" {
  count = var.enable_fsbp_standard ? 1 : 0

  standards_arn = local.fsbp_standard_arn

  depends_on = [
    aws_securityhub_account.main
  ]
}

resource "aws_securityhub_standards_subscription" "cis" {
  count = var.enable_cis_standard ? 1 : 0

  standards_arn = local.cis_standard_arn

  depends_on = [
    aws_securityhub_account.main
  ]
}