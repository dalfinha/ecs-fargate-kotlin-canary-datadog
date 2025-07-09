variable "ecs_cluster_name" {
  description = "Nome do Cluster ECS Fargate"
}

variable "env_variables" {
  description = "Variaveis de ambiente associadas ao container"
  type        = map(string)
  default = {}
}

variable "env" {
  description = "Variavel de ambiente. OBS: Pode habilitar o uso do Container Insights"
  default = "dev"
}

variable "service_name" {
  description = "Nome do Serviço ECS Fargate"
}

variable "role_task_arn" {
  description = "Role IAM com permissão para Task"
}

variable "role_execution_arn" {
  description = "Role IAM para permissão de Execução"
}

variable "port_application" {
  description = "Porta da Aplicação"
}

variable "subnet_id" {
  description = "Lista de Subnets associadas ao Serviço ECS"
  type = list(string)
  default = []
}

variable "deployment_controller_type" {
  type    = string
  default = "CODE_DEPLOY"
}

variable "sg_default" {
  description = "Security Group da Aplicação"
}

variable "target_group" {
  description = "Nome do Target Group que será associado ao serviço. OBS: Não adicionar o -blue ou -green"
}

variable "enable_datadog" {
  description = "Habilita o uso do Datadog Logs e APM na aplicação"
  type    = bool
  default = true
}

variable "deployment_config_canary" {
  description = "Estratégia de Canary associada a aplicação"
  default = "CodeDeployDefault.ECSAllAtOnce"
}

variable "ecr_repository" {
  type  = string
}
