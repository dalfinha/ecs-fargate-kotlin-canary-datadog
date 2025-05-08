resource "aws_s3_bucket" "this" {
  bucket = "artefactory-${var.service_name}"
}

resource "aws_s3_object" "this" {
  depends_on = [local_file.this]

  bucket = aws_s3_bucket.this.bucket
  key    = "appspec.yaml"
  source = "${path.module}/codedeploy-appspec/appspec_template/appspec.yaml"
  acl    = "private"
}
