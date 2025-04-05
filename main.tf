provider "aws" {
  region = var.aws_region
}

module "s3_website" {
  source          = "./modules/s3_website"
  bucket_name     = var.s3_bucket_name
  index_html_path = var.index_html_path
  error_html_path = var.error_html_path
  route53_zone_id = var.route53_zone_id
  domain_name     = var.domain_name
}