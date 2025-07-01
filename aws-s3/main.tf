terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "demobucket" {
    bucket = "my-unique-bucket-${random_id.bucket_suffix.hex}"

    tags = {
        Name        = "MyDemoBucket"
        Environment = "Dev"
    }
}

resource "aws_s3_object" "bucket-data" {
    bucket = aws_s3_bucket.demobucket.bucket
    source = "./1.txt"
    key = "mydata.txt"
}