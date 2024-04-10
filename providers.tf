terraform {
  cloud {
    organization = "EOyebamiji-TF-Bootcamp"
    workspaces {
      name = "Terra-House-1"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}