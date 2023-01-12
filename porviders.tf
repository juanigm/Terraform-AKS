// $ export AWS_ACCESS_KEY_ID="anaccesskey"
// $ export AWS_SECRET_ACCESS_KEY="asecretkey"
// $ export AWS_REGION="region"

terraform {

    backend "s3" {
        bucket = "mybucketashe"
        key    = "stateus"
        region = "us-east-1"
    }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}