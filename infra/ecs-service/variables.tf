variable "ecs_cluster_name" {}

variable "env_variables" {
  type = list(object({
    key   = string
    value = string
  }))
}

variable "env" {}

variable "service_name" {}

variable "role_task_arn" {}

variable "role_execution_arn" {}

variable "port_application" {}

variable "subnet_id" {
  type = list(string)
  default = []
}

variable "deployment_controller_type" {
  type    = string
  default = "CODE_DEPLOY"
}

variable "sg_default" {}

variable "uri_image" {}

variable "target_group" {}

