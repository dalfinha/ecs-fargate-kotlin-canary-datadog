resource "aws_lb" "this" {
  depends_on = [aws_lb_target_group.this]
  name               = "alb-kotlin-canary"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.this.id]
  subnets            = data.aws_subnets.this.ids

  enable_deletion_protection = false
}