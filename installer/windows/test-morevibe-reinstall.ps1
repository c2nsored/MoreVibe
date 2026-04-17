param(
    [string]$ProjectType = "webapp"
)

$ErrorActionPreference = "Stop"

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\.."))
$tempRoot = Join-Path $repoRoot ".tmp-reinstall-smoke"
$homeRoot = Join-Path $tempRoot "home"
$projectRoot = Join-Path $tempRoot "project"
$installScript = Join-Path $PSScriptRoot "install-morevibe.ps1"

if (Test-Path -LiteralPath $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $homeRoot,$projectRoot -Force | Out-Null

Set-ExecutionPolicy -Scope Process Bypass

& $installScript `
    -HomePath $homeRoot `
    -CodexHomePath (Join-Path $homeRoot ".codex") `
    -ClaudeHomePath (Join-Path $homeRoot ".claude") `
    -GeminiHomePath (Join-Path $homeRoot ".gemini") `
    -ProjectPath $projectRoot `
    -ProjectType $ProjectType `
    -InstallCodex `
    -InstallClaudeCode `
    -InstallAntigravity | Out-Null

$overviewPath = Join-Path $projectRoot ".morevibe\canon\PROJECT_OVERVIEW.md"
$statePath = Join-Path $projectRoot ".morevibe\wiki\state.md"
$overviewSentinel = "Smoke sentinel: preserve overview"
$stateSentinel = "Smoke sentinel: preserve wiki state"

Set-Content -LiteralPath $overviewPath -Value "# Project Overview`r`n`r`n$overviewSentinel`r`n" -Encoding UTF8
Set-Content -LiteralPath $statePath -Value "# MoreVibe State`r`n`r`nLast Updated: 2026-04-17 00:00`r`n`r`n## Current Focus`r`n- $stateSentinel`r`n`r`n## Active Risks`r`n- None.`r`n`r`n## Recent Changes`r`n- None.`r`n`r`n## Next Session`r`n- Continue.`r`n" -Encoding UTF8

# Seed a legacy Stop hook (from an older MoreVibe version) plus a user-custom
# hook. After reinstall, the legacy MoreVibe entry must be gone (no duplicate
# with the new auto_sync command), and the user-custom entry must survive.
$claudeSettingsPath = Join-Path $projectRoot ".claude\settings.json"
$legacySettings = @{
    hooks = @{
        Stop = @(
            @{ hooks = @(@{ type = "command"; command = "python .claude/morevibe/scripts/lint_morevibe.py --project-root ." }) },
            @{ hooks = @(@{ type = "command"; command = "echo user-custom-hook" }) }
        )
    }
} | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $claudeSettingsPath -Value $legacySettings -Encoding UTF8

& $installScript `
    -HomePath $homeRoot `
    -CodexHomePath (Join-Path $homeRoot ".codex") `
    -ClaudeHomePath (Join-Path $homeRoot ".claude") `
    -GeminiHomePath (Join-Path $homeRoot ".gemini") `
    -ProjectPath $projectRoot `
    -ProjectType $ProjectType `
    -InstallCodex `
    -InstallClaudeCode `
    -InstallAntigravity | Out-Null

$overviewText = Get-Content -LiteralPath $overviewPath -Raw -Encoding UTF8
$stateText = Get-Content -LiteralPath $statePath -Raw -Encoding UTF8

$overviewPreserved = $overviewText.Contains($overviewSentinel)
$statePreserved = $stateText.Contains($stateSentinel)

# Verify Stop hook merge: legacy MoreVibe entry must be gone, canonical
# auto_sync entry must be the only MoreVibe-managed Stop hook, user-custom
# entry must survive.
$claudeSettings = Get-Content -LiteralPath $claudeSettingsPath -Raw -Encoding UTF8 | ConvertFrom-Json
$stopCommands = @()
foreach ($entry in $claudeSettings.hooks.Stop) {
    foreach ($hook in $entry.hooks) {
        $stopCommands += $hook.command
    }
}
$autoSyncCount = ($stopCommands | Where-Object { $_ -like "*auto_sync_morevibe_session.py*" }).Count
$legacyLintCount = ($stopCommands | Where-Object { $_ -like "*lint_morevibe.py*" -and $_ -notlike "*auto_sync*" }).Count
$userCustomPresent = $stopCommands -contains "echo user-custom-hook"

$hookDedupOk = ($autoSyncCount -eq 1) -and ($legacyLintCount -eq 0) -and $userCustomPresent

$lintOutput = & python (Join-Path $repoRoot "plugin\scripts\lint_morevibe.py") --project-root $projectRoot --skip-log

Write-Host "MoreVibe reinstall smoke test" -ForegroundColor Cyan
Write-Host ("[{0}] Preserve canon/PROJECT_OVERVIEW.md sentinel" -f ($(if ($overviewPreserved) { "OK" } else { "FAIL" })))
Write-Host ("[{0}] Preserve wiki/state.md sentinel" -f ($(if ($statePreserved) { "OK" } else { "FAIL" })))
Write-Host ("[{0}] Stop hook dedup (canonical=1, legacy=0, user-custom preserved)" -f ($(if ($hookDedupOk) { "OK" } else { "FAIL" })))
Write-Host ("    canonical auto_sync count : {0}" -f $autoSyncCount)
Write-Host ("    legacy lint-only count    : {0}" -f $legacyLintCount)
Write-Host ("    user-custom preserved     : {0}" -f $userCustomPresent)
Write-Host ""
Write-Host $lintOutput

if (-not $overviewPreserved -or -not $statePreserved) {
    throw "Reinstall smoke test failed: preserved content was overwritten."
}
if (-not $hookDedupOk) {
    throw "Reinstall smoke test failed: Stop hook dedup did not behave as expected."
}
