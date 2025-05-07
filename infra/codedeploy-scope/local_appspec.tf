data "template_file" "this" {
  template = file("${path.module}/codedeploy/appspec_sample_template.yaml")
  vars = {
    TASK_DEFINITION_ARN = aws_ecs_task_definition.this.arn
    CONTAINER_NAME      = jsondecode(aws_ecs_task_definition.this.container_definitions)[0].name
    CONTAINER_PORT      = jsondecode(aws_ecs_task_definition.this.container_definitions)[0].portMappings[0].containerPort
  }
}

resource "local_file" "this" {
  content  = data.template_file.this.rendered
  filename = "${path.module}/codedeploy/appspec.yaml"
}

