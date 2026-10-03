# Infrastructure

This directory contains the Terraform configuration used to provision the AWS infrastructure for the ECS Threat Composer project.

## Components

The infrastructure includes:

- Amazon ECS Fargate
- Amazon ECR
- Application Load Balancer
- Route 53
- ACM
- S3 remote Terraform state
- IAM roles for GitHub Actions OIDC

## CI/CD

Changes inside this directory trigger the Terraform GitHub Actions workflow on the `main` branch.
