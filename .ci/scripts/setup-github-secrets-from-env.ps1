# GitHub Environment Secrets Setup Script (PowerShell)
# This script reads secrets from .env files (dev.env, staging.env, prod.env) in env it must be X=<api_key> no spaces
# .\setup-github-secrets-from-env.ps1 -Environment dev -Repository "Nawaah-LB/multi_agent_app"
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('dev', 'staging', 'prod')]
    [string]$Environment,
    
    [Parameter(Mandatory=$false)]
    [string]$Repository
)

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-ErrorMsg {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Check if GitHub CLI is installed
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-ErrorMsg "GitHub CLI is not installed"
    Write-Host "Please install it from: https://cli.github.com/"
    exit 1
}

# Check if user is authenticated
if (-not (gh auth status 2>&1)) {
    Write-ErrorMsg "Not authenticated with GitHub CLI"
    Write-Host "Please run: gh auth login"
    exit 1
}

# If repository not specified, try to detect from git remote
if (-not $Repository) {
    try {
        $remoteUrl = git remote get-url origin 2>&1
        if ($remoteUrl -match "github\.com[:/](.+?)(\.git)?$") {
            $Repository = $matches[1] -replace "\.git$", ""
            Write-Info "Detected repository: $Repository"
        }
    } catch {
        Write-ErrorMsg "Repository not specified and cannot be detected"
        exit 1
    }
}

Write-Info "Setting up secrets for environment: $Environment"
Write-Info "Repository: $Repository"
Write-Host ""

$environmentsDir = Join-Path $PSScriptRoot "..\environments"
$envFile = Join-Path $environmentsDir "$Environment.env"

Write-Info "Loading secrets from: $envFile"

if (-not (Test-Path $envFile)) {
    Write-ErrorMsg "Environment file not found: $envFile"
    Write-Host "Please create the file with your secrets"
    exit 1
}

$secrets = @{}

try {
    $content = Get-Content $envFile -Raw
    
    foreach ($line in $content -split "`n") {
        $line = $line.Trim()
        
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith("#")) {
            continue
        }
        
        if ($line -match '^([A-Z_][A-Z0-9_]*)=(.*)$') {
            $key = $matches[1]
            $value = $matches[2]
            $value = $value.Trim('"').Trim("'")
            $secrets[$key] = $value
        }
    }
    
    $count = $secrets.Keys.Count
    Write-Success "Loaded $count variables from $Environment.env"
} catch {
    Write-ErrorMsg "Failed to parse $envFile"
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}

if ($secrets.Count -eq 0) {
    Write-ErrorMsg "No secrets found in $envFile"
    exit 1
}

function Set-GitHubSecret {
    param(
        [string]$SecretName,
        [string]$SecretValue
    )
    
    if ([string]::IsNullOrWhiteSpace($SecretValue)) {
        Write-Warning "Skipping $SecretName (empty value)"
        return
    }
    
    $output = gh secret set $SecretName --env $Environment --body $SecretValue --repo $Repository 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Set $SecretName"
    } else {
        Write-ErrorMsg "Failed to set $SecretName"
        Write-Host "Details: $output"
    }
}

$sep = "================================================"
Write-Host $sep
Write-Host "GitHub Environment Secrets Setup"
Write-Host $sep
Write-Host "Environment: $Environment"
Write-Host "Repository: $Repository"
Write-Host "Secrets to upload: $($secrets.Keys.Count)"
Write-Host $sep
Write-Host ""

Write-Warning "You are about to set $($secrets.Count) secrets in GitHub"
# Print the secrets to be set
Write-Host "Secrets to be set:"
foreach ($key in $secrets.Keys | Sort-Object) {
    Write-Host "  $key = $($secrets[$key])"
}
Write-Warning "Press Ctrl+C at any time to cancel."
Write-Host ""

$confirmation = Read-Host "Continue? (y/n)"
if ($confirmation -ne "y" -and $confirmation -ne "Y") {
    Write-Info "Cancelled by user"
    exit 0
}

foreach ($secretName in $secrets.Keys | Sort-Object) {
    $secretValue = $secrets[$secretName]
    Set-GitHubSecret -SecretName $secretName -SecretValue $secretValue
}

Write-Host ""
Write-Host $sep
Write-Success "Secret setup completed for $Environment environment!"
Write-Host $sep
Write-Host ""
Write-Info "Next steps:"
Write-Host "1. Verify secrets in GitHub UI: Settings - Environments - $Environment"
Write-Host "2. Test deployment: Actions - Reusable AWS ECS Deployment - Run workflow"
Write-Host "3. Check ECS task logs to verify environment variables are loaded"
Write-Host ""
Write-Info "To set up another environment, run:"
Write-Host "  .\setup-github-secrets-from-env.ps1 -Environment <env>"