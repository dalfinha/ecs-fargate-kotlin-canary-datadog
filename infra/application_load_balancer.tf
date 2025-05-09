resource "aws_lb" "this" {
  depends_on         = [aws_lb_target_group.this, aws_ecs_task_definition.this]

  name               = "alb-${var.service_name}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.this.id]
  subnets            = data.aws_subnets.this.ids

  enable_deletion_protection = false
}