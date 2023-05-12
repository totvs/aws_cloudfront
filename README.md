# aws_cloudfront

Terraform module that creates an AWS Cloudfront.

## Inputs

```hcl
module "aws_cloudfront" {
  source = "../modules/aws_cloudfront"

  domain_name                    = # DNS domain name of either the S3 bucket, or web site of your custom origin
  origin_id                      = # Unique identifier for the origin
  cloudfront_enable              = # Whether the distribution is enabled to accept end user requests for content
  default_root_object            = # Object that you want CloudFront to return (for example, index.html) when an end user requests the root URL
  aliases                        = # Extra CNAMEs (alternate domain names), if any, for this distribution
  allowed_methods                = # Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin
  cached_methods                 = # Controls whether CloudFront caches the response to requests using the specified HTTP methods
  target_origin_id               = # Value of ID for the origin that you want CloudFront to route requests to when a request matches the path pattern either for a cache behavior or for the default cache behavior
  cookies_forward                = # Whether you want CloudFront to forward cookies to the origin that is associated with this cache behavior
  viewer_protocol_policy         = # Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern
  min_ttl                        = # Minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated
  default_ttl                    = # Default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header
  max_ttl                        = # Maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated
  restriction_type               = # Method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist
  restriction_locations          = # ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist). If the type is specified as none an empty array can be used
  cloudfront_default_certificate = # true if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. Specify this, acm_certificate_arn, or iam_certificate_id
  acm_certificate_arn            = # ARN of the AWS Certificate Manager certificate that you wish to use with this distribution. Specify this, cloudfront_default_certificate, or iam_certificate_id
  ssl_support_method             = # How you want CloudFront to serve HTTPS requests. One of vip or sni-only
  minimum_protocol_version       = # Minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections
}
```

Example
```hcl
module "aws_cloudfront" {
  source = "../modules/aws_cloudfront"

  domain_name                    = example.io
  origin_id                      = origin-resource-name
  cloudfront_enable              = true
  default_root_object            = ["example.to"]
  aliases                        = ["example2.io",example3.io]
  allowed_methods                = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods                 = ["GET", "HEAD"]
  target_origin_id               = origin-resource-name
  cookies_forward                 = "none"
  viewer_protocol_policy         = "allow-all"
  min_ttl                        = 0
  default_ttl                    = 3600
  max_ttl                        = 86400
  restriction_type               = "whitelist"
  restriction_locations          = ["BR", "MX", "AR", "US", "CA", "GB", "JP", "CL"]
  cloudfront_default_certificate = false
  acm_certificate_arn            = "arn:aws:acm:us-east-1:XXXXXXXXXXXXXXXX:certificate/YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY"
  ssl_support_method             = "sni-only"
  minimum_protocol_version       = "TLSv1.2_2021"
}
```