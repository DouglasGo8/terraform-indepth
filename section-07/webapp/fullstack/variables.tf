# 
variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AWS_PROFILE" {
  default = "default"
}

# Project wide variable
variable PROJECT_NAME {}

# RDS Variables
variable "RDS_ENGINE" {}
variable "DB_INSTANCE_CLASS" {}
variable "ENGINE_VERSION" {}
variable "BACKUP_RETENTION_PERIOD" {}
variable "PUBLICLY_ACCESSIBLE" {}
variable "RDS_USERNAME" {}
variable "RDS_PASSWORD" {}
variable "RDS_ALLOCATED_STORAGE" {}
variable "RDS_CIDR" {}

# VPC Variables
variable "VPC_CIDR_BLOCK" {}

variable "VPC_PUBLIC_SUBNET1_CIDR_BLOCK" {}
variable "VPC_PUBLIC_SUBNET2_CIDR_BLOCK" {}
variable "VPC_PRIVATE_SUBNET1_CIDR_BLOCK" {}
variable "VPC_PRIVATE_SUBNET2_CIDR_BLOCK" {}

# Ec2 /Autoscaling Variables
variable "SSH_CIDR_APP_SERVER" {}
variable "SSH_CIDR_WEB_SERVER" {}
variable "USER_DATA_FOR_APPSERVER" {}
variable "USER_DATA_FOR_WEBSERVER" {}
variable "APP_SERVER_INSTANCE_TYPE" {}
variable "WEB_SERVER_INSTANCE_TYPE" {}


