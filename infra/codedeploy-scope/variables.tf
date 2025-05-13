variable "role_codedeploy" {}

variable "deployment_config_canary" {
  default = "CodeDeployDefault.ECSCanary10Percent5Minutes"
}

variable "cluster_name" {
  default = "meu-cluster-name"
}

variable "service_name" {
  default = "meu-service-name"
}

variable "cluster_arn" {
  default = "cluster_arn"
}

variable "target_group" {
  default = "seu-target-group"
} #TO-DO: adicionar como lista para acesso ao canary

variable "port_application" {
  default = 10000
}
