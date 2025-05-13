variable "ecs_cluster_name" {
  description = "Nome do Cluster ECS Fargate"
}

variable "env_variables" {
  type = list(object({
    key   = string
    value = string
  }))
  default = []
}

variable "env" {
  description = "Variavel de ambiente"
  default = "dev"
}

variable "service_name" {
  description = "Nome do Serviço e Containers"
}

variable "role_task_arn" {
  description = "Role IAM com permissão para Task"
}

variable "role_execution_arn" {
  description = "Role IAM para permissão de Execução"
}

variable "port_application" {
  description = "Porta da aplicação"
}

variable "subnet_id" {
  type = list(string)
  default = []
}

variable "deployment_controller_type" {
  type    = string
  default = "CODE_DEPLOY"
}

variable "sg_default" {
  description = "Security Group da aplicação"
}

variable "uri_image" {
  description = "Imagem ECR para execução do Container (URI)"
}

variable "target_group" {
  description = "Nome do Target Group"
}

