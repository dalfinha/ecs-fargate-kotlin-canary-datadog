resource "aws_s3_bucket" "this" {
  bucket = "artefatos-kotlin-canary"
}

resource "aws_s3_object" "this" {
  bucket = aws_s3_bucket.this.bucket
  key    = "appspec.yaml"
  source = "${path.module}/codedeploy/appspec.yaml"
  acl    = "private"

  depends_on = [local_file.appspec_rendered]
}
