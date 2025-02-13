# CloudFront Endpoints
output "cloudfront_endpoints" {
  description = "CloudFront endpoints for each domain"
  value       = { for domain in var.domains : domain => aws_cloudfront_distribution.s3_distribution[domain].domain_name }
}

# CloudFront IDs
output "cloudfront_distribution_ids" {
  description = "CloudFront distribution IDs"
  value = { for domain, cf in aws_cloudfront_distribution.s3_distribution : domain => cf.id }
}

# S3 Bucket ARNs
output "s3bucket_arns" {
  description = "S3 bucket ARNs for each domain"
  value       = { for domain in var.domains : domain => aws_s3_bucket.s3bucket[domain].arn }
}

# ACM Certificate ARNs
output "acm_certificate_arns" {
  description = "ACM certificate ARNs for each domain"
  value       = { for domain in var.domains : domain => aws_acm_certificate.managed_cert[domain].arn }
}


## IAM User Access Keys: Add to GitLab CI Variables

# Output Access Keys (Make sure to securely store them)
output "gitlab_ci_access_key_id" {
  value     = aws_iam_access_key.gitlab_ci_user_key.id
  sensitive = true
}

output "gitlab_ci_secret_access_key" {
  value     = aws_iam_access_key.gitlab_ci_user_key.secret
  sensitive = true
}