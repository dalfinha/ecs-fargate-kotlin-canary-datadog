resource "aws_s3_bucket" "this" {
  bucket = "artefactory-${var.service_name}"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "this" {
  depends_on = [local_file.this]

  bucket = aws_s3_bucket.this.bucket
  key    = "appspec.yaml"
  source = "${path.module}/appspec_template/appspec.yaml"
  acl    = "private"
}
