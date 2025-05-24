#!/bin/bash
set -e

ECR_REPOSITORY_NAME="$1"
AWS_REGION="us-east-1"

if [ -z "$ECR_REPOSITORY_NAME" ]; then
  echo "Erro: Nome do repositório ECR não informado"
  exit 1
fi

echo "Obtendo detalhes do assume-role..."
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
# TO-DO - Refinar uso do get-caller -> https://docs.aws.amazon.com/cli/latest/reference/sts/get-caller-identity.html#get-caller-identity

echo "Obtendo detalhes do repositório ECR..."
URI_ECR_REPOSITORY=$(aws ecr describe-repositories --region "$AWS_REGION" --repository-names "$ECR_REPOSITORY_NAME" --query 'repositories[0].repositoryUri' --output text)

echo "Autenticando Docker ECR..."
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

echo "Obtendo versões da imagem anterior para tagueamento..."
LAST_TAG=$(aws ecr list-images --repository-name "$ECR_REPOSITORY_NAME" --region "$AWS_REGION" --query 'imageIds[*].imageTag' --output text | tr '\t' '\n' | grep '^1\.' | sort -V | tail -n1 || echo "1.0")
echo "Última tag encontrada: $LAST_TAG"

IFS='.' read -r prefix number <<< "$LAST_TAG"
if [[ "$prefix" != "1" || -z "$number" ]]; then
  prefix="1"
  number=0
fi

NEXT_TAG="$prefix.$((number + 1))"

echo "Tagueando a imagem com a nova tag: $NEXT_TAG"
docker tag "$ECR_REPOSITORY_NAME:latest" "$URI_ECR_REPOSITORY:$NEXT_TAG"

echo "Realizando push da imagem $NEXT_TAG..."
docker push "$URI_ECR_REPOSITORY:$NEXT_TAG"

echo "Push realizado com sucesso! | Nova versão: $ECR_REPOSITORY_NAME:$NEXT_TAG"
