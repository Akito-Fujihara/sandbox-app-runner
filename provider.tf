provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Name = "sandbox-app-runner"
    }
  }
}

terraform {
  required_version = "~> 1.5.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
  }
}
