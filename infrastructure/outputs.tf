###############################################################################
# File        : outputs.tf
# Project     : Terraform Backend Bootstrap
#
# Description
# -----------
# Exposes outputs from the backend module.
#
# Notes
# -----
# - The root module should expose only the values useful to operators,
#   automation, and downstream Terraform projects.
# - Outputs are intentionally delegated from the backend module.
###############################################################################

################################################################################
# Remote State Bucket
################################################################################

output "state_bucket_name" {

  description = "Name of the Terraform remote state bucket."

  value = module.backend.state_bucket_name

}

################################################################################
# Remote State Bucket ARN
################################################################################

output "state_bucket_arn" {

  description = "ARN of the Terraform remote state bucket."

  value = module.backend.state_bucket_arn

}

################################################################################
# Remote State Bucket ID
################################################################################

output "state_bucket_id" {

  description = "ID of the Terraform remote state bucket."

  value = module.backend.state_bucket_id

}

################################################################################
# Remote State Bucket Regional Domain Name
################################################################################

output "state_bucket_regional_domain_name" {

  description = "Regional endpoint of the Terraform remote state bucket."

  value = module.backend.state_bucket_regional_domain_name

}

################################################################################
# DynamoDB Lock Table
################################################################################

output "lock_table_name" {

  description = "Name of the Terraform state locking table."

  value = module.backend.lock_table_name

}

################################################################################
# DynamoDB Lock Table ARN
################################################################################

output "lock_table_arn" {

  description = "ARN of the Terraform state locking table."

  value = module.backend.lock_table_arn

}

################################################################################
# Backend AWS Region
################################################################################

output "backend_region" {

  description = "AWS Region hosting the Terraform backend."

  value = module.backend.backend_region

}

################################################################################
# Backend Configuration
################################################################################

output "backend_configuration" {

  description = "Backend configuration used by downstream Terraform projects."

  value = module.backend.backend_configuration

}

################################################################################
# Versioning Status
################################################################################

output "versioning_enabled" {

  description = "Indicates whether bucket versioning is enabled."

  value = module.backend.versioning_enabled

}

################################################################################
# Encryption Algorithm
################################################################################

output "encryption_algorithm" {

  description = "Encryption algorithm used by the backend bucket."

  value = module.backend.encryption_algorithm

}