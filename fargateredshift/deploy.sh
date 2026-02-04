#!/bin/bash
set -e

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"
REPO_NAME="dbt-redshift"

echo "🔨 Building sudo docker image..."
sudo docker build -t ${REPO_NAME}:latest .

echo "🔑 Logging into ECR..."
aws ecr get-login-password --region ${REGION} | \
  sudo docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

echo "🏷️ Tagging image..."
sudo docker tag ${REPO_NAME}:latest ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest

echo "📤 Pushing to ECR..."
sudo docker push ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest

echo "📋 Registering Task Definition..."
aws ecs register-task-definition --cli-input-json file://task-definition.json

echo "🚀 Deploying Step Functions..."
aws stepfunctions create-state-machine --cli-input-json file://stepfunctions-dbt-pipeline.json

echo "✅ Deployment completed!"