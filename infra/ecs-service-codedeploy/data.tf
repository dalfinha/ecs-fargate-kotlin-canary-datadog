data "aws_region" "current" {}

data "aws_lb_target_group" "current" {
  name = var.target_group
}

data "aws_secretsmanager_secret" "datadog" {
  name = "datadog-agent"
}

data "aws_lb_listener" "current" {
  load_balancer_arn = tolist(data.aws_lb_target_group.blue.load_balancer_arns)[0]
  port              = var.port_application
}

data "aws_lb_target_group" "blue" {
  name = "${var.target_group}-blue"
}

data "aws_lb_target_group" "green" {
  name = "${var.target_group}-green"
}
