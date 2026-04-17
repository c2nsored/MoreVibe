# MoreVibe Release Guide

This guide explains what to include in a Windows-friendly release package.

## Recommended release contents

Current preferred Windows release package:

- `MoreVibeInstaller-v1.2.1-win-x64.zip`
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
- classify installed skills into active and fallback layers in generated schema
- generate `FIRST_SESSION_GUIDE.md` for the first project conversation
- install `.claude/skills/` for Claude Code targets
- install project-local `.codex/` files for Codex targets
- apply project-type role templates for `webapp`, `ecommerce`, `blog`, `api`, or generic fallback
- treat the main agent as orchestrator and route internal execution through `pm-lead`
- print a project bootstrap health summary after installation
- warn when canon/wiki still contain placeholder content that should be replaced with real project state
- replay the existing-project migration advisory once on upgraded installs even if a legacy bootstrap timestamp survives
- upgrade the Claude bootstrap session flag from the old timestamp-only format to the current JSON state format when needed

## v1.2.1 release message

`v1.2.1` should be described as:

- a document-centered workflow harness for long-running AI coding projects
- natural-language first for non-programmers
- orchestrator -> `pm-lead` -> workers internally
- active / fallback skill layering
- project-type specialist checks
- Codex / Claude Code parity with Antigravity role partition support
- session-end auto-sync for `wiki/state.md`, `wiki/log.md`, and `canon/HANDOFF.md`
- Claude statusline and dangerous-command confirmation baseline
- periodic drift audit generation during long-running sessions
- existing-project migration workflow via `migrate-existing-project`
- migration advisory injection in the session brief for projects that already have docs or a prior MoreVibe install
- a compatibility fix that replays the migration advisory once after upgraded installs, even when the old `.session_bootstrapped` flag would otherwise suppress it

## Future release target

Later, MoreVibe can add:

- signed installer builds
- automatic GitHub Actions release packaging
- richer progress reporting and recovery flows
