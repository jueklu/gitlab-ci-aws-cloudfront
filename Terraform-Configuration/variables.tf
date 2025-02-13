# CloudFront Domains
variable "domains" {
  description = "List of domain names"
  type        = list(string)
  default     = ["cf-dev.jklug.work", "cf-prod.jklug.work"]
}

# Route 53 Hosted Zone ID
variable "route53_zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
  default     = "Z05838622L1SISL2KGD4M" 
}


# IAM User for GitLab CI
variable "gitlab_ci_iam_user" {
  description = "IAM User for GitLab CI"
  type        = string
  default     = "gitlab-ci-cf-s3-deploy" 
}

# IAM Policy for GitLab CI: Access S3
variable "gitlab_ci_iam_policy_s3" {
  description = "IAM Policy for GitLab CI"
  type        = string
  default     = "gitlab-ci-cf-s3-deploy" 
}

# IAM Policy for GitLab CI: CloudFront Invalidation
variable "gitlab_ci_iam_policy_cf" {
  description = "IAM Policy for GitLab CI"
  type        = string
  default     = "gitlab-ci-cf-invalidation" 
}