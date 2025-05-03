resource "aws_lb_target_group" "this" {
  depends_on  = [aws_ecs_cluster.this]

  for_each    = toset(["blue","green"])

  name        = "canary-${each.key}"
  target_type = "ip"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.this.id

  health_check {
    path        = "/actuator/health"
    interval    = 120
  }

}
