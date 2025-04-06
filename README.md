# Kosli Tech Test - AWS Website Hosting with Terraform

This repository contains Terraform configuration for deploying websites on AWS using two different approaches:
1. Static website using S3, CloudFront, and Route53
2. Server-side website using single EC2 instance with Elastic IP and Route53

## Project Structure

```
aws-website-hosting-terraform/
├── backend.tf              # Remote state configuration
├── main.tf                 # Root configuration that instantiates modules
├── variables.tf            # Global variables for the project
├── dev.tfvars              # Dev-specific variable overrides for S3 solution
├── prod.tfvars             # Production-specific variable overrides for S3 solution
├── dev2.tfvars             # Dev-specific variable overrides for EC2 solution
├── prod2.tfvars            # Production-specific variable overrides for EC2 solution
├── html/                   # Static website files
│   ├── index.html
│   └── error.html 
└── modules/
    ├── s3_website/        # S3 bucket, CloudFront, and Route53 resources
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ec2_website/       # EC2, Elastic IP, and Route53 resources
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Requirements

* Terraform v1.0.0+
* AWS CLI configured with appropriate credentials
* S3 bucket for Terraform state (configured in backend.tf)
* GitHub account for CI/CD (optional)

## Deployment Instructions

### Manual Deployment

1. Clone this repository
2. Update the S3 bucket name in `backend.tf` for your Terraform state
3. Customize the values in `dev.tfvars` and `prod.tfvars` for your environments
4. Initialize Terraform:
   ```
   terraform init
   ```
5. Deploy to development environment (S3-based solution):
   ```
   terraform plan -var-file=dev.tfvars
   terraform apply -var-file=dev.tfvars
   ```
6. Deploy to production environment (S3-based solution):
   ```
   terraform plan -var-file=prod.tfvars
   terraform apply -var-file=prod.tfvars
   ```
7. Deploy to development environment (EC2-based solution):
   ```
   terraform plan -var-file=dev2.tfvars
   terraform apply -var-file=dev2.tfvars
   ```
8. Deploy to production environment (EC2-based solution):
   ```
   terraform plan -var-file=prod2.tfvars
   terraform apply -var-file=prod2.tfvars
   ```

### CI/CD Deployment

1. Fork/clone this repository to your GitHub account
2. Configure AWS credentials in GitHub Secrets
3. Push changes to trigger the CI/CD pipeline:
   - Pull requests: Runs validation and plan
   - Merge to main: Automatically deploys to dev environment
   - Manual trigger: Deploy to dev, prod, dev2, or prod2 environments via GitHub Actions
4. See `.github/workflows/deploy-guide.md` for detailed setup instructions

## Features

### Solution 1: S3-based Static Website
* S3 static website hosting with CloudFront distribution for global low-latency delivery
* Optimized for static content with minimal cost
* CloudFront caching for improved performance

### Solution 2: EC2-based Dynamic Website
* Single EC2 instance with Elastic IP for stable addressing
* Cost-optimized t2.micro instance type
* Custom user data script for Apache server setup
* Self-managed SSL with certbot
* Security groups for controlled access
* EBS volumes for persistent storage:
  * Root volume (8GB, OS and applications)
  * Data volume (1GB dev/2GB prod, website content)

### Common Features
* Route53 DNS configuration to maintain consistent domain name
* Change detection to trigger redeployment
* Remote state management with S3 backend
* Environment-specific configuration using variable files
* GitHub Actions CI/CD pipeline for automated testing and deployment
* Multi-environment support (dev/prod/dev2/prod2) with separate configurations

## Comparison of Solutions

### Solution 1: S3 + CloudFront + Route53
* Best for: Static websites, content delivery, low-cost hosting
* Advantages: Low cost, highly scalable, minimal maintenance, global edge distribution
* Limitations: No server-side processing, limited to static content

### Solution 2: EC2 + Elastic IP + Route53
* Best for: Dynamic websites, custom server-side applications, web services
* Advantages: Full server control, custom application support, server-side processing, extremely cost-optimized
* Limitations: No high availability (single instance), manual restarts if instance fails

Both solutions maintain stable DNS endpoints during deployments and support infrastructure-as-code management with Terraform.

## Assignment

There are many ways to serve websites on AWS. Your goal is to do research and pick two ways. You should be able to explain the reasons for your choice and why you decided against others.

## Requirements

* You should provision all necessary infra using Terraform.
* You should not store Terraform state locally. Pick any supported backend.
* Changes to HTML should cause redeployment.
* DNS name or IP address should stay the same after redeployment.
* TLS is optional.
* You should be able to deploy the same code into two different AWS accounts (think dev and prod). There should be a possibility to specify different parameters between accounts. For instance, the name of the ssh key if you are to go with EC2.
* Please store Terraform code on GitHub and share a link to the repo with us.
* CI setup is optional.