output "application_name_codedeploy" {
  value = aws_codedeploy_app.this.name
}

output "s3_bucket" {
  value = aws_s3_bucket.this.bucket_domain_name
}

output "deploy_strategy" {
  value = aws_codedeploy_deployment_group.this.deployment_config_name
}

output "version_task_definition" {
  value = data.aws_ecs_task_definition.current.arn
}

output "aaa" {
  value = local.load_balancer_arn
}

output "aaaaa" {
  value = data.aws_lb_listener.current.arn
}