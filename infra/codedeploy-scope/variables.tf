variable "role_codedeploy" {
  description = "Role IAM com permissoes para executar o CodeDeploy"
}

variable "deployment_config_canary" {
  description = "Estratégia de Canary associada a aplicação"
  default = "CodeDeployDefault.ECSCanary10Percent5Minutes"
}

variable "cluster_name" {
  description = "Nome do Cluster Existente"
}

variable "service_name" {
  description = "Nome do Service Existente"
}

variable "cluster_arn" {
  description = "ARN do Cluster ECS Fargate"
}

variable "target_group" {
  description = "Nome do Target Group que será associado ao serviço. OBS: Não adicionar o -blue ou -green"
}

variable "port_application" {
  description = "Porta da Aplicação"
}
