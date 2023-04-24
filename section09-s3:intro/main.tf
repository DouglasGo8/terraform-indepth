terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_s3_bucket" "awsdev-cert-ddb-bucket" {
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl
  # Canned ACL
  acl    = "private"
  bucket = "awsdev-cert-ddb-bucket"
  tags = {
    Name        = "Aws Dev Cert Bucket"
    Environment = "Dev"
  }
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "images" {
  key    = "images/"
  bucket = aws_s3_bucket.awsdev-cert-ddb-bucket.id
}
