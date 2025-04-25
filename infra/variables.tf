variable "env_variables" {
  description = "Variaveis de ambiente para a task definition"
  type = list(object({
    key   = string
    value = string
  }))
  default = []
}

variable "service_name" {
  description = "Nome do Microsserviço ECS"
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

variable "tags" {
  type    = map(string)
  default = {}
}
