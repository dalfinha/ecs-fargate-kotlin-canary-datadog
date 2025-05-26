#!/bin/bash
set -e

ECR_REPOSITORY_NAME=${1:-demo-spring-app}
AWS_REGION=${2:-us-east-1}

echo "## PULL ECR - $ECR_ECR_REPOSITORY_NAME ##"
if [ -z "$ECR_REPOSITORY_NAME" ]; then
  echo -e '\033[0;31mErro: O nome do repositório não pode estar vazio!\033[0m'
  exit 1
fi

echo "Obtendo detalhes do assume-role..."
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)

echo "Obtendo detalhes do repositório ECR..."
URI_ECR_REPOSITORY=$(aws ecr describe-repositories --region "$AWS_REGION" --repository-names "$ECR_REPOSITORY_NAME" --query 'repositories[0].repositoryUri' --output text)

echo "Autenticando Docker ECR..."
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

echo "Verificando tags existentes no repositório..."
TAGS=$(aws ecr list-images --repository-name "$ECR_REPOSITORY_NAME" --region "$AWS_REGION" --query 'imageIds[?imageTag!=null].imageTag' --output text)

VERSIONS=$(echo "$TAGS" | tr ' \t' '\n' | grep -E '^v[0-9]+$' | sed 's/^v//' | sort -n)
if [[ -z "$VERSIONS" ]]; then
  NEXT_VERSION=1
else
  LAST_VERSION=$(echo "$VERSIONS" | tail -1)
  NEXT_VERSION=$((LAST_VERSION + 1))
fi

NEW_TAG="v$NEXT_VERSION"

echo "Criando nova tag: $NEW_TAG"
docker tag "$ECR_REPOSITORY_NAME:latest" "$URI_ECR_REPOSITORY:$NEW_TAG"
docker push "$URI_ECR_REPOSITORY:$NEW_TAG"
echo -e "\033[1;32mPush realizado com sucesso! Nova versão: $NEW_TAG\033[0m"
