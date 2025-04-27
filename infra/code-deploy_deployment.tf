resource "aws_codedeploy_deployment" "this" {
  application_name = aws_codedeploy_app.this.name
  deployment_group_name = aws_codedeploy_deployment_group.this.deployment_group_name

  revision {
    revision_type = "S3"

    s3_location {
      bucket = aws_s3_bucket.codedeploy_bucket.bucket
      key    = "app.zip"
      bundle_type = "zip"
    }
  }
}
