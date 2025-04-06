output "website_url" {
  description = "URL of the website"
  value       = "http://${var.domain_name}"
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.website.id
}

output "elastic_ip" {
  description = "Elastic IP address"
  value       = aws_eip.website.public_ip
}

output "instance_security_group" {
  description = "Security Group ID for EC2 instances"
  value       = aws_security_group.ec2.id
}