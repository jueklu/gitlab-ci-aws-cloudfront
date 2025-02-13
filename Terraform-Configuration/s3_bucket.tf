# S3 Buckets for each domain
resource "aws_s3_bucket" "s3bucket" {
  for_each = toset(var.domains)

  bucket = replace(each.key, ".", "-") # Replace dots with hyphens for valid S3 names

  tags = {
    Name = "Bucket for ${each.key}"
  }
}

# Bucket Ownership
resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  for_each = aws_s3_bucket.s3bucket

  bucket = each.value.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}