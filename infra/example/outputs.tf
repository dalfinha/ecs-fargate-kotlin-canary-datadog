output "service_name" {
  value = module.ecs-service.service_name
}

output "alb_name" {
  value = module.alb.application_load_balancer_name
}

output "datadog" {
  value = module.ecs-service.datadog
}

output "version_application_image" {
  value = data.aws_ecr_repository.this.most_recent_image_tags[0]
}

output "codedeploy_application" {
  value = module.codedeploy.application_name_codedeploy
}

output "s3_appspec" {
  value = module.codedeploy.s3_bucket
}

output "codedeploy_config_strategy" {
  value = module.codedeploy.deploy_strategy
}