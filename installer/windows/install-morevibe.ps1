param(
    [string]$HomePath = $HOME
)

$ErrorActionPreference = "Stop"

$pluginSource = Join-Path $PSScriptRoot "..\..\plugin"
$pluginSource = [System.IO.Path]::GetFullPath($pluginSource)

$pluginsDir = Join-Path $HomePath "plugins"
$pluginTarget = Join-Path $pluginsDir "morevibe"
$agentsDir = Join-Path $HomePath ".agents\plugins"
$marketplacePath = Join-Path $agentsDir "marketplace.json"

Write-Host "Installing MoreVibe..." -ForegroundColor Cyan
Write-Host "Source: $pluginSource"
Write-Host "Target: $pluginTarget"

New-Item -ItemType Directory -Path $pluginsDir -Force | Out-Null
New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null

if (Test-Path $pluginTarget) {
    Remove-Item -LiteralPath $pluginTarget -Recurse -Force
}

Copy-Item -LiteralPath $pluginSource -Destination $pluginTarget -Recurse -Force

$marketplace = @{
    name = "morevibe-local"
    interface = @{
        displayName = "MoreVibe Local"
    }
    plugins = @(
        @{
            name = "morevibe"
            source = @{
                source = "local"
                path = "./plugins/morevibe"
            }
            policy = @{
                installation = "AVAILABLE"
                authentication = "ON_INSTALL"
            }
            category = "Productivity"
        }
    )
}

$marketplace | ConvertTo-Json -Depth 8 | Set-Content -Path $marketplacePath -Encoding UTF8

Write-Host ""
Write-Host "MoreVibe installation complete." -ForegroundColor Green
Write-Host "Plugin path: $pluginTarget"
Write-Host "Marketplace: $marketplacePath"
