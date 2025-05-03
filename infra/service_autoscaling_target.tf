resource "aws_appautoscaling_target" "ecs_service_scaling" {
  depends_on = [aws_ecs_service.this]

  max_capacity       = local.max_scaling
  min_capacity       = aws_ecs_service.this.desired_count
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}