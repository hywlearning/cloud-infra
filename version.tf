terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "4.0.6"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.92.0"
    }
  }
}

provider "aws" {
  # Configuration options
}