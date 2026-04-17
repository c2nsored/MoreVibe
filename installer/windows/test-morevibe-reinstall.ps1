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

$lintOutput = & python (Join-Path $repoRoot "plugin\scripts\lint_morevibe.py") --project-root $projectRoot --skip-log

Write-Host "MoreVibe reinstall smoke test" -ForegroundColor Cyan
Write-Host ("[{0}] Preserve canon/PROJECT_OVERVIEW.md sentinel" -f ($(if ($overviewPreserved) { "OK" } else { "FAIL" })))
Write-Host ("[{0}] Preserve wiki/state.md sentinel" -f ($(if ($statePreserved) { "OK" } else { "FAIL" })))
Write-Host ""
Write-Host $lintOutput

if (-not $overviewPreserved -or -not $statePreserved) {
    throw "Reinstall smoke test failed: preserved content was overwritten."
}
