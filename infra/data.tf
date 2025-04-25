data "aws_iam_role" "this" {
  name = "ecs-tasks-demo"
}

data "aws_ecr_image" "this" {
  repository_name = "demo/kotlin-app-canary"
  most_recent = true
}

data "aws_vpc" "this" {
  default = true
}

data "aws_security_group" "this" {
  name   = "default"
  vpc_id = data.aws_vpc.this.id
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}
