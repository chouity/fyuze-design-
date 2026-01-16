#!/bin/bash

# Infrastructure Automation Script
# Creates AWS resources if they don't exist, skips if they do
# Usage: ./ensure-infrastructure.sh <ecr-repo-name> <ecs-cluster-name> <environment> [service-port] [health-check-path]

set -e

ECR_REPOSITORY_NAME="$1"
ECS_CLUSTER_NAME="$2"
ENVIRONMENT="$3"
SERVICE_PORT="${4:-8000}"
HEALTH_CHECK_PATH="${5:-/health}"

if [ -z "$ECR_REPOSITORY_NAME" ] || [ -z "$ECS_CLUSTER_NAME" ] || [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 <ecr-repo-name> <ecs-cluster-name> <environment> [service-port] [health-check-path]"
    exit 1
fi

echo "🏗️  Ensuring AWS infrastructure exists..."
echo "ECR Repository: $ECR_REPOSITORY_NAME"
echo "ECS Cluster: $ECS_CLUSTER_NAME"
echo "Environment: $ENVIRONMENT"
echo "Service Port: $SERVICE_PORT"
echo "Health Check Path: $HEALTH_CHECK_PATH"

# Function to check if ECR repository exists
check_ecr_repository() {
    local repo_name="$1"
    aws ecr describe-repositories --repository-names "$repo_name" >/dev/null 2>&1
}

# Function to check if ECS cluster exists and is active
check_ecs_cluster() {
    local cluster_name="$1"
    local status=$(aws ecs describe-clusters --clusters "$cluster_name" --query 'clusters[0].status' --output text 2>/dev/null || echo "NOTFOUND")
    [ "$status" = "ACTIVE" ]
}

# Function to check if VPC exists for the environment
ensure_vpc() {
    local env="$1"
    local vpc_name="${ECR_REPOSITORY_NAME%-*}-vpc-${env}"
    
    # Check if VPC exists
    local vpc_id=$(aws ec2 describe-vpcs \
        --filters "Name=tag:Name,Values=$vpc_name" \
        --query 'Vpcs[0].VpcId' \
        --output text 2>/dev/null || echo "None")
    
    if [ "$vpc_id" = "None" ] || [ "$vpc_id" = "null" ]; then
        echo "📡 Creating VPC: $vpc_name"
        vpc_id=$(aws ec2 create-vpc \
            --cidr-block 10.0.0.0/16 \
            --query 'Vpc.VpcId' \
            --output text)
        
        # Tag the VPC
        aws ec2 create-tags \
            --resources "$vpc_id" \
            --tags Key=Name,Value="$vpc_name" Key=Environment,Value="$env"
        
        # Enable DNS hostnames
        aws ec2 modify-vpc-attribute \
            --vpc-id "$vpc_id" \
            --enable-dns-hostnames
        
        # Create Internet Gateway
        local igw_id=$(aws ec2 create-internet-gateway \
            --query 'InternetGateway.InternetGatewayId' \
            --output text)
        
        aws ec2 attach-internet-gateway \
            --vpc-id "$vpc_id" \
            --internet-gateway-id "$igw_id"
        
        # Create subnets
        local subnet1_id=$(aws ec2 create-subnet \
            --vpc-id "$vpc_id" \
            --cidr-block 10.0.1.0/24 \
            --availability-zone "${AWS_DEFAULT_REGION}a" \
            --query 'Subnet.SubnetId' \
            --output text)
            
        local subnet2_id=$(aws ec2 create-subnet \
            --vpc-id "$vpc_id" \
            --cidr-block 10.0.2.0/24 \
            --availability-zone "${AWS_DEFAULT_REGION}b" \
            --query 'Subnet.SubnetId' \
            --output text)
        
        # Tag subnets
        aws ec2 create-tags \
            --resources "$subnet1_id" "$subnet2_id" \
            --tags Key=Name,Value="$vpc_name-subnet" Key=Environment,Value="$env"
        
        # Create route table and route
        local rt_id=$(aws ec2 create-route-table \
            --vpc-id "$vpc_id" \
            --query 'RouteTable.RouteTableId' \
            --output text)
        
        aws ec2 create-route \
            --route-table-id "$rt_id" \
            --destination-cidr-block 0.0.0.0/0 \
            --gateway-id "$igw_id"
        
        aws ec2 associate-route-table \
            --subnet-id "$subnet1_id" \
            --route-table-id "$rt_id"
        
        aws ec2 associate-route-table \
            --subnet-id "$subnet2_id" \
            --route-table-id "$rt_id"
            
        echo "✅ VPC created: $vpc_id"
    else
        echo "✅ VPC already exists: $vpc_id"
    fi
    
    echo "vpc-id=$vpc_id" >> $GITHUB_OUTPUT
}

# Create ECR repository if it doesn't exist
if check_ecr_repository "$ECR_REPOSITORY_NAME"; then
    echo "✅ ECR repository already exists: $ECR_REPOSITORY_NAME"
else
    echo "📦 Creating ECR repository: $ECR_REPOSITORY_NAME"
    
    # Create repository first
    aws ecr create-repository \
        --repository-name "$ECR_REPOSITORY_NAME" \
        --image-scanning-configuration scanOnPush=true >/dev/null
    
    # Apply lifecycle policy separately
    aws ecr put-lifecycle-policy \
        --repository-name "$ECR_REPOSITORY_NAME" \
        --lifecycle-policy-text '{"rules":[{"rulePriority":1,"description":"Keep last 10 images","selection":{"tagStatus":"any","countType":"imageCountMoreThan","countNumber":10},"action":{"type":"expire"}}]}' >/dev/null 2>&1 || echo "Warning: Could not set lifecycle policy"
    
    echo "✅ ECR repository created: $ECR_REPOSITORY_NAME"
fi

# Create ECS cluster if it doesn't exist
if check_ecs_cluster "$ECS_CLUSTER_NAME"; then
    echo "✅ ECS cluster already exists: $ECS_CLUSTER_NAME"
else
    echo "🚢 Creating ECS cluster: $ECS_CLUSTER_NAME"
    aws ecs create-cluster \
        --cluster-name "$ECS_CLUSTER_NAME" \
        --capacity-providers FARGATE \
        --default-capacity-provider-strategy capacityProvider=FARGATE,weight=1 \
        --tags key=Environment,value="$ENVIRONMENT" >/dev/null
    echo "✅ ECS cluster created: $ECS_CLUSTER_NAME"
fi

# Ensure VPC and networking
ensure_vpc "$ENVIRONMENT"

# Create security group if it doesn't exist
SECURITY_GROUP_NAME="${ECR_REPOSITORY_NAME%-*}-sg-${ENVIRONMENT}"
security_group_id=$(aws ec2 describe-security-groups \
    --filters "Name=group-name,Values=$SECURITY_GROUP_NAME" \
    --query 'SecurityGroups[0].GroupId' \
    --output text 2>/dev/null || echo "None")

if [ "$security_group_id" = "None" ] || [ "$security_group_id" = "null" ]; then
    echo "🔒 Creating security group: $SECURITY_GROUP_NAME"
    
    # Get VPC ID
    vpc_id=$(aws ec2 describe-vpcs \
        --filters "Name=tag:Name,Values=${ECR_REPOSITORY_NAME%-*}-vpc-${ENVIRONMENT}" \
        --query 'Vpcs[0].VpcId' \
        --output text)
    
    security_group_id=$(aws ec2 create-security-group \
        --group-name "$SECURITY_GROUP_NAME" \
        --description "Security group for $ECR_REPOSITORY_NAME $ENVIRONMENT" \
        --vpc-id "$vpc_id" \
        --query 'GroupId' \
        --output text)
    
    # Allow HTTP traffic
    aws ec2 authorize-security-group-ingress \
        --group-id "$security_group_id" \
        --protocol tcp \
        --port 80 \
        --cidr 0.0.0.0/0
    
    # Allow HTTPS traffic
    aws ec2 authorize-security-group-ingress \
        --group-id "$security_group_id" \
        --protocol tcp \
        --port 443 \
        --cidr 0.0.0.0/0
    
    # Allow application port
    aws ec2 authorize-security-group-ingress \
        --group-id "$security_group_id" \
        --protocol tcp \
        --port 8000 \
        --cidr 0.0.0.0/0
    
    echo "✅ Security group created: $security_group_id"
else
    echo "✅ Security group already exists: $security_group_id"
fi

# Output values for use in subsequent steps
echo "security-group-id=$security_group_id" >> $GITHUB_OUTPUT


# ------------------------------
# Application Load Balancer (ALB)
# ------------------------------
# Replace underscores with hyphens for AWS-compliant names
LB_NAME="$(echo ${ECR_REPOSITORY_NAME%-*}-alb-${ENVIRONMENT} | tr '_' '-')"
TG_NAME="$(echo ${ECR_REPOSITORY_NAME%-*}-tg-${ENVIRONMENT} | tr '_' '-')"

# Find VPC ID again
vpc_id=$(aws ec2 describe-vpcs \
    --filters "Name=tag:Name,Values=${ECR_REPOSITORY_NAME%-*}-vpc-${ENVIRONMENT}" \
    --query 'Vpcs[0].VpcId' \
    --output text)

# Collect two subnets in the VPC
subnet_ids=$(aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$vpc_id" "Name=tag:Environment,Values=$ENVIRONMENT" \
    --query 'Subnets[].SubnetId' --output text)

SUBNET_ARR=($subnet_ids)
if [ ${#SUBNET_ARR[@]} -lt 2 ]; then
    echo "❌ Need at least two subnets for an internet-facing ALB in VPC $vpc_id"
    exit 1
fi

echo "🧭 Ensuring Target Group exists: $TG_NAME"
TG_ARN=$(aws elbv2 describe-target-groups \
    --names "$TG_NAME" 2>/dev/null \
    --query 'TargetGroups[0].TargetGroupArn' --output text || echo "None")

if [ "$TG_ARN" = "None" ] || [ "$TG_ARN" = "null" ]; then
    TG_ARN=$(aws elbv2 create-target-group \
        --name "$TG_NAME" \
        --protocol HTTP --port $SERVICE_PORT \
        --target-type ip \
        --vpc-id "$vpc_id" \
        --health-check-protocol HTTP \
        --health-check-path "$HEALTH_CHECK_PATH" \
        --health-check-interval-seconds 30 \
        --healthy-threshold-count 2 \
        --unhealthy-threshold-count 5 \
        --query 'TargetGroups[0].TargetGroupArn' --output text)
    echo "✅ Target Group created: $TG_ARN"
else
    echo "✅ Target Group already exists: $TG_ARN"
fi

echo "🧭 Ensuring ALB exists: $LB_NAME"
LB_ARN=$(aws elbv2 describe-load-balancers --names "$LB_NAME" 2>/dev/null \
    --query 'LoadBalancers[0].LoadBalancerArn' --output text || echo "None")

if [ "$LB_ARN" = "None" ] || [ "$LB_ARN" = "null" ]; then
    # Create ALB using existing security group
    LB_ARN=$(aws elbv2 create-load-balancer \
        --name "$LB_NAME" \
        --type application \
        --scheme internet-facing \
        --security-groups "$security_group_id" \
        --subnets "${SUBNET_ARR[0]}" "${SUBNET_ARR[1]}" \
        --query 'LoadBalancers[0].LoadBalancerArn' --output text)
    echo "✅ ALB created: $LB_ARN"
else
    echo "✅ ALB already exists: $LB_ARN"
fi

LB_DNS=$(aws elbv2 describe-load-balancers --load-balancer-arns "$LB_ARN" \
    --query 'LoadBalancers[0].DNSName' --output text)

echo "🧭 Ensuring Listener exists on :80"
LISTENER_ARN=$(aws elbv2 describe-listeners --load-balancer-arn "$LB_ARN" \
    --query 'Listeners[?Port==`80`].ListenerArn' --output text 2>/dev/null || echo "None")

if [ -z "$LISTENER_ARN" ] || [ "$LISTENER_ARN" = "None" ] || [ "$LISTENER_ARN" = "null" ]; then
    LISTENER_ARN=$(aws elbv2 create-listener \
        --load-balancer-arn "$LB_ARN" \
        --protocol HTTP --port 80 \
        --default-actions Type=forward,TargetGroupArn=$TG_ARN \
        --query 'Listeners[0].ListenerArn' --output text)
    echo "✅ Listener created: $LISTENER_ARN"
else
    echo "✅ Listener already exists: $LISTENER_ARN"
fi

# Output for subsequent steps
echo "target-group-arn=$TG_ARN" >> $GITHUB_OUTPUT
echo "load-balancer-arn=$LB_ARN" >> $GITHUB_OUTPUT
echo "load-balancer-dns=$LB_DNS" >> $GITHUB_OUTPUT

echo "🎉 Infrastructure setup complete!"
echo "ECR Repository: $ECR_REPOSITORY_NAME"
echo "ECS Cluster: $ECS_CLUSTER_NAME"
echo "Security Group: $security_group_id"
echo "ALB DNS: $LB_DNS"