resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name             = var.application_name
}