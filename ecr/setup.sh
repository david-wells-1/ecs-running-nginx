#!/bin/bash
export AWS_PAGER=""

# Get the AWS Account ID
export AWS_ACCOUNT=$(aws sts get-caller-identity --query 'Account' --output text)

# Set configuration variables
export AWS_REGION="eu-west-2"
export ECR_NAME="ecs-running-nginx"

# Authenticate Docker to the AWS ECR registry
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Check if the repository exists, create it if it doesn't
if aws ecr describe-repositories --repository-names "${ECR_NAME}" --region "${AWS_REGION}" > /dev/null 2>&1; then
    echo "Repository '${ECR_NAME}' already exists."
else
    echo "Repository '${ECR_NAME}' not found. Creating it now..."
    
    aws ecr create-repository \
        --repository-name "${ECR_NAME}" \
        --region "${AWS_REGION}" \
        --image-tag-mutability MUTABLE \
        --image-scanning-configuration scanOnPush=true
        
    if [ $? -eq 0 ]; then
        echo "Successfully created repository '${ECR_NAME}'."
    else
        echo "Error: Failed to create repository '${ECR_NAME}'."
        exit 1
    fi
fi

# Build the Docker image locally
docker build --platform linux/amd64 . -t ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_NAME}:latest

# Push the Docker image to AWS ECR
docker push ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_NAME}:latest
