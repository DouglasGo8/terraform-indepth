terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_s3_bucket" "udemy-aws-dev-cert-bucket" {
  bucket = "udemy-aws-dev-cert"
  acl    = "private"
  tags = {
    Name        = "Udemy AWS Developer Certified Bucket"
    Environment = "Dev"
  }
}
