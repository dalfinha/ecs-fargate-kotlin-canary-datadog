resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name             = local.project_name
}