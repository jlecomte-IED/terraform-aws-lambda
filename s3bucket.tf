data "aws_s3_bucket" "deployment_bucket" {
  bucket = var.lambda_bucket
}
