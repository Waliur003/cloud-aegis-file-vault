//Create S3 Bucket for CloudTrail Logs
resource "aws_s3_bucket" "cloudtrail_logs_bucket" {
  bucket = "${var.project_name}-cloudtrail-logs"

  tags = {
    Name        = "CloudTrail Logs Bucket"
    Environment = "Production"
  }
}


//Enable versioning for CloudTrail Logs Bucket
resource "aws_s3_bucket_versioning" "cloudtrail_logs_bucket_versioning" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


//Enable Encryption for CloudTrail Logs Bucket using AWS KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs_bucket_encryption" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.vault_kms_key.arn
    }
  }
}


//Block all public access to CloudTrail Logs Bucket
resource "aws_s3_bucket_public_access_block" "cloudtrail_logs_bucket_public_access_block" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


//Create S3 bucket policy to allow CloudTrail to write logs to the CloudTrail Logs Bucket
resource "aws_s3_bucket_policy" "cloudtrail_logging_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.cloudtrail_logs_bucket.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.cloudtrail_logs_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
        }
    ]
}
POLICY
}


//Create CloudTrail Trail for Vault Security Auditing
resource "aws_cloudtrail" "vault_cloudtrail" {
  name                          = var.trail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs_bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  advanced_event_selector {
    name = "Log Vault S3 Data Events"

    field_selector {
      field  = "resources.type"
      equals = ["AWS::S3::Object"]
    }

    field_selector {
      field       = "resources.arn"
      starts_with = ["arn:aws:s3:::${var.vault_bucket_name}/"]
    }
  }

  depends_on = [aws_s3_bucket_policy.cloudtrail_logging_policy]
}
