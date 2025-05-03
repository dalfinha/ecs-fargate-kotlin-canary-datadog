resource "aws_ecs_cluster" "this" {
  depends_on = [aws_cloudwatch_log_group.this]
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = var.env == "dev" ? "disabled" : "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}