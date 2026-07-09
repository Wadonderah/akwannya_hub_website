###############################################################################
# File        : versions.tf
# Project     : Akwannya Hub Infrastructure
#
# Description
# -----------
# Defines the required Terraform version and required providers.
#
# Why this file exists
# --------------------
# - Ensures all engineers use a compatible Terraform version.
# - Prevents unexpected behaviour caused by provider upgrades.
# - Makes builds reproducible across development, CI/CD and production.
###############################################################################

terraform {
  ###########################################################################
  # Required Terraform Version
  ###########################################################################

  required_version = ">= 1.14.0"

  ###########################################################################
  # Required Providers
  ###########################################################################
  #
  # Provider Version Constraints:
  # -----------------------------
  # - Use "~>" (pessimistic constraint) to allow patch updates only.
  # - This prevents breaking changes from minor/major upgrades.
  #
  # AWS Provider (~> 6.0):
  # - Allows: 6.0.x only (e.g., 6.0.0, 6.0.1)
  # - Prevents: 6.1.0 (would contain breaking changes)
  #
  # Random Provider (~> 3.7):
  # - Allows: 3.7.x only (e.g., 3.7.0, 3.7.1)
  # - Used for generating unique suffixes for bucket names
  ###########################################################################

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}