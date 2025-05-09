data "aws_lb_target_group" "current" {
  name = var.target_group
}

data "aws_lb_listener" "current" {
  port = var.port_application
}

data "aws_ecs_service" "current" {
  cluster_name = var.cluster_name
  service_name = var.service_name
}
