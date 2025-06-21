resource "aws_ecs_task_definition" "this" {
  depends_on = [aws_ecs_cluster.this]

  family                   = "family-${var.service_name}"
  task_role_arn            = var.role_task_arn
  execution_role_arn       = var.role_execution_arn
  network_mode             = "awsvpc"
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
          memory = 512
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
          healthCheck = {
            command     = ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]
            interval    = 30
            timeout     = 5
            retries     = 3
            startPeriod = 10
          }
          environment = concat(
            [
              for env in var.env_variables : {
              name  = env.key
              value = env.value
              }
            ],
             var.enable_datadog ? local.dd_variables : []
          )
          logConfiguration = var.enable_datadog ? local.fluentbit : local.cloudwatch_logs
        }
      ],
        var.enable_datadog ? [local.dd_apm_configure] : [],
        var.enable_datadog ? [local.dd_logs_configure]: []
    )
  )
}
