###############################################################################
# File        : main.tf
# Project     : Akwannya Hub Infrastructure
#
# Description
# -----------
# Root module responsible for orchestrating the backend infrastructure.
#
# Notes
# -----
# - No AWS resources are declared directly in this file.
# - Only reusable modules are invoked.
# - All naming logic is centralized in locals.tf.
###############################################################################

################################################################################
# Backend Infrastructure
################################################################################
#
# Creates the Terraform remote state infrastructure:
# - S3 bucket for state storage
# - DynamoDB table for state locking
#
# Why this is separate:
# ---------------------
# - Backend resources must exist BEFORE Terraform can use them
# - They are bootstrapped in a separate phase
# - They are protected from accidental deletion
################################################################################

module "backend" {
  source = "./modules/backend"

  ###########################################################################
  # Project Information
  ###########################################################################

  project_name = var.project_name
  environment  = var.environment

  ###########################################################################
  # Resource Names (from locals.tf)
  ###########################################################################
  #
  # These names are generated centrally to ensure consistency.
  #
  # state_bucket_name: akwannya-hub-prod-tf-state-k4m8x2
  # lock_table_name:   akwannya-hub-prod-tf-locks
  ###########################################################################

  state_bucket_name = local.state_bucket_name
  lock_table_name   = local.lock_table_name

  ###########################################################################
  # Bucket Configuration
  ###########################################################################

  enable_versioning = var.enable_versioning
  enable_encryption = var.enable_encryption
  sse_algorithm     = var.sse_algorithm

  enable_lifecycle_rules = var.enable_lifecycle_rules
  noncurrent_version_expiration_days = var.noncurrent_version_expiration_days

  ###########################################################################
  # Resource Protection
  ###########################################################################

  prevent_destroy = var.prevent_destroy

  ###########################################################################
  # Common Tags
  ###########################################################################

  tags = local.common_tags
}

################################################################################
# Outputs
################################################################################
#
# These outputs are used to verify the backend infrastructure
# and to configure other Terraform projects.
#
# Example usage:
# ---------------
# terraform output backend_configuration
################################################################################

output "state_bucket_name" {
  description = "Name of the Terraform state bucket"
  value       = module.backend.state_bucket_name
}

output "lock_table_name" {
  description = "Name of the DynamoDB lock table"
  value       = module.backend.lock_table_name
}

output "backend_configuration" {
  description = "Complete backend configuration for other projects"
  value       = module.backend.backend_configuration
}