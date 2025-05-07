resource "aws_lb_target_group" "this" {
  for_each    = toset(["blue","green"])

  name        = "canary-${each.key}"
  target_type = "ip"
  port        = var.port_application
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path        = "/actuator/health"
    interval    = 120
  }
}
