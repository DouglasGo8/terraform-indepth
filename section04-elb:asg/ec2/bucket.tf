
terraform {
    backend "s3" {
        bucket = "udemy-aws-dev-cert"
        key    = "section04-alb:asg/asg"
        region = "sa-east-1"
    }
}