# S3-based website outputs (Solution 1)
output "s3_website_url" {
  description = "The CloudFront domain name for the S3 website"
  value       = module.s3_website.website_url
}

output "s3_domain_url" {
  description = "The website domain name for the S3 website"
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

# EC2-based website outputs (Solution 2)
output "ec2_website_url" {
  description = "The URL for the EC2-based website"
  value       = var.vpc_id != "" && length(var.subnet_ids) > 0 && var.ami_id != "" ? module.ec2_website[0].website_url : "EC2 website not deployed"
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = var.vpc_id != "" && length(var.subnet_ids) > 0 && var.ami_id != "" ? module.ec2_website[0].alb_dns_name : "EC2 website not deployed"
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = var.vpc_id != "" && length(var.subnet_ids) > 0 && var.ami_id != "" ? module.ec2_website[0].asg_name : "EC2 website not deployed"
}