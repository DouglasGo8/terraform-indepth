
terraform {
    backend "s3" {
        bucket = "udemy-aws-dev-cert"
        key    = "section04-elb:asg/asg"
        region = "sa-east-1"
    }
}