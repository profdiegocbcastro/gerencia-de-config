terraform {
  required_version = ">1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "123"
  secret_key = "123"
  token      = "123"
}