locals {
  secret_name = "secure-landing-zone/${var.environment}/example-application"
}

resource "aws_secretsmanager_secret" "application" {
  name        = local.secret_name
  description = "Example application secret managed by the secure landing zone"

  kms_key_id = var.kms_key_arn

  recovery_window_in_days = 7

  tags = {
    Name        = local.secret_name
    Purpose     = "application-secret-management"
    Environment = var.environment
    DataClass   = "sensitive"
  }
}

data "aws_region" "current" {}

data "aws_iam_policy_document" "secret_read_access" {
  statement {
    sid    = "ReadSpecificSecret"
    effect = "Allow"

    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      aws_secretsmanager_secret.application.arn
    ]
  }

  statement {
    sid    = "DecryptSecretWithKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt"
    ]

    resources = [
      var.kms_key_arn
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"

      values = [
        "secretsmanager.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "secret_read_access" {
  name = "secure-landing-zone-${var.environment}-secret-read-access"

  description = "Allows read access to the designated application secret"

  policy = data.aws_iam_policy_document.secret_read_access.json

  tags = {
    Name        = "secure-landing-zone-${var.environment}-secret-read-access"
    Purpose     = "least-privilege-secret-access"
    Environment = var.environment
  }
}