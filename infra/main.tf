module "alb" {
  source = "./application-load-balancer"

  #ALB
  scope      = "datadog-kotlin"
  sg_default = [data.aws_security_group.this.id]
  subnet_id  = data.aws_subnets.this.ids

  #Target Group e Listener
  port_application = 8080
  vpc_id           = data.aws_vpc.this.id
}

module "codedeploy" {
  source = "./codedeploy-scope"
}