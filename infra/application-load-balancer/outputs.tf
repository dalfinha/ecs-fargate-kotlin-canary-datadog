output "target_group_blue_green" {
  value = {
    for tg_key, tg in aws_lb_target_group.this :
    tg_key => tg.name
  }
}

output "port_application" {
  value = var.port_application
}

output "listener_protocol" {
  value = aws_lb_listener.this.protocol
}

output "application_load_balancer_arn" {
  value = aws_lb.this.arn
}

output "application_load_balancer_name" {
  value = aws_lb.this.name
}

output "security_group" {
  value = tolist(var.sg_default)[0]
}
