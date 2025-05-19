env              = "dev"

role_iam         = "ecs-tasks-demo"
service_name     = "kotlin-canary"
ecs_cluster_name =  "ecs-kotlin-canary"

ecr_repository   = "demo/kotlin-app-canary"
env_variables    = []

port_application = 8080
