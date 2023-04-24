
terraform {
    backend "s3" {
        bucket = "udemy-aws-dev-cert"
        key    = "section03-iam:ec2/ec2"
        region = "sa-east-1"
    }
}