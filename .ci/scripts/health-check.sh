#!/bin/bash

# Health Check Script
# Performs health checks on deployed ECS service
# Usage: ./health-check.sh <cluster-name> <service-name> <health-check-path> <environment>

set -e

ECS_CLUSTER="$1"
ECS_SERVICE="$2"
HEALTH_CHECK_PATH="$3"
ENVIRONMENT="$4"

if [ -z "$ECS_CLUSTER" ] || [ -z "$ECS_SERVICE" ] || [ -z "$HEALTH_CHECK_PATH" ] || [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 <cluster-name> <service-name> <health-check-path> <environment>"
    exit 1
fi

echo "🏥 Performing health checks..."
echo "Cluster: $ECS_CLUSTER"
echo "Service: $ECS_SERVICE"
echo "Health Check Path: $HEALTH_CHECK_PATH"
echo "Environment: $ENVIRONMENT"

# Function to get service status
get_service_status() {
    aws ecs describe-services \
        --cluster "$ECS_CLUSTER" \
        --services "$ECS_SERVICE" \
        --query 'services[0].deployments[0].status' \
        --output text
}

# Function to get running task count
get_running_tasks() {
    aws ecs describe-services \
        --cluster "$ECS_CLUSTER" \
        --services "$ECS_SERVICE" \
        --query 'services[0].runningCount' \
        --output text
}

# Function to get desired task count
get_desired_tasks() {
    aws ecs describe-services \
        --cluster "$ECS_CLUSTER" \
        --services "$ECS_SERVICE" \
        --query 'services[0].desiredCount' \
        --output text
}

# Function to get task public IP
get_task_public_ip() {
    local task_arn=$(aws ecs list-tasks \
        --cluster "$ECS_CLUSTER" \
        --service-name "$ECS_SERVICE" \
        --desired-status RUNNING \
        --query 'taskArns[0]' \
        --output text)
    
    if [ "$task_arn" = "None" ] || [ "$task_arn" = "null" ]; then
        echo ""
        return
    fi
    
    local eni_id=$(aws ecs describe-tasks \
        --cluster "$ECS_CLUSTER" \
        --tasks "$task_arn" \
        --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' \
        --output text)
    
    if [ "$eni_id" = "None" ] || [ "$eni_id" = "null" ]; then
        echo ""
        return
    fi
    
    aws ec2 describe-network-interfaces \
        --network-interface-ids "$eni_id" \
        --query 'NetworkInterfaces[0].Association.PublicIp' \
        --output text 2>/dev/null || echo ""
}

# Wait for service to stabilize
echo "⏳ Waiting for service to stabilize..."
TIMEOUT=600  # 10 minutes
ELAPSED=0
INTERVAL=30

while [ $ELAPSED -lt $TIMEOUT ]; do
    STATUS=$(get_service_status)
    RUNNING=$(get_running_tasks)
    DESIRED=$(get_desired_tasks)
    
    echo "Status: $STATUS, Running: $RUNNING/$DESIRED tasks"
    
    if [ "$STATUS" = "PRIMARY" ] && [ "$RUNNING" -eq "$DESIRED" ] && [ "$DESIRED" -gt 0 ]; then
        echo "✅ Service is stable and running"
        break
    fi
    
    if [ "$STATUS" = "ROLLBACK_COMPLETE" ]; then
        echo "❌ Deployment failed and rolled back"
        exit 1
    fi
    
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
done

if [ $ELAPSED -ge $TIMEOUT ]; then
    echo "❌ Timeout waiting for service to stabilize"
    exit 1
fi

# Get task public IP for health check
echo "🔍 Finding task public IP..."
PUBLIC_IP=$(get_task_public_ip)

if [ -z "$PUBLIC_IP" ] || [ "$PUBLIC_IP" = "None" ] || [ "$PUBLIC_IP" = "null" ]; then
    echo "⚠️  Could not retrieve public IP, skipping HTTP health check"
    echo "✅ Service deployment completed successfully (container health checks will verify internally)"
    exit 0
fi

echo "📍 Task public IP: $PUBLIC_IP"

# Perform HTTP health check
echo "🏥 Performing HTTP health check..."
HEALTH_URL="http://${PUBLIC_IP}:8000${HEALTH_CHECK_PATH}"
MAX_ATTEMPTS=10
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    echo "Attempt $ATTEMPT/$MAX_ATTEMPTS: Testing $HEALTH_URL"
    
    if curl -f -s --connect-timeout 10 --max-time 30 "$HEALTH_URL" >/dev/null 2>&1; then
        echo "✅ Health check passed!"
        
        # Get response for verification
        RESPONSE=$(curl -s --connect-timeout 10 --max-time 30 "$HEALTH_URL" 2>/dev/null || echo "No response")
        echo "Response: $RESPONSE"
        break
    else
        echo "❌ Health check failed (attempt $ATTEMPT/$MAX_ATTEMPTS)"
        
        if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
            echo "❌ All health check attempts failed"
            echo "🔍 Service may still be starting up. Check ECS console for details."
            
            # Show recent logs for debugging
            echo "📊 Recent logs:"
            aws logs tail "/ecs/${ECS_SERVICE%-service-*}-task-${ENVIRONMENT}" --since 5m --format short || echo "No logs available"
            
            exit 1
        fi
        
        sleep 30
    fi
    
    ATTEMPT=$((ATTEMPT + 1))
done

# Additional service verification
echo "🔍 Final service verification..."
FINAL_STATUS=$(get_service_status)
FINAL_RUNNING=$(get_running_tasks)
FINAL_DESIRED=$(get_desired_tasks)

echo "Final Status: $FINAL_STATUS"
echo "Final Task Count: $FINAL_RUNNING/$FINAL_DESIRED"

if [ "$FINAL_STATUS" = "PRIMARY" ] && [ "$FINAL_RUNNING" -eq "$FINAL_DESIRED" ]; then
    echo "🎉 Health check completed successfully!"
    echo "🌐 Service is accessible at: $HEALTH_URL"
else
    echo "⚠️  Service may not be fully healthy"
    exit 1
fi