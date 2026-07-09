###############################################################################
# File        : modules/backend/variables.tf
# Module      : Terraform Backend
# Project     : Akwannya Hub Infrastructure
#
# Description
# -----------
# Defines all input variables required by the backend module.
#
# Notes
# -----
# - This file forms the public input interface of the module.
# - The root module is responsible for supplying these values.
# - No naming conventions should be generated inside this module.
###############################################################################

################################################################################
# Project Information
################################################################################

variable "project_name" {
  description = "Name of the project."

  type = string
}

variable "environment" {
  description = "Deployment environment."

  type = string
}

################################################################################
# Resource Names
################################################################################

variable "state_bucket_name" {
  description = "Name of the Terraform remote state bucket."

  type = string
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table used for Terraform state locking."

  type = string
}

################################################################################
# Bucket Configuration
################################################################################

variable "enable_versioning" {
  description = "Enable bucket versioning."

  type = bool
}

variable "enable_encryption" {
  description = "Enable default server-side encryption."

  type = bool
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm."

  type = string
}

variable "enable_lifecycle_rules" {
  description = "Enable lifecycle configuration."

  type = bool
}

variable "noncurrent_version_expiration_days" {
  description = "Retention period for previous object versions."

  type = number
}

################################################################################
# Resource Protection
################################################################################

variable "prevent_destroy" {
  description = "Protect backend resources from accidental deletion."

  type = bool
}

################################################################################
# Common Tags
################################################################################

variable "tags" {
  description = "Tags applied to all resources."

  type = map(string)
}