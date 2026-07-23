resource "aws_iam_account_password_policy" "main" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  hard_expiry                    = false

  max_password_age          = 90
  password_reuse_prevention = 24
}

resource "aws_accessanalyzer_analyzer" "account" {
  analyzer_name = "secure-landing-zone-${var.environment}-account-analyzer"
  type          = "ACCOUNT"

  tags = {
    Name        = "secure-landing-zone-${var.environment}-account-analyzer"
    Purpose     = "external-access-analysis"
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "break_glass_assume_role" {
  count = var.trusted_principal_arn != "" ? 1 : 0

  statement {
    sid     = "AllowTrustedPrincipal"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_role" "break_glass" {
  count = var.trusted_principal_arn != "" ? 1 : 0

  name                 = "secure-landing-zone-${var.environment}-break-glass"
  description          = "Emergency administrative access role protected by MFA"
  max_session_duration = 3600

  assume_role_policy = data.aws_iam_policy_document.break_glass_assume_role[0].json

  tags = {
    Name        = "secure-landing-zone-${var.environment}-break-glass"
    Purpose     = "emergency-access"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "break_glass_admin" {
  count = var.trusted_principal_arn != "" ? 1 : 0

  role       = aws_iam_role.break_glass[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}