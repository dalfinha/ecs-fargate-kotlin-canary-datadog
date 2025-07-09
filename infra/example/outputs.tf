output "service_name" {
  value = module.ecs-service-codedeploy.service_name
}

output "alb_name" {
  value = module.alb.application_load_balancer_name
}

output "datadog" {
  value = module.ecs-service-codedeploy.datadog
}

output "version_application_image" {
  value = data.aws_ecr_repository.this.most_recent_image_tags[0]
}

output "codedeploy_application" {
  value = module.ecs-service-codedeploy.application_name_codedeploy
}

output "s3_appspec" {
  value = module.ecs-service-codedeploy.s3_bucket
}

output "codedeploy_config_strategy" {
  value = module.ecs-service-codedeploy.deploy_strategy
}