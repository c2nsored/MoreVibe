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
$docsRoot = Join-Path $projectRoot "docs"
$overviewSentinel = "Smoke sentinel: preserve overview"
$stateSentinel = "Smoke sentinel: preserve wiki state"

Set-Content -LiteralPath $overviewPath -Value "# Project Overview`r`n`r`n$overviewSentinel`r`n" -Encoding UTF8
Set-Content -LiteralPath $statePath -Value "# MoreVibe State`r`n`r`nLast Updated: 2026-04-17 00:00`r`n`r`n## Current Focus`r`n- $stateSentinel`r`n`r`n## Active Risks`r`n- None.`r`n`r`n## Recent Changes`r`n- None.`r`n`r`n## Next Session`r`n- Continue.`r`n" -Encoding UTF8
New-Item -ItemType Directory -Path $docsRoot -Force | Out-Null
Set-Content -LiteralPath (Join-Path $docsRoot "migration-notes.md") -Value "# Existing project docs`r`n" -Encoding UTF8

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

# Verify migration advisory replay: while the migration sentinel is absent,
# the advisory must appear on EVERY `--once` run so Claude cannot silently
# skip it on trivial greetings. After the sentinel is written, the advisory
# must stop replaying and the session flag must flip to `migration_advisory_shown: true`.
$bootstrapScript = Join-Path $projectRoot ".claude\morevibe\scripts\bootstrap_morevibe_session.py"
$sessionFlagPath = Join-Path $projectRoot ".claude\morevibe\.session_bootstrapped"
$sentinelPath = Join-Path $projectRoot ".morevibe\.migration_complete"
$legacyBootstrapTimestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
Set-Content -LiteralPath $sessionFlagPath -Value $legacyBootstrapTimestamp -Encoding UTF8

$bootstrapFirst = & python $bootstrapScript --project-root $projectRoot --once --skip-log
$bootstrapSecond = & python $bootstrapScript --project-root $projectRoot --once --skip-log
$sessionFlagRawPending = Get-Content -LiteralPath $sessionFlagPath -Raw -Encoding UTF8
$sessionFlagStatePending = $sessionFlagRawPending | ConvertFrom-Json

# Now simulate migration completion by writing the sentinel, then rerun.
New-Item -ItemType Directory -Force -Path (Split-Path $sentinelPath -Parent) | Out-Null
Set-Content -LiteralPath $sentinelPath -Value "migration complete" -Encoding UTF8
$bootstrapAfterSentinel = & python $bootstrapScript --project-root $projectRoot --once --skip-log
$bootstrapAfterSentinelSecond = & python $bootstrapScript --project-root $projectRoot --once --skip-log
$sessionFlagRawDone = Get-Content -LiteralPath $sessionFlagPath -Raw -Encoding UTF8
$sessionFlagStateDone = $sessionFlagRawDone | ConvertFrom-Json

$migrationAdvisoryFirstShown = $bootstrapFirst -match "Migration Advisory"
$migrationAdvisoryReplays = $bootstrapSecond -match "Migration Advisory"
$pendingFlagStaysFalse = ($sessionFlagStatePending.version -eq 2) -and (-not $sessionFlagStatePending.migration_advisory_shown)
$advisoryStopsAfterSentinel = -not ($bootstrapAfterSentinelSecond -match "Migration Advisory")
$doneFlagIsTrue = ($sessionFlagStateDone.version -eq 2) -and $sessionFlagStateDone.migration_advisory_shown

$migrationReplayOk = $migrationAdvisoryFirstShown -and $migrationAdvisoryReplays -and $pendingFlagStaysFalse -and $advisoryStopsAfterSentinel -and $doneFlagIsTrue

$lintOutput = & python (Join-Path $repoRoot "plugin\scripts\lint_morevibe.py") --project-root $projectRoot --skip-log

Write-Host "MoreVibe reinstall smoke test" -ForegroundColor Cyan
Write-Host ("[{0}] Preserve canon/PROJECT_OVERVIEW.md sentinel" -f ($(if ($overviewPreserved) { "OK" } else { "FAIL" })))
Write-Host ("[{0}] Preserve wiki/state.md sentinel" -f ($(if ($statePreserved) { "OK" } else { "FAIL" })))
Write-Host ("[{0}] Stop hook dedup (canonical=1, legacy=0, user-custom preserved)" -f ($(if ($hookDedupOk) { "OK" } else { "FAIL" })))
Write-Host ("    canonical auto_sync count : {0}" -f $autoSyncCount)
Write-Host ("    legacy lint-only count    : {0}" -f $legacyLintCount)
Write-Host ("    user-custom preserved     : {0}" -f $userCustomPresent)
Write-Host ("[{0}] Migration advisory replays while pending and stops after sentinel" -f ($(if ($migrationReplayOk) { "OK" } else { "FAIL" })))
Write-Host ("    advisory shown first run     : {0}" -f $migrationAdvisoryFirstShown)
Write-Host ("    advisory replays second run  : {0}" -f $migrationAdvisoryReplays)
Write-Host ("    pending flag stays false     : {0}" -f $pendingFlagStaysFalse)
Write-Host ("    advisory stops after sentinel: {0}" -f $advisoryStopsAfterSentinel)
Write-Host ("    done flag flips to true      : {0}" -f $doneFlagIsTrue)
Write-Host ""
Write-Host $lintOutput

if (-not $overviewPreserved -or -not $statePreserved) {
    throw "Reinstall smoke test failed: preserved content was overwritten."
}
if (-not $hookDedupOk) {
    throw "Reinstall smoke test failed: Stop hook dedup did not behave as expected."
}
if (-not $migrationReplayOk) {
    throw "Reinstall smoke test failed: migration advisory replay did not behave as expected."
}
