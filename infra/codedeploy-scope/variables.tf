variable "application_name" {}

variable "role_codedeploy" {}

variable "deployment_config_canary" {
  default = "CodeDeployDefault.ECSCanary10Percent5Minutes"
}

variable "cluster_name" {}

variable "service_name" {}

variable "arn_listener" {}

variable "listeners_name" {} #TO-DO: adicionar como lista para acesso ao canary

variable "task_definition_arn" {}

variable "container_name" {}

variable "port_application" {}
