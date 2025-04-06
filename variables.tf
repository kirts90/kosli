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

# Variables for EC2-based solution
variable "vpc_id" {
  description = "The VPC ID where resources will be created"
  type        = string
  default     = ""
}

variable "ssh_public_key" {
  description = "The SSH public key to use for EC2 instances (provided via environment variable)"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EC2 instance"
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = ""
}

# Removed ASG-related variables since we're using a single EC2 instance

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
  default     = ""
}

variable "html_content" {
  description = "HTML content for the web server"
  type        = string
  default     = "<html><body><h1>Hello from EC2 Website</h1><p>This website is served from a single EC2 instance.</p></body></html>"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 8
}

variable "data_volume_size" {
  description = "Size of the data EBS volume in GB"
  type        = number
  default     = 1
}

variable "data_volume_type" {
  description = "Type of the data EBS volume (gp2, gp3, io1, etc.)"
  type        = string
  default     = "gp2"
}