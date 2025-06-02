data "aws_region" "current" {}

data "aws_lb_target_group" "current" {
  name = var.target_group
}

data "aws_secretsmanager_secret" "datadog" {
  name = "datadog-agent"
}
