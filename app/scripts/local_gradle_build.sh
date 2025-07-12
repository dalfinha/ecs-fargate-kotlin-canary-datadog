#!/bin/bash

set -e

APP_NAME=${1:-demo-spring-app}

echo "## SETUP BUILD LOCAL ##"
echo "Criando settings.gradle.kts com o nome do projeto: $APP_NAME"
echo "rootProject.name = \"$APP_NAME\"" > settings.gradle.kts

echo "Limpando e gerando bootJar..."
./gradlew clean bootJar

echo "Buildando imagem Docker..."
docker build -t $APP_NAME .

# Para integrar o build ao repositório ECR
./scripts/local_pull_ecr.sh $APP_NAME
echo "Iniciando upload para o repositório ECR..."

# Para execução local
echo "Executando container..."
docker run -it $APP_NAME