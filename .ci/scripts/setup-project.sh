#!/bin/bash

# Project Setup Script
# Initializes CI/CD pipeline for a new project
# Usage: ./setup-project.sh <project-name> [port]

set -e

PROJECT_NAME="$1"
SERVICE_PORT="${2:-8000}"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: $0 <project-name> [port]"
    echo "Example: $0 my-awesome-app 3000"
    exit 1
fi

echo "🚀 Setting up CI/CD pipeline for: $PROJECT_NAME"
echo "Service Port: $SERVICE_PORT"

# Create CI directory structure
mkdir -p .ci/{scripts,environments}

# Copy configuration template
cat > .ci/project-config.yml << EOF
# Project Configuration
# This file defines project-specific settings for CI/CD deployment

project:
  # Project name (used for resource naming)
  name: "$PROJECT_NAME"
  
  # Port your application runs on
  port: $SERVICE_PORT
  
  # Health check endpoint path
  health_check_path: "/health"
  
  # Docker build context (default: current directory)
  build_context: "."
  
  # Dockerfile path (relative to build context)
  dockerfile: "Dockerfile"

# Environment-specific configurations
environments:
  # Development environment
  dev:
    cpu: 256        # CPU units (256 = 0.25 vCPU)
    memory: 512     # Memory in MB
    min_capacity: 1 # Minimum number of tasks
    max_capacity: 2 # Maximum number of tasks
    
  # Staging environment  
  staging:
    cpu: 512        # CPU units (512 = 0.5 vCPU)
    memory: 1024    # Memory in MB
    min_capacity: 1 # Minimum number of tasks
    max_capacity: 3 # Maximum number of tasks
    
  # Production environment
  prod:
    cpu: 1024       # CPU units (1024 = 1 vCPU)
    memory: 2048    # Memory in MB
    min_capacity: 2 # Minimum number of tasks
    max_capacity: 10 # Maximum number of tasks

# AWS Configuration (optional - can use GitHub secrets instead)
aws:
  # AWS region (can be overridden by GitHub variable AWS_REGION)
  region: "us-east-1"
  
  # ECR repository settings
  ecr:
    # Enable image scanning
    scan_on_push: true
    
    # Lifecycle policy - keep last N images
    keep_last_images: 10

# Build Configuration
build:
  # Build arguments to pass to Docker
  build_args: []
  
  # Build targets (for multi-stage builds)
  target: ""
  
  # Additional Docker build options
  options: []

# Deployment Configuration
deployment:
  # Health check configuration
  health_check:
    # Number of retry attempts
    max_attempts: 10
    
    # Interval between attempts (seconds)
    interval: 30
    
    # Timeout for each attempt (seconds)
    timeout: 10
  
  # Deployment timeout (seconds)
  timeout: 600
  
  # Auto-rollback on failure
  auto_rollback: true
EOF

# Create environment files
for env in dev staging prod; do
    cat > ".ci/environments/${env}.env" << EOF
# ${env^} Environment Variables
# These will be injected into the ECS task definition

# Application Environment
ENVIRONMENT=$env
DEBUG=$([ "$env" = "dev" ] && echo "true" || echo "false")
LOG_LEVEL=$([ "$env" = "dev" ] && echo "debug" || [ "$env" = "staging" ] && echo "info" || echo "warning")

# Example configurations (uncomment and modify as needed)
# API_BASE_URL=https://api$([ "$env" != "prod" ] && echo "-$env").example.com
# DATABASE_URL=postgresql://user:pass@${env}-db.example.com:5432/myapp
# REDIS_URL=redis://${env}-redis.example.com:6379
# AWS_S3_BUCKET=myapp-${env}-bucket
EOF
done

# Check if health endpoint exists in the application
echo "🏥 Checking for health endpoint..."
if [ -f "main.py" ] && grep -q "/health" main.py; then
    echo "✅ Health endpoint found in main.py"
elif [ -f "app.py" ] && grep -q "/health" app.py; then
    echo "✅ Health endpoint found in app.py"
else
    echo "⚠️  Health endpoint not found. You may need to add one:"
    echo "   @app.get('/health')"
    echo "   def health_check():"
    echo "       return {'status': 'healthy'}"
fi

# Check if Dockerfile exists
if [ -f "Dockerfile" ]; then
    echo "✅ Dockerfile found"
else
    echo "⚠️  Dockerfile not found. Make sure you have a Dockerfile in your project root."
fi

# Create GitHub Actions workflow directory
mkdir -p .github/workflows

echo ""
echo "🎉 CI/CD pipeline setup complete!"
echo ""
echo "📁 Created files:"
echo "   .ci/project-config.yml"
echo "   .ci/environments/dev.env"
echo "   .ci/environments/staging.env"
echo "   .ci/environments/prod.env"
echo ""
echo "📋 Next steps:"
echo "1. Copy the workflow file to .github/workflows/deploy.yml"
echo "2. Copy the scripts to .ci/scripts/"
echo "3. Set up GitHub repository secrets:"
echo "   - AWS_ACCESS_KEY_ID"
echo "   - AWS_SECRET_ACCESS_KEY"
echo "4. Optionally set GitHub variables:"
echo "   - AWS_REGION (default: us-east-1)"
echo "5. Customize .ci/project-config.yml for your project"
echo "6. Add environment variables to .ci/environments/*.env files"
echo "7. Push to GitHub and the pipeline will automatically deploy!"
echo ""
echo "🔗 Branches:"
echo "   - Push to 'main' → deploys to production"
echo "   - Push to 'staging' → deploys to staging"
echo "   - Push to other branches → deploys to dev"