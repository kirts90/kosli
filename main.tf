provider "aws" {
  region = var.aws_region
}

# S3-based website module (Solution 1)
module "s3_website" {
  source          = "./modules/s3_website"
  bucket_name     = var.s3_bucket_name
  index_html_path = var.index_html_path
  error_html_path = var.error_html_path
  route53_zone_id = var.route53_zone_id
  domain_name     = var.domain_name
  certificate_arn = var.certificate_arn

  # Only create this resource when we're not using the EC2 solution
  # This effectively makes the modules mutually exclusive
  count = var.vpc_id == "" && length(var.subnet_ids) == 0 && var.ami_id == "" ? 1 : 0
}

# EC2-based website module (Solution 2)
module "ec2_website" {
  source           = "./modules/ec2_website"
  vpc_id           = var.vpc_id
  subnet_ids       = var.subnet_ids
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  domain_name      = var.domain_name
  route53_zone_id  = var.route53_zone_id
  key_name         = var.key_name
  ssh_public_key   = var.ssh_public_key
  certificate_arn  = var.certificate_arn
  html_content     = var.html_content
  root_volume_size = var.root_volume_size
  data_volume_size = var.data_volume_size
  data_volume_type = var.data_volume_type

  # Only create this resource when variables are provided
  count = var.vpc_id != "" && length(var.subnet_ids) > 0 && var.ami_id != "" ? 1 : 0
}