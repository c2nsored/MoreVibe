# MoreVibe Release Guide

This guide explains what to include in a Windows-friendly release package.

## Recommended release contents

- `installer/windows/install-morevibe.ps1`
- `installer/windows/install-morevibe.bat`
- `plugin/`
- `templates/`
- `adapters/`

## Minimal Windows release flow

1. Prepare a release archive that preserves folder structure.
2. Publish it on GitHub Releases.
3. Tell users to download and extract the release.
4. Let Windows users run `installer/windows/install-morevibe.bat`.

## Current limitation

The current installer is not yet a standalone `.exe`.

It is a Windows-friendly script launcher around the PowerShell installer.

## Future release target

Later, MoreVibe can add:

- a self-contained `.exe` installer
- guided UI prompts for project path selection
- tool-adapter selection during install
