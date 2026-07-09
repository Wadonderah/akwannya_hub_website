###############################################################################
# File        : locals.tf
# Project     : Akwannya Hub Infrastructure
#
# Description
# -----------
# Defines local values shared throughout the project.
#
# Notes
# -----
# - Centralizes common tags.
# - Centralizes resource naming conventions.
# - Keeps naming logic out of reusable modules.
###############################################################################

locals {
  #############################################################################
  # Common Tags
  #############################################################################
  #
  # Applied automatically to all supported AWS resources through the
  # AWS provider's default_tags block.
  #
  # Why tags matter:
  # - Cost tracking: Identify resource costs by project/environment
  # - Ownership: Know who owns each resource
  # - Management: Auto-detect resources for cleanup
  # - Compliance: Audit resource compliance
  #############################################################################

  common_tags = {
    Project     = var.project_name
    Environment = lower(var.environment)
    Owner       = var.owner
    ManagedBy   = var.managed_by
    CostCenter  = var.cost_center
    Repository  = var.repository
  }

  #############################################################################
  # Resource Naming
  #############################################################################
  #
  # Root module owns all naming conventions.
  # Child modules consume these names.
  #
  # Why use format() instead of interpolation?
  # ------------------------------------------
  # - format() is more readable for complex strings
  # - Easier to maintain and modify
  # - Consistent pattern across all resources
  #
  # S3 Bucket Naming:
  # -----------------
  # S3 bucket names must be globally unique across ALL AWS accounts.
  # This is why we add a random suffix.
  #
  # Format: {project}-{environment}-tf-state-{random}
  # Example: akwannya-hub-dev-tf-state-a3f9
  #
  # DynamoDB Table Naming:
  # ----------------------
  # DynamoDB table names only need to be unique within your AWS account.
  # Therefore, we use a predictable naming pattern.
  #
  # Format: {project}-{environment}-tf-locks
  # Example: akwannya-hub-dev-tf-locks
  #############################################################################

  state_bucket_name = format(
    "%s-%s-tf-state-%s",
    lower(var.project_name),
    lower(var.environment),
    random_string.bucket_suffix.result
  )

  lock_table_name = format(
    "%s-%s-tf-locks",
    lower(var.project_name),
    lower(var.environment)
  )

  #############################################################################
  # Domain Configuration (Optional)
  #############################################################################
  #
  # Determines if a custom domain is being used.
  # Website URL based on domain availability.
  #############################################################################

  use_custom_domain = var.domain_name != ""

  # This will be populated after CloudFront module is created
  website_url = var.domain_name != "" ? "https://${var.domain_name}" : "https://${module.cloudfront.cloudfront_domain_name}"
}