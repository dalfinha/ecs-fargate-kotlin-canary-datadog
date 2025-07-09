output "application_name_codedeploy" {
  value = aws_codedeploy_app.this.name
}

output "s3_bucket" {
  value = aws_s3_bucket.this.bucket_domain_name
}

output "deploy_strategy" {
  value = aws_codedeploy_deployment_group.this.deployment_config_name
}
