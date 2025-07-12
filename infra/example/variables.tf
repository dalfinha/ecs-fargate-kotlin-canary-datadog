variable "env_variables" {
  type        = map(string)
  description = "Variáveis de ambiente com chave e valor"
  default     = {}
}

variable "service_name" {
  type        = string
  description = "Nome do serviço ECS"
  default     = "demo-canary-kotlin"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Nome do cluster ECS"
  default     = "ecs-kotlin-canary"
}

variable "env" {
  type        = string
  description = "Ambiente de implantação (ex: dev, prod)"
  default     = "dev"
}

variable "ecr_repository" {
  type        = string
  description = "Nome do repositório ECR para obter a imagem Docker"
  default     = "demo-spring-app"
}

variable "role_iam" {
  type        = string
  description = "Nome da role IAM com TODAS as roles necessárias para funcionamento dos módulos"
  default     = "ecs-tasks-demo" # APENAS caso use de forma restrita e no data.tf
}

variable "role_task_arn" {
  type        = string
  description = "ARN da role atribuída à task ECS"
  default     = "role-task-arn"
}

variable "role_execution_arn" {
  type        = string
  description = "ARN da role de execução do ECS"
  default     = "role-execution-arn"
}

variable "port_application" {
  type        = number
  description = "Porta onde a aplicação escuta"
  default     = 8080
}

variable "subnet_id" {
  type        = list(string)
  description = "Lista de IDs das subnets para deploy"
  default     = []
}

variable "sg_default" {
  type        = string
  description = "ID do grupo de segurança padrão"
  default     = "sg-default"
}

variable "uri_image" {
  type        = string
  description = "URI completa da imagem Docker no ECR"
  default     = "uri-image-ecr"
}

variable "target_group" {
  type        = string
  description = "Nome do target group para balanceamento"
  default     = "target-group-default"
}
