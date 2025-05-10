data "template_file" "this" {
  template = file("${path.module}/codedeploy-scope/appspec_template/appspec_sample_template.yaml")
  vars = {
    TASK_DEFINITION_ARN = data.aws_ecs_service.current.task_definition
    CONTAINER_NAME      = data.aws_ecs_service.current.task_definition
    CONTAINER_PORT      = var.port_application
  }
}

resource "local_file" "this" {
  content  = data.template_file.this.rendered
  filename = "${path.module}/codedeploy-scope/appspec_template/appspec.yaml"
}

