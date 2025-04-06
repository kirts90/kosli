# Security group for EC2 instances
resource "aws_security_group" "ec2" {
  name        = "website-ec2-sg"
  description = "Security group for website EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "website-ec2-sg"
  }
}

# Create an IAM role for the EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "ec2_website_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the AmazonSSMManaged policy to the role
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an instance profile for EC2 instances
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_website_profile"
  role = aws_iam_role.ec2_role.name
}

# Single EC2 instance
resource "aws_instance" "website" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0] # Use the first subnet
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name != "" ? var.key_name : null

  # IAM profile for the instance
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Root volume
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }

  # Data volume
  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_size           = var.data_volume_size
    volume_type           = var.data_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Install Apache & SSL
    apt-get update -y
    apt-get install -y apache2 certbot python3-certbot-apache
    
    # Format and mount the data volume
    mkfs -t ext4 /dev/nvme1n1
    mkdir -p /data
    echo "/dev/nvme1n1 /data ext4 defaults 0 2" >> /etc/fstab
    mount -a
    mkdir -p /data/website
    
    # Create symlink to Apache document root
    rm -rf /var/www/html
    ln -s /data/website /var/www/html
    mkdir -p /data/website
    
    # Configure Apache with the website content
    cat > /data/website/index.html << 'INNEREOF'
    ${var.html_content}
    INNEREOF
    
    # Set correct permissions
    chown -R www-data:www-data /data/website
    
    # Update Apache config for hostname
    echo "ServerName ${var.domain_name}" >> /etc/apache2/apache2.conf
    
    # Ensure Apache is listening on standard ports
    a2enmod ssl
    a2ensite default-ssl
    
    # Start Apache
    systemctl start apache2
    systemctl enable apache2
  EOF
  )

  tags = {
    Name = "website-ec2"
  }
}

# Elastic IP for static addressing
resource "aws_eip" "website" {
  domain = "vpc"
  tags = {
    Name = "website-eip"
  }
}

# Associate Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.website.id
  allocation_id = aws_eip.website.id
}

# Route53 record pointing to the Elastic IP
resource "aws_route53_record" "website" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [aws_eip.website.public_ip]
}
