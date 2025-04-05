output "website_url" {
  description = "The CloudFront domain name"
  value       = module.s3_website.website_url
}

output "domain_url" {
  description = "The website domain name"
  value       = module.s3_website.domain_url
}

output "bucket_id" {
  description = "The S3 bucket ID"
  value       = module.s3_website.bucket_id
}

output "cloudfront_distribution_id" {
  description = "The CloudFront distribution ID"
  value       = module.s3_website.cloudfront_distribution_id
}