resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.service_name}"
  name_prefix = "poc"
  retention_in_days = 1
}