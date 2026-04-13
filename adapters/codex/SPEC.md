# Codex Adapter Specification

This document defines how MoreVibe should integrate with Codex.

## Scope

The Codex adapter is responsible for:

- project/global `AGENTS.md` bootstrap for Codex
- project-local `.morevibe/` bootstrap
- plugin installation into the user's Codex plugin path as a delivery helper
- Codex marketplace registration as a delivery helper
- minimal Codex-facing project bootstrap text

## Entry Model

### Project entrypoint

- primary project entrypoint: root `AGENTS.md`
- MoreVibe must not replace this file
- MoreVibe may add a minimal bootstrap block or referenced snippet when installing into a project

### Project-local namespace

- MoreVibe namespace: `.morevibe/`
- purpose: internal project harness for `sources / canon / wiki`

### Global entrypoint

- primary global Codex entrypoint: `~/.codex/AGENTS.md`
- MoreVibe should use this file as the main Codex-wide bootstrap lever
- plugin registration should not be treated as the main startup guarantee

## Global Integration

Current Codex-specific install behavior:

- append a MoreVibe bootstrap block to `~/.codex/AGENTS.md`
- install plugin to `~/plugins/morevibe`
- ensure `~/.agents/plugins/marketplace.json` contains the `morevibe` entry

Current rule:

- merge marketplace content when possible
- back up before replacement
- prefer `AGENTS.md` bootstrap over plugin-only discovery

## Project Integration

### Minimum project bootstrap

Codex projects that adopt MoreVibe should be able to understand:

- that root `AGENTS.md` remains the public entrypoint
- that `.morevibe/` is the MoreVibe-managed namespace
- that `canon` is authoritative over `wiki`

### Preferred integration method

1. Keep the existing root `AGENTS.md`
2. Add a short MoreVibe bootstrap block during installation
3. Keep detailed rules inside `.morevibe/`
4. Treat plugin assets as supporting Codex-specific delivery only

## Non-destructive policy

- do not overwrite root `AGENTS.md` by default
- do not append duplicate bootstrap blocks
- do not replace `.morevibe/` unless the user explicitly allows it
- keep backups before destructive replacement

## Planned automation

Planned Codex adapter automation should eventually support:

- detecting whether `AGENTS.md` already references MoreVibe
- inserting a minimal bootstrap block once
- skipping duplicate inserts
- reporting exactly what was changed
- keeping global/project `AGENTS.md` as the main default startup path
- using plugin-provided skills/scripts to support that path rather than replace it
