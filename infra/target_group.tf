resource "aws_lb_target_group" "this" {
  depends_on = [aws_ecs_cluster.this]
  for_each    = toset(["blue", "green"])
  name        = "kotlin-canary-${each.key}"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.this.id
}
