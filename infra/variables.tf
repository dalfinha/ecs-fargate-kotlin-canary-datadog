variable "env_variables" {
  description = "Variaveis de ambiente para a task definition"
  type    = list(object({ name = string, value = string }))
  default = []
}

variable "service_name" {
  description = "Nome do Microsservico ECS"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Nome do Cluster ECS"
  type = string
}

variable "env" {
  type = string
  default = "dev"
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
