# ClaudeCode Adapter Specification

This document defines how MoreVibe should integrate with ClaudeCode.

## Scope

The ClaudeCode adapter is responsible for:

- identifying ClaudeCode's global rule/config entrypoint
- defining how MoreVibe should be referenced from project-level instructions
- keeping `.morevibe/` as the shared project-local namespace
- applying non-destructive bootstrap changes
- wiring project-local memory, slash commands, limited hooks, and subagents

## Entry Model

### Project entrypoint

- primary public project entrypoint should remain the project's existing root guide file
- MoreVibe must not replace the project's existing root instructions
- MoreVibe may add a minimal bootstrap reference when explicitly requested

### Project-local namespace

- MoreVibe namespace: `.morevibe/`
- purpose: shared harness for `schema / sources / canon / wiki`

## Global Integration

ClaudeCode support should eventually define:

- where global AI operating rules live
- how MoreVibe should be referenced from that global context
- how to avoid destructive replacement of existing user rules

Documented Claude Code integration points from official docs include:

- `CLAUDE.md` recursive memory loading
- `.claude/settings.json` hooks
- `.claude/commands/` custom slash commands
- `.claude/agents/` project subagents

Important limitation:

- Claude Code does not expose an official `SessionStart` hook
- therefore `CLAUDE.md` is the primary automatic startup lever for MoreVibe
- session-end automation is still useful and should refresh memory before linting

## Project Integration

ClaudeCode projects that adopt MoreVibe should be able to understand:

- the root project guide remains the public entrypoint
- `.morevibe/` is the internal harness namespace
- `canon` is authoritative over `wiki`
- `morevibe-using-morevibe` is the preferred workflow router when MoreVibe is present
- `/morevibe-start` and `/morevibe-sync` can be used as first-class project commands
- the main Claude session should act as the user-facing orchestrator
- project subagents should follow `pm-lead -> workers -> qa-reviewer`
- startup automation should be expressed in `CLAUDE.md`, not assumed from hooks
- session-end hooks should auto-sync `wiki/state.md`, `wiki/log.md`, and `canon/HANDOFF.md` before the harness is linted
- project settings should expose a short MoreVibe statusline instead of requiring the user to inspect schema files manually
- risky commands such as `git push`, `git reset --hard`, `git clean -f`, and `rm -rf` should default to ask-for-confirmation behavior

## Non-destructive policy

- do not overwrite root project instruction files by default
- do not append duplicate MoreVibe bootstrap text
- do not replace `.morevibe/` unless explicitly requested
- keep backups before destructive replacement

## Current status

This adapter now has project assets that can be installed into:

- `CLAUDE.md`
- `.claude/settings.json`
- `.claude/commands/`
- `.claude/agents/`
