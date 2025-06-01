resource "aws_ecs_task_definition" "this" {
  depends_on = [aws_ecs_cluster.this]

  family                  = "family-${var.service_name}"
  task_role_arn           = var.role_task_arn
  execution_role_arn      = var.role_execution_arn
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = var.enable_datadog ? "512" : "256"
  memory = var.enable_datadog ? "1024" : "512"

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode(
    concat(
      [
        {
          name  = "container-${var.service_name}"
          image = var.uri_image
          cpu   = 256
          portMappings = [
            {
              name          = "container-${var.service_name}-${var.port_application}-tcp"
              containerPort = var.port_application
              hostPort      = var.port_application
              protocol      = "tcp"
              appProtocol   = "http"
            }
          ]
          essential   = true
          environment = concat(
            [
              for env in var.env_variables : {
              name  = env.key
              value = env.value
            }
            ],
              var.enable_datadog ? [
              { name = "DD_AGENT_HOST", value = "127.0.0.1" }
            ] : []
          )
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = aws_cloudwatch_log_group.this.name
              mode                  = "non-blocking"
              max-buffer-size       = "25m"
              awslogs-region        = data.aws_region.current.id
              awslogs-stream-prefix = "ecs"
            }
          }
        }
      ],
        var.enable_datadog ? [
        {
          name      = "datadog-agent"
          image     = "public.ecr.aws/datadog/agent:latest"
          cpu       = 64
          memory    = 256
          essential = false
          environment = [
            { name = "ECS_FARGATE", value = "true" },
            { name = "DD_SITE", value = "datadoghq.com" },
            { name = "DD_LOGS_ENABLED", value = "true" },
            { name = "DD_APM_ENABLED", value = "true" }
          ]
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
              name = "DD_API_KEY"
              valueFrom = local.datadog_api_key
            }]
        }
      ] : []
    )
  )
}
