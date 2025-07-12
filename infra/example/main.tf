module "alb" {
  source = "git::https://github.com/dalfinha/ecs-fargate-kotlin-canary-datadog.git//infra/application-load-balancer?ref=feature/codedeploy-configuration"

  #ALB
  scope      = var.service_name
  sg_default = [data.aws_security_group.this.id]
  subnet_id  = data.aws_subnets.this.ids

  #Target Group and Listener
  target_group_name = "canary"
  port_application  = var.port_application
  vpc_id            = data.aws_vpc.this.id
}

module "ecs-service" {
  depends_on = [ module.alb ]
  source = "git::https://github.com/dalfinha/ecs-fargate-kotlin-canary-datadog.git//infra/ecs-service?ref=feature/codedeploy-configuration"

  env    = "dev"
  # Service Config
  ecs_cluster_name   = var.ecs_cluster_name
  service_name       = var.service_name
  role_execution_arn = data.aws_iam_role.this.arn
  role_task_arn      = data.aws_iam_role.this.arn

  # Network Config
  port_application   = module.alb.port_application
  subnet_id          = data.aws_subnets.this.ids
  sg_default         = [data.aws_security_group.this.id]
  ecr_repository     = data.aws_ecr_image.this.repository_name
  target_group       = module.alb.target_group_blue_green["blue"]

  # Additional Configs in Task Definition
  env_variables      = {
    "made"  = "codedeploy_module"
  }

  enable_datadog     = true
}

module "codedeploy" {
  depends_on = [ module.ecs-service ]
  source = "git::https://github.com/dalfinha/ecs-fargate-kotlin-canary-datadog.git//infra/codedeploy?ref=feature/codedeploy-configuration"

  # Config Service
  cluster_name             = module.ecs-service.cluster_name
  service_name             = module.ecs-service.service_name
  target_group             = "canary"
  port_application         = module.alb.port_application

  #Strategy Canary Deploy
  role_codedeploy_arn      = data.aws_iam_role.this.arn
  deployment_config_canary = "CodeDeployDefault.ECSAllAtOnce"
}
