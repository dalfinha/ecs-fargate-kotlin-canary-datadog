resource "aws_ecs_task_definition" "this" {
  depends_on = [aws_ecs_cluster.this]

  family                   = "family-${var.service_name}"
  task_role_arn            = var.role_task_arn
  execution_role_arn       = var.role_execution_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = local.total_cpu
  memory = local.total_memory

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode(
    concat(
      [
        {
          name  = "container-${var.service_name}"
          image = data.aws_ecr_image.this.image_uri
          cpu    = local.default_app_cpu
          memory = local.default_app_memory
          portMappings = [
            {
              name          = "container-${var.service_name}-${var.port_application}-tcp"
              containerPort = var.port_application
              hostPort      = var.port_application
              protocol      = "tcp"
              appProtocol   = "http"
            }
          ]
          healthCheck = {
            command     = ["CMD-SHELL", "curl -f http://localhost:${var.port_application}/actuator/health || exit 1"]
            interval    = 30
            timeout     = 5
            retries     = 3
            startPeriod = 10
          }
          essential   = true
          environment = concat(
            [
              for key, value in var.env_variables : {
              name  = key
              value = value
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
  skip_destroy = true

  lifecycle {
    create_before_destroy = true
  }
}
