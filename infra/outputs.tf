output "iam_role" {
  value = data.aws_iam_role.this.name
}

output "ultima_imagem_ecr" {
  value = data.aws_ecr_image.this.image_uri
}

output "vpc_id" {
  value = data.aws_vpc.this.id
}

output "security_group_id" {
  value = data.aws_security_group.this.id
}

output "subnet_ids" {
  value = data.aws_subnets.this.ids
}
