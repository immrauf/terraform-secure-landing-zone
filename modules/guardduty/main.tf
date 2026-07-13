resource "aws_guardduty_detector" "main" {
  enable                       = true
  finding_publishing_frequency = var.finding_publishing_frequency

  tags = {
    Name    = "secure-landing-zone-${var.environment}-guardduty"
    Purpose = "threat-detection"
  }
}

resource "aws_guardduty_detector_feature" "s3_data_events" {
  detector_id = aws_guardduty_detector.main.id
  name        = "S3_DATA_EVENTS"
  status      = var.enable_s3_protection ? "ENABLED" : "DISABLED"
}

resource "aws_guardduty_detector_feature" "rds_login_events" {
  detector_id = aws_guardduty_detector.main.id
  name        = "RDS_LOGIN_EVENTS"
  status      = var.enable_rds_protection ? "ENABLED" : "DISABLED"
}