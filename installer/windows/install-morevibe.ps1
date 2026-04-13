param(
    [string]$HomePath = $HOME,
    [string]$CodexHomePath = "",
    [string]$ProjectPath = "",
    [switch]$ForceProjectTemplate,
    [switch]$ApplyProjectAgentsBootstrap,
    [switch]$ApplyCodexGlobalBootstrap,
    [string[]]$ExportAdapters = @()
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

function Read-TextFile {
    param([string]$LiteralPath)

    if (-not (Test-Path -LiteralPath $LiteralPath)) {
        return $null
    }

    return Get-Content -LiteralPath $LiteralPath -Raw -Encoding UTF8
}

function Write-TextFile {
    param(
        [string]$LiteralPath,
        [string]$Value
    )

    Set-Content -LiteralPath $LiteralPath -Value $Value -Encoding UTF8
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

function Install-AdapterExports {
    param(
        [string]$ScriptRootPath,
        [string]$ResolvedHome,
        [string[]]$Adapters
    )

    if ($null -eq $Adapters -or $Adapters.Count -eq 0) {
        return @()
    }

    $results = @()
    $exportRoot = Join-Path $ResolvedHome ".morevibe\adapters"
    New-Item -ItemType Directory -Path $exportRoot -Force | Out-Null

    foreach ($adapter in $Adapters) {
        $normalized = $adapter.ToLowerInvariant()
        if ($normalized -notin @("claudecode", "antigravity")) {
            $results += [ordered]@{
                adapter = $adapter
                action = "skipped"
                reason = "Unsupported adapter export target."
            }
            continue
        }

        $sourcePath = Resolve-FullPath -PathValue (Join-Path $ScriptRootPath "..\..\adapters\$normalized")
        if (-not (Test-Path -LiteralPath $sourcePath)) {
            $results += [ordered]@{
                adapter = $normalized
                action = "skipped"
                reason = "Adapter source not found."
            }
            continue
        }

        $targetPath = Join-Path $exportRoot $normalized
        $backup = $null
        if (Test-Path -LiteralPath $targetPath) {
            $backup = Backup-PathIfExists -LiteralPath $targetPath
        }

        Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Recurse -Force
        $results += [ordered]@{
            adapter = $normalized
            action = "installed"
            target = $targetPath
            backup = $backup
        }
    }

    return $results
}

function Apply-AgentsBootstrap {
    param(
        [string]$ProjectRoot,
        [string]$BootstrapSnippetPath
    )

    if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
        return $null
    }

    $agentsPath = Join-Path $ProjectRoot "AGENTS.md"
    if (-not (Test-Path -LiteralPath $agentsPath)) {
        return [ordered]@{
            action = "skipped"
            target = $agentsPath
            reason = "AGENTS.md does not exist."
        }
    }

    $snippet = Read-TextFile -LiteralPath $BootstrapSnippetPath
    $existing = Read-TextFile -LiteralPath $agentsPath

    if ([string]::IsNullOrWhiteSpace($snippet)) {
        throw "Bootstrap snippet is empty: $BootstrapSnippetPath"
    }

    if ($existing -like "*## MoreVibe Bootstrap*") {
        return [ordered]@{
            action = "skipped"
            target = $agentsPath
            reason = "MoreVibe bootstrap block already exists."
        }
    }

    $backupPath = Copy-Item -LiteralPath $agentsPath -Destination "$agentsPath.backup-$(New-Timestamp)" -Force -PassThru | ForEach-Object { $_.FullName }

    $trimmedExisting = $existing.TrimEnd()
    $trimmedSnippet = $snippet.Trim()
    $newContent = "$trimmedExisting`r`n`r`n$trimmedSnippet`r`n"
    Write-TextFile -LiteralPath $agentsPath -Value $newContent

    return [ordered]@{
        action = "updated"
        target = $agentsPath
        backup = $backupPath
    }
}

function Apply-CodexGlobalBootstrap {
    param(
        [string]$ResolvedCodexHomePath,
        [string]$BootstrapSnippetPath
    )

    if ([string]::IsNullOrWhiteSpace($ResolvedCodexHomePath)) {
        return [ordered]@{
            action = "skipped"
            target = ""
            reason = "Codex home path is empty."
        }
    }

    $agentsPath = Join-Path $ResolvedCodexHomePath "AGENTS.md"
    if (-not (Test-Path -LiteralPath $agentsPath)) {
        return [ordered]@{
            action = "skipped"
            target = $agentsPath
            reason = "Codex global AGENTS.md does not exist."
        }
    }

    $snippet = Read-TextFile -LiteralPath $BootstrapSnippetPath
    $existing = Read-TextFile -LiteralPath $agentsPath

    if ([string]::IsNullOrWhiteSpace($snippet)) {
        throw "Global bootstrap snippet is empty: $BootstrapSnippetPath"
    }

    if ($existing -like "*# MoreVibe Global Bootstrap for Codex*") {
        return [ordered]@{
            action = "skipped"
            target = $agentsPath
            reason = "MoreVibe global bootstrap block already exists."
        }
    }

    $backupPath = Copy-Item -LiteralPath $agentsPath -Destination "$agentsPath.backup-$(New-Timestamp)" -Force -PassThru | ForEach-Object { $_.FullName }
    $newContent = "$($existing.TrimEnd())`r`n`r`n$($snippet.Trim())`r`n"
    Write-TextFile -LiteralPath $agentsPath -Value $newContent

    return [ordered]@{
        action = "updated"
        target = $agentsPath
        backup = $backupPath
    }
}

$scriptRoot = Resolve-FullPath -PathValue $PSScriptRoot
$pluginSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\plugin")
$templateSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\templates\project\.morevibe")
$projectAgentsBootstrapSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\adapters\codex\snippets\project-agents-bootstrap.md")
$codexGlobalBootstrapSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\adapters\codex\snippets\global-bootstrap.md")
$resolvedHomePath = Resolve-FullPath -PathValue $HomePath
$resolvedCodexHomePath = if ([string]::IsNullOrWhiteSpace($CodexHomePath)) { Join-Path $resolvedHomePath ".codex" } else { Resolve-FullPath -PathValue $CodexHomePath }

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
    $marketplaceBackupPath = "$marketplacePath.backup-$(New-Timestamp)"
    Copy-Item -LiteralPath $marketplacePath -Destination $marketplaceBackupPath -Force
    $marketplaceBackup = $marketplaceBackupPath
}

$marketplace = Merge-Marketplace -MarketplacePath $marketplacePath
Write-JsonFile -LiteralPath $marketplacePath -Data $marketplace

$adapterExportResults = Install-AdapterExports -ScriptRootPath $scriptRoot -ResolvedHome $resolvedHomePath -Adapters $ExportAdapters
$templateResult = Install-ProjectTemplate -TemplateSource $templateSource -TargetProjectPath $ProjectPath -ForceTemplate $ForceProjectTemplate.IsPresent
$agentsBootstrapResult = $null
$codexGlobalBootstrapResult = $null
if (-not [string]::IsNullOrWhiteSpace($ProjectPath)) {
    $resolvedProjectPath = Resolve-FullPath -PathValue $ProjectPath
    $agentsBootstrapResult = Apply-AgentsBootstrap -ProjectRoot $resolvedProjectPath -BootstrapSnippetPath $projectAgentsBootstrapSource
} elseif ($ApplyProjectAgentsBootstrap.IsPresent) {
    throw "ProjectPath is required when using -ApplyProjectAgentsBootstrap."
}

if ($ApplyCodexGlobalBootstrap.IsPresent -or (Test-Path -LiteralPath (Join-Path $resolvedCodexHomePath "AGENTS.md"))) {
    $codexGlobalBootstrapResult = Apply-CodexGlobalBootstrap -ResolvedCodexHomePath $resolvedCodexHomePath -BootstrapSnippetPath $codexGlobalBootstrapSource
}

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

if ($null -ne $agentsBootstrapResult) {
    Write-Host "AGENTS bootstrap: $($agentsBootstrapResult.action) -> $($agentsBootstrapResult.target)"
    if ($agentsBootstrapResult.backup) {
        Write-Host "AGENTS backup: $($agentsBootstrapResult.backup)"
    }
    if ($agentsBootstrapResult.reason) {
        Write-Host "AGENTS note: $($agentsBootstrapResult.reason)"
    }
}

if ($null -ne $codexGlobalBootstrapResult) {
    Write-Host "Codex global bootstrap: $($codexGlobalBootstrapResult.action) -> $($codexGlobalBootstrapResult.target)"
    if ($codexGlobalBootstrapResult.backup) {
        Write-Host "Codex global backup: $($codexGlobalBootstrapResult.backup)"
    }
    if ($codexGlobalBootstrapResult.reason) {
        Write-Host "Codex global note: $($codexGlobalBootstrapResult.reason)"
    }
}

if ($null -ne $adapterExportResults -and $adapterExportResults.Count -gt 0) {
    foreach ($result in $adapterExportResults) {
        Write-Host "Adapter export [$($result.adapter)]: $($result.action)"
        if ($result.target) {
            Write-Host "Adapter export target: $($result.target)"
        }
        if ($result.backup) {
            Write-Host "Adapter export backup: $($result.backup)"
        }
        if ($result.reason) {
            Write-Host "Adapter export note: $($result.reason)"
        }
    }
}
