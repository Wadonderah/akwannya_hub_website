# ========================================
# ACM Module - SSL/TLS Certificate
# INACTIVE - Prepared for future custom domain
# ========================================

resource "aws_acm_certificate" "main" {
  count = var.domain_name != "" ? 1 : 0

  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = var.subject_alternative_names

  tags = merge(var.tags, {
    Name        = "${replace(var.domain_name, ".", "-")}-cert"
    Environment = var.environment
    ManagedBy   = "terraform"
  })

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "main" {
  count = var.domain_name != "" ? 1 : 0

  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  count = var.domain_name != "" ? length(aws_acm_certificate.main[0].domain_validation_options) : 0

  allow_overwrite = true
  name            = aws_acm_certificate.main[0].domain_validation_options[count.index].resource_record_name
  records         = [aws_acm_certificate.main[0].domain_validation_options[count.index].resource_record_value]
  ttl             = 60
  type            = aws_acm_certificate.main[0].domain_validation_options[count.index].resource_record_type
  zone_id         = data.aws_route53_zone.main[0].zone_id
}

resource "aws_acm_certificate_validation" "main" {
  count = var.domain_name != "" ? 1 : 0

  certificate_arn         = aws_acm_certificate.main[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  timeouts {
    create = "10m"
  }
}
