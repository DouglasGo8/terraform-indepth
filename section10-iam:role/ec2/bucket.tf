
terraform {
    backend "s3" {
        bucket = "udemy-aws-dev-cert"
        key    = "section10-iam:role/ec2"
        region = "sa-east-1"
    }
}