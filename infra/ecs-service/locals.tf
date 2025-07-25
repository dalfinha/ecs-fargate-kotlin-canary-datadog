locals {
  max_capacity_scaling = aws_ecs_service.this.desired_count * 3

  task_suffix = substr(md5(1), 0, 6)

  target_group = replace(var.target_group, "-blue", "")
  force_trigger_appspec = timestamp()

  container_definition = jsondecode(aws_ecs_task_definition.this.container_definitions)
  container_name = local.container_definition[0].name

  total_cpu    = var.enable_datadog ? 512  : 256
  total_memory = var.enable_datadog ? 1024 : 512

  default_app_cpu    = 256
  default_app_memory = 512

  left_over_cpu    = local.total_cpu    - local.default_app_cpu
  left_over_memory = local.total_memory - local.default_app_memory

  sidecar_weights = {
    dd_logs = 50
    dd_apm  = 50
  }

  div_task_resource = merge(
    {
      app = {
        cpu    = local.default_app_cpu
        memory = local.default_app_memory
      }
    },
    { for k, v in local.sidecar_weights :
      k => {
      cpu    = floor(local.left_over_cpu * v / 100)
      memory = floor(local.left_over_memory * v / 100)
    }
    }
  )

  dd_version = split("@", data.aws_ecr_image.this.image_uri)[1]

  dd_variables = concat([
      for key, value in var.env_variables :
    {
      name  = key
      value = value
    }
  ], [
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
      name  = "DD_LOGS_INJECTION",
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
      DD_SERVICE  = var.service_name
      DD_SOURCE  = "kotlin"
      DD_TAGS    = "env:${var.env}"
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
    cpu       = local.div_task_resource.dd_apm.cpu
    memory    = local.div_task_resource.dd_apm.memory
    essential = false
    environment = local.dd_variables
    portMappings = [
      {
        containerPort = 8126
        protocol      = "tcp"
      }
    ]
    healthCheck = {
      command     = ["CMD-SHELL", "curl -f http://localhost:8126/info || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 10
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

  dd_logs_configure = {
    name      = "datadog-logs-fluentbit"
    image     = "public.ecr.aws/aws-observability/aws-for-fluent-bit:latest"
    cpu       = local.div_task_resource.dd_logs.cpu
    memory    = local.div_task_resource.dd_logs.memory
    essential = false
    environment = local.dd_variables
    healthCheck = {
      command = ["CMD-SHELL", "pgrep fluent-bit || exit 1"]
      interval = 30
      timeout = 5
      retries = 3
      startPeriod = 10
    }
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
