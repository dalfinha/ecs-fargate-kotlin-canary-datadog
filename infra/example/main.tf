module "alb" {
  source = "git::https://github.com/dalfinha/ecs-fargate-kotlin-canary-datadog.git//infra/application-load-balancer?ref=v2.0.0"

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
  source = "git::https://github.com/dalfinha/ecs-fargate-kotlin-canary-datadog.git//infra/ecs-service?ref=v2.0.0"

  env    = "dev"
  # Service Config
  ecs_cluster_name   = var.ecs_cluster_name
  service_name       = var.service_name
  role_execution_arn = data.aws_iam_role.this.arn
  role_task_arn      = data.aws_iam_role.this.arn

  # Network Config
  port_application   = module.alb.port_application
  subnet_id          = data.aws_subnets.this.ids
  sg_default         = data.aws_security_group.this.id
  uri_image          = data.aws_ecr_image.this.image_uri
  target_group       = module.alb.target_group_name_list["blue"]

  # Additional Configs in Task Definition
  env_variables      = []
}

module "code-deploy" {
  depends_on = [ module.ecs-service ]
  source = "git::https://github.com/dalfinha/ecs-fargate-kotlin-canary-datadog.git//infra/codedeploy-scope?ref=v2.0.0"

  # Config Service
  cluster_name             = module.ecs-service.cluster_name
  cluster_arn              = module.ecs-service.cluster_arn
  service_name             = module.ecs-service.service_name
  target_group             = "canary"
  port_application         = module.alb.port_application

  #Strategy Canary
  role_codedeploy          = data.aws_iam_role.this.arn
  deployment_config_canary = "CodeDeployDefault.ECSCanary10Percent5Minutes"

}

