param(
    [string]$HomePath = $HOME,
    [string]$ProjectPath = "",
    [switch]$ForceProjectTemplate
)

$ErrorActionPreference = "Stop"

function Resolve-FullPath {
    param([string]$PathValue)

    return [System.IO.Path]::GetFullPath($PathValue)
}

function New-Timestamp {
    return Get-Date -Format "yyyyMMdd-HHmmss"
}

function Backup-PathIfExists {
    param([string]$LiteralPath)

    if (-not (Test-Path -LiteralPath $LiteralPath)) {
        return $null
    }

    $timestamp = New-Timestamp
    $backupPath = "$LiteralPath.backup-$timestamp"
    Move-Item -LiteralPath $LiteralPath -Destination $backupPath -Force
    return $backupPath
}

function Read-JsonFile {
    param([string]$LiteralPath)

    if (-not (Test-Path -LiteralPath $LiteralPath)) {
        return $null
    }

    $raw = Get-Content -LiteralPath $LiteralPath -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return $null
    }

    return $raw | ConvertFrom-Json
}

function Write-JsonFile {
    param(
        [string]$LiteralPath,
        [object]$Data
    )

    $json = $Data | ConvertTo-Json -Depth 16
    Set-Content -LiteralPath $LiteralPath -Value $json -Encoding UTF8
}

function New-MarketplaceObject {
    $pluginEntry = [ordered]@{
        name = "morevibe"
        source = [ordered]@{
            source = "local"
            path = "./plugins/morevibe"
        }
        policy = [ordered]@{
            installation = "AVAILABLE"
            authentication = "ON_INSTALL"
        }
        category = "Productivity"
    }

    return [ordered]@{
        name = "morevibe-local"
        interface = [ordered]@{
            displayName = "MoreVibe Local"
        }
        plugins = @($pluginEntry)
    }
}

function Merge-Marketplace {
    param([string]$MarketplacePath)

    $existing = Read-JsonFile -LiteralPath $MarketplacePath
    if ($null -eq $existing) {
        return (New-MarketplaceObject)
    }

    $name = $existing.name
    if ([string]::IsNullOrWhiteSpace($name)) {
        $name = "morevibe-local"
    }

    $displayName = $null
    if ($null -ne $existing.interface -and -not [string]::IsNullOrWhiteSpace($existing.interface.displayName)) {
        $displayName = $existing.interface.displayName
    } else {
        $displayName = "MoreVibe Local"
    }

    $plugins = @()
    if ($null -ne $existing.plugins) {
        foreach ($plugin in $existing.plugins) {
            if ($plugin.name -ne "morevibe") {
                $plugins += [ordered]@{
                    name = $plugin.name
                    source = $plugin.source
                    policy = $plugin.policy
                    category = $plugin.category
                    products = $plugin.products
                }
            }
        }
    }

    $plugins += [ordered]@{
        name = "morevibe"
        source = [ordered]@{
            source = "local"
            path = "./plugins/morevibe"
        }
        policy = [ordered]@{
            installation = "AVAILABLE"
            authentication = "ON_INSTALL"
        }
        category = "Productivity"
    }

    return [ordered]@{
        name = $name
        interface = [ordered]@{
            displayName = $displayName
        }
        plugins = $plugins
    }
}

function Install-ProjectTemplate {
    param(
        [string]$TemplateSource,
        [string]$TargetProjectPath,
        [bool]$ForceTemplate
    )

    if ([string]::IsNullOrWhiteSpace($TargetProjectPath)) {
        return $null
    }

    $resolvedProjectPath = Resolve-FullPath -PathValue $TargetProjectPath
    if (-not (Test-Path -LiteralPath $resolvedProjectPath)) {
        throw "Project path does not exist: $resolvedProjectPath"
    }

    $templateTarget = Join-Path $resolvedProjectPath ".morevibe"
    if (Test-Path -LiteralPath $templateTarget) {
        if (-not $ForceTemplate) {
            return [ordered]@{
                target = $templateTarget
                action = "skipped"
                reason = ".morevibe already exists. Use -ForceProjectTemplate to overwrite it."
            }
        }

        $backupPath = Backup-PathIfExists -LiteralPath $templateTarget
        Copy-Item -LiteralPath $TemplateSource -Destination $templateTarget -Recurse -Force

        return [ordered]@{
            target = $templateTarget
            action = "replaced"
            backup = $backupPath
        }
    }

    Copy-Item -LiteralPath $TemplateSource -Destination $templateTarget -Recurse -Force
    return [ordered]@{
        target = $templateTarget
        action = "created"
    }
}

$scriptRoot = Resolve-FullPath -PathValue $PSScriptRoot
$pluginSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\plugin")
$templateSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\templates\project\.morevibe")
$resolvedHomePath = Resolve-FullPath -PathValue $HomePath

$pluginsDir = Join-Path $resolvedHomePath "plugins"
$pluginTarget = Join-Path $pluginsDir "morevibe"
$agentsDir = Join-Path $resolvedHomePath ".agents\plugins"
$marketplacePath = Join-Path $agentsDir "marketplace.json"

Write-Host "Installing MoreVibe..." -ForegroundColor Cyan
Write-Host "Plugin source: $pluginSource"
Write-Host "Plugin target: $pluginTarget"

New-Item -ItemType Directory -Path $pluginsDir -Force | Out-Null
New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null

$pluginBackup = Backup-PathIfExists -LiteralPath $pluginTarget
Copy-Item -LiteralPath $pluginSource -Destination $pluginTarget -Recurse -Force

$marketplaceBackup = $null
if (Test-Path -LiteralPath $marketplacePath) {
    Copy-Item -LiteralPath $marketplacePath -Destination "$marketplacePath.backup-$(New-Timestamp)" -Force
    $marketplaceBackup = Get-ChildItem -LiteralPath "$marketplacePath.backup-*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | ForEach-Object { $_.FullName }
}

$marketplace = Merge-Marketplace -MarketplacePath $marketplacePath
Write-JsonFile -LiteralPath $marketplacePath -Data $marketplace

$templateResult = Install-ProjectTemplate -TemplateSource $templateSource -TargetProjectPath $ProjectPath -ForceTemplate $ForceProjectTemplate.IsPresent

Write-Host ""
Write-Host "MoreVibe installation complete." -ForegroundColor Green
Write-Host "Plugin path: $pluginTarget"
Write-Host "Marketplace: $marketplacePath"

if ($null -ne $pluginBackup) {
    Write-Host "Previous plugin backup: $pluginBackup"
}

if ($null -ne $marketplaceBackup) {
    Write-Host "Marketplace backup: $marketplaceBackup"
}

if ($null -ne $templateResult) {
    Write-Host "Project template: $($templateResult.action) -> $($templateResult.target)"
    if ($templateResult.backup) {
        Write-Host "Project template backup: $($templateResult.backup)"
    }
    if ($templateResult.reason) {
        Write-Host "Project template note: $($templateResult.reason)"
    }
}
