resource "aws_lb_listener" "this" {
  depends_on = [aws_lb_target_group.this]

  load_balancer_arn = aws_lb.this.arn
  port              = var.port_application
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this["blue"].arn
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}