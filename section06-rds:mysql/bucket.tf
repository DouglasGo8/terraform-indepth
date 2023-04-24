
terraform {
    backend "s3" {
        bucket = "udemy-aws-dev-cert"
        key    = "section06-rds:mysql"
        region = "sa-east-1"
    }
}