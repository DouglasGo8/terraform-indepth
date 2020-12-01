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