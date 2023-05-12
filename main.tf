resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = var.domain_name
    origin_id   = var.origin_id
  }

  enabled             = var.cloudfront_enable
  default_root_object = var.default_root_object

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = var.target_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = var.cookies_forward
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }
  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations        = var.restriction_locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.cloudfront_default_certificate
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.ssl_support_method
    minimum_protocol_version       = var.minimum_protocol_version
  }

}