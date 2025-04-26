resource "aws_lb_listener" "this" {
  for_each = aws_lb_target_group.this

  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = each.value.arn
  }
}