variable "ecs_cluster_name" {}

variable "env" {}

variable "service_name" {}

variable "role_task_arn" {}

variable "role_eecution_arn" {}

variable "port_application" {}

variable "env_variable" {
  type = list(string)
}
