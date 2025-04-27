resource "aws_lb_target_group" "this" {
  depends_on  = [aws_ecs_cluster.this]

  for_each    = toset(["blue", "green"])

  name        = "kotlin-canary-${each.key}"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.this.id
}
