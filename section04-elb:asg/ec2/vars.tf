

variable "profile" { default = "default" }

variable "region" {
  default = "sa-east-1"
}

variable "instance_count" {
  default = "3"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "amis" {
  default = {
    # Amazon Linux 2 AMI (HVM), SSD Volume Type
    sa-east-1  = "ami-081a078e835a9f751"
    sa-east-1b = "ami-0c4f7d4b4c66bd8a6"
    sa-east-1c = "ami-081a078e835a9f751"
  }
  type        = map
  description = "AMIs pool instances ID"
}


variable "zones" {
  default     = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
  type        = list
  description = "Available Lists"
}
