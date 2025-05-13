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