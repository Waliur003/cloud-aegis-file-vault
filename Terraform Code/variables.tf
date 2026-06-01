//declare variables
variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}


//declare vault bucket name variable
variable "vault_bucket_name" {
  description = "The name of the S3 bucket to store Vault data."
  type        = string
  default     = "secure-vault-2026"
}


//create variable for project name for Cognito user pool as "project_1"
variable "project_name" {
  description = "The name of the project."
  type        = string
  default     = "project_1"
}


variable "trail_name" {
  default = "vault-security-audit"
}