variable "role_codedeploy_arn" {
  description = "Role IAM com permissoes para executar o CodeDeploy"
}

variable "deployment_config_canary" {
  default = "CodeDeployDefault.ECSAllAtOnce"
}

variable "cluster_name" {
  description = "Nome do Cluster Existente"
  default = "meu-cluster-name"
}

variable "service_name" {
  description = "Nome do Service Existente"
  default = "meu-service-name"
}

variable "cluster_arn" {
  description = "ARN do Cluster"
  default = "cluster_arn"
}

variable "target_group" {
  description = "Nome do Target Group"
  default = "canary-target-gro"
}

variable "port_application" {
  description = "Porta da aplicação"
  default = 10000
}