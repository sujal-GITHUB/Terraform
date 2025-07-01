variable "region" {
  description = "value of the AWS region"
  default = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

provider "aws" {
  region = var.region 
}

resource "aws_instance" "myserver" {
  ami = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
}