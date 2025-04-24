data "aws_iam_role" "this" {
  name = local.project_name
}

data "aws_ecr_image" "this" {
  repository_name = "demo/kotlin-app-canary"
}

data "aws_vpc" "this" {
  default = true
}

data "aws_security_group" "this" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnets" "this" {
  filter {
    name   = data.aws_vpc.this
    values = [data.aws_vpc.this.id]
  }
}
