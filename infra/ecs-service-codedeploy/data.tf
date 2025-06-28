data "aws_region" "current" {}

data "aws_lb_target_group" "current" {
  name = local.target_group
}

data "aws_secretsmanager_secret" "datadog" {
  name = "datadog-agent"
}

data "aws_lb" "alb" {
  name = "alb-${var.service_name}"
}

data "aws_lb_listener" "current" {
  load_balancer_arn = data.aws_lb.alb.arn
  port              = var.port_application
}

data "aws_lb_target_group" "blue" {
  name = "${local.target_group}-blue"
}

data "aws_lb_target_group" "green" {
  name = "${local.target_group}-green"
}
