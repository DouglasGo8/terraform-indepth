terraform {
  required_version = "~> 0.13.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}