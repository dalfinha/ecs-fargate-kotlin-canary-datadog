resource "aws_ecs_task_definition" "this" {
  family                = "family-${local.project_name}"

  task_role_arn           = data.aws_iam_role.this.arn
  execution_role_arn      = data.aws_iam_role.this.arn
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
      name  = "container-${local.project_name}"
      image = data.aws_ecr_image.this.image_uri
      cpu   = 0
      portMappings = [
        {
          name          = "container-${local.project_name}-80-tcp"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      essential           = true
      environment         = [
        for env in var.env_variables : {
          name  = env.key
          value = env.value
        }
      ]
      environmentFiles    = []
      mountPoints         = []
      volumesFrom         = []
      ulimits             = []
      systemControls      = []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          mode                  = "non-blocking"
          max-buffer-size       = "25m"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
        secretOptions = []
      }
    }
  ])
}