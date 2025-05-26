#!/bin/bash

set -e

APP_NAME=${1:-demo-spring-app}

echo "Criando settings.gradle.kts com o nome do projeto: $APP_NAME"
echo "rootProject.name = \"$APP_NAME\"" > settings.gradle.kts

echo "Limpando e gerando bootJar..."
./gradlew clean bootJar

echo "Buildando imagem Docker..."
docker build -t $APP_NAME .

./scripts/local_pull_ecr.sh $APP_NAME
#echo "Executando container..."
#docker run -it $APP_NAME

