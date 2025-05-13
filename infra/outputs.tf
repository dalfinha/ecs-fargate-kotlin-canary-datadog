output "service_name" {
  value = module.ecs-service.service_name
}

output "container_name" {
  value = module.ecs-service.container_name
}

output "last_image_ecr" {
  value = data.aws_ecr_image.this.image_uri
}

output "alb_name" {
  value = module.alb.application_load_balancer_name
}

output "codedeploy_application" {
  value = module.code-deploy.application_name_codedeploy
}

output "s3_appspec" {
  value = module.code-deploy.s3_bucket
}

output "codedeploy-config-strategy" {
  value = module.code-deploy.deploy_strategy
}