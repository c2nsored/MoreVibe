# MoreVibe

[English](./README.md) | [한국어](./README.ko.md)

MoreVibe is a personal LLM harness plugin for better vibe coding across any project.

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

Instead, Codex is the first implemented adapter, while ClaudeCode and Antigravity are planned adapter targets.

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

MoreVibe is currently in early scaffolding.

This repository already includes:

- a Codex-oriented plugin manifest
- a reusable MoreVibe skill set
- a Windows installer starting point
- a project template namespace for `.morevibe/`
- a core/adapters architecture baseline
- a main workflow entry skill and skill-routing schema
- ClaudeCode and Antigravity adapter scaffolds

## Repository Layout

```text
plugin/        # The installable MoreVibe plugin
installer/     # Installation scripts and packaging entrypoints
templates/     # Project bootstrap templates used by MoreVibe
core/          # Tool-agnostic MoreVibe harness model
adapters/      # Tool-specific integration guidance
```

## What Is Automated vs Not Yet Automated

Already implemented:

- local Codex-style plugin installation
- marketplace registration merge/update
- project-local `.morevibe/` bootstrap
- optional safe insertion of a MoreVibe bootstrap block into project `AGENTS.md`
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
- Antigravity project integration assets for `GEMINI.md`, `.agents/rules/`, and CLI-driven lifecycle commands

Partially automated:

- write-back of reusable answers into `wiki/outputs/` through a dedicated script and skill
- repeatable harness lint reports into `wiki/lint/` through a dedicated script and skill
- adapter export packages for ClaudeCode and Antigravity from the installer

Documented but not yet fully automatic:

- patching tool-specific global config files in-place
- guaranteed tool-level auto-triggering without adapter support

## Project Integration Model

MoreVibe should not replace the project's root `AGENTS.md`.

Instead, the intended integration model is:

- keep the root `AGENTS.md` as the standard entrypoint used by agent tools
- install MoreVibe as a reusable plugin
- use `.morevibe/` inside each project as the plugin-managed namespace

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
3. Install the plugin into the user's local Codex plugin directory.
4. Enable MoreVibe in projects without manual setup.

## Current Windows Installer

The current installer entrypoint is:

```powershell
installer/windows/install-morevibe.ps1
```

For easier Windows usage, a batch launcher is also provided:

```text
installer/windows/install-morevibe.bat
```

Basic usage:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1
```

Install the plugin and also bootstrap a project-local `.morevibe/` folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1 -ProjectPath "C:\path\to\project"
```

Install the plugin, bootstrap `.morevibe/`, and add the MoreVibe bootstrap block to the project's root `AGENTS.md`:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1 -ProjectPath "C:\path\to\project" -ApplyProjectAgentsBootstrap
```

If a project already has a `.morevibe/` folder and you intentionally want to replace it:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1 -ProjectPath "C:\path\to\project" -ForceProjectTemplate
```

The installer currently:

- installs the MoreVibe plugin into `~/plugins/morevibe`
- creates or updates `~/.agents/plugins/marketplace.json`
- backs up an existing plugin directory before replacing it
- backs up the current marketplace file before writing updates
- bootstraps `.morevibe/` into a project when `-ProjectPath` is provided
- appends the MoreVibe bootstrap block to the project's root `AGENTS.md` when `-ProjectPath` is provided
- appends the MoreVibe global bootstrap block to Codex global `AGENTS.md` when a Codex home `AGENTS.md` exists
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

- Current primary implementation target
- Uses the current local plugin structure in `plugin/`
- Assumes the project root `AGENTS.md` remains the standard entrypoint

### ClaudeCode

- Official Claude Code integration points are wired into the adapter
- Installer can create project `CLAUDE.md` memory import, `.claude/settings.json` stop hook, custom commands, and project agents
- Installer can also create a Claude global bootstrap in `~/.claude/CLAUDE.md`

### Antigravity

- Installer can create project `GEMINI.md`, `.agents/rules/`, and `.agents/morevibe/scripts/`
- Installer can also create a Gemini global bootstrap in `~/.gemini/GEMINI.md`
- Integration uses rule injection and `run_command`-driven lifecycle behavior instead of native hooks

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
- project-local `.morevibe/`
- plugin marketplace and registration files

## Current Next Steps

1. Add deeper tool-specific automatic triggering where the host supports it.
2. Turn adapter exports into tool-specific in-place installers when those hosts are fully confirmed.
