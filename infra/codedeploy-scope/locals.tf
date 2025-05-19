locals {
  container_defs = jsondecode(data.aws_ecs_task_definition.current.container_definitions)
  container_name = local.container_defs[0].name
}
