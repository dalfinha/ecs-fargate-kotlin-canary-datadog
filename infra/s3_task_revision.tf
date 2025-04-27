resource "aws_s3_bucket" "codedeploy_bucket" {
  bucket        = "${local.project_name}-task-definition"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.codedeploy_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}