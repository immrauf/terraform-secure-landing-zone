resource "aws_sns_topic" "security_alerts" {
  name              = "secure-landing-zone-${var.environment}-security-alerts"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Name        = "secure-landing-zone-${var.environment}-security-alerts"
    Purpose     = "security-alerting"
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "email" {
  count = var.alert_email != "" ? 1 : 0

  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  name        = "secure-landing-zone-${var.environment}-guardduty-findings"
  description = "Captures medium and high severity GuardDuty findings"

  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
    detail = {
      severity = [
        {
          numeric = [">=", 4]
        }
      ]
    }
  })

  tags = {
    Name    = "secure-landing-zone-${var.environment}-guardduty-findings"
    Purpose = "guardduty-alerting"
  }
}

resource "aws_cloudwatch_event_target" "guardduty_sns" {
  rule      = aws_cloudwatch_event_rule.guardduty_findings.name
  target_id = "SendGuardDutyFindingToSNS"
  arn       = aws_sns_topic.security_alerts.arn
}

data "aws_iam_policy_document" "security_alert_topic" {
  statement {
    sid    = "AllowEventBridgePublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = [
      "sns:Publish"
    ]

    resources = [
      aws_sns_topic.security_alerts.arn
    ]
  }
}

resource "aws_sns_topic_policy" "security_alerts" {
  arn    = aws_sns_topic.security_alerts.arn
  policy = data.aws_iam_policy_document.security_alert_topic.json
}

resource "aws_cloudwatch_event_rule" "security_hub_findings" {
  name        = "secure-landing-zone-${var.environment}-security-hub-findings"
  description = "Captures high and critical Security Hub findings"

  event_pattern = jsonencode({
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        Severity = {
          Label = [
            "HIGH",
            "CRITICAL"
          ]
        }
        Workflow = {
          Status = [
            "NEW",
            "NOTIFIED"
          ]
        }
      }
    }
  })

  tags = {
    Name    = "secure-landing-zone-${var.environment}-security-hub-findings"
    Purpose = "security-hub-alerting"
  }
}

resource "aws_cloudwatch_event_target" "security_hub_sns" {
  rule      = aws_cloudwatch_event_rule.security_hub_findings.name
  target_id = "SendSecurityHubFindingToSNS"
  arn       = aws_sns_topic.security_alerts.arn
}

resource "aws_cloudwatch_event_rule" "config_noncompliance" {
  name        = "secure-landing-zone-${var.environment}-config-noncompliance"
  description = "Captures AWS Config resources that become noncompliant"

  event_pattern = jsonencode({
    source      = ["aws.config"]
    detail-type = ["Config Rules Compliance Change"]
    detail = {
      newEvaluationResult = {
        complianceType = [
          "NON_COMPLIANT"
        ]
      }
    }
  })

  tags = {
    Name    = "secure-landing-zone-${var.environment}-config-noncompliance"
    Purpose = "config-alerting"
  }
}

resource "aws_cloudwatch_event_target" "config_sns" {
  rule      = aws_cloudwatch_event_rule.config_noncompliance.name
  target_id = "SendConfigNoncomplianceToSNS"
  arn       = aws_sns_topic.security_alerts.arn
}