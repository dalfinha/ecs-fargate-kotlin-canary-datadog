resource "aws_ecs_cluster" "this" {
  depends_on = [aws_cloudwatch_log_group.this]
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = var.env == "dev" ? "disabled" : "enabled"
  }

  tags = {
   projeto = local.project_name
  }
}