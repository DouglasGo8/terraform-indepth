terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_db_instance" "MySQLDbInstance" {
  engine                  = "mysql"
  engine_version          = "5.7.22"
  instance_class          = "db.t2.micro" # Free Tier Template
  identifier              = "myfirstmysql"
  name                    = "myfirstmysql"
  username                = "root"
  password                = "welcome1"
  storage_type            = "gp2"
  allocated_storage       = "20" # means 20 GB
  publicly_accessible     = true
  multi_az                = false
  backup_retention_period = 30
  parameter_group_name    = $MustBeCreated
  apply_immediately       = true
  skip_final_snapshot     = true
  tags = {
    Name = "mysql-instance"
  }
}

resource "aws_db_parameter_group" "MySQLDbParameterGroup" {
  name        = "mysqldb-param-group"
  family      = "mysql5.7"
  description = "MySQL paramters group"
}

