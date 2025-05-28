resource "null_resource" "this" {
  depends_on = [aws_codedeploy_deployment_group.this, aws_codedeploy_app.this]

  provisioner "local-exec" {
    working_dir = path.module
    command     = "bash scripts/local_force_deploy.sh"

    environment = {
      APPLICATION_NAME      = aws_codedeploy_app.this.name
      DEPLOYMENT_GROUP_NAME = aws_codedeploy_deployment_group.this.deployment_group_name
      S3_APPSPEC            = aws_s3_bucket.this.id
    }
  }

  triggers = {
    always_run = timestamp()
  }
}
