$projectRoot = (Get-Location).Path
$morevibeRoot = Join-Path $projectRoot ".morevibe"
$tasksPath = Join-Path $morevibeRoot "canon\TASKS.md"
$skillMapPath = Join-Path $morevibeRoot "schema\project_skill_map.json"

function Get-FirstSectionBullet {
    param(
        [string]$LiteralPath,
        [string[]]$SectionNames
    )

    if (-not (Test-Path -LiteralPath $LiteralPath)) {
        return ""
    }

    $lines = Get-Content -LiteralPath $LiteralPath -ErrorAction SilentlyContinue
    if (-not $lines) {
        return ""
    }

    $currentSection = ""
    foreach ($rawLine in $lines) {
        $line = ""
        if ($null -ne $rawLine) {
            $line = ([string]$rawLine).Trim()
        }
        if ($line.StartsWith("## ")) {
            $currentSection = $line.Substring(3).Trim()
            continue
        }

        if ($currentSection -notin $SectionNames) {
            continue
        }

        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        if ($line.Contains("[TODO]")) {
            continue
        }

        if ($line.StartsWith("- ") -or $line.StartsWith("* ")) {
            return $line.Substring(2).Trim()
        }

        if ($line -match '^\d+\.\s+') {
            return ($line -replace '^\d+\.\s+', '').Trim()
        }

        return $line
    }

    return ""
}

function Get-LeadLabel {
    param([string]$LiteralPath)

    if (-not (Test-Path -LiteralPath $LiteralPath)) {
        return "pm-lead"
    }

    try {
        $json = Get-Content -LiteralPath $LiteralPath -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($null -ne $json.roles -and $null -ne $json.roles.lead -and -not [string]::IsNullOrWhiteSpace($json.roles.lead)) {
            return [string]$json.roles.lead
        }
    } catch {
        return "pm-lead"
    }

    return "pm-lead"
}

$taskLabel = Get-FirstSectionBullet -LiteralPath $tasksPath -SectionNames @("Now", "Next")
if ([string]::IsNullOrWhiteSpace($taskLabel)) {
    $taskLabel = "Open FIRST_SESSION_GUIDE and resume the top task"
}

$leadLabel = Get-LeadLabel -LiteralPath $skillMapPath
$taskLabel = $taskLabel -replace '\s+', ' '
if ($taskLabel.Length -gt 80) {
    $taskLabel = $taskLabel.Substring(0, 77).TrimEnd() + "..."
}

Write-Output ("MoreVibe | {0} | Now: {1}" -f $leadLabel, $taskLabel)
