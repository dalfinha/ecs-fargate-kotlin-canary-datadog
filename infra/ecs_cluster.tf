resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = var.env == "dev" ? "disabled" : "enabled"
  }

}