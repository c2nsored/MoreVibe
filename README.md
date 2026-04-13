# MoreVibe

[English](./README.md) | [한국어](./README.ko.md)

MoreVibe is a personal LLM harness system for better vibe coding across any project.

It is designed for a workflow where the user may not be a programmer and delegates most structure, writing, and maintenance work to AI.

MoreVibe helps LLM agents work with a stable project memory model:

- `sources`: evidence, references, notes, snapshots
- `canon`: authoritative project documents
- `wiki`: compiled LLM working memory

The point is not to build a human-facing wiki first.

The point is to give the LLM a reliable internal harness so knowledge compounds across sessions instead of being rediscovered from scratch every time.

## Core Model

MoreVibe separates project knowledge into four roles:

- `schema`: the operating rules that tell the LLM how to read, write, and maintain the harness
- `sources`: mostly immutable inputs and evidence
- `canon`: the current authoritative project documents, even if they are written by AI
- `wiki`: the LLM-maintained memory layer built from sources and canon

These roles are separated by function, not by who wrote the files.

An AI-written document can still be part of `canon` if it is the project's current official reference.

## Core + Adapters

MoreVibe is structured around two layers:

- `core`: the shared harness model that should work across different agent tools
- `adapters`: tool-specific integration layers for Codex, ClaudeCode, and Antigravity

The core should stay stable across project types such as web apps, games, tools, and automation systems.

Adapters are responsible for tool-specific behavior such as:

- where global rules live
- how project entrypoints are discovered
- how installation should modify user-level config
- how MoreVibe should attach to a project without overwriting existing files

This means MoreVibe should not be treated as "Codex only".

Codex was the first implemented adapter. ClaudeCode and Antigravity adapters are now also implemented.

## Why MoreVibe Exists

Most LLM workflows behave like ad hoc retrieval:

- upload some files
- ask a question
- retrieve fragments
- repeat the synthesis every time

MoreVibe is built around a different idea:

- keep the project's evidence
- maintain an authoritative current canon
- let the LLM compile persistent working memory
- keep that memory healthy through repeated maintenance

This makes long-running vibe-coding projects easier to resume, steer, and evolve.

## Standard Operating Loop

MoreVibe is built around three recurring operations:

1. `ingest`
Bring new information into the harness, classify it, and update the wiki.

2. `query`
Answer questions from the wiki first, then fall back to canon and sources when needed. Valuable answers should be written back into the harness.

3. `lint`
Check the harness for drift, outdated claims, duplication, missing links, and canon/wiki mismatch.

## Status

MoreVibe is currently an active early-stage harness system.

This repository already includes:

- host-native bootstrap rules for Codex, Claude Code, and Antigravity
- a Codex-oriented plugin manifest used as a delivery helper
- a reusable MoreVibe skill set
- a Windows installer starting point
- a WPF installer UI scaffold for beginner-friendly Windows setup
- a project template namespace for `.morevibe/`
- a core/adapters architecture baseline
- a main workflow entry skill and skill-routing schema
- ClaudeCode and Antigravity adapter scaffolds

## Repository Layout

```text
core/          # Tool-agnostic MoreVibe harness model
adapters/      # Tool-specific integration guidance
templates/     # Project bootstrap templates used by MoreVibe
installer/     # Installation scripts and packaging entrypoints
installer-ui/  # WPF Windows installer UI scaffold
plugin/        # Codex delivery helper for skills/scripts/manifest
```

## What Is Automated vs Not Yet Automated

Already implemented:

- project-local `.morevibe/` bootstrap
- automatic project `AGENTS.md` bootstrap when `-ProjectPath` is provided
- automatic Codex global `AGENTS.md` bootstrap
- automatic Claude project `CLAUDE.md` bootstrap and global `CLAUDE.md` bootstrap
- automatic Antigravity project `GEMINI.md` bootstrap and global `GEMINI.md` bootstrap
- local Codex-style plugin installation as a delivery helper
- marketplace registration merge/update for Codex environments
- backup before replacement for current installer targets
- reusable workflow skills for planning, execution, review, verification, docs, handoff, deployment, and delegation
- default `.morevibe/schema/`, `.morevibe/canon/`, and `.morevibe/wiki/` starter documents
- a main MoreVibe workflow router for feature, bug, and document task chains
- a session memory sync script and skill for state, log, and handoff updates
- scripted ingest into `sources` or `canon`
- scripted harness query reports from `wiki`, `canon`, and `sources`
- scripted session bootstrap briefs from the harness
- subagent orchestration guidance and schema
- Claude Code project integration assets for `CLAUDE.md`, `.claude/settings.json`, commands, and agents
- automatic Claude Code `UserPromptSubmit` hook registration for session-start context bootstrap with per-session TTL guard
- Antigravity project integration assets for `GEMINI.md`, `.agents/rules/`, and CLI-driven lifecycle commands

Partially automated:

- write-back of reusable answers into `wiki/outputs/` through a dedicated script and skill
- repeatable harness lint reports into `wiki/lint/` through a dedicated script and skill
- adapter export packages for ClaudeCode and Antigravity from the installer

Documented but not yet fully automatic:

- guaranteed tool-level auto-triggering for Codex and Antigravity beyond what each host officially supports
- host behaviors that depend on the tool always honoring project/global rule files in the same way

## Project Integration Model

MoreVibe should not replace the project's root `AGENTS.md`.

Instead, the intended integration model is:

- keep the root `AGENTS.md` as the standard entrypoint used by agent tools
- use `.morevibe/` inside each project as the MoreVibe-managed namespace
- treat installer-added plugin assets as secondary delivery helpers, not the primary source of authority

Recommended project-local layout:

```text
project-root/
  AGENTS.md
  .morevibe/
    schema/
    sources/
    canon/
    wiki/
```

This avoids collisions with common project folders such as `src`, `docs`, or `sources`.

## Layer Rules

- `schema` stores MoreVibe-local operating rules.
- `sources` stores evidence, external material, notes, snapshots, and raw inputs.
- `canon` stores the project's current official reference documents.
- `wiki` stores the LLM's compiled internal memory and cross-linked summaries.
- The same rule should not be authoritative in more than one place.
- If `wiki` conflicts with `canon`, update or inspect `canon` first.
- If `canon` was generated by AI, it is still canon if the project treats it as official.

## Intended Installation Model

The long-term goal is simple installation for non-technical users:

1. Download MoreVibe from GitHub Releases.
2. Run the installer.
3. Let the installer wire the host-native rule files and project-local `.morevibe/`.
4. Start working in the project without manually rebuilding the harness structure.

## Current Windows GUI Installer (Recommended)

For Windows users, we now provide an intuitive **WPF-based GUI installer**.
You can download `MoreVibeInstaller.exe` from the [GitHub Releases](https://github.com/c2nsored/MoreVibe/releases/latest) page. Just run it, and you can finish the installation and project bootstrap with a few clicks.

## Script-based Installation

If you prefer the terminal, you can use the raw PowerShell script.

The current script installer entrypoint is:

```powershell
installer/windows/install-morevibe.ps1
```

For easier Windows usage, a batch launcher is also provided:

```text
installer/windows/install-morevibe.bat
```

When launched by double-click, the batch installer now:

- shows a basic installation guide
- asks whether to continue
- lets the user choose Codex, Claude Code, Antigravity, or all targets
- asks for an optional real project root path after target selection
- keeps the console open so success or failure is visible

Basic usage:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1
```

Install MoreVibe and also bootstrap a project-local `.morevibe/` folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1 -ProjectPath "C:\path\to\project"
```

Install MoreVibe for a project. This bootstraps `.morevibe/` and also updates the project's root `AGENTS.md` automatically:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1 -ProjectPath "C:\path\to\project"
```

If a project already has a `.morevibe/` folder and you intentionally want to replace it:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1 -ProjectPath "C:\path\to\project" -ForceProjectTemplate
```

The installer currently:

- bootstraps `.morevibe/` into a project when `-ProjectPath` is provided
- appends the MoreVibe bootstrap block to the project's root `AGENTS.md` when `-ProjectPath` is provided
- appends the MoreVibe global bootstrap block to Codex global `AGENTS.md`
- appends the MoreVibe bootstrap block to project and global Claude memory files
- appends the MoreVibe bootstrap block to project and global Gemini rule files
- installs the MoreVibe Codex plugin into `~/plugins/morevibe` as a delivery helper
- creates or updates `~/.agents/plugins/marketplace.json` for Codex environments
- backs up an existing plugin directory before replacing it
- backs up the current marketplace file before writing updates
- can export adapter packages for ClaudeCode and Antigravity

## Included Skill Set

Current MoreVibe skills include:

- using-morevibe
- bootstrap
- start session
- plan feature
- execute plan
- debug bug
- delegate work
- request review
- apply review fixes
- verify change
- update docs
- update handoff
- finish task
- report deployment
- sync memory
- ingest item
- query harness
- session brief
- orchestrate subagents
- write back answer
- lint harness
- test first

## Adapter Strategy

### Codex

- Uses `~/.codex/AGENTS.md` and project `AGENTS.md` as the primary startup lever
- Uses `.morevibe/` as the project-local harness namespace
- Uses `plugin/` and marketplace registration as secondary delivery helpers for Codex-specific assets

### ClaudeCode

- Uses project/global `CLAUDE.md` as the primary startup lever
- Uses `.claude/commands`, `.claude/agents`, `UserPromptSubmit` hooks, and `Stop` hooks as supporting integration assets
- Installer can create project `CLAUDE.md`, `.claude/settings.json`, commands, agents, and global bootstrap

### Antigravity

- Uses project/global `GEMINI.md` as the primary startup lever
- Uses `.agents/rules/` and `run_command`-driven lifecycle behavior as supporting integration assets
- Installer can create project `GEMINI.md`, `.agents/rules/`, `.agents/morevibe/scripts/`, and global bootstrap

## Safe Installation Principle

MoreVibe should follow a strict non-destructive installation rule:

- do not overwrite existing project entry files without explicit intent
- do not replace user config blindly
- back up before replacing
- merge when possible
- add only the minimum bootstrap needed for the target tool

This principle applies to:

- global user-level agent config
- project root `AGENTS.md`
- project root `CLAUDE.md`
- project root `GEMINI.md`
- project-local `.morevibe/`
- plugin marketplace and registration files

## Current Next Steps

1. Add deeper tool-specific automatic triggering where the host supports it.
2. Turn adapter exports into tool-specific in-place installers when those hosts are fully confirmed.
