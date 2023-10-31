terraform {
  backend "s3" {
    bucket         = "mikes-terraform-state"
    key            = "mikes-lambda-pre-sign-up.tfstate"
    region         = "us-east-2"
    encrypt        = true
  }
}