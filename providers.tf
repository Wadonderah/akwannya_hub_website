###############################################################################
# File        : providers.tf
# Project     : Akwannya Hub Infrastructure
#
# Description
# -----------
# Configures the AWS provider used by Terraform.
#
# Why this file exists
# --------------------
# - Defines the AWS region.
# - Applies default tags to every supported AWS resource.
# - Configures provider aliases for multi-region support.
# - Centralizes provider configuration.
###############################################################################

################################################################################
# Primary AWS Provider
################################################################################
# This provider is used for all resources unless overridden.
#
# Resources in this provider:
# - S3 buckets
# - CloudFront distributions
# - Route53 records
# - IAM roles/policies
# - Budget alerts
################################################################################

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

################################################################################
# AWS Provider Alias: us-east-1
################################################################################
# This provider is required for ACM certificates used with CloudFront.
#
# Why us-east-1 is required:
# - CloudFront distributions can ONLY use ACM certificates from us-east-1.
# - This is a hard AWS requirement.
# - Even if primary region is different, ACM must be in us-east-1.
#
# Resources in this provider:
# - ACM certificates
# - Certificate validations
################################################################################

provider "aws" {
  alias  = "us_east_1"
  region = var.acm_region

  default_tags {
    tags = local.common_tags
  }
}

################################################################################
# AWS Provider Alias: Primary Region (Explicit)
################################################################################
# Optional: Use this if you need to explicitly reference the primary provider.
# Use with: provider = aws.primary
################################################################################

# provider "aws" {
#   alias  = "primary"
#   region = var.aws_region
#
#   default_tags {
#     tags = local.common_tags
#   }
# }