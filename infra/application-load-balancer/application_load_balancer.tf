resource "aws_lb" "this" {
  name               = "alb-${var.scope}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.sg_default
  subnets            = var.subnet_id

  enable_deletion_protection = false
}