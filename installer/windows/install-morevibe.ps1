param(
    [string]$HomePath = $HOME,
    [string]$CodexHomePath = "",
    [string]$ClaudeHomePath = "",
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

function Ensure-ParentDirectory {
    param([string]$LiteralPath)
    $parent = Split-Path -Parent $LiteralPath
    if (-not [string]::IsNullOrWhiteSpace($parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
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
            $results += [ordered]@{ adapter = $adapter; action = "skipped"; reason = "Unsupported adapter export target." }
            continue
        }

        $sourcePath = Resolve-FullPath -PathValue (Join-Path $ScriptRootPath "..\..\adapters\$normalized")
        if (-not (Test-Path -LiteralPath $sourcePath)) {
            $results += [ordered]@{ adapter = $normalized; action = "skipped"; reason = "Adapter source not found." }
            continue
        }

        $targetPath = Join-Path $exportRoot $normalized
        $backup = $null
        if (Test-Path -LiteralPath $targetPath) {
            $backup = Backup-PathIfExists -LiteralPath $targetPath
        }

        Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Recurse -Force
        $results += [ordered]@{ adapter = $normalized; action = "installed"; target = $targetPath; backup = $backup }
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
        return [ordered]@{ action = "skipped"; target = $agentsPath; reason = "AGENTS.md does not exist." }
    }

    $snippet = Read-TextFile -LiteralPath $BootstrapSnippetPath
    $existing = Read-TextFile -LiteralPath $agentsPath
    if ([string]::IsNullOrWhiteSpace($snippet)) {
        throw "Bootstrap snippet is empty: $BootstrapSnippetPath"
    }
    if ($existing -like "*## MoreVibe Bootstrap*") {
        return [ordered]@{ action = "skipped"; target = $agentsPath; reason = "MoreVibe bootstrap block already exists." }
    }

    $backupPath = Copy-Item -LiteralPath $agentsPath -Destination "$agentsPath.backup-$(New-Timestamp)" -Force -PassThru | ForEach-Object { $_.FullName }
    $newContent = "$($existing.TrimEnd())`r`n`r`n$($snippet.Trim())`r`n"
    Write-TextFile -LiteralPath $agentsPath -Value $newContent
    return [ordered]@{ action = "updated"; target = $agentsPath; backup = $backupPath }
}

function Apply-CodexGlobalBootstrap {
    param(
        [string]$ResolvedCodexHomePath,
        [string]$BootstrapSnippetPath
    )

    if ([string]::IsNullOrWhiteSpace($ResolvedCodexHomePath)) {
        return [ordered]@{ action = "skipped"; target = ""; reason = "Codex home path is empty." }
    }

    Ensure-ParentDirectory -LiteralPath (Join-Path $ResolvedCodexHomePath "AGENTS.md")
    $agentsPath = Join-Path $ResolvedCodexHomePath "AGENTS.md"
    if (-not (Test-Path -LiteralPath $agentsPath)) {
        Write-TextFile -LiteralPath $agentsPath -Value "# Global Codex Rules`r`n"
    }

    $snippet = Read-TextFile -LiteralPath $BootstrapSnippetPath
    $existing = Read-TextFile -LiteralPath $agentsPath
    if ([string]::IsNullOrWhiteSpace($snippet)) {
        throw "Global bootstrap snippet is empty: $BootstrapSnippetPath"
    }
    if ($existing -like "*# MoreVibe Global Bootstrap for Codex*") {
        return [ordered]@{ action = "skipped"; target = $agentsPath; reason = "MoreVibe global bootstrap block already exists." }
    }

    $backupPath = Copy-Item -LiteralPath $agentsPath -Destination "$agentsPath.backup-$(New-Timestamp)" -Force -PassThru | ForEach-Object { $_.FullName }
    $newContent = "$($existing.TrimEnd())`r`n`r`n$($snippet.Trim())`r`n"
    Write-TextFile -LiteralPath $agentsPath -Value $newContent
    return [ordered]@{ action = "updated"; target = $agentsPath; backup = $backupPath }
}

function Apply-ClaudeMemoryImport {
    param(
        [string]$LiteralPath,
        [string]$ImportLine,
        [string]$DefaultHeader,
        [string]$BlockMarker
    )

    Ensure-ParentDirectory -LiteralPath $LiteralPath
    if (-not (Test-Path -LiteralPath $LiteralPath)) {
        Write-TextFile -LiteralPath $LiteralPath -Value ($DefaultHeader + "`r`n`r`n" + $ImportLine + "`r`n")
        return [ordered]@{ action = "created"; target = $LiteralPath }
    }

    $existing = Read-TextFile -LiteralPath $LiteralPath
    if ($existing -like "*$BlockMarker*") {
        return [ordered]@{ action = "skipped"; target = $LiteralPath; reason = "MoreVibe import already exists." }
    }

    $backupPath = Copy-Item -LiteralPath $LiteralPath -Destination "$LiteralPath.backup-$(New-Timestamp)" -Force -PassThru | ForEach-Object { $_.FullName }
    $newContent = "$($existing.TrimEnd())`r`n`r`n$ImportLine`r`n"
    Write-TextFile -LiteralPath $LiteralPath -Value $newContent
    return [ordered]@{ action = "updated"; target = $LiteralPath; backup = $backupPath }
}

function Install-ClaudeProjectIntegration {
    param(
        [string]$ProjectRoot,
        [string]$ScriptRootPath
    )

    if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
        return $null
    }

    $resolvedProjectRoot = Resolve-FullPath -PathValue $ProjectRoot
    $claudeRoot = Join-Path $resolvedProjectRoot ".claude"
    $commandsRoot = Join-Path $claudeRoot "commands"
    $agentsRoot = Join-Path $claudeRoot "agents"
    $morevibeRoot = Join-Path $claudeRoot "morevibe"
    $scriptsRoot = Join-Path $morevibeRoot "scripts"
    $settingsPath = Join-Path $claudeRoot "settings.json"
    $projectMemoryPath = Join-Path $resolvedProjectRoot "CLAUDE.md"

    New-Item -ItemType Directory -Path $commandsRoot,$agentsRoot,$scriptsRoot -Force | Out-Null

    Copy-Item -LiteralPath (Join-Path $ScriptRootPath "..\..\adapters\claudecode\project\commands\*") -Destination $commandsRoot -Force
    Copy-Item -LiteralPath (Join-Path $ScriptRootPath "..\..\adapters\claudecode\project\agents\*") -Destination $agentsRoot -Force
    Copy-Item -LiteralPath (Join-Path $ScriptRootPath "..\..\adapters\claudecode\project\CLAUDE.morevibe.md") -Destination (Join-Path $morevibeRoot "CLAUDE.morevibe.md") -Force

    $scriptFiles = @(
        "bootstrap_morevibe_session.py",
        "ingest_morevibe_item.py",
        "query_morevibe.py",
        "sync_morevibe_memory.py",
        "writeback_morevibe_output.py",
        "lint_morevibe.py"
    )
    foreach ($scriptFile in $scriptFiles) {
        Copy-Item -LiteralPath (Join-Path $ScriptRootPath "..\..\plugin\scripts\$scriptFile") -Destination (Join-Path $scriptsRoot $scriptFile) -Force
    }

    $settingsBackup = $null
    if (Test-Path -LiteralPath $settingsPath) {
        $settingsBackup = Copy-Item -LiteralPath $settingsPath -Destination "$settingsPath.backup-$(New-Timestamp)" -Force -PassThru | ForEach-Object { $_.FullName }
    }
    & python (Join-Path $ScriptRootPath "..\..\plugin\scripts\merge_claude_settings.py") --settings-path $settingsPath | Out-Null

    $memoryResult = Apply-ClaudeMemoryImport -LiteralPath $projectMemoryPath -ImportLine "@.claude/morevibe/CLAUDE.morevibe.md" -DefaultHeader "# Claude Project Memory" -BlockMarker "@.claude/morevibe/CLAUDE.morevibe.md"

    return [ordered]@{
        action = "installed"
        target = $claudeRoot
        settings = $settingsPath
        settingsBackup = $settingsBackup
        memoryAction = $memoryResult.action
        memoryTarget = $memoryResult.target
        memoryBackup = $memoryResult.backup
    }
}

function Apply-ClaudeGlobalBootstrap {
    param(
        [string]$ResolvedClaudeHomePath,
        [string]$BootstrapSnippetPath
    )

    if ([string]::IsNullOrWhiteSpace($ResolvedClaudeHomePath)) {
        return [ordered]@{ action = "skipped"; target = ""; reason = "Claude home path is empty." }
    }

    $memoryPath = Join-Path $ResolvedClaudeHomePath "CLAUDE.md"
    Ensure-ParentDirectory -LiteralPath $memoryPath
    $snippet = Read-TextFile -LiteralPath $BootstrapSnippetPath
    if ([string]::IsNullOrWhiteSpace($snippet)) {
        throw "Claude global bootstrap snippet is empty: $BootstrapSnippetPath"
    }

    if (-not (Test-Path -LiteralPath $memoryPath)) {
        Write-TextFile -LiteralPath $memoryPath -Value ($snippet.Trim() + "`r`n")
        return [ordered]@{ action = "created"; target = $memoryPath }
    }

    $existing = Read-TextFile -LiteralPath $memoryPath
    if ($existing -like "*# MoreVibe Global Bootstrap for ClaudeCode*") {
        return [ordered]@{ action = "skipped"; target = $memoryPath; reason = "MoreVibe Claude global bootstrap already exists." }
    }

    $backupPath = Copy-Item -LiteralPath $memoryPath -Destination "$memoryPath.backup-$(New-Timestamp)" -Force -PassThru | ForEach-Object { $_.FullName }
    $newContent = "$($existing.TrimEnd())`r`n`r`n$($snippet.Trim())`r`n"
    Write-TextFile -LiteralPath $memoryPath -Value $newContent
    return [ordered]@{ action = "updated"; target = $memoryPath; backup = $backupPath }
}

$scriptRoot = Resolve-FullPath -PathValue $PSScriptRoot
$pluginSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\plugin")
$templateSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\templates\project\.morevibe")
$projectAgentsBootstrapSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\adapters\codex\snippets\project-agents-bootstrap.md")
$codexGlobalBootstrapSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\adapters\codex\snippets\global-bootstrap.md")
$claudeGlobalBootstrapSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\adapters\claudecode\snippets\global-bootstrap.md")
$resolvedHomePath = Resolve-FullPath -PathValue $HomePath
$resolvedCodexHomePath = if ([string]::IsNullOrWhiteSpace($CodexHomePath)) { Join-Path $resolvedHomePath ".codex" } else { Resolve-FullPath -PathValue $CodexHomePath }
$resolvedClaudeHomePath = if ([string]::IsNullOrWhiteSpace($ClaudeHomePath)) { Join-Path $resolvedHomePath ".claude" } else { Resolve-FullPath -PathValue $ClaudeHomePath }

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
$claudeProjectIntegrationResult = $null
$claudeGlobalBootstrapResult = $null

if (-not [string]::IsNullOrWhiteSpace($ProjectPath)) {
    $resolvedProjectPath = Resolve-FullPath -PathValue $ProjectPath
    $agentsBootstrapResult = Apply-AgentsBootstrap -ProjectRoot $resolvedProjectPath -BootstrapSnippetPath $projectAgentsBootstrapSource
    $claudeProjectIntegrationResult = Install-ClaudeProjectIntegration -ProjectRoot $resolvedProjectPath -ScriptRootPath $scriptRoot
} elseif ($ApplyProjectAgentsBootstrap.IsPresent) {
    throw "ProjectPath is required when using -ApplyProjectAgentsBootstrap."
}

if ($ApplyCodexGlobalBootstrap.IsPresent -or (Test-Path -LiteralPath (Join-Path $resolvedCodexHomePath "AGENTS.md"))) {
    $codexGlobalBootstrapResult = Apply-CodexGlobalBootstrap -ResolvedCodexHomePath $resolvedCodexHomePath -BootstrapSnippetPath $codexGlobalBootstrapSource
}

if ($ApplyProjectAgentsBootstrap.IsPresent -and [string]::IsNullOrWhiteSpace($ProjectPath)) {
    throw "ProjectPath is required when using -ApplyProjectAgentsBootstrap."
}

if ((Test-Path -LiteralPath $resolvedClaudeHomePath) -or -not [string]::IsNullOrWhiteSpace($ClaudeHomePath)) {
    $claudeGlobalBootstrapResult = Apply-ClaudeGlobalBootstrap -ResolvedClaudeHomePath $resolvedClaudeHomePath -BootstrapSnippetPath $claudeGlobalBootstrapSource
}

Write-Host ""
Write-Host "MoreVibe installation complete." -ForegroundColor Green
Write-Host "Plugin path: $pluginTarget"
Write-Host "Marketplace: $marketplacePath"

if ($null -ne $pluginBackup) { Write-Host "Previous plugin backup: $pluginBackup" }
if ($null -ne $marketplaceBackup) { Write-Host "Marketplace backup: $marketplaceBackup" }

if ($null -ne $templateResult) {
    Write-Host "Project template: $($templateResult.action) -> $($templateResult.target)"
    if ($templateResult.backup) { Write-Host "Project template backup: $($templateResult.backup)" }
    if ($templateResult.reason) { Write-Host "Project template note: $($templateResult.reason)" }
}

if ($null -ne $agentsBootstrapResult) {
    Write-Host "AGENTS bootstrap: $($agentsBootstrapResult.action) -> $($agentsBootstrapResult.target)"
    if ($agentsBootstrapResult.backup) { Write-Host "AGENTS backup: $($agentsBootstrapResult.backup)" }
    if ($agentsBootstrapResult.reason) { Write-Host "AGENTS note: $($agentsBootstrapResult.reason)" }
}

if ($null -ne $codexGlobalBootstrapResult) {
    Write-Host "Codex global bootstrap: $($codexGlobalBootstrapResult.action) -> $($codexGlobalBootstrapResult.target)"
    if ($codexGlobalBootstrapResult.backup) { Write-Host "Codex global backup: $($codexGlobalBootstrapResult.backup)" }
    if ($codexGlobalBootstrapResult.reason) { Write-Host "Codex global note: $($codexGlobalBootstrapResult.reason)" }
}

if ($null -ne $claudeProjectIntegrationResult) {
    Write-Host "Claude project integration: $($claudeProjectIntegrationResult.action) -> $($claudeProjectIntegrationResult.target)"
    Write-Host "Claude settings: $($claudeProjectIntegrationResult.settings)"
    if ($claudeProjectIntegrationResult.settingsBackup) { Write-Host "Claude settings backup: $($claudeProjectIntegrationResult.settingsBackup)" }
    Write-Host "Claude memory: $($claudeProjectIntegrationResult.memoryAction) -> $($claudeProjectIntegrationResult.memoryTarget)"
    if ($claudeProjectIntegrationResult.memoryBackup) { Write-Host "Claude memory backup: $($claudeProjectIntegrationResult.memoryBackup)" }
}

if ($null -ne $claudeGlobalBootstrapResult) {
    Write-Host "Claude global bootstrap: $($claudeGlobalBootstrapResult.action) -> $($claudeGlobalBootstrapResult.target)"
    if ($claudeGlobalBootstrapResult.backup) { Write-Host "Claude global backup: $($claudeGlobalBootstrapResult.backup)" }
    if ($claudeGlobalBootstrapResult.reason) { Write-Host "Claude global note: $($claudeGlobalBootstrapResult.reason)" }
}

if ($null -ne $adapterExportResults -and $adapterExportResults.Count -gt 0) {
    foreach ($result in $adapterExportResults) {
        Write-Host "Adapter export [$($result.adapter)]: $($result.action)"
        if ($result.target) { Write-Host "Adapter export target: $($result.target)" }
        if ($result.backup) { Write-Host "Adapter export backup: $($result.backup)" }
        if ($result.reason) { Write-Host "Adapter export note: $($result.reason)" }
    }
}
