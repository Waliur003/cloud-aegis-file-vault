data "aws_caller_identity" "current" {}

resource "aws_kms_key" "vault_kms_key" {
  description             = "KMS key for encrypting Vault data"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_kms_alias" "vault_kms_alias" {
  name          = "alias/file-vault-key"
  target_key_id = aws_kms_key.vault_kms_key.key_id
}