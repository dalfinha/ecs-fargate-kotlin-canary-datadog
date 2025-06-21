locals {
  max_capacity_scaling = aws_ecs_service.this.desired_count * 3

  container_definition = jsondecode(aws_ecs_task_definition.this.container_definitions)
  container_name = local.container_definition[0].name

  dd_version = split("@", var.uri_image)[1]

  dd_variables = concat(var.env_variables, [
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
      value = var.env
    },
    {
      name  = "DD_VERSION",
      value = local.dd_version
    },
    {
      name  = "DD_SERVICE",
      value = var.service_name
    },
    {
       name = "DD_AGENT_HOST",
       value = "127.0.0.1"
    }
  ])
  dd_api_key = var.enable_datadog ? data.aws_secretsmanager_secret.datadog.arn : null

  cloudwatch_logs = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.this.name
      mode                  = "non-blocking"
      max-buffer-size       = "25m"
      awslogs-region        = data.aws_region.current.id
      awslogs-stream-prefix = "ecs"
    }
    secretOptions = []
  }
  fluentbit = {
    logDriver = "awsfirelens"
    options = {
      Name        = "datadog"
      Host        = "http-intake.logs.datadoghq.com"
      TLS         = "on"
      dd_service  = var.service_name
      dd_source   = "kotlin"
      dd_tags     = "env:${var.env}"
    }
    secretOptions = [
      {
        name      = "apikey"
        valueFrom = local.dd_api_key
      }
    ]
  }
  dd_apm_configure  = {
    name      = "datadog-apm"
    image     = "public.ecr.aws/datadog/agent:latest"
    cpu       = 64
    memory    = 256
    essential = false
    environment = local.dd_variables
    portMappings = [
      {
        containerPort = 8126
        protocol      = "tcp"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.this.name
        awslogs-region        = data.aws_region.current.id
        awslogs-stream-prefix = "ecs"
      }
    }
    secrets = [
      {
        name      = "DD_API_KEY"
        valueFrom = local.dd_api_key
      }
    ]
  }
  dd_logs_configure = {
    name      = "datadog-fluentbit"
    image     = "public.ecr.aws/aws-observability/aws-for-fluent-bit:latest"
    cpu       = 64
    memory    = 256
    essential = false
    firelensConfiguration = {
      type = "fluentbit"
      options = {
        "enable-ecs-log-metadata" = "true"
      }
    }
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.this.name
        awslogs-region        = data.aws_region.current.id
        awslogs-stream-prefix = "ecs"
      }
    }
    secrets = [
      {
        name      = "DD_API_KEY"
        valueFrom = local.dd_api_key
      }
    ]
  }
}
