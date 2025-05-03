resource "null_resource" "run_command" {
  provisioner "local-exec" {
    working_dir = path.module
    command     = "bash ./force-deploy.sh"
  }
}
