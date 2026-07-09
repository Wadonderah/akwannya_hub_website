###############################################################################
# File        : backend.tf
# Project     : Akwannya Hub Infrastructure
# Description : Configures the remote Terraform backend.
#
# Notes:
# - Backend values are intentionally NOT hardcoded.
# - Environment-specific backend configuration is supplied during
#   `terraform init` using a backend.hcl file.
# - Remote state is stored in Amazon S3.
# - State locking is provided by Amazon DynamoDB.
###############################################################################

terraform {

  backend "s3" {}

}