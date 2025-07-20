terraform {
  backend "s3" {
    bucket         = "cloudcore0070"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
