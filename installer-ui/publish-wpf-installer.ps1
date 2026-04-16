param(
    [string]$Version = "v0.4.3",
    [string]$Runtime = "win-x64",
    [switch]$SkipZip
)

$ErrorActionPreference = "Stop"

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$projectPath = Join-Path $PSScriptRoot "MoreVibeInstaller\MoreVibeInstaller.csproj"
$publishRoot = Join-Path $repoRoot "dist\wpf-publish\$Runtime"
$bundleRoot = Join-Path $repoRoot "dist\MoreVibeInstaller-$Runtime"
$zipPath = Join-Path $repoRoot "dist\MoreVibeInstaller-$Version-$Runtime.zip"

if (Test-Path -LiteralPath $publishRoot) {
    Remove-Item -LiteralPath $publishRoot -Recurse -Force
}

if (Test-Path -LiteralPath $bundleRoot) {
    Remove-Item -LiteralPath $bundleRoot -Recurse -Force
}

if (Test-Path -LiteralPath $zipPath) {
    Remove-Item -LiteralPath $zipPath -Force
}

Write-Host "Publishing MoreVibeInstaller..." -ForegroundColor Cyan
dotnet publish $projectPath -c Release -r $Runtime --self-contained true /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true -o $publishRoot

New-Item -ItemType Directory -Path $bundleRoot -Force | Out-Null

Copy-Item -LiteralPath (Join-Path $publishRoot "MoreVibeInstaller.exe") -Destination (Join-Path $bundleRoot "MoreVibeInstaller.exe") -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "installer") -Destination (Join-Path $bundleRoot "installer") -Recurse -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "plugin") -Destination (Join-Path $bundleRoot "plugin") -Recurse -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "templates") -Destination (Join-Path $bundleRoot "templates") -Recurse -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "adapters") -Destination (Join-Path $bundleRoot "adapters") -Recurse -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "core") -Destination (Join-Path $bundleRoot "core") -Recurse -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "README.md") -Destination (Join-Path $bundleRoot "README.md") -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "README.ko.md") -Destination (Join-Path $bundleRoot "README.ko.md") -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "LICENSE") -Destination (Join-Path $bundleRoot "LICENSE") -Force

if (-not $SkipZip) {
    Compress-Archive -LiteralPath $bundleRoot -DestinationPath $zipPath -Force
    Write-Host "Release zip created: $zipPath" -ForegroundColor Green
} else {
    Write-Host "Bundle folder created: $bundleRoot" -ForegroundColor Green
}

