# GitHub Actions CI/CD Setup Guide

This guide explains how to set up CI/CD for deploying the AWS website infrastructure across multiple environments.

## Prerequisites

1. Create AWS IAM Users for CI/CD:
   - Create separate IAM users for dev and prod accounts
   - Assign the necessary permissions (S3, CloudFront, Route53)
   - Generate access keys for these users

2. Create an S3 Bucket for Terraform State:
   - Create a bucket in each AWS account for storing Terraform state
   - Enable versioning on the bucket
   - Update the bucket name in `backend.tf`

## GitHub Secrets Setup

Add the following secrets to your GitHub repository:

1. For dev environment:
   - `AWS_ACCESS_KEY_ID` - IAM user access key for dev account
   - `AWS_SECRET_ACCESS_KEY` - IAM user secret key for dev account

2. For prod environment (optional - if using separate accounts):
   - Create GitHub environments (dev and prod)
   - Add the secrets to the appropriate environment

## Workflow Functionality

The CI/CD workflow performs the following:

1. **On Pull Requests**:
   - Validates Terraform configuration
   - Runs `terraform plan` and comments the results on the PR
   - Checks Terraform formatting

2. **On Push to Main**:
   - Automatically deploys to the dev environment
   - Invalidates CloudFront cache to ensure changes are visible

3. **Manual Deployment**:
   - Allows manual deployment to dev or prod environment
   - Uses the environment-specific tfvars file

## Using Multiple AWS Accounts

To deploy across multiple AWS accounts:

1. Set up separate GitHub environments with different AWS credentials
2. Modify the workflow to use the appropriate credentials based on the target environment
3. Use environment-specific backend configurations

## Handling HTML Changes

The workflow will:
1. Apply Terraform changes which will update S3 objects due to the `filemd5()` etag
2. Invalidate the CloudFront cache to ensure updates are immediately visible

## Security Considerations

1. Use IAM roles with least privilege principle
2. Store sensitive variables in GitHub Secrets
3. Consider using OIDC for AWS authentication instead of long-lived credentials