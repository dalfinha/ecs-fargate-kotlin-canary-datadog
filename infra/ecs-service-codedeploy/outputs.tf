output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "service_name" {
  value = aws_ecs_service.this.name
}

output "cluster_arn" {
  value = aws_ecs_cluster.this.arn
}

output "container_name" {
  value = local.container_definition
}

output "task_definition_acctual" {
  value = aws_ecs_task_definition.this.id
}

output "datadog" {
  value = var.enable_datadog
}

output "deploy_strategy" {
  value = aws_codedeploy_deployment_group.this.deployment_config_name
}

output "application_name_codedeploy" {
  value = aws_codedeploy_app.this.name
}

output "s3_bucket" {
  value = aws_s3_bucket.this.bucket_domain_name
}
