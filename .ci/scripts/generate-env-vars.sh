#!/bin/bash

# Generate Environment Variables for GitHub Actions Workflow
# This script reads the env-variables.yml file and outputs the env: block format
# suitable for inclusion in GitHub Actions workflows

CONFIG_FILE="${1:-.ci/env-variables.yml}"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "[ERROR] Configuration file not found: $CONFIG_FILE" >&2
    exit 1
fi

# Extract variable names from YAML config
if command -v yq >/dev/null 2>&1; then
    # Use yq to extract variable names from YAML
    variables=$(yq eval '.variables[]' "$CONFIG_FILE")
else
    # Fallback: extract variable names using grep
    variables=$(grep -E '^\s*-\s+[A-Z_]+' "$CONFIG_FILE" | sed 's/^[[:space:]]*-[[:space:]]*//' | tr -d ' ')
fi

# Output the env block
echo "        env:"
echo "          # Application Environment Variables from GitHub Environment Secrets"
echo "          # These are automatically loaded from .ci/env-variables.yml configuration"

for var_name in $variables; do
    # Skip empty lines
    if [ -z "$var_name" ]; then
        continue
    fi
    echo "          $var_name: \${{ secrets.$var_name }}"
done
