# Codex Adapter Specification

This document defines how MoreVibe should integrate with Codex.

## Scope

The Codex adapter is responsible for:

- plugin installation into the user's Codex plugin path
- Codex marketplace registration
- project-local `.morevibe/` bootstrap
- minimal Codex-facing project bootstrap text

## Entry Model

### Project entrypoint

- primary project entrypoint: root `AGENTS.md`
- MoreVibe must not replace this file
- MoreVibe may add a minimal bootstrap block or referenced snippet when explicitly requested

### Project-local namespace

- MoreVibe namespace: `.morevibe/`
- purpose: internal project harness for `sources / canon / wiki`

## Global Integration

Current Codex-specific install behavior:

- install plugin to `~/plugins/morevibe`
- ensure `~/.agents/plugins/marketplace.json` contains the `morevibe` entry

Current rule:

- merge marketplace content when possible
- back up before replacement

## Project Integration

### Minimum project bootstrap

Codex projects that adopt MoreVibe should be able to understand:

- that root `AGENTS.md` remains the public entrypoint
- that `.morevibe/` is the MoreVibe-managed namespace
- that `canon` is authoritative over `wiki`

### Preferred integration method

1. Keep the existing root `AGENTS.md`
2. Add a short MoreVibe bootstrap block only if needed
3. Keep detailed rules inside `.morevibe/`

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
