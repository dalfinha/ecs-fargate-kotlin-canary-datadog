output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "service_name" {
  value = aws_ecs_service.this.name
}

output "cluster_arn" {
  value = aws_ecs_cluster.this.arn
}