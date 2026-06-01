// Define the required Terraform version and the AWS provider with its version constraint. The AWS provider is configured to use the region specified in the variable `aws_region`.
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

// Configure the AWS provider to use the region specified in the variable `aws_region`.
provider "aws" {
  region = var.aws_region
}
