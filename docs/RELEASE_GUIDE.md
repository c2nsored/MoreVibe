# MoreVibe Release Guide

This guide explains what to include in a Windows-friendly release package.

## Recommended release contents

Current preferred Windows release package:

- `MoreVibeInstaller-v0.5.0-win-x64.zip`
- `MoreVibeInstaller.exe`
- `installer/`
- `plugin/`
- `templates/`
- `adapters/`
- `core/`
- `README.md`
- `README.ko.md`
- `LICENSE`

## Current Windows release flow

1. Run `installer-ui/publish-wpf-installer.ps1`.
2. Upload the generated ZIP from `dist/` to GitHub Releases.
3. Tell users to download and extract the release.
4. Let Windows users run `MoreVibeInstaller.exe`.

## Current limitation

The WPF installer is now a standalone Windows executable wrapper, but it still relies on the packaged PowerShell installer and repository assets shipped beside it.

The release package should reflect the current install behavior:

- create or update a project root `AGENTS.md`
- install default MoreVibe project skills into `.agents/skills/`
- install shared native workflow aliases such as `start-session`, `project-bootstrap`, and `plan-feature`
- install `.claude/skills/` for Claude Code targets
- install project-local `.codex/` files for Codex targets
- apply project-type role templates for `webapp`, `ecommerce`, `blog`, `api`, or generic fallback
- print a project bootstrap health summary after installation

## Future release target

Later, MoreVibe can add:

- signed installer builds
- automatic GitHub Actions release packaging
- richer progress reporting and recovery flows
