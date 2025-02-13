# CloudFront Distributions
resource "aws_cloudfront_distribution" "s3_distribution" {
  for_each = aws_s3_bucket.s3bucket

  origin {
    domain_name              = each.value.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = each.value.id
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "CloudFront for ${each.key}"
  default_root_object = "index.html"

  aliases = [each.key]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = each.value.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["AT", "DE"]
    }
  }

  tags = {
    Environment = "production"
  }

  depends_on = [aws_acm_certificate_validation.cert_validation]

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.managed_cert[each.key].arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# Route 53 CNAME Records for CloudFront
resource "aws_route53_record" "cloudfront_cname" {
  for_each = aws_cloudfront_distribution.s3_distribution

  zone_id = var.route53_zone_id
  name    = each.key
  type    = "CNAME"
  ttl     = 300

  records = [each.value.domain_name]

  depends_on = [aws_cloudfront_distribution.s3_distribution]
}


## Permissions

# CloudFront Access Control
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "s3-oac"
  description                       = "CloudFront access to S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# S3 Bucket Policies for CloudFront Access
resource "aws_s3_bucket_policy" "s3bucket_policy" {
  for_each = aws_s3_bucket.s3bucket

  bucket = each.value.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:GetObject"
      Resource = "${each.value.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution[each.key].arn
        }
      }
    }]
  })
}