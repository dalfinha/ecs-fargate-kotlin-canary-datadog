resource "aws_cloudwatch_log_group" "this" {
  depends_on = [ aws_ecs_cluster.this ]
  
  name              = "/ecs/${var.service_name}"
  retention_in_days = 1
}