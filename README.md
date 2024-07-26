# aws_cloudfront

Terraform module that creates an AWS Cloudfront.

## Inputs

```hcl
module "aws_cloudfront" {
  source = "aws_cloudfront"
  
  cloudfront_enable   = # Whether the distribution is enabled to accept end user requests for content
  default_root_object = # Object that you want CloudFront to return (for example, index.html) when an end user requests the root URL
  aliases             = # Extra CNAMEs (alternate domain names), if any, for this distribution
  is_ipv6_enabled     = # Whether the IPv6 is enabled for the distribution
  
  custom_error_response = {
    error_caching_min_ttl = # Minimum amount of time you want HTTP error codes to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated
    error_code            = # 4xx or 5xx HTTP status code that you want to customize
    response_code         = # HTTP status code that you want CloudFront to return with the custom error page to the viewer.
    response_page_path    = # Path of the custom error page
  }

  default_cache_behavior = {
    allowed_methods  = # Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin
    cached_methods   = # Controls whether CloudFront caches the response to requests using the specified HTTP methods
    target_origin_id = # Value of ID for the origin that you want CloudFront to route requests to when a request matches the path pattern either for a cache behavior or for the default cache behavior

    compress               = # Whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header
    viewer_protocol_policy = # Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern
    min_ttl                = # Minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated
    default_ttl            = # Default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header
    max_ttl                = # Maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated

    forwarded_values = {
      query_string = # Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior
      cookies = {
        forward = # Whether you want CloudFront to forward cookies to the origin that is associated with this cache behavior
      }
    }
  }

  origin = {
    domain_name = # DNS domain name of either the S3 bucket, or web site of your custom origin
    origin_id   = # Unique identifier for the origin
  }

  custom_origin_config { # Required when using S3 Bucket Websites
    http_port              = # HTTP Port for custom origin
    https_port             = # HTTPS Port for custom origin
    origin_protocol_policy = # Protocol policy to use such as "http-only"
    origin_ssl_protocols   = # SSL protocols to use such as ["TLSv1", "TLSv1.1", "TLSv1.2"]
  } 

  restrictions = {
    geo_restriction = {
      restriction_type = # Method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist
      locations        = # ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist). If the type is specified as none an empty array can be used
    }
  }

  viewer_certificate = {
    cloudfront_default_certificate = # true if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. Specify this, acm_certificate_arn, or iam_certificate_id
    acm_certificate_arn            = # ARN of the AWS Certificate Manager certificate that you wish to use with this distribution. Specify this, cloudfront_default_certificate, or iam_certificate_id
    ssl_support_method             = # How you want CloudFront to serve HTTPS requests. One of vip or sni-only
    minimum_protocol_version       = # Minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections
  }
}
```

Example
```hcl
module "aws_cloudfront" {
  source = "aws_cloudfront"
  
  cloudfront_enable   = true
  default_root_object = index.html
  aliases             = ["example2.io",example3.io]
  is_ipv6_enabled     = true
  
  custom_error_response = {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 200
    response_page_path    = "/custom_404.html"
  }

  default_cache_behavior = {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = origin-resource-name

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values = {
      query_string = false
      cookies = {
        forward = "none"
      }
    }
  }

  origin = {
    domain_name = example.io
    origin_id   = origin-resource-name
  } 

  restrictions = {
    geo_restriction = {
      restriction_type = "whitelist"
      locations        = ["BR", "MX", "AR", "US", "CA", "GB", "JP", "CL"]
    }
  }

  viewer_certificate = {
    cloudfront_default_certificate = false
    acm_certificate_arn            = "arn:aws:acm:us-east-1:XXXXXXXXXXXXXXXX:certificate/YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY"
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}
```