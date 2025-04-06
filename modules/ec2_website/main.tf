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

# Create a key pair for SSH access if key_name and ssh_public_key are specified
resource "aws_key_pair" "website_key" {
  count      = var.key_name != "" && var.ssh_public_key != "" ? 1 : 0
  key_name   = var.key_name
  public_key = var.ssh_public_key
}

# Calculate a hash based on directory content
data "external" "html_dir_hash" {
  program = ["bash", "-c", "echo '{\"hash\":\"'$(find ${path.root}/html -type f -exec md5sum {} \\; | sort | md5sum | cut -d' ' -f1)'\"}'"]
}

# Calculate a hash of HTML content for change detection
locals {
  # Hash of entire html directory - the only source of truth
  html_dir_hash = data.external.html_dir_hash.result.hash
  
  # Use the directory hash directly as the content hash
  content_hash = local.html_dir_hash
}

# Single EC2 instance
resource "aws_instance" "website" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0] # Use the first subnet
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name != "" ? aws_key_pair.website_key[0].key_name : null
  
  # This forces instance recreation when html content changes
  user_data_replace_on_change = true
  
  # Add tag with content hash to force recreation on content change
  tags = {
    Name         = "website-ec2"
    ContentHash  = local.content_hash
  }

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
    apt-get install -y apache2 certbot python3-certbot-apache git

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
    
    # Clone the repository to get HTML files
    cd /tmp
    git clone https://github.com/georgioskyrtsidis/kosli.git
    
    # Copy ALL files from the html directory - no fallback
    if [ -d /tmp/kosli/html ]; then
      cp -r /tmp/kosli/html/* /data/website/
      echo "HTML files successfully copied from repository"
    else
      echo "ERROR: HTML directory not found in repository"
      exit 1
    fi
    
    # Clean up
    rm -rf /tmp/kosli
    
    # Set correct permissions
    chown -R www-data:www-data /data/website
    
    # Update Apache config for hostname
    echo "ServerName ${var.domain_name}" >> /etc/apache2/apache2.conf
    
    # Configure Apache to use error.html for 404 errors
    cat > /etc/apache2/conf-available/custom-errors.conf << 'EOT'
    ErrorDocument 404 /error.html
    EOT
    a2enconf custom-errors
    
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
