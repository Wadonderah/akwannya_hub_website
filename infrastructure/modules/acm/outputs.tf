# ========================================
# ACM Module Outputs
# ========================================

output "certificate_arn" {
  description = "ARN of the ACM certificate (null if no domain configured)"
  value       = var.domain_name != "" ? aws_acm_certificate.main[0].arn : null
}

output "certificate_domain" {
  description = "Primary domain name of the certificate"
  value       = var.domain_name != "" ? aws_acm_certificate.main[0].domain_name : null
}

output "certificate_status" {
  description = "Status of the certificate"
  value       = var.domain_name != "" ? aws_acm_certificate.main[0].status : null
}

output "hosted_zone_id" {
  description = "Route53 hosted zone ID (null if no domain)"
  value       = var.domain_name != "" ? data.aws_route53_zone.main[0].zone_id : null
}

output "has_certificate" {
  description = "Whether a certificate is configured"
  value       = var.domain_name != ""
}
