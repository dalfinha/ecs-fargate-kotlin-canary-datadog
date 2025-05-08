locals {
  max_capacity_scaling = aws_ecs_service.this.desired_count * 5
}
