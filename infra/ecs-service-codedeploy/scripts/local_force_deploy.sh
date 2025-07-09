#!/bin/env bash

echo "Iniciando verificação de status de deployment..."

DEPLOYMENT_ID=$(aws deploy list-deployments --application-name $APPLICATION_NAME --deployment-group-name $DEPLOYMENT_GROUP_NAME --query 'deployments[0]' --output text)

if [ "$DEPLOYMENT_ID" != "None" ]; then
    STATUS=$(aws deploy get-deployment --deployment-id $DEPLOYMENT_ID --query 'deploymentInfo.status' --output text)

    if [ "$STATUS" == "InProgress" ]; then
        echo "Já existe um deployment em andamento (ID: $DEPLOYMENT_ID). Um novo deployment não será iniciado."
        exit 0
    else
        echo "Sem deploy em andamento. Iniciando novo deployment..."
    fi
else
    echo "Sem deploy em andamento. Iniciando novo deployment..."
fi

aws s3 cp ./codedeploy/appspec.yaml s3://$S3_APPSPEC/appspec.yaml

sleep 15

DEPLOYMENT_ID=$(aws deploy create-deployment \
  --application-name $APPLICATION_NAME \
  --deployment-group-name $DEPLOYMENT_GROUP_NAME \
  --revision "{\"revisionType\": \"S3\", \"s3Location\": {\"bucket\": \"$S3_APPSPEC\", \"key\": \"appspec.yaml\", \"bundleType\": \"yaml\"}}" \
  --output text --query deploymentId)

echo -e "\033[1;32mID do deployment: $DEPLOYMENT_ID\033[0m"

rm -rf ./codedeploy/appspec.yaml
#aws s3 rm s3://$S3_APPSPEC/appspec.yaml
