# PowerShell script to generate a GitHub Actions env: block from .ci/env-variables.yml
# Usage: pwsh .ci/scripts/generate-env-vars.ps1

$envVarsFile = "..\env-variables.yml"

if (!(Test-Path $envVarsFile)) {
    Write-Error ".ci/env-variables.yml not found."
    exit 1
}

# Read variable names from YAML (assumes 'variables:' is the key and each variable is a list item)
$lines = Get-Content $envVarsFile
$inVars = $false
$vars = @()
foreach ($line in $lines) {
    if ($line -match '^variables:') {
        $inVars = $true
        continue
    }
    if ($inVars) {
        if ($line -match '^\s*-\s*(\w+)') {
            $vars += $Matches[1]
        } elseif ($line -match '^[^\s#-]') {
            # New top-level YAML key (not indented, not comment, not dash)
            break
        } else {
            # Ignore comments, blank lines, and indented lines
            continue
        }
    }
}

if ($vars.Count -eq 0) {
    Write-Error "No variables found in $envVarsFile."
    exit 1
}

Write-Output "env:"
foreach ($var in $vars) {
    Write-Output ('  {0}: ${{{{ secrets.{0} }}}}' -f $var)
}
