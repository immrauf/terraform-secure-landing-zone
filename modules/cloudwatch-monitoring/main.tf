locals {
  metric_namespace = "SecureLandingZone/Security"

  detections = {
    root-account-usage = {
      description = "Detects activity performed with the AWS root account"

      pattern = "{ $.userIdentity.type = Root && $.userIdentity.invokedBy NOT EXISTS && $.eventType != AwsServiceEvent }"
    }

    failed-console-login = {
      description = "Detects failed AWS Management Console login attempts"

      pattern = "{ $.eventName = ConsoleLogin && $.responseElements.ConsoleLogin = Failure }"
    }

    unauthorized-api-calls = {
      description = "Detects denied or unauthorized AWS API requests"

      pattern = "{ ($.errorCode = *UnauthorizedOperation) || ($.errorCode = AccessDenied*) }"
    }

    iam-policy-changes = {
      description = "Detects changes to IAM users, roles, and policies"

      pattern = "{ ($.eventName = CreatePolicy) || ($.eventName = DeletePolicy) || ($.eventName = CreatePolicyVersion) || ($.eventName = DeletePolicyVersion) || ($.eventName = AttachUserPolicy) || ($.eventName = DetachUserPolicy) || ($.eventName = AttachRolePolicy) || ($.eventName = DetachRolePolicy) || ($.eventName = PutUserPolicy) || ($.eventName = DeleteUserPolicy) || ($.eventName = PutRolePolicy) || ($.eventName = DeleteRolePolicy) || ($.eventName = UpdateAssumeRolePolicy) }"
    }

    cloudtrail-changes = {
      description = "Detects modifications to CloudTrail configuration"

      pattern = "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }"
    }

    security-group-changes = {
      description = "Detects modifications to VPC security groups"

      pattern = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup) }"
    }

    network-acl-changes = {
      description = "Detects modifications to network ACLs"

      pattern = "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"
    }

    kms-key-changes = {
      description = "Detects KMS key disablement or scheduled deletion"

      pattern = "{ ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }"
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "security_detection" {
  for_each = local.detections

  name           = "secure-landing-zone-${var.environment}-${each.key}"
  pattern        = each.value.pattern
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name          = each.key
    namespace     = local.metric_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "security_detection" {
  for_each = local.detections

  alarm_name        = "secure-landing-zone-${var.environment}-${each.key}"
  alarm_description = each.value.description

  namespace   = local.metric_namespace
  metric_name = each.key

  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"

  treat_missing_data = "notBreaching"

  alarm_actions = [
    var.security_alert_topic_arn
  ]

  tags = {
    Name        = "secure-landing-zone-${var.environment}-${each.key}"
    Purpose     = "security-monitoring"
    Environment = var.environment
  }

  depends_on = [
    aws_cloudwatch_log_metric_filter.security_detection
  ]
}