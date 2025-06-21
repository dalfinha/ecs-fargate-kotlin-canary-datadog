variable "sg_default" {
    description = "Security Group do ALB (APOS A ASSOCIAÇÃO NÃO É POSSIVEL ATRIBUIR NO ALB)"
    type = list(string)
}

variable "subnet_id" {
    description = "Lista de Subnets associadas ao Serviço ECS"
    type = list(string)
    default = []
}

variable "scope" {
    description = "Nome do Application Load Balancer"
    type = string
}

variable "port_application" {
    description = "Porta da aplicação para criação do listener HTTP"
    type = number
}

variable "vpc_id" {
    description = "VPC associada ao Application Load Balancer"
}

variable "target_group_name" {
    description = "Nome do Target Group (blue e green)"
    default = "canary"
}