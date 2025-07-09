module "alb" {
  source = "git::https://github.com/dalfinha/ecs-fargate-kotlin-canary-datadog.git//infra/application-load-balancer?ref=feature/secrets"

  #ALB
  scope      = var.service_name
  sg_default = [data.aws_security_group.this.id]
  subnet_id  = data.aws_subnets.this.ids

  #Target Group and Listener
  target_group_name = "canary"
  port_application  = var.port_application
  vpc_id            = data.aws_vpc.this.id
}

module "ecs-service-codedeploy" {
  depends_on = [ module.alb ]
  source = "git::https://github.com/dalfinha/ecs-fargate-kotlin-canary-datadog.git//infra/ecs-service-codedeploy?ref=feature/secrets"

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
  ecr_repository     = data.aws_ecr_image.this.image_uri
  target_group       = module.alb.target_group_name_list["blue"]

  # Additional Configs in Task Definition
  env_variables      = []

  # Enable Datadog in Task Definition
  enable_datadog     = false
}
