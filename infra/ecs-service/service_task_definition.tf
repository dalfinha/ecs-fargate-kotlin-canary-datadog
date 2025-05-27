resource "aws_ecs_task_definition" "this" {
  depends_on = [aws_ecs_cluster.this]

  family                = "family-${var.service_name}"
  task_role_arn           = var.role_task_arn
  execution_role_arn      = var.role_execution_arn
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu                     = "256"
  memory                  = "512"

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
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
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.port_application}/actuator/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 10
      }
      essential   = true
      environment = [
        for env in var.env_variables : {
          name  = env.key
          value = env.value
        }
      ]
      environmentFiles = []
      mountPoints = []
      volumesFrom = []
      ulimits = []
      systemControls = []
      logConfiguration = {
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
    }
  ])
}
