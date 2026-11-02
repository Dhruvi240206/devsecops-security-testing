
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket
resource "aws_s3_bucket" "compliance_bucket" {
  bucket = "dhruvi-compliance-demo-2026"

  tags = {
    Name        = "ComplianceDemo"
    Environment = "Testing"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "secure_access" {
  bucket = aws_s3_bucket.compliance_bucket.id

  block_public_acls = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.compliance_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.compliance_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
