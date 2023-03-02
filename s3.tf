resource "aws_s3_bucket" "spi-test" {
  bucket = "${var.bucket_name}"
  acl = "private"
}

output "s3_bucket" {
    value = aws_s3_bucket.spi-test.id
}