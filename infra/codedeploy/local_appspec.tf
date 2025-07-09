data "template_file" "this" {
  template = file("${path.module}/appspec_template/appspec_sample_template.yaml")
  vars = {
    TASK_DEFINITION_ARN = data.aws_ecs_service.current.task_definition
    CONTAINER_NAME      = local.container_name
    CONTAINER_PORT      = var.port_application
    TRIGGER             = local.force_trigger_appspec
  }
}

resource "local_file" "this" {
  content  = data.template_file.this.rendered
  filename = "${path.module}/appspec_template/appspec.yaml"
}