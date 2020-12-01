


resource "aws_s3_bucket" "terraform-indepth-ddb-bucket" {
  bucket = "terraform-indepth-ddb-bucket"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
  
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

}
