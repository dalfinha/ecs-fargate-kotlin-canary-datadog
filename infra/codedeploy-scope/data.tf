data "aws_lb_target_group" "blue" {
  name = "${var.target_group}-blue"
}

data "aws_lb_target_group" "green" {
  name = "${var.target_group}-green"
}

data "aws_ecs_service" "current" {
  cluster_arn  = var.cluster_arn
  service_name = var.service_name
}

data "aws_lb_listener" "current" {
  load_balancer_arn = tolist(data.aws_lb_target_group.blue.load_balancer_arns)[0]
  port              = var.port_application
}

data "aws_ecs_task_definition" "current" {
  task_definition = data.aws_ecs_service.current.task_definition
}
