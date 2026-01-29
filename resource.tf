resource "aws_s3_bucket" "web_bucket" {
  
bucket = "lkm-mitali-bucket2-29jan2026"

}

# Enable Hosting
resource "aws_s3_bucket_website_configuration" "web_config" {
  bucket = aws_s3_bucket.web_bucket.id
  index_document { suffix = "index.html" }
}

# Unblock Public Access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.web_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Public Read Policy
resource "aws_s3_bucket_policy" "read_policy" {
  depends_on = [aws_s3_bucket_public_access_block.public_access]
  bucket     = aws_s3_bucket.web_bucket.id
  policy     = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid = "PublicRead", Effect = "Allow", Principal = "*",
      Action = "s3:GetObject", Resource = "${aws_s3_bucket.web_bucket.arn}/*"
    }]
  })
}

# Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.web_bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

# Output URL
output "website_link" {
  value = aws_s3_bucket_website_configuration.web_config.website_endpoint
}

