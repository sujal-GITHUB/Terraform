terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "my-unique-bucket-7db6a2c0"
    key            = "backend.tfstate"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "newserver" {
  ami = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"

  tags = {
    Name = "MyNewServer"        
  }
}