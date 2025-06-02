locals {
  max_capacity_scaling = aws_ecs_service.this.desired_count * 5

  container_definition = jsondecode(aws_ecs_task_definition.this.container_definitions)
  container_name = local.container_definition[0].name

  dd_version    = split("@", var.uri_image)[1]

  datadog_configure = concat(var.env_variables, [
    {
      name  = "ECS_FARGATE",
      value = "true"
    },
    {
      name  = "DD_SITE",
      value = "datadoghq.com"
    },
    {
      name  = "DD_LOGS_ENABLED",
      value = "true"
    },
    {
      name  = "DD_APM_ENABLED",
      value = "true"
    },
    {
      name  = "DD_ENV",
      value =  var.env
    },
    {
      name  = "DD_VERSION",
      value = local.dd_version
    },
    {
      name  = "DD_SERVICE",
      value = var.service_name
    }
  ])

  datadog_api_key   = var.enable_datadog ? data.aws_secretsmanager_secret.datadog.arn : null
}
