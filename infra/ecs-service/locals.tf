locals {
  max_capacity_scaling = aws_ecs_service.this.desired_count * 5

  container_definition = jsondecode(aws_ecs_task_definition.this.container_definitions)
  container_name = local.container_definition[0].name
}
