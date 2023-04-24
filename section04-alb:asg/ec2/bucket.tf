
terraform {
    backend "s3" {
        bucket = "udemy-aws-dev-cert"
        key    = "section04-alb:asg/ec2"
        region = "sa-east-1"
    }
}