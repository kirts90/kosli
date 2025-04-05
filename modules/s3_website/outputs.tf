output "bucket_id" {
  description = "The S3 bucket ID"
  value       = aws_s3_bucket.website_bucket.id
}

output "cloudfront_distribution_id" {
  description = "The CloudFront distribution ID"
  value       = aws_cloudfront_distribution.website_cf.id
}

output "website_url" {
  description = "The CloudFront domain name"
  value       = aws_cloudfront_distribution.website_cf.domain_name
}

output "domain_url" {
  description = "The website domain name"
  value       = "https://${var.domain_name}"
}