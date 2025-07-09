data "aws_lb_target_group" "blue" {
  name = "${local.target_group}-blue"
}

data "aws_lb_target_group" "green" {
  name = "${local.target_group}-green"
}

data "aws_ecs_service" "current" {
  cluster_arn  = data.aws_ecs_cluster.current.arn
  service_name = var.service_name
}

data "aws_lb_listener" "current" {
  load_balancer_arn = local.load_balancer_arn
  port              = var.port_application
}

data "aws_ecs_task_definition" "current" {
  task_definition = data.aws_ecs_service.current.task_definition
}

data "aws_ecs_cluster" "current" {
  cluster_name = var.cluster_name
}