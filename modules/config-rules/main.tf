locals {
  managed_rules = {
    s3_public_read_prohibited = {
      description       = "Prevents S3 buckets from allowing public read access"
      source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
    }

    s3_public_write_prohibited = {
      description       = "Prevents S3 buckets from allowing public write access"
      source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
    }

    s3_encryption_enabled = {
      description       = "Requires server-side encryption for S3 buckets"
      source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
    }

    s3_ssl_requests_only = {
      description       = "Requires S3 buckets to deny unencrypted transport"
      source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY"
    }

    encrypted_ebs_volumes = {
      description       = "Requires attached EBS volumes to be encrypted"
      source_identifier = "ENCRYPTED_VOLUMES"
    }

    ec2_no_public_ip = {
      description       = "Detects EC2 instances with public IPv4 addresses"
      source_identifier = "EC2_INSTANCE_NO_PUBLIC_IP"
    }

    restricted_ssh = {
      description       = "Detects security groups that allow unrestricted inbound SSH"
      source_identifier = "INCOMING_SSH_DISABLED"
    }

    default_security_group_closed = {
      description       = "Requires default VPC security groups to block all traffic"
      source_identifier = "VPC_DEFAULT_SECURITY_GROUP_CLOSED"
    }

    cloudtrail_enabled = {
      description       = "Requires AWS CloudTrail to be enabled"
      source_identifier = "CLOUD_TRAIL_ENABLED"
    }

    kms_key_rotation_enabled = {
      description       = "Requires rotation for eligible customer-managed KMS keys"
      source_identifier = "CMK_BACKING_KEY_ROTATION_ENABLED"
    }
  }
}

resource "aws_config_config_rule" "managed" {
  for_each = local.managed_rules

  name = "${var.rule_name_prefix}-${var.environment}-${replace(each.key, "_", "-")}"

  description = each.value.description

  source {
    owner             = "AWS"
    source_identifier = each.value.source_identifier
  }

  tags = {
    Name        = "${var.rule_name_prefix}-${var.environment}-${replace(each.key, "_", "-")}"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "continuous-compliance"
  }
}