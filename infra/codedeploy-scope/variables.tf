variable "application_name" {}

variable "role_codedeploy" {}

variable "deployment_config_canary" {
  default = "CodeDeployDefault.ECSCanary10Percent5Minutes"
}

variable "cluster_name" {}

variable "service_name" {}

variable "arn_listener" {}

variable "listeners_name" {}
