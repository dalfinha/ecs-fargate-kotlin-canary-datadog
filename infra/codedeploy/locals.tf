locals {
  container_defs = jsondecode(data.aws_ecs_task_definition.current.container_definitions)
  container_name = local.container_defs[0].name

  force_trigger_appspec = timestamp()

  target_group = replace(var.target_group, "-blue", "")

  load_balancer_arn = (
    length(tolist(data.aws_lb_target_group.blue.load_balancer_arns)) > 0 ?
    tolist(data.aws_lb_target_group.blue.load_balancer_arns)[0] :
    tolist(data.aws_lb_target_group.green.load_balancer_arns)[0]
  )
}
