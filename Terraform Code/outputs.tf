//output kms key id
output "vault_kms_key_id" {
  description = "The ID of the KMS key used for encrypting Vault data."
  value       = aws_kms_key.vault_kms_key.key_id
}

//output kms key arn
output "vault_kms_key_arn" {
  description = "The ARN of the KMS key used for encrypting Vault data."
  value       = aws_kms_key.vault_kms_key.arn
}

//output kms alias name
output "vault_kms_alias_name" {
  description = "The name of the KMS alias for the Vault KMS key."
  value       = aws_kms_alias.vault_kms_alias.name
}


//output cognito user pool id
output "vault_user_pool_id" {
  description = "The ID of the Cognito User Pool for Vault authentication."
  value       = aws_cognito_user_pool.vault_user_pool.id
}


//output cognito user pool client id
output "vault_user_pool_client_id" {
  description = "The ID of the Cognito User Pool Client for Vault authentication."
  value       = aws_cognito_user_pool_client.vault_user_pool_client.id
}


//output cognito user pool domain
output "vault_user_pool_domain" {
  description = "The domain of the Cognito Hosted UI for Vault authentication."
  value       = aws_cognito_user_pool_domain.vault_user_pool_domain.domain
}


//output cognito domain 
//domain be like this: https://terraform-demo-auth-example.auth.us-east-1.amazoncognito.com/login
output "vault_cognito_domain_url" {
  description = "The URL of the Cognito Hosted UI for Vault authentication."
  value       = "https://${aws_cognito_user_pool_domain.vault_user_pool_domain.domain}.auth.${var.aws_region}.amazoncognito.com/login"
}


//output cloudtrail trail name
output "vault_cloudtrail_trail_name" {
  description = "The name of the CloudTrail Trail for Vault security auditing."
  value       = aws_cloudtrail.vault_cloudtrail.name
}


//output cloudtrail logs bucket name
output "vault_cloudtrail_logs_bucket_name" {
  description = "The name of the S3 bucket for CloudTrail logs."
  value       = aws_s3_bucket.cloudtrail_logs_bucket.bucket
}


//output Trial ARN
output "vault_cloudtrail_trail_arn" {
  description = "The ARN of the CloudTrail Trail for Vault security auditing."
  value       = aws_cloudtrail.vault_cloudtrail.arn
}

