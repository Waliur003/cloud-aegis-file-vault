//create s3 named "sun-secure-vault-2026"
resource "aws_s3_bucket" "vault_bucket" {
  bucket = var.vault_bucket_name
  force_destroy = true
  

  tags = {
    Name        = "Vault Data Bucket"
    Environment = "Production"
  }
}


//Ensure Block all public access
resource "aws_s3_bucket_public_access_block" "vault_bucket_public_access_block" {
  bucket = aws_s3_bucket.vault_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


//Enable bucket versioning
resource "aws_s3_bucket_versioning" "vault_bucket_versioning" {
  bucket = aws_s3_bucket.vault_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


//Select Server-side encryption with AWS Key Management Service keys (SSE-KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "vault_bucket_encryption" {
  bucket = aws_s3_bucket.vault_bucket.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.vault_kms_key.arn
    }
  }
}