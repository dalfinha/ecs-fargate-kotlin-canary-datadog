resource "aws_ecs_service" "this" {
  depends_on = [aws_ecs_cluster.this]

  name = var.service_name
  cluster = aws_ecs_cluster.this.id
  task_defini
}