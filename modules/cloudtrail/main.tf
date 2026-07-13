locals {
  trail_name = "secure-landing-zone-${var.environment}-trail"

  log_bucket_name = lower(
    "secure-landing-zone-${var.environment}-cloudtrail-${var.aws_account_id}"
  )

  cloudwatch_log_group_name = "/aws/cloudtrail/secure-landing-zone-${var.environment}"
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = local.log_bucket_name

  tags = {
    Name        = local.log_bucket_name
    Purpose     = "cloudtrail-audit-logging"
    DataClass   = "security-logs"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }

    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    id     = "cloudtrail-log-retention"
    status = "Enabled"

    filter {}

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = var.s3_log_retention_days
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.cloudtrail
  ]
}

data "aws_iam_policy_document" "cloudtrail_bucket" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      aws_s3_bucket.cloudtrail.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cloudtrail:${var.aws_region}:${var.aws_account_id}:trail/${local.trail_name}"
      ]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${var.aws_account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cloudtrail:${var.aws_region}:${var.aws_account_id}:trail/${local.trail_name}"
      ]
    }
  }

  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.cloudtrail.arn,
      "${aws_s3_bucket.cloudtrail.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail_bucket.json

  depends_on = [
    aws_s3_bucket_public_access_block.cloudtrail,
    aws_s3_bucket_ownership_controls.cloudtrail
  ]
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_retention_days
  kms_key_id        = var.kms_key_arn

  tags = {
    Name      = "secure-landing-zone-${var.environment}-cloudtrail-logs"
    Purpose   = "cloudtrail-monitoring"
    DataClass = "security-logs"
  }
}

data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    sid     = "AllowCloudTrailToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloudtrail_cloudwatch" {
  name = "secure-landing-zone-${var.environment}-cloudtrail-cloudwatch-role"

  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json

  tags = {
    Name    = "secure-landing-zone-${var.environment}-cloudtrail-cloudwatch-role"
    Purpose = "publish-cloudtrail-events"
  }
}

data "aws_iam_policy_document" "cloudtrail_cloudwatch" {
  statement {
    sid    = "AllowCloudTrailLogDelivery"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
    ]
  }
}

resource "aws_iam_policy" "cloudtrail_cloudwatch" {
  name = "secure-landing-zone-${var.environment}-cloudtrail-cloudwatch-policy"

  description = "Allows CloudTrail to deliver account activity to its designated CloudWatch log group"
  policy      = data.aws_iam_policy_document.cloudtrail_cloudwatch.json

  tags = {
    Name    = "secure-landing-zone-${var.environment}-cloudtrail-cloudwatch-policy"
    Purpose = "publish-cloudtrail-events"
  }
}

resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch" {
  role       = aws_iam_role.cloudtrail_cloudwatch.name
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch.arn
}

resource "aws_cloudtrail" "main" {
  name       = local.trail_name
  kms_key_id = var.kms_key_arn

  s3_bucket_name = aws_s3_bucket.cloudtrail.id

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch.arn

  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  enable_logging                = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  tags = {
    Name      = local.trail_name
    Purpose   = "account-audit-logging"
    DataClass = "security-logs"
  }

  depends_on = [
    aws_s3_bucket_policy.cloudtrail,
    aws_iam_role_policy_attachment.cloudtrail_cloudwatch
  ]
}