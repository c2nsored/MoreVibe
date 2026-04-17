# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [1.1.0] - 2026-04-17

### Added
- Session-end auto-sync for `.morevibe/wiki/state.md`, `.morevibe/wiki/log.md`, and `.morevibe/canon/HANDOFF.md`.
- Periodic documentation drift audit generation during long-running sessions.
- Claude statusline baseline so project context is visible without opening schema files.
- Claude dangerous-command confirmation baseline for risky shell actions.
- Reinstall smoke test for preserving existing `canon/` and `wiki/` content.

### Changed
- Lint guidance is now bridged into session-end automation output.
- Installer health checks now verify Claude statusline and permissions baseline.
- Delegation rules now document when not to split work across subagents.

## [1.0.0] - 2026-04-16

### Added
- First stable Windows installer release package for MoreVibe.
- Document-centered `sources / canon / wiki / schema` harness model for long-running AI coding projects.
- Natural-language-first workflow routing for non-programmers.
- Shared native workflow skills plus active / fallback classification in generated schema.
- Project-type specialist presets for `webapp`, `ecommerce`, `blog`, `api`, and `generic`.

### Changed
- Standardized the orchestration model as `main agent -> pm-lead -> workers`.
- Strengthened specialist skills, type-specific checks, and onboarding documentation.
- Improved lint and health reporting around routing, parity, and placeholder detection.

## [0.5.1] - 2026-04-16

### Changed
- Refined repository messaging and product positioning in English and Korean documentation.
- Polished release-facing documentation to better explain the harness model and installation flow.

## [0.5.0] - 2026-04-16

### Added
- First specialist skill expansion layer for review, release, debugging, handoff, onboarding, and drift checks.
- Natural-language routing guidance across project docs and schema files.
- Methodology documents such as `METHOD.md`, `WORKFLOW_MAP.md`, `TEAM_MODEL.md`, `MEMORY_MODEL.md`, and `NON_PROGRAMMER_GUIDE.md`.
- Optional command guidance and stronger non-programmer onboarding examples.

### Changed
- Elevated MoreVibe from a basic installer harness into a more explicit methodology product.
- Improved project-type skill support and quality guardrails around workflow usage.

## [0.4.x] - 2026-04-16

### Added
- Initial Windows installer flow and WPF installer packaging.
- Project-local `.morevibe/` template, `AGENTS.md` bootstrap, and generated schema rendering.
- Codex / Claude Code / Antigravity integration scaffolding.
- Shared project skill installation, native workflow aliases, and project-type role presets.

### Changed
- Generalized project presets away from project-specific custom roles.
- Improved README quality, installer messaging, and release packaging through the 0.4 series.
