data "aws_region" "current" {}

data "aws_iam_role" "this" {
  name = var.role_iam
}

data "aws_ecr_image" "this" {
  repository_name = var.ecr_repository
  most_recent     = true
}

data "aws_ecr_repository" "this" {
  name = var.ecr_repository
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
