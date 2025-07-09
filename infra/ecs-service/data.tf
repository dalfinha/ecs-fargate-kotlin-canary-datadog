data "aws_region" "current" {}

data "aws_lb_target_group" "current" {
  name = var.target_group
}

data "aws_ecr_image" "this" {
  repository_name = var.ecr_repository
  most_recent     = true
}

data "aws_secretsmanager_secret" "datadog" {
  name = "datadog-agent"
}