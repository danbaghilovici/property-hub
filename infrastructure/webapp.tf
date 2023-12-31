data "aws_caller_identity" "current" {}

resource "aws_cloudfront_origin_access_identity" "cloudfront_identity" {
  comment = "property-hub-cdn-frontend-identity"
}

data "aws_iam_policy_document" "read_asset_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.property-hub-webapp.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket" "property-hub-webapp" {
  bucket = "${data.aws_caller_identity.current.account_id}-property-hub-website-${terraform.workspace}"
  tags = {
    Name        = "property-hub website bucket"
  }
}
resource "aws_s3_bucket_public_access_block" "property-hub-bucket" {
  bucket = aws_s3_bucket.property-hub-webapp.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "read_assets" {
  bucket = aws_s3_bucket.property-hub-webapp.id
  policy = data.aws_iam_policy_document.read_asset_bucket.json
}

resource "aws_cloudfront_distribution" "property-hub-webapp" {
  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.property-hub-webapp.bucket
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    min_ttl     = 0
    default_ttl = 300
    max_ttl     = 24 * 3600

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }

  origin {
    domain_name = aws_s3_bucket.property-hub-webapp.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.property-hub-webapp.bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
