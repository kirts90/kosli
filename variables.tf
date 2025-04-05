variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "eu-west-2"
}

variable "s3_bucket_name" {
  description = "The S3 bucket name for static website hosting"
  type        = string
}

variable "index_html_path" {
  description = "Local path to the index.html file"
  type        = string
}

variable "error_html_path" {
  description = "Local path to the error.html file"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the website (e.g., www.example.com)"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for the custom domain"
  type        = string
  default     = ""
}