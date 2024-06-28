resource "aws_cloudfront_distribution" "cloudfront" {
  
  enabled             = var.cloudfront_enable
  default_root_object = var.default_root_object
  aliases             = var.aliases
  is_ipv6_enabled     = var.is_ipv6_enabled

  custom_error_response {
    error_caching_min_ttl = var.custom_error_response["error_caching_min_ttl"]
    error_code            = var.custom_error_response["error_code"]
    response_code         = var.custom_error_response["response_code"]
    response_page_path    = var.custom_error_response["response_page_path"]
  }
  
  default_cache_behavior {
    allowed_methods  = var.default_cache_behavior["allowed_methods"]
    cached_methods   = var.default_cache_behavior["cached_methods"]
    target_origin_id = var.default_cache_behavior["target_origin_id"]

    compress               = var.default_cache_behavior["compress"]
    viewer_protocol_policy = var.default_cache_behavior["viewer_protocol_policy"]
    min_ttl                = var.default_cache_behavior["min_ttl"]
    default_ttl            = var.default_cache_behavior["default_ttl"]
    max_ttl                = var.default_cache_behavior["max_ttl"]

    forwarded_values {
      query_string = var.default_cache_behavior["forwarded_values"]["query_string"]
      cookies {
        forward = var.default_cache_behavior["forwarded_values"]["cookies"]["forward"]
      }
    }
  }

  origin {
    domain_name = var.origin["domain_name"]
    origin_id   = var.origin["origin_id"]
  }
  
  restrictions {
    geo_restriction {
      restriction_type = var.restrictions["geo_restriction"]["restriction_type"]
      locations        = var.restrictions["geo_restriction"]["locations"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.viewer_certificate["cloudfront_default_certificate"]
    acm_certificate_arn            = var.viewer_certificate["acm_certificate_arn"]
    ssl_support_method             = var.viewer_certificate["ssl_support_method"]
    minimum_protocol_version       = var.viewer_certificate["minimum_protocol_version"]
  }
}


data "aws_route53_zone" "hz" {
  name         = var.zone_domain_name
  private_zone = false
}

data "aws_route53_zone" "hz_public" {
  name         = var.zone_domain_name
  private_zone = public
}


resource "aws_route53_record" "hz" {
  count = length(var.aliases)

  zone_id = data.aws_route53_zone.hz.zone_id
  name    = var.aliases[count.index]
  type    = "A"
  
  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "hz_public" {
  count = length(var.aliases)

  zone_id = data.aws_route53_zone.hz_public.zone_id
  name    = var.aliases[count.index]
  type    = "A"
  
  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
    evaluate_target_health = true
  }
}