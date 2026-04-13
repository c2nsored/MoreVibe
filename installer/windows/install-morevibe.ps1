param(
    [string]$HomePath = $HOME,
    [string]$CodexHomePath = "",
    [string]$ClaudeHomePath = "",
    [string]$GeminiHomePath = "",
    [string]$ProjectPath = "",
    [switch]$InstallCodex,
    [switch]$InstallClaudeCode,
    [switch]$InstallAntigravity,
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
        interface = [ordered]@{ displayName = "MoreVibe Local" }
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
    if ([string]::IsNullOrWhiteSpace($name)) { $name = "morevibe-local" }

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
        source = [ordered]@{ source = "local"; path = "./plugins/morevibe" }
        policy = [ordered]@{ installation = "AVAILABLE"; authentication = "ON_INSTALL" }
        category = "Productivity"
    }

    return [ordered]@{ name = $name; interface = [ordered]@{ displayName = $displayName }; plugins = $plugins }
}

function Get-ProjectDomainPaths {
    param([string]$ProjectRoot)

    $ignoredDirs = @('node_modules', '.next', 'dist', 'build', '.git', '__pycache__', '.venv', 'venv', 'coverage', '.turbo', '.vercel', 'out', '.cache', 'tmp', 'temp')
    $frontendNames = @('app', 'pages', 'components', 'views', 'layouts', 'ui', 'public', 'styles', 'assets', 'features', 'screens')
    $backendNames = @('api', 'lib', 'server', 'services', 'prisma', 'db', 'database', 'utils', 'helpers', 'middleware', 'routes', 'controllers', 'models', 'schema')

    $frontendPaths = [System.Collections.Generic.List[string]]::new()
    $backendPaths = [System.Collections.Generic.List[string]]::new()

    $allDirs = Get-ChildItem -LiteralPath $ProjectRoot -Directory -ErrorAction SilentlyContinue |
               Where-Object { $_.Name -notin $ignoredDirs -and -not $_.Name.StartsWith('.') } |
               Select-Object -ExpandProperty Name

    # Next.js App Router: split app/ into app/api (backend) and the rest (frontend)
    $hasNextConfig = (Test-Path (Join-Path $ProjectRoot "next.config.js")) -or
                     (Test-Path (Join-Path $ProjectRoot "next.config.ts")) -or
                     (Test-Path (Join-Path $ProjectRoot "next.config.mjs"))
    $hasAppApi = Test-Path (Join-Path $ProjectRoot "app\api")

    foreach ($dir in $allDirs) {
        $lower = $dir.ToLowerInvariant()
        if ($lower -eq 'app' -and $hasNextConfig -and $hasAppApi) {
            $frontendPaths.Add("app/**")
            $backendPaths.Add("app/api/**")
        } elseif ($lower -in $frontendNames) {
            $frontendPaths.Add("$dir/**")
        } elseif ($lower -in $backendNames) {
            $backendPaths.Add("$dir/**")
        }
    }

    if ($frontendPaths.Count -eq 0) { $frontendPaths.Add("[no frontend dirs auto-detected — add paths here]") }
    if ($backendPaths.Count -eq 0) { $backendPaths.Add("[no backend dirs auto-detected — add paths here]") }

    return [ordered]@{ frontend = $frontendPaths.ToArray(); backend = $backendPaths.ToArray() }
}

function Set-AgentFocusPaths {
    param([string]$AgentFilePath, [string[]]$Paths)
    if (-not (Test-Path -LiteralPath $AgentFilePath)) { return }

    $lines = Get-Content -LiteralPath $AgentFilePath -Encoding UTF8
    $newLines = [System.Collections.Generic.List[string]]::new()
    $skipExampleLine = $false

    foreach ($line in $lines) {
        if ($skipExampleLine) {
            $skipExampleLine = $false
            if ($line -match '^\s*- Example:') { continue }
            $newLines.Add($line)
            continue
        }
        if ($line -match '\[CUSTOMIZE:') {
            foreach ($path in $Paths) { $newLines.Add("- ``$path``") }
            $skipExampleLine = $true
            continue
        }
        $newLines.Add($line)
    }

    Set-Content -LiteralPath $AgentFilePath -Value ($newLines -join "`n") -Encoding UTF8
}

function Install-ProjectTemplate {
    param(
        [string]$TemplateSource,
        [string]$TargetProjectPath,
        [bool]$ForceTemplate
    )
    if ([string]::IsNullOrWhiteSpace($TargetProjectPath)) { return $null }

    $resolvedProjectPath = Resolve-FullPath -PathValue $TargetProjectPath
    if (-not (Test-Path -LiteralPath $resolvedProjectPath)) {
        throw "Project path does not exist: $resolvedProjectPath"
    }

    $templateTarget = Join-Path $resolvedProjectPath ".morevibe"
    if (Test-Path -LiteralPath $templateTarget) {
        if (-not $ForceTemplate) {
            return [ordered]@{ target = $templateTarget; action = "skipped"; reason = ".morevibe already exists. Use -ForceProjectTemplate to overwrite it." }
        }
        $backupPath = Backup-PathIfExists -LiteralPath $templateTarget
        Copy-Item -LiteralPath $TemplateSource -Destination $templateTarget -Recurse -Force
        return [ordered]@{ target = $templateTarget; action = "replaced"; backup = $backupPath }
    }

    Copy-Item -LiteralPath $TemplateSource -Destination $templateTarget -Recurse -Force
    return [ordered]@{ target = $templateTarget; action = "created" }
}

function Install-AdapterExports {
    param(
        [string]$ScriptRootPath,
        [string]$ResolvedHome,
        [string[]]$Adapters
    )
    if ($null -eq $Adapters -or $Adapters.Count -eq 0) { return @() }

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
        if (Test-Path -LiteralPath $targetPath) { $backup = Backup-PathIfExists -LiteralPath $targetPath }
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
    $newContent = "$($existing.TrimEnd())`r`n`r`n$($snippet.Trim())`r`n"
    Write-TextFile -LiteralPath $agentsPath -Value $newContent
    return [ordered]@{
        action = "updated"
        target = $agentsPath
        backup = $backupPath
    }
}

function Apply-TextBootstrap {
    param(
        [string]$LiteralPath,
        [string]$SnippetPath,
        [string]$Marker,
        [string]$DefaultHeader,
        [string]$MissingReason
    )

    Ensure-ParentDirectory -LiteralPath $LiteralPath
    if (-not (Test-Path -LiteralPath $LiteralPath)) {
        if ([string]::IsNullOrWhiteSpace($DefaultHeader)) {
            return [ordered]@{ action = "skipped"; target = $LiteralPath; reason = $MissingReason }
        }
        Write-TextFile -LiteralPath $LiteralPath -Value ($DefaultHeader + "`r`n")
    }

    $snippet = Read-TextFile -LiteralPath $SnippetPath
    $existing = Read-TextFile -LiteralPath $LiteralPath
    if ([string]::IsNullOrWhiteSpace($snippet)) {
        throw "Bootstrap snippet is empty: $SnippetPath"
    }
    if ($existing -like "*$Marker*") {
        return [ordered]@{ action = "skipped"; target = $LiteralPath; reason = "Bootstrap block already exists." }
    }
    $backupPath = Copy-Item -LiteralPath $LiteralPath -Destination "$LiteralPath.backup-$(New-Timestamp)" -Force -PassThru | ForEach-Object { $_.FullName }
    $newContent = "$($existing.TrimEnd())`r`n`r`n$($snippet.Trim())`r`n"
    Write-TextFile -LiteralPath $LiteralPath -Value $newContent
    return [ordered]@{ action = "updated"; target = $LiteralPath; backup = $backupPath }
}

function Install-ClaudeProjectIntegration {
    param(
        [string]$ProjectRoot,
        [string]$ScriptRootPath
    )

    if ([string]::IsNullOrWhiteSpace($ProjectRoot)) { return $null }

    $resolvedProjectRoot = Resolve-FullPath -PathValue $ProjectRoot
    $claudeRoot = Join-Path $resolvedProjectRoot ".claude"
    $commandsRoot = Join-Path $claudeRoot "commands"
    $agentsRoot = Join-Path $claudeRoot "agents"
    $morevibeRoot = Join-Path $claudeRoot "morevibe"
    $scriptsRoot = Join-Path $morevibeRoot "scripts"
    $settingsPath = Join-Path $claudeRoot "settings.json"
    $projectMemoryPath = Join-Path $resolvedProjectRoot "CLAUDE.md"

    New-Item -ItemType Directory -Path $commandsRoot,$agentsRoot,$scriptsRoot -Force | Out-Null
    Copy-Item -Path (Join-Path $ScriptRootPath "..\..\adapters\claudecode\project\commands\*") -Destination $commandsRoot -Force
    Copy-Item -Path (Join-Path $ScriptRootPath "..\..\adapters\claudecode\project\agents\*") -Destination $agentsRoot -Force

    # Auto-configure worker agent file paths from project structure
    $domainPaths = Get-ProjectDomainPaths -ProjectRoot $resolvedProjectRoot
    Set-AgentFocusPaths -AgentFilePath (Join-Path $agentsRoot "frontend-worker.md") -Paths $domainPaths.frontend
    Set-AgentFocusPaths -AgentFilePath (Join-Path $agentsRoot "backend-worker.md") -Paths $domainPaths.backend
    Copy-Item -LiteralPath (Join-Path $ScriptRootPath "..\..\adapters\claudecode\project\CLAUDE.morevibe.md") -Destination (Join-Path $morevibeRoot "CLAUDE.morevibe.md") -Force

    foreach ($scriptFile in @("bootstrap_morevibe_session.py","ingest_morevibe_item.py","query_morevibe.py","sync_morevibe_memory.py","writeback_morevibe_output.py","lint_morevibe.py")) {
        Copy-Item -LiteralPath (Join-Path $ScriptRootPath "..\..\plugin\scripts\$scriptFile") -Destination (Join-Path $scriptsRoot $scriptFile) -Force
    }

    $settingsBackup = $null
    if (Test-Path -LiteralPath $settingsPath) {
        $settingsBackup = Copy-Item -LiteralPath $settingsPath -Destination "$settingsPath.backup-$(New-Timestamp)" -Force -PassThru | ForEach-Object { $_.FullName }
    }
    & python (Join-Path $ScriptRootPath "..\..\plugin\scripts\merge_claude_settings.py") --settings-path $settingsPath | Out-Null

    $memoryResult = Apply-TextBootstrap -LiteralPath $projectMemoryPath -SnippetPath (Join-Path $ScriptRootPath "..\..\adapters\claudecode\project\CLAUDE.morevibe.md") -Marker "This project uses MoreVibe as an internal harness." -DefaultHeader "# Claude Project Memory" -MissingReason "Claude project memory file missing."

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

function Install-AntigravityProjectIntegration {
    param(
        [string]$ProjectRoot,
        [string]$ScriptRootPath
    )

    if ([string]::IsNullOrWhiteSpace($ProjectRoot)) { return $null }

    $resolvedProjectRoot = Resolve-FullPath -PathValue $ProjectRoot
    $rulesRoot = Join-Path $resolvedProjectRoot ".agents\rules"
    $morevibeRoot = Join-Path $resolvedProjectRoot ".agents\morevibe"
    $scriptsRoot = Join-Path $morevibeRoot "scripts"
    $geminiPath = Join-Path $resolvedProjectRoot "GEMINI.md"

    New-Item -ItemType Directory -Path $rulesRoot,$scriptsRoot -Force | Out-Null
    Copy-Item -Path (Join-Path $ScriptRootPath "..\..\adapters\antigravity\project\rules\*") -Destination $rulesRoot -Force
    Copy-Item -LiteralPath (Join-Path $ScriptRootPath "..\..\adapters\antigravity\project\GEMINI.morevibe.md") -Destination (Join-Path $morevibeRoot "GEMINI.morevibe.md") -Force

    foreach ($scriptFile in @("bootstrap_morevibe_session.py","ingest_morevibe_item.py","query_morevibe.py","sync_morevibe_memory.py","writeback_morevibe_output.py","lint_morevibe.py")) {
        Copy-Item -LiteralPath (Join-Path $ScriptRootPath "..\..\plugin\scripts\$scriptFile") -Destination (Join-Path $scriptsRoot $scriptFile) -Force
    }

    $geminiResult = Apply-TextBootstrap -LiteralPath $geminiPath -SnippetPath (Join-Path $ScriptRootPath "..\..\adapters\antigravity\project\GEMINI.morevibe.md") -Marker "This project uses MoreVibe as an internal harness." -DefaultHeader "# Gemini Project Rules" -MissingReason "Gemini project file missing."

    return [ordered]@{
        action = "installed"
        target = $morevibeRoot
        rules = $rulesRoot
        geminiAction = $geminiResult.action
        geminiTarget = $geminiResult.target
        geminiBackup = $geminiResult.backup
    }
}

$scriptRoot = Resolve-FullPath -PathValue $PSScriptRoot
$pluginSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\plugin")
$templateSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\templates\project\.morevibe")
$projectAgentsBootstrapSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\adapters\codex\snippets\project-agents-bootstrap.md")
$codexGlobalBootstrapSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\adapters\codex\snippets\global-bootstrap.md")
$claudeGlobalBootstrapSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\adapters\claudecode\snippets\global-bootstrap.md")
$antigravityGlobalBootstrapSource = Resolve-FullPath -PathValue (Join-Path $scriptRoot "..\..\adapters\antigravity\snippets\global-bootstrap.md")
$resolvedHomePath = Resolve-FullPath -PathValue $HomePath
$resolvedCodexHomePath = if ([string]::IsNullOrWhiteSpace($CodexHomePath)) { Join-Path $resolvedHomePath ".codex" } else { Resolve-FullPath -PathValue $CodexHomePath }
$resolvedClaudeHomePath = if ([string]::IsNullOrWhiteSpace($ClaudeHomePath)) { Join-Path $resolvedHomePath ".claude" } else { Resolve-FullPath -PathValue $ClaudeHomePath }
$resolvedGeminiHomePath = if ([string]::IsNullOrWhiteSpace($GeminiHomePath)) { Join-Path $resolvedHomePath ".gemini" } else { Resolve-FullPath -PathValue $GeminiHomePath }

$selectedTargetCount = 0
if ($InstallCodex.IsPresent) { $selectedTargetCount += 1 }
if ($InstallClaudeCode.IsPresent) { $selectedTargetCount += 1 }
if ($InstallAntigravity.IsPresent) { $selectedTargetCount += 1 }
if ($selectedTargetCount -eq 0) {
    $InstallCodex = $true
    $InstallClaudeCode = $true
    $InstallAntigravity = $true
}

$pluginsDir = Join-Path $resolvedHomePath "plugins"
$pluginTarget = Join-Path $pluginsDir "morevibe"
$agentsDir = Join-Path $resolvedHomePath ".agents\plugins"
$marketplacePath = Join-Path $agentsDir "marketplace.json"

Write-Host "Installing MoreVibe..." -ForegroundColor Cyan
Write-Host "Plugin source: $pluginSource"
Write-Host "Plugin target: $pluginTarget"
Write-Host "Targets: Codex=$InstallCodex ClaudeCode=$InstallClaudeCode Antigravity=$InstallAntigravity"

$pluginBackup = $null
$marketplaceBackup = $null
if ($InstallCodex) {
    New-Item -ItemType Directory -Path $pluginsDir -Force | Out-Null
    New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null

    $pluginBackup = Backup-PathIfExists -LiteralPath $pluginTarget
    Copy-Item -LiteralPath $pluginSource -Destination $pluginTarget -Recurse -Force

    if (Test-Path -LiteralPath $marketplacePath) {
        $marketplaceBackupPath = "$marketplacePath.backup-$(New-Timestamp)"
        Copy-Item -LiteralPath $marketplacePath -Destination $marketplaceBackupPath -Force
        $marketplaceBackup = $marketplaceBackupPath
    }

    $marketplace = Merge-Marketplace -MarketplacePath $marketplacePath
    Write-JsonFile -LiteralPath $marketplacePath -Data $marketplace
}

$adapterExportResults = Install-AdapterExports -ScriptRootPath $scriptRoot -ResolvedHome $resolvedHomePath -Adapters $ExportAdapters
$templateResult = Install-ProjectTemplate -TemplateSource $templateSource -TargetProjectPath $ProjectPath -ForceTemplate $ForceProjectTemplate.IsPresent
$agentsBootstrapResult = $null
$codexGlobalBootstrapResult = $null
$claudeProjectIntegrationResult = $null
$claudeGlobalBootstrapResult = $null
$antigravityProjectIntegrationResult = $null
$antigravityGlobalBootstrapResult = $null

if (-not [string]::IsNullOrWhiteSpace($ProjectPath)) {
    $resolvedProjectPath = Resolve-FullPath -PathValue $ProjectPath
    if ($InstallCodex) {
        $agentsBootstrapResult = Apply-AgentsBootstrap -ProjectRoot $resolvedProjectPath -BootstrapSnippetPath $projectAgentsBootstrapSource
    }
    if ($InstallClaudeCode) {
        $claudeProjectIntegrationResult = Install-ClaudeProjectIntegration -ProjectRoot $resolvedProjectPath -ScriptRootPath $scriptRoot
    }
    if ($InstallAntigravity) {
        $antigravityProjectIntegrationResult = Install-AntigravityProjectIntegration -ProjectRoot $resolvedProjectPath -ScriptRootPath $scriptRoot
    }
} elseif ($ApplyProjectAgentsBootstrap.IsPresent) {
    throw "ProjectPath is required when using -ApplyProjectAgentsBootstrap."
}

if ($InstallCodex) {
    $codexGlobalBootstrapResult = Apply-TextBootstrap -LiteralPath (Join-Path $resolvedCodexHomePath "AGENTS.md") -SnippetPath $codexGlobalBootstrapSource -Marker "# MoreVibe Global Bootstrap for Codex" -DefaultHeader "# Global Codex Rules" -MissingReason "Codex global AGENTS missing."
}
if ($InstallClaudeCode) {
    $claudeGlobalBootstrapResult = Apply-TextBootstrap -LiteralPath (Join-Path $resolvedClaudeHomePath "CLAUDE.md") -SnippetPath $claudeGlobalBootstrapSource -Marker "# MoreVibe Global Bootstrap for ClaudeCode" -DefaultHeader "# Claude Global Memory" -MissingReason "Claude global memory missing."
}
if ($InstallAntigravity) {
    $antigravityGlobalBootstrapResult = Apply-TextBootstrap -LiteralPath (Join-Path $resolvedGeminiHomePath "GEMINI.md") -SnippetPath $antigravityGlobalBootstrapSource -Marker "# MoreVibe Global Bootstrap for Antigravity" -DefaultHeader "# Gemini Global Rules" -MissingReason "Gemini global rules missing."
}

Write-Host ""
Write-Host "MoreVibe installation complete." -ForegroundColor Green
if ($InstallCodex) {
    Write-Host "Plugin path: $pluginTarget"
    Write-Host "Marketplace: $marketplacePath"
}

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
}

if ($null -ne $antigravityProjectIntegrationResult) {
    Write-Host "Antigravity project integration: $($antigravityProjectIntegrationResult.action) -> $($antigravityProjectIntegrationResult.target)"
    Write-Host "Antigravity rules: $($antigravityProjectIntegrationResult.rules)"
    Write-Host "Antigravity project memory: $($antigravityProjectIntegrationResult.geminiAction) -> $($antigravityProjectIntegrationResult.geminiTarget)"
    if ($antigravityProjectIntegrationResult.geminiBackup) { Write-Host "Antigravity project memory backup: $($antigravityProjectIntegrationResult.geminiBackup)" }
}
if ($null -ne $antigravityGlobalBootstrapResult) {
    Write-Host "Antigravity global bootstrap: $($antigravityGlobalBootstrapResult.action) -> $($antigravityGlobalBootstrapResult.target)"
    if ($antigravityGlobalBootstrapResult.backup) { Write-Host "Antigravity global backup: $($antigravityGlobalBootstrapResult.backup)" }
}

if ($null -ne $adapterExportResults -and $adapterExportResults.Count -gt 0) {
    foreach ($result in $adapterExportResults) {
        Write-Host "Adapter export [$($result.adapter)]: $($result.action)"
        if ($result.target) { Write-Host "Adapter export target: $($result.target)" }
        if ($result.backup) { Write-Host "Adapter export backup: $($result.backup)" }
        if ($result.reason) { Write-Host "Adapter export note: $($result.reason)" }
    }
}
