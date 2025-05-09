resource "aws_ecs_service" "this" {
  depends_on = [aws_ecs_task_definition.this]

  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = null
  scheduling_strategy = "REPLICA"
  enable_ecs_managed_tags = true
  health_check_grace_period_seconds = 60

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  network_configuration {
    subnets           = var.subnet_id
    security_groups   = [ var.sg_default ]
    assign_public_ip  = true
  }

  load_balancer {
    target_group_arn = var.target_group["blue"].arn
    container_name   = "container-${var.service_name}"
    container_port   = var.port_application
  }
}

