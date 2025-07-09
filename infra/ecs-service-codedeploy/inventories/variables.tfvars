env              = "dev"

service_name = "demo-canary-kotlin"

role_task = "ecs-tasks-demo"
role_execution = "ecs-tasks-demo"

ecs_cluster_name = "ecs-kotlin-canary"

ecr_repository   = "demo-spring-app"
env_variables    = {}

target_group = "canary-blue"

port_application = 8080

scope = "demo-canary-kotlin"
sg_default = ["sg-046a3ad6000cf9fa6"]
vpc_id = "vpc-0602f5bc2a1cbad26"
subnet_id = ["subnet-074881897ff18f8f1", "subnet-0a893f8d9dab0ac52", "subnet-0cc51a1598183189b", "subnet-0394792a866a64b31", "subnet-08a5b2e5650b13368", "subnet-0e93cedeea7b031d9"]

deployment_config_canary = "CodeDeployDefault.ECSAllAtOnce"

enable_datadog = false