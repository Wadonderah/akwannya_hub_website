###############################################################################
# File        : backend.hcl
# Environment : Production
# Project     : Terraform Backend Bootstrap
#
# Description
# -----------
# Backend configuration used AFTER the backend infrastructure has been created.
#
# IMPORTANT
# ---------
# This file is NOT used during the initial bootstrap.
#
# Bootstrap Process:
#
# 1. Deploy backend locally.
# 2. Create S3 bucket.
# 3. Create DynamoDB table.
# 4. Update this file.
# 5. Run:
#
#    terraform init -migrate-state
#
###############################################################################

###############################################################################
# Amazon S3 Backend
###############################################################################

bucket = "REPLACE_WITH_CREATED_BUCKET_NAME"

###############################################################################
# Terraform State File
###############################################################################

key = "terraform/backend/terraform.tfstate"

###############################################################################
# AWS Region
###############################################################################

region = "eu-west-1"

###############################################################################
# DynamoDB Lock Table
###############################################################################

dynamodb_table = "akwannya-hub-prod-tf-locks"

###############################################################################
# Encryption
###############################################################################

encrypt = true