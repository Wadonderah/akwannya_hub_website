###############################################################################
# File        : variables.tf
# Project     : Akwannya Hub Infrastructure
#
# Description
# -----------
# Defines all configurable input variables for the project.
#
# Design Principles
# -----------------
# - No hardcoded values.
# - Strong validation.
# - Reusable across projects and environments.
# - Self-documenting variable descriptions.
###############################################################################

################################################################################
# AWS Configuration
################################################################################

variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed."

  type = string

  default = "eu-west-1"

  validation {
    condition     = length(trim(var.aws_region)) > 0
    error_message = "AWS region cannot be empty."
  }
}

################################################################################
# ACM Region (Fixed for CloudFront)
################################################################################

variable "acm_region" {
  description = "AWS region used for ACM certificates (must be us-east-1 for CloudFront)."

  type = string

  default = "us-east-1"

  validation {
    condition     = var.acm_region == "us-east-1"
    error_message = "CloudFront ACM certificates must be created in us-east-1."
  }
}

################################################################################
# Project Information
################################################################################

variable "project_name" {
  description = "Name of the project."

  type = string

  validation {
    condition     = length(trim(var.project_name)) >= 3
    error_message = "Project name must contain at least three characters."
  }
}

variable "environment" {
  description = "Deployment environment."

  type = string

  validation {
    condition = contains(
      [
        "dev",
        "test",
        "stage",
        "prod"
      ],
      lower(var.environment)
    )

    error_message = "Environment must be one of: dev, test, stage or prod."
  }
}

################################################################################
# S3 Bucket Configuration
################################################################################

variable "bucket_name_override" {
  description = "Optional custom bucket name. Leave null to use the generated naming convention."

  type = string

  default = null

  validation {
    condition     = var.bucket_name_override == null || length(trim(var.bucket_name_override)) >= 3
    error_message = "Bucket name must contain at least three characters if specified."
  }
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning."

  type = bool

  default = true
}

variable "enable_encryption" {
  description = "Enable default server-side encryption."

  type = bool

  default = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm."

  type = string

  default = "AES256"

  validation {
    condition = contains(
      [
        "AES256",
        "aws:kms"
      ],
      var.sse_algorithm
    )

    error_message = "Supported values are AES256 and aws:kms."
  }
}

variable "enable_lifecycle_rules" {
  description = "Enable S3 lifecycle rules."

  type = bool

  default = false
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days to retain previous object versions."

  type = number

  default = 90

  validation {
    condition = (
      var.noncurrent_version_expiration_days >= 1 &&
      var.noncurrent_version_expiration_days <= 3650
    )

    error_message = "Retention period must be between 1 and 3650 days."
  }
}

################################################################################
# Domain Configuration (Optional)
################################################################################

variable "domain_name" {
  description = "Custom domain name for the website. Leave empty to use CloudFront default URL."

  type = string

  default = ""

  validation {
    condition     = var.domain_name == "" || can(regex("^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,}$", var.domain_name))
    error_message = "Must be a valid domain name or empty for CloudFront default."
  }
}

variable "create_www_record" {
  description = "Create DNS record for www subdomain (only if domain_name is set)."

  type = bool

  default = true
}

variable "create_www_certificate" {
  description = "Create separate certificate for www subdomain (only if domain_name is set)."

  type = bool

  default = false
}

variable "subject_alternative_names" {
  description = "Additional Subject Alternative Names for the ACM certificate."

  type = list(string)

  default = []
}

################################################################################
# CloudFront Configuration
################################################################################

variable "price_class" {
  description = "CloudFront Price Class."

  type = string

  default = "PriceClass_100"

  validation {
    condition = contains(
      [
        "PriceClass_100",
        "PriceClass_200",
        "PriceClass_All"
      ],
      var.price_class
    )

    error_message = "Invalid CloudFront Price Class."
  }
}

variable "enable_waf" {
  description = "Enable WAF protection for CloudFront."

  type = bool

  default = false
}

variable "enable_logging" {
  description = "Enable CloudFront access logging."

  type = bool

  default = true
}

variable "log_retention_days" {
  description = "Number of days to retain CloudFront logs."

  type = number

  default = 30

  validation {
    condition     = var.log_retention_days >= 1 && var.log_retention_days <= 3650
    error_message = "Log retention period must be between 1 and 3650 days."
  }
}

variable "add_security_headers" {
  description = "Add security headers via CloudFront function."

  type = bool

  default = true
}

################################################################################
# Resource Tags
################################################################################

variable "owner" {
  description = "Infrastructure owner."

  type = string

  default = "Infrastructure Team"
}

variable "managed_by" {
  description = "Tool managing the infrastructure."

  type = string

  default = "Terraform"
}

variable "cost_center" {
  description = "Cost centre for billing purposes."

  type = string

  default = "Engineering"
}

variable "repository" {
  description = "Git repository name."

  type = string

  default = "akwannya_hub_website"
}

################################################################################
# Cost Control
################################################################################

variable "monthly_budget_limit" {
  description = "Monthly budget alert in USD (0 to disable)."

  type = number

  default = 10

  validation {
    condition     = var.monthly_budget_limit >= 0
    error_message = "Monthly budget must be greater than or equal to 0."
  }
}

################################################################################
# Resource Protection
################################################################################

variable "prevent_destroy" {
  description = "Protect critical resources from accidental destruction."

  type = bool

  default = true
}