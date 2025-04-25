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
  default     = "kotlin-canary-datadog"
}

variable "ecs_cluster_name" {
  description = "Nome do Cluster ECS"
  type = string
  default = "ecs-kotlin-canary-datadog"
}

variable "env" {
  type = string
  default = "dev"
}
