# Antigravity Adapter Specification

This document defines how MoreVibe should integrate with Antigravity.

## Scope

The Antigravity adapter is responsible for:

- identifying Antigravity's global rule/config entrypoint
- defining how MoreVibe should be referenced from project-level instructions
- keeping `.morevibe/` as the shared project-local namespace
- applying non-destructive bootstrap changes
- using Antigravity's global rules and CLI execution model to simulate lifecycle hooks

## Entry Model

### Project entrypoint

- primary public project entrypoint should remain the project's existing root guide file
- MoreVibe must not replace the project's existing root instructions
- MoreVibe may add a minimal bootstrap reference when explicitly requested

### Project-local namespace

- MoreVibe namespace: `.morevibe/`
- purpose: shared harness for `schema / sources / canon / wiki`

## Global Integration

Antigravity support should eventually define:

- where global AI operating rules live
- how MoreVibe should be referenced from that global context
- how to avoid destructive replacement of existing user rules

Current confirmed integration assumptions are:

- global rules can be injected through `~/.gemini/GEMINI.md`
- CLI execution can be enforced through rule text that instructs `run_command`
- project-local rules can be scaffolded under `.agents/rules/`

## Project Integration

Antigravity projects that adopt MoreVibe should be able to understand:

- the root project guide remains the public entrypoint
- `.morevibe/` is the internal harness namespace
- `canon` is authoritative over `wiki`
- `morevibe-using-morevibe` is the preferred workflow router when MoreVibe is present
- lifecycle behavior should be driven through `run_command` rules for session start and session end
- `.agents/rules/` can act as a project-local skill/subagent surrogate

## Non-destructive policy

- do not overwrite root project instruction files by default
- do not append duplicate MoreVibe bootstrap text
- do not replace `.morevibe/` unless explicitly requested
- keep backups before destructive replacement

## Current status

This adapter now has project assets that can be installed into:

- `~/.gemini/GEMINI.md`
- project `GEMINI.md`
- `.agents/rules/`
- `.agents/morevibe/scripts/`
