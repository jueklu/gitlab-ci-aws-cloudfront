# IAM User for GitLab CI Pipeline
resource "aws_iam_user" "gitlab_ci_user" {
  name = var.gitlab_ci_iam_user
}

# IAM Policy for GitLab CI Pipeline / Access S3 Buckets
resource "aws_iam_policy" "gitlab_ci_s3_access_policy" {
  name        = var.gitlab_ci_iam_policy_s3
  description = "IAM Policy for S3"

  depends_on = [aws_s3_bucket.s3bucket]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [for bucket in aws_s3_bucket.s3bucket : bucket.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = [for bucket in aws_s3_bucket.s3bucket : "${bucket.arn}/*"]
      }
    ]
  })
}

# IAM Policy for GitLab CI Pipeline / Invalidate CloudFront Cache
resource "aws_iam_policy" "gitlab_cf_policy" {
  name        = var.gitlab_ci_iam_policy_cf
  description = "IAM Policy for CloudFront Invalidation "

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "cloudfront:CreateInvalidation"
        Resource = [for distribution in aws_cloudfront_distribution.s3_distribution : distribution.arn]
      }
    ]
  })
}


# Attach S3 Policy to IAM User
resource "aws_iam_user_policy_attachment" "gitlab_ci_s3_access_polic_attachment" {
  user       = aws_iam_user.gitlab_ci_user.name
  policy_arn = aws_iam_policy.gitlab_ci_s3_access_policy.arn
}

# Attach CloudFront Policy to IAM User
resource "aws_iam_user_policy_attachment" "gitlab_ci_cf_policy_attachment" {
  user       = aws_iam_user.gitlab_ci_user.name
  policy_arn = aws_iam_policy.gitlab_cf_policy.arn
}


# IAM Access Key IAM User
resource "aws_iam_access_key" "gitlab_ci_user_key" {
  user = aws_iam_user.gitlab_ci_user.name
}