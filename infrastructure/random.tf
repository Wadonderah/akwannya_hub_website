###############################################################################
# File        : random.tf
# Project     : Terraform Backend Bootstrap
#
# Description
# -----------
# Generates globally unique suffixes for resources that require
# globally unique names.
#
# Why a dedicated file?
# --------------------
# - Keeps all randomness centralized
# - Makes it obvious why it exists
# - Easy to find and modify
# - Prevents accidental deletion
#
# Why 6 characters?
# -----------------
# - 6 hex characters = 16,777,216 possible combinations
# - Enough to ensure global uniqueness
# - Short enough to stay readable
# - Example: a3f9b7, c4d8e2, f5a6b3
###############################################################################

resource "random_string" "bucket_suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false

  # Keep the suffix consistent across terraform apply runs
  keepers = {
    project_name = var.project_name
    environment  = var.environment
  }
}
