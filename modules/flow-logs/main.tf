resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/secure-landing-zone-${var.environment}-flow-logs"
  retention_in_days = var.log_retention_days

  tags = {
    Name    = "secure-landing-zone-${var.environment}-vpc-flow-logs"
    Purpose = "network-traffic-auditing"
  }
}

data "aws_iam_policy_document" "flow_logs_assume_role" {
  statement {
    sid     = "AllowVPCFlowLogsToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:vpc-flow-log/*"
      ]
    }
  }
}

resource "aws_iam_role" "vpc_flow_logs" {
  name               = "secure-landing-zone-${var.environment}-vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume_role.json

  tags = {
    Name    = "secure-landing-zone-${var.environment}-vpc-flow-logs-role"
    Purpose = "publish-vpc-flow-logs"
  }
}

data "aws_iam_policy_document" "flow_logs_permissions" {
  statement {
    sid    = "AllowFlowLogDelivery"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "${aws_cloudwatch_log_group.vpc_flow_logs.arn}:*"
    ]
  }
}

resource "aws_iam_policy" "vpc_flow_logs" {
  name        = "secure-landing-zone-${var.environment}-vpc-flow-logs-policy"
  description = "Allows VPC Flow Logs to publish records to the designated CloudWatch log group"
  policy      = data.aws_iam_policy_document.flow_logs_permissions.json

  tags = {
    Name    = "secure-landing-zone-${var.environment}-vpc-flow-logs-policy"
    Purpose = "publish-vpc-flow-logs"
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs" {
  role       = aws_iam_role.vpc_flow_logs.name
  policy_arn = aws_iam_policy.vpc_flow_logs.arn
}

resource "aws_flow_log" "vpc" {
  vpc_id = var.vpc_id

  iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn

  log_destination_type     = "cloud-watch-logs"
  traffic_type             = "ALL"
  max_aggregation_interval = 60

  tags = {
    Name    = "secure-landing-zone-${var.environment}-vpc-flow-log"
    Purpose = "network-traffic-auditing"
  }

  depends_on = [
    aws_iam_role_policy_attachment.vpc_flow_logs
  ]
}