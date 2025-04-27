resource "local_file" "task_def_json" {
  content  = aws_ecs_task_definition.this.container_definitions
  filename = "${path.module}/taskdef.json"
}


resource "local_file" "app_sec" {
  content = jsonencode({
    family                   = aws_ecs_task_definition.this.family
    taskRoleArn              = aws_ecs_task_definition.this.task_role_arn
    executionRoleArn         = aws_ecs_task_definition.this.execution_role_arn
    networkMode              = aws_ecs_task_definition.this.network_mode
    requiresCompatibilities  = aws_ecs_task_definition.this.requires_compatibilities
    cpu                      = aws_ecs_task_definition.this.cpu
    memory                   = aws_ecs_task_definition.this.memory
    runtimePlatform          = {
      cpuArchitecture         = "X86_64"
      operatingSystemFamily    = "LINUX"
    }
    containerDefinitions     = jsondecode(aws_ecs_task_definition.this.container_definitions)
  })
  filename = "${path.module}/taskdef.json"
}

resource "local_file" "appspec" {
  content = <<EOT
version: 1
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: taskdef.json
        LoadBalancerInfo:
          ContainerName: container-${local.project_name}
          ContainerPort: 80
EOT
  filename = "${path.module}/appspec.yaml"
}

resource "null_resource" "zip_and_upload" {
  provisioner "local-exec" {
    command = <<EOT
      zip app.zip taskdef.json appspec.yaml
      aws s3 cp app.zip s3://poc-dev-kotlin-canary-datadog-task-definition/app.zip
    EOT
  }

  depends_on = [
    local_file.task_def_json, local_file.appspec
  ]
}

