# AWS Managed TLS Certificates
resource "aws_acm_certificate" "managed_cert" {
  for_each = toset(var.domains)

  domain_name       = each.key
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Route 53 Entries for Certificate Validation
resource "aws_route53_record" "cert_validation" {

  for_each = { for domain in var.domains : domain => tolist(aws_acm_certificate.managed_cert[domain].domain_validation_options) }

  zone_id = var.route53_zone_id
  name    = each.value[0].resource_record_name
  type    = each.value[0].resource_record_type
  records = [each.value[0].resource_record_value]
  ttl     = 300
}

# Certificate Validation Status
resource "aws_acm_certificate_validation" "cert_validation" {
  for_each = aws_acm_certificate.managed_cert

  certificate_arn         = each.value.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn if record.name == each.value.domain_name]
}