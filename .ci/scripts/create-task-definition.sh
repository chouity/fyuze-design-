#!/bin/bash

# Task Definition Creation Script
# Creates ECS task definition with configurable parameters
# Usage: ./create-task-definition.sh <task-family> <image-uri> <cpu> <memory> <port> <environment>

set -euo pipefail

# 1) Parse arguments
TASK_FAMILY="${1:-}"
IMAGE_URI="${2:-}"
CPU="${3:-}"
MEMORY="${4:-}"
SERVICE_PORT="${5:-}"
ENVIRONMENT="${6:-}"

if [ -z "$TASK_FAMILY" ] || [ -z "$IMAGE_URI" ] || [ -z "$CPU" ] || [ -z "$MEMORY" ] || [ -z "$SERVICE_PORT" ] || [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 <task-family> <image-uri> <cpu> <memory> <port> <environment>"
    exit 1
fi

# Ensure AWS_DEFAULT_REGION is set
if [ -z "${AWS_DEFAULT_REGION:-}" ]; then
    echo "⚠️  AWS_DEFAULT_REGION not set, trying to get from AWS CLI"
    AWS_DEFAULT_REGION=$(aws configure get region 2>/dev/null || echo "us-east-1")
    export AWS_DEFAULT_REGION
    echo "🌍 Using region: $AWS_DEFAULT_REGION"
fi

echo "[INFO] Creating ECS task definition..."
echo "Task Family: $TASK_FAMILY"
echo "Image URI: $IMAGE_URI"
echo "CPU: $CPU"
echo "Memory: $MEMORY"
echo "Port: $SERVICE_PORT"
echo "Environment: $ENVIRONMENT"

# Create execution role if it doesn't exist
EXECUTION_ROLE_NAME="ecsTaskExecutionRole-${TASK_FAMILY}"
echo "[INFO] Ensuring ECS execution role exists..."

# Check if role exists
if aws iam get-role --role-name "$EXECUTION_ROLE_NAME" >/dev/null 2>&1; then
    echo "[SUCCESS] Execution role already exists: $EXECUTION_ROLE_NAME"
else
    echo "[INFO] Creating ECS execution role: $EXECUTION_ROLE_NAME"
    
    # Create role
    aws iam create-role \
        --role-name "$EXECUTION_ROLE_NAME" \
        --assume-role-policy-document '{
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "ecs-tasks.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }' >/dev/null
    
    # Attach policies
    aws iam attach-role-policy \
        --role-name "$EXECUTION_ROLE_NAME" \
        --policy-arn "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    
    aws iam attach-role-policy \
        --role-name "$EXECUTION_ROLE_NAME" \
        --policy-arn "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    
    echo "[SUCCESS] Execution role created: $EXECUTION_ROLE_NAME"
fi

# Get account ID and region for ARN construction
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
EXECUTION_ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/${EXECUTION_ROLE_NAME}"

# Create CloudWatch log group if it doesn't exist
LOG_GROUP_NAME="/ecs/${TASK_FAMILY}"
echo "[INFO] Ensuring CloudWatch log group exists..."

if aws logs describe-log-groups --log-group-name-prefix "$LOG_GROUP_NAME" --query 'logGroups[?logGroupName==`'$LOG_GROUP_NAME'`]' --output text | grep -q "$LOG_GROUP_NAME"; then
    echo "[SUCCESS] Log group already exists: $LOG_GROUP_NAME"
else
    echo "[INFO] Creating CloudWatch log group: $LOG_GROUP_NAME"
    aws logs create-log-group --log-group-name "$LOG_GROUP_NAME"
    echo "[SUCCESS] Log group created: $LOG_GROUP_NAME"
fi

# Load environment variable names from centralized config
CONFIG_FILE="${BASH_SOURCE%/*}/../env-variables.yml"

echo "[INFO] Loading environment variables configuration from: $CONFIG_FILE"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "[ERROR] Configuration file not found: $CONFIG_FILE"
    echo "Please create .ci/env-variables.yml with your application variables"
    exit 1
fi

# Extract variable names from YAML config
echo "[INFO] Parsing environment variables from configuration file..."

if command -v yq >/dev/null 2>&1; then
    # Use yq to extract variable names from YAML
    mapfile -t APP_ENV_VARS < <(yq eval '.variables[]' "$CONFIG_FILE")
    echo "[SUCCESS] Loaded ${#APP_ENV_VARS[@]} variables from configuration file"
else
    # Fallback: extract variable names using grep (remove leading/trailing whitespace and dashes)
    echo "[WARNING] yq not found, using fallback parser"
    mapfile -t APP_ENV_VARS < <(grep -E '^\s*-\s+[A-Z_]+' "$CONFIG_FILE" | sed 's/^[[:space:]]*-[[:space:]]*//' | tr -d ' ')
    echo "[SUCCESS] Loaded ${#APP_ENV_VARS[@]} variables from configuration file (fallback mode)"
fi

# Check if we're running in GitHub Actions
if [ -z "${GITHUB_ACTIONS:-}" ]; then
    echo "[ERROR] This script must be run in GitHub Actions"
    echo "       GitHub Actions provides environment secrets automatically"
    echo "       Please run this from a GitHub Actions workflow"
    exit 1
fi

echo "[INFO] Loading environment variables from GitHub Environment Secrets"

# Build environment variables JSON from explicitly set application secrets
ENV_VARS_JSON="["
first=true

for var_name in "${APP_ENV_VARS[@]}"; do
    # Get the value from environment (set by GitHub Actions from secrets)
    var_value="${!var_name:-}"
    
    # Skip if value is empty
    if [[ -z "$var_value" ]]; then
        echo "[DEBUG] $var_name is not set or empty, skipping..."
        continue
    fi
    
    # Escape quotes in value
    var_value=$(echo "$var_value" | sed 's/"/\\"/g')
    
    if [ "$first" = true ]; then
        first=false
    else
        ENV_VARS_JSON="${ENV_VARS_JSON},"
    fi
    
    ENV_VARS_JSON="${ENV_VARS_JSON}{\"name\":\"${var_name}\",\"value\":\"${var_value}\"}"
    echo "  [+] Added: $var_name"
done
ENV_VARS_JSON="${ENV_VARS_JSON}]"

echo "[SUCCESS] Loaded environment variables from GitHub Environment Secrets"

# Debug: Print inputs
echo "[INFO] Inputs"
echo "- TASK_FAMILY: $TASK_FAMILY"
echo "- IMAGE_URI: $IMAGE_URI"
echo "- CPU: $CPU"
echo "- MEMORY: $MEMORY"
echo "- SERVICE_PORT: $SERVICE_PORT"
echo "- ENVIRONMENT: $ENVIRONMENT"

# Create task definition JSON using explicit concatenation to avoid heredoc issues
TASK_DEFINITION="{
    \"family\": \"${TASK_FAMILY}\",
    \"networkMode\": \"awsvpc\",
    \"requiresCompatibilities\": [\"FARGATE\"],
    \"cpu\": \"${CPU}\",
    \"memory\": \"${MEMORY}\",
    \"executionRoleArn\": \"${EXECUTION_ROLE_ARN}\",
    \"taskRoleArn\": \"${EXECUTION_ROLE_ARN}\",
    \"containerDefinitions\": [
        {
            \"name\": \"${TASK_FAMILY}-container\",
            \"image\": \"${IMAGE_URI}\",
            \"essential\": true,
            \"portMappings\": [
                {
                    \"containerPort\": ${SERVICE_PORT},
                    \"protocol\": \"tcp\"
                }
            ],
            \"environment\": ${ENV_VARS_JSON},
            \"logConfiguration\": {
                \"logDriver\": \"awslogs\",
                \"options\": {
                    \"awslogs-group\": \"${LOG_GROUP_NAME}\",
                    \"awslogs-region\": \"${AWS_DEFAULT_REGION}\",
                    \"awslogs-stream-prefix\": \"ecs\"
                }
            },
            \"healthCheck\": {
                \"command\": [
                    \"CMD-SHELL\",
                    \"exit 0\"
                ],
                \"interval\": 30,
                \"timeout\": 5,
                \"retries\": 3,
                \"startPeriod\": 60
            }
        }
    ]
}"

############################################
# Validate JSON and Register task definition
############################################
echo "[INFO] Registering task definition..."
echo "Generated task definition JSON (first 40 lines):"
echo "$TASK_DEFINITION" | sed -n '1,40p'

# Validate JSON before sending (try multiple validators, then basic check)
JSON_VALID=false
if command -v python3 >/dev/null 2>&1; then
    if echo "$TASK_DEFINITION" | python3 -m json.tool >/dev/null 2>&1; then JSON_VALID=true; fi
elif command -v python >/dev/null 2>&1; then
    if echo "$TASK_DEFINITION" | python -m json.tool >/dev/null 2>&1; then JSON_VALID=true; fi
elif command -v jq >/dev/null 2>&1; then
    if echo "$TASK_DEFINITION" | jq . >/dev/null 2>&1; then JSON_VALID=true; fi
fi

if [ "$JSON_VALID" != true ]; then
    if [[ "$TASK_DEFINITION" == *"\"family\""* && "$TASK_DEFINITION" == *"\"containerDefinitions\""* ]]; then
        echo "[WARNING] Proceeding with basic structure validation only."
        JSON_VALID=true
    fi
fi

if [ "$JSON_VALID" != true ]; then
    echo "[ERROR] Task definition JSON is invalid"
    echo "Full JSON:"; echo "$TASK_DEFINITION"
    echo "Variables dump:";
    echo "TASK_FAMILY='$TASK_FAMILY'"; echo "IMAGE_URI='$IMAGE_URI'"; echo "CPU='$CPU'"; echo "MEMORY='$MEMORY'";
    echo "SERVICE_PORT='$SERVICE_PORT'"; echo "EXECUTION_ROLE_ARN='$EXECUTION_ROLE_ARN'"; echo "LOG_GROUP_NAME='$LOG_GROUP_NAME'";
    echo "AWS_DEFAULT_REGION='${AWS_DEFAULT_REGION:-}'"; echo "ENV_VARS_JSON='$ENV_VARS_JSON'";
    exit 1
fi

# Write JSON to a temp file to avoid stdin parsing issues
TMP_JSON_FILE=$(mktemp)
printf "%s" "$TASK_DEFINITION" > "$TMP_JSON_FILE"
echo "[INFO] JSON size: $(wc -c < "$TMP_JSON_FILE") bytes"

# Try registering with file:// scheme
set +e
TASK_DEFINITION_ARN=$(aws ecs register-task-definition \
    --cli-input-json file://"$TMP_JSON_FILE" \
    --query 'taskDefinition.taskDefinitionArn' \
    --output text 2>register_err.log)
AWS_CLI_STATUS=$?
set -e

if [ $AWS_CLI_STATUS -ne 0 ] || [ -z "$TASK_DEFINITION_ARN" ] || [ "$TASK_DEFINITION_ARN" = "None" ]; then
    echo "[ERROR] AWS CLI failed to register task definition"
    echo "--- AWS CLI Error ---"
    sed -n '1,120p' register_err.log || true
    echo "---------------------"
    echo "Re-validating JSON with python (if available):"
    if command -v python3 >/dev/null 2>&1; then
        python3 -m json.tool < "$TMP_JSON_FILE" >/dev/null && echo "JSON valid" || python3 -m json.tool < "$TMP_JSON_FILE" 2>&1 | head -50
    fi
    echo "Full JSON written to: $TMP_JSON_FILE"
    exit 1
fi

rm -f "$TMP_JSON_FILE" register_err.log || true

echo "[SUCCESS] Task definition registered: $TASK_DEFINITION_ARN"

# Output for use in subsequent steps
echo "task-definition-arn=$TASK_DEFINITION_ARN" >> $GITHUB_OUTPUT
echo "execution-role-arn=$EXECUTION_ROLE_ARN" >> $GITHUB_OUTPUT
echo "log-group-name=$LOG_GROUP_NAME" >> $GITHUB_OUTPUT

echo "[SUCCESS] Task definition creation complete!"
echo "Task Definition ARN: $TASK_DEFINITION_ARN"
echo "Execution Role ARN: $EXECUTION_ROLE_ARN"
echo "Log Group: $LOG_GROUP_NAME"