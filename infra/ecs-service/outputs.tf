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
  value = local.container_name
}

output "task_definition_actual" {
  value = aws_ecs_task_definition.this.id
}

output "datadog" {
  value = var.enable_datadog
}
