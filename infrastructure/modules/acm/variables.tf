# ========================================
# ACM Module Variables
# ========================================

variable "domain_name" {
  description = "Domain name for the certificate (leave empty for CloudFront default)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names for the certificate"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
