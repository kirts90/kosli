# S3-based website outputs (Solution 1)
output "s3_website_url" {
  description = "The CloudFront domain name for the S3 website"
  value       = length(module.s3_website) > 0 ? module.s3_website[0].website_url : "S3 website not deployed"
}

output "s3_domain_url" {
  description = "The website domain name for the S3 website"
  value       = length(module.s3_website) > 0 ? module.s3_website[0].domain_url : "S3 website not deployed"
}

output "bucket_id" {
  description = "The S3 bucket ID"
  value       = length(module.s3_website) > 0 ? module.s3_website[0].bucket_id : "S3 website not deployed"
}

output "cloudfront_distribution_id" {
  description = "The CloudFront distribution ID"
  value       = length(module.s3_website) > 0 ? module.s3_website[0].cloudfront_distribution_id : "E265OJ8PZ5FK14"
}

# EC2-based website outputs (Solution 2)
output "ec2_website_url" {
  description = "The URL for the EC2-based website"
  value       = var.vpc_id != "" && length(var.subnet_ids) > 0 && var.ami_id != "" ? module.ec2_website[0].website_url : "EC2 website not deployed"
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = var.vpc_id != "" && length(var.subnet_ids) > 0 && var.ami_id != "" ? module.ec2_website[0].instance_id : "EC2 website not deployed"
}

output "elastic_ip" {
  description = "Elastic IP address"
  value       = var.vpc_id != "" && length(var.subnet_ids) > 0 && var.ami_id != "" ? module.ec2_website[0].elastic_ip : "EC2 website not deployed"
}