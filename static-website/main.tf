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

resource "aws_s3_bucket" "webbucket" {
    bucket = "my-unique-bucket-${random_id.bucket_suffix.hex}"

    tags = {
        Name        = "MyWebBucket"
        Environment = "Dev"
    }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.webbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "mywebapp" {
  bucket = aws_s3_bucket.webbucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Principal = "*"
      Effect    = "Allow"
      Action    = "s3:GetObject"
      Resource  = "arn:aws:s3:::${aws_s3_bucket.webbucket.bucket}/*"
    }]
  })
}


resource "aws_s3_bucket_website_configuration" "webapp" {
  bucket = aws_s3_bucket.webbucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index_html" {
    bucket = aws_s3_bucket.webbucket.bucket
    source = "./index.html"
    key = "index.html"
    content_type = "text/html"
}

resource "aws_s3_object" "styles_css" {
    bucket = aws_s3_bucket.webbucket.bucket
    source = "./styles.css"
    key = "styles.css"
    content_type = "text/css"
}

output "website_link" {
  value = aws_s3_bucket_website_configuration.webapp.website_endpoint
  description = "The URL of the static website hosted on S3"
}