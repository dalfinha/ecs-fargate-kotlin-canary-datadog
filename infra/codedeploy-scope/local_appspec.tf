data "template_file" "this" {
  template = file("${path.module}/appspec_template/appspec_sample_template.yaml")
  vars = {
    TASK_DEFINITION_ARN = data.aws_ecs_service.current.task_definition
    CONTAINER_NAME      = local.container_name
    CONTAINER_PORT      = var.port_application
  }
}

resource "local_file" "this" {
  depends_on = [null_resource.create_new_appspec]

  content  = data.template_file.this.rendered
  filename = "${path.module}/appspec_template/appspec.yaml"
}

resource "null_resource" "create_new_appspec" {
  triggers = {
    always_run = timestamp()
  }
}