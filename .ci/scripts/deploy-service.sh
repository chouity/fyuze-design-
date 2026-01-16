#!/bin/bash

# Service Deployment Script
# Creates or updates ECS service with auto-scaling
# Usage: ./deploy-service.sh <cluster-name> <service-name> <task-family> <min-capacity> <max-capacity> <environment> [target-group-arn]

set -e

ECS_CLUSTER="$1"
ECS_SERVICE="$2"
TASK_FAMILY="$3"
MIN_CAPACITY="$4"
MAX_CAPACITY="$5"
ENVIRONMENT="$6"
TARGET_GROUP_ARN="${7:-}"

if [ -z "$ECS_CLUSTER" ] || [ -z "$ECS_SERVICE" ] || [ -z "$TASK_FAMILY" ] || [ -z "$MIN_CAPACITY" ] || [ -z "$MAX_CAPACITY" ] || [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 <cluster-name> <service-name> <task-family> <min-capacity> <max-capacity> <environment> [target-group-arn]"
    exit 1
fi

echo "🚀 Deploying ECS service..."
echo "Cluster: $ECS_CLUSTER"
echo "Service: $ECS_SERVICE"
echo "Task Family: $TASK_FAMILY"
echo "Min Capacity: $MIN_CAPACITY"
echo "Max Capacity: $MAX_CAPACITY"
echo "Environment: $ENVIRONMENT"
if [ -n "$TARGET_GROUP_ARN" ]; then echo "Target Group: $TARGET_GROUP_ARN"; fi

# Get latest task definition ARN
TASK_DEFINITION_ARN=$(aws ecs describe-task-definition \
    --task-definition "$TASK_FAMILY" \
    --query 'taskDefinition.taskDefinitionArn' \
    --output text)

echo "📋 Using task definition: $TASK_DEFINITION_ARN"

# Determine service port if ALB is used and SERVICE_PORT not set
if [ -n "$TARGET_GROUP_ARN" ]; then
    SERVICE_PORT=$(aws ecs describe-task-definition \
        --task-definition "$TASK_DEFINITION_ARN" \
        --query 'taskDefinition.containerDefinitions[0].portMappings[0].containerPort' \
        --output text)
    echo "🔎 Derived container/service port from task definition: $SERVICE_PORT"
fi

# Get VPC and subnet information
PROJECT_NAME="${ECS_SERVICE%-service-*}"
VPC_NAME="${PROJECT_NAME}-vpc-${ENVIRONMENT}"

echo "🔍 Looking up VPC and subnets..."
VPC_ID=$(aws ec2 describe-vpcs \
    --filters "Name=tag:Name,Values=$VPC_NAME" \
    --query 'Vpcs[0].VpcId' \
    --output text)

if [ "$VPC_ID" = "None" ] || [ "$VPC_ID" = "null" ]; then
    echo "❌ VPC not found: $VPC_NAME"
    exit 1
fi

SUBNET_IDS=$(aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Environment,Values=$ENVIRONMENT" \
    --query 'Subnets[].SubnetId' \
    --output text | tr '\t' ',')

SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
    --filters "Name=group-name,Values=${PROJECT_NAME}-sg-${ENVIRONMENT}" \
    --query 'SecurityGroups[0].GroupId' \
    --output text)

echo "📡 Network configuration:"
echo "VPC ID: $VPC_ID"
echo "Subnet IDs: $SUBNET_IDS"
echo "Security Group ID: $SECURITY_GROUP_ID"

# Check if service exists
SERVICE_EXISTS=$(aws ecs describe-services \
    --cluster "$ECS_CLUSTER" \
    --services "$ECS_SERVICE" \
    --query 'services[0].status' \
    --output text 2>/dev/null || echo "NOTFOUND")

if [ "$SERVICE_EXISTS" = "NOTFOUND" ] || [ "$SERVICE_EXISTS" = "None" ]; then
    echo "🆕 Creating new ECS service: $ECS_SERVICE"
    
    if [ -n "$TARGET_GROUP_ARN" ]; then
        aws ecs create-service \
            --cluster "$ECS_CLUSTER" \
            --service-name "$ECS_SERVICE" \
            --task-definition "$TASK_DEFINITION_ARN" \
            --desired-count "$MIN_CAPACITY" \
            --launch-type FARGATE \
            --platform-version LATEST \
            --health-check-grace-period-seconds 60 \
            --load-balancers targetGroupArn=$TARGET_GROUP_ARN,containerName=${TASK_FAMILY}-container,containerPort=$SERVICE_PORT \
            --network-configuration "awsvpcConfiguration={subnets=[$SUBNET_IDS],securityGroups=[$SECURITY_GROUP_ID],assignPublicIp=ENABLED}" \
            --tags key=Environment,value="$ENVIRONMENT" \
            --enable-execute-command >/dev/null
    else
        aws ecs create-service \
            --cluster "$ECS_CLUSTER" \
            --service-name "$ECS_SERVICE" \
            --task-definition "$TASK_DEFINITION_ARN" \
            --desired-count "$MIN_CAPACITY" \
            --launch-type FARGATE \
            --platform-version LATEST \
            --network-configuration "awsvpcConfiguration={subnets=[$SUBNET_IDS],securityGroups=[$SECURITY_GROUP_ID],assignPublicIp=ENABLED}" \
            --tags key=Environment,value="$ENVIRONMENT" \
            --enable-execute-command >/dev/null
    fi
    
    echo "✅ Service created: $ECS_SERVICE"
else
    echo "🔄 Updating existing ECS service: $ECS_SERVICE"
    
    # Update service
    if [ -n "$TARGET_GROUP_ARN" ]; then
        aws ecs update-service \
            --cluster "$ECS_CLUSTER" \
            --service "$ECS_SERVICE" \
            --task-definition "$TASK_DEFINITION_ARN" \
            --desired-count "$MIN_CAPACITY" \
            --health-check-grace-period-seconds 60 \
            --load-balancers targetGroupArn=$TARGET_GROUP_ARN,containerName=${TASK_FAMILY}-container,containerPort=$SERVICE_PORT >/dev/null
    else
        aws ecs update-service \
            --cluster "$ECS_CLUSTER" \
            --service "$ECS_SERVICE" \
            --task-definition "$TASK_DEFINITION_ARN" \
            --desired-count "$MIN_CAPACITY" >/dev/null
    fi
    
    echo "✅ Service updated: $ECS_SERVICE"
fi

# Set up auto-scaling if min and max capacity are different
if [ "$MIN_CAPACITY" != "$MAX_CAPACITY" ]; then
    echo "⚖️  Setting up auto-scaling..."
    
    # Create scalable target
    RESOURCE_ID="service/${ECS_CLUSTER}/${ECS_SERVICE}"
    
    aws application-autoscaling register-scalable-target \
        --service-namespace ecs \
        --resource-id "$RESOURCE_ID" \
        --scalable-dimension ecs:service:DesiredCount \
        --min-capacity "$MIN_CAPACITY" \
        --max-capacity "$MAX_CAPACITY" >/dev/null 2>&1 || echo "Scalable target already exists"
    
    # Create scaling policy for CPU utilization
    POLICY_NAME="${ECS_SERVICE}-cpu-scaling"
    
    aws application-autoscaling put-scaling-policy \
        --policy-name "$POLICY_NAME" \
        --service-namespace ecs \
        --resource-id "$RESOURCE_ID" \
        --scalable-dimension ecs:service:DesiredCount \
        --policy-type TargetTrackingScaling \
        --target-tracking-scaling-policy-configuration '{
            "TargetValue": 70.0,
            "PredefinedMetricSpecification": {
                "PredefinedMetricType": "ECSServiceAverageCPUUtilization"
            },
            "ScaleOutCooldown": 300,
            "ScaleInCooldown": 300
        }' >/dev/null 2>&1 || echo "Scaling policy already exists"
    
    echo "✅ Auto-scaling configured: ${MIN_CAPACITY}-${MAX_CAPACITY} instances"
else
    echo "ℹ️  Auto-scaling skipped (min == max capacity)"
fi

# Get service information
SERVICE_ARN=$(aws ecs describe-services \
    --cluster "$ECS_CLUSTER" \
    --services "$ECS_SERVICE" \
    --query 'services[0].serviceArn' \
    --output text)

# Output for use in subsequent steps
echo "service-arn=$SERVICE_ARN" >> $GITHUB_OUTPUT
echo "resource-id=$RESOURCE_ID" >> $GITHUB_OUTPUT

echo "🎉 Service deployment complete!"
echo "Service ARN: $SERVICE_ARN"
echo "Resource ID: $RESOURCE_ID"