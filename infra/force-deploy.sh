#!/bin/env bash
echo "Iniciando um novo Deployment..."
sleep 30
# Forçando um novo deployment
aws deploy create-deployment --application-name poc-dev-kotlin-canary-datadog --deployment-group-name poc-dev-kotlin-canary-datadog --revision "{\"revisionType\": \"S3\", \"s3Location\": {\"bucket\": \"artefatos-kotlin-canary\", \"key\": \"appspec.yaml\", \"bundleType\": \"yaml\"}}"

# Limpando o arquivo temporário
rm -rf ./codedeploy/appspec.yaml