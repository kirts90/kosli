# Kosli Tech Test - AWS Website Hosting with Terraform

This repository contains Terraform configuration for deploying static websites on AWS using S3, CloudFront, and Route53.

## Project Structure

```
aws-website-hosting-terraform/
├── backend.tf              # Remote state configuration
├── main.tf                 # Root configuration that instantiates modules
├── variables.tf            # Global variables for the project
├── dev.tfvars              # Dev-specific variable overrides
├── prod.tfvars             # Production-specific variable overrides
├── html/                   # Static website files
│   ├── index.html
│   └── error.html 
└── modules/
    └── s3_website/        # S3 bucket, CloudFront, and Route53 resources
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
5. Deploy to development environment:
   ```
   terraform plan -var-file=dev.tfvars
   terraform apply -var-file=dev.tfvars
   ```
6. Deploy to production environment:
   ```
   terraform plan -var-file=prod.tfvars
   terraform apply -var-file=prod.tfvars
   ```

### CI/CD Deployment

1. Fork/clone this repository to your GitHub account
2. Configure AWS credentials in GitHub Secrets
3. Push changes to trigger the CI/CD pipeline:
   - Pull requests: Runs validation and plan
   - Merge to main: Automatically deploys to dev environment
   - Manual trigger: Deploy to dev or prod environment via GitHub Actions
4. See `.github/workflows/deploy-guide.md` for detailed setup instructions

## Features

* S3 static website hosting with CloudFront distribution for global low-latency delivery
* Route53 DNS configuration to maintain consistent domain name
* Change detection for HTML files to trigger redeployment
* Remote state management with S3 backend
* Environment-specific configuration using variable files
* GitHub Actions CI/CD pipeline for automated testing and deployment
* Multi-environment support (dev/prod) with separate configurations

## Note on Deployment Options

This implementation uses S3 + CloudFront + Route53 for optimal performance, cost-effectiveness, and ease of management for static websites. Alternative approaches like EC2 instances, ECS/EKS, or AWS Amplify would be better suited for dynamic websites or applications with specific runtime requirements.

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