###############################################################################
# File        : modules/backend/main.tf
# Module      : Terraform Backend
# Project     : Akwannya Hub Infrastructure
#
# Description
# -----------
# Creates the infrastructure required for Terraform remote state.
#
# Resources
# ---------
# - Amazon S3 (Terraform State)
# - DynamoDB (State Locking)
###############################################################################

################################################################################
# Current AWS Region
################################################################################
#
# This data source retrieves the AWS region from the provider configuration.
#
# Why use a data source instead of a variable?
# --------------------------------------------
# - The backend module doesn't receive aws_region as an input variable.
# - It relies on the provider configuration.
# - Using a data source ensures accuracy and decouples the module.
################################################################################

data "aws_region" "current" {}

################################################################################
# Amazon S3 Bucket
################################################################################
#
# Stores the Terraform state file.
#
# This bucket:
# - Is private
# - Uses versioning
# - Uses server-side encryption
# - Is protected against accidental deletion
#
# Why prevent_destroy?
# --------------------
# This is one of the most important settings in the entire backend.
#
# Without protection:
# - S3 Bucket: ❌ Deleted
# - Terraform State: ❌ Lost
# - Infrastructure: ❌ Unmanageable
#
# With prevent_destroy = true:
# - Terraform stops immediately with an error
# - Protects the backend from accidental deletion
################################################################################

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket_name

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }

  tags = merge(
    var.tags,
    {
      Name    = var.state_bucket_name
      Purpose = "Terraform Remote State"
      Type    = "State Bucket"
    }
  )

  # Ensure bucket is deleted even if it has objects (for non-prod only)
  force_destroy = !var.prevent_destroy
}

################################################################################
# Amazon S3 Ownership Controls
################################################################################
#
# Enforces bucket owner ownership for all objects.
#
# This disables ACLs and ensures that all objects uploaded to the bucket are
# owned by the AWS account that owns the bucket.
#
# Why?
# -----
# AWS recommends disabling ACLs for all new S3 buckets.
#
# Benefits:
# - Simpler permissions
# - Better security
# - IAM and bucket policies become the only access mechanism
# - Eliminates ownership conflicts
################################################################################

resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

################################################################################
# Amazon S3 Public Access Block
################################################################################
#
# Blocks every possible method of making the bucket public.
#
# Why?
# -----
# A Terraform state bucket should never be publicly accessible.
# Even accidentally exposing it could reveal infrastructure details.
# This configuration is AWS's recommended secure baseline.
################################################################################

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

################################################################################
# Amazon S3 Bucket Versioning
################################################################################
#
# Why Versioning is Mandatory for State:
# --------------------------------------
# - Terraform updates the state file on almost every successful apply
# - If the state becomes corrupted, versioning allows recovery
# - Previous versions can be restored if needed
#
# Versioning gives you:
# - Version 1
# - Version 2
# - Version 3
#
# So you can recover previous state files.
#
# This is why HashiCorp strongly recommends enabling versioning
# on remote state buckets.
################################################################################

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

################################################################################
# Amazon S3 Server-Side Encryption
################################################################################
#
# Protects sensitive data at rest.
# - State files may contain sensitive information
# - Secrets, passwords, and keys could be in state
# - Encryption ensures data is protected
################################################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }

    bucket_key_enabled = true
  }
}

################################################################################
# Amazon S3 Lifecycle Policy
################################################################################
#
# Manages cost by transitioning older versions to cheaper storage.
# - Non-current versions are transitioned to Standard-IA after 30 days
# - Non-current versions are expired after 90 days
# - Current versions remain accessible
################################################################################

resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "transition-old-versions"
    status = var.enable_lifecycle_rules ? "Enabled" : "Disabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

################################################################################
# Amazon DynamoDB Table
################################################################################
#
# Used by Terraform to provide state locking.
#
# State locking prevents multiple users or CI/CD pipelines from modifying the
# same Terraform state simultaneously.
#
# Why State Locking is Critical:
# ------------------------------
# - Without locking, two users could apply changes simultaneously
# - This causes "state drift" and inconsistency
# - Locking prevents corruption of the state file
#
# Example:
# - User A: terraform apply (acquires lock)
# - User B: terraform apply (waits for lock)
# - User A: releases lock
# - User B: can now apply
#
# This ensures only one person modifies the state at a time.
#
# PAY_PER_REQUEST billing:
# ------------------------
# - Cost-effective for variable workloads
# - You pay only for what you use
# - No need to provision capacity
################################################################################

resource "aws_dynamodb_table" "terraform_lock" {
  name           = var.lock_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  stream_enabled = false

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }

  tags = merge(
    var.tags,
    {
      Name    = var.lock_table_name
      Purpose = "Terraform State Locking"
    }
  )
}