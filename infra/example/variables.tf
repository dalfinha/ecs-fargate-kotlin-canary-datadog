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
  default     = "kotlin-canary"
}

variable "ecs_cluster_name" {
  description = "Nome do Cluster ECS"
  type        = string
  default     = "ecs-kotlin-canary"
}

variable "env" {
  type = string
  default = "dev"
}

variable "ecr_repository" {
  type  = string
  default = "demo/kotlin-app-canary"
}

variable "role_iam" {
  type = string
  default = "ecs-tasks-demo"
}

# Service
variable "role_task_arn" {
  default = "role-task-arn"
}

variable "role_execution_arn" {
  default = "role-execution-arn"
}

variable "port_application" {
  default = 8080
}

variable "subnet_id" {
  type = list(string)
  default = []
}

variable "sg_default" {
  default = "default"
}

variable "uri_image" {
  default = "hash-image-ecr"
}

variable "target_group" {
  default = "target-group-default"
}
