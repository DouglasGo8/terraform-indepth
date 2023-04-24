

variable "profile" { default = "default" }

variable "region" {
  default = "sa-east-1"
}


variable "amis" {
  default = {
    # Amazon Linux 2 AMI (HVM), SSD Volume Type
    sa-east-1 = "ami-081a078e835a9f751"
  }
  type = map
  description = "AMIs pool instances ID"
}