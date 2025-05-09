output "port_application" {
  value = var.port_application
}

output "target_group_name_list" {
  value = {
    for tg_key, tg in aws_lb_target_group.this :
    tg_key => tg.name
  }
}
