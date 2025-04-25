resource "aws_ecs_service" "this" {
  depends_on = [aws_ecs_cluster.this, aws_ecs_task_definition.this]

  name        = var.service_name
  cluster     = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.env == "dev" ? 1 : 0
  launch_type     = null
  scheduling_strategy = "REPLICA"
  platform_version    = "LATEST"
  enable_ecs_managed_tags = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  network_configuration {
    subnets           = data.aws_subnets.this.ids
    security_groups   = [data.aws_security_group.this.id]
    assign_public_ip  = true
  }

  tags = var.tags
}