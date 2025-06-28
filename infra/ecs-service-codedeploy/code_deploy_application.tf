resource "aws_codedeploy_app" "this" {
  depends_on = [aws_ecs_service.this]
  compute_platform = "ECS"
  name             = "app-${var.service_name}"
}