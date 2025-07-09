resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name             = "app-${var.service_name}"
}