###############################################################################
# File        : modules/backend/outputs.tf
# Module      : Terraform Backend
# Project     : Akwannya Hub Infrastructure
#
# Description
# -----------
# Exposes reusable outputs from the backend module.
#
# Notes
# -----
# - Outputs form the public interface (API) of the module.
# - Only expose values required by the root module, CI/CD, or operators.
# - Avoid exposing unnecessary implementation details.
###############################################################################

################################################################################
# S3 Bucket Name
################################################################################

output "state_bucket_name" {
  description = "Name of the Terraform remote state bucket."

  value = aws_s3_bucket.terraform_state.bucket
}

################################################################################
# S3 Bucket ID
################################################################################

output "state_bucket_id" {
  description = "ID of the Terraform remote state bucket."

  value = aws_s3_bucket.terraform_state.id
}

################################################################################
# S3 Bucket ARN
################################################################################

output "state_bucket_arn" {
  description = "ARN of the Terraform remote state bucket."

  value = aws_s3_bucket.terraform_state.arn
}

################################################################################
# S3 Bucket Regional Domain Name
################################################################################

output "state_bucket_regional_domain_name" {
  description = "Regional domain name of the Terraform state bucket."

  value = aws_s3_bucket.terraform_state.bucket_regional_domain_name
}

################################################################################
# S3 Bucket Versioning Status
################################################################################

output "versioning_enabled" {
  description = "Indicates whether bucket versioning is enabled."

  value = var.enable_versioning
}

################################################################################
# Encryption Algorithm
################################################################################

output "encryption_algorithm" {
  description = "Server-side encryption algorithm used by the state bucket."

  value = var.sse_algorithm
}

################################################################################
# DynamoDB Lock Table Name
################################################################################

output "lock_table_name" {
  description = "Name of the DynamoDB state locking table."

  value = aws_dynamodb_table.terraform_lock.name
}

################################################################################
# DynamoDB Lock Table ARN
################################################################################

output "lock_table_arn" {
  description = "ARN of the DynamoDB state locking table."

  value = aws_dynamodb_table.terraform_lock.arn
}

################################################################################
# Backend Region
################################################################################

output "backend_region" {
  description = "AWS region where the backend resources are deployed."

  value = data.aws_region.current.name
}

################################################################################
# Backend Configuration Helper
################################################################################
#
# Why this is useful:
# -------------------
# When bootstrapping other Terraform projects, you can simply run:
#
# terraform output backend_configuration
#
# And get exactly what you need for your backend.hcl or backend.tf.
#
# This saves time and reduces the chance of configuration mistakes.
#
# Example usage in another project:
# ---------------------------------
# terraform {
#   backend "s3" {
#     bucket         = "akwannya-hub-prod-tf-state"
#     key            = "prod/terraform.tfstate"
#     region         = "eu-west-1"
#     dynamodb_table = "akwannya-hub-prod-tf-locks"
#     encrypt        = true
#   }
# }
################################################################################

output "backend_configuration" {
  description = "Backend configuration values used by other Terraform projects."

  value = {
    bucket         = aws_s3_bucket.terraform_state.bucket
    region         = data.aws_region.current.name
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
  }
}