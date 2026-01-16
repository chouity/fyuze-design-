#!/bin/bash

# GitHub Environment Secrets Setup Script
# This script reads secrets from .env files (dev.env, staging.env, prod.env)
# 
# Prerequisites:
# 1. Install GitHub CLI: https://cli.github.com/
# 2. Authenticate: gh auth login
# 3. Create .env files: dev.env, staging.env, prod.env in the environments directory
#
# Usage: ./setup-github-secrets-from-env.sh <environment> [repository]
# Example: ./setup-github-secrets-from-env.sh dev Nawaah-LB/multi_agent_app

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI is not installed"
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    print_error "Not authenticated with GitHub CLI"
    echo "Please run: gh auth login"
    exit 1
fi

# Parse arguments
ENVIRONMENT="${1:-}"
REPO="${2:-}"

if [ -z "$ENVIRONMENT" ]; then
    print_error "Environment not specified"
    echo "Usage: $0 <environment> [repository]"
    echo "Example: $0 dev Nawaah-LB/multi_agent_app"
    exit 1
fi

if [ -z "$REPO" ]; then
    # Try to get repo from git remote
    if git remote get-url origin &> /dev/null; then
        REPO_URL=$(git remote get-url origin)
        REPO=$(echo "$REPO_URL" | sed -e 's/.*github.com[:/]\(.*\)\.git/\1/' -e 's/.*github.com[:/]\(.*\)/\1/')
        print_info "Detected repository: $REPO"
    else
        print_error "Repository not specified and cannot be detected"
        echo "Usage: $0 <environment> [repository]"
        exit 1
    fi
fi

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    print_error "Invalid environment: $ENVIRONMENT"
    echo "Valid environments: dev, staging, prod"
    exit 1
fi

print_info "Setting up secrets for environment: $ENVIRONMENT"
print_info "Repository: $REPO"
echo ""

# Load configuration from .env file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENVIRONMENTS_DIR="${SCRIPT_DIR}/../environments"
ENV_FILE="${ENVIRONMENTS_DIR}/${ENVIRONMENT}.env"

print_info "Loading secrets from: $ENV_FILE"

if [ ! -f "$ENV_FILE" ]; then
    print_error "Environment file not found: $ENV_FILE"
    echo "Please create the file with your secrets"
    echo "Expected files: dev.env, staging.env, prod.env in ../environments/"
    exit 1
fi

# Parse .env file
declare -A SECRETS

while IFS= read -r line; do
    # Skip empty lines and comments
    if [ -z "$line" ] || [[ "$line" =~ ^# ]]; then
        continue
    fi
    
    # Parse KEY=VALUE format
    if [[ "$line" =~ ^([A-Z_][A-Z0-9_]*)=(.*)$ ]]; then
        key="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"
        
        # Remove quotes if present
        value="${value%\"}"
        value="${value#\"}"
        value="${value%\'}"
        value="${value#\'}"
        
        SECRETS["$key"]="$value"
    fi
done < "$ENV_FILE"

if [ ${#SECRETS[@]} -eq 0 ]; then
    print_error "No secrets found in $ENV_FILE"
    exit 1
fi

print_success "Loaded ${#SECRETS[@]} variables from $ENVIRONMENT.env"

# Function to set a secret
set_secret() {
    local secret_name="$1"
    local secret_value="$2"
    
    if [ -z "$secret_value" ]; then
        print_warning "Skipping $secret_name (empty value)"
        return
    fi
    
    output=$(gh secret set "$secret_name" --env "$ENVIRONMENT" --body "$secret_value" --repo "$REPO" 2>&1)
    exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        print_success "Set $secret_name"
    else
        print_error "Failed to set $secret_name"
        echo "Details: $output"
    fi
}

# Main setup
sep="================================================"
echo "$sep"
echo "GitHub Environment Secrets Setup"
echo "$sep"
echo "Environment: $ENVIRONMENT"
echo "Repository: $REPO"
echo "Secrets to upload: ${#SECRETS[@]}"
echo "$sep"
echo ""

print_warning "You are about to set ${#SECRETS[@]} secrets in GitHub"
print_warning "Press Ctrl+C at any time to cancel."
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Cancelled by user"
    exit 0
fi

# Process each secret
for secret_name in $(printf '%s\n' "${!SECRETS[@]}" | sort); do
    secret_value="${SECRETS[$secret_name]}"
    set_secret "$secret_name" "$secret_value"
done

echo ""
echo "$sep"
print_success "Secret setup completed for $ENVIRONMENT environment!"
echo "$sep"
echo ""
print_info "Next steps:"
echo "1. Verify secrets in GitHub UI: Settings - Environments - $ENVIRONMENT"
echo "2. Test deployment: Actions - Reusable AWS ECS Deployment - Run workflow"
echo "3. Check ECS task logs to verify environment variables are loaded"
echo ""
print_info "To set up another environment, run:"
echo "  $0 <staging|prod> $REPO"
