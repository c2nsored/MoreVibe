# Antigravity Adapter Specification

This document defines how MoreVibe should integrate with Antigravity.

## Scope

The Antigravity adapter is responsible for:

- identifying Antigravity's global rule/config entrypoint
- defining how MoreVibe should be referenced from project-level instructions
- keeping `.morevibe/` as the shared project-local namespace
- applying non-destructive bootstrap changes

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

## Project Integration

Antigravity projects that adopt MoreVibe should be able to understand:

- the root project guide remains the public entrypoint
- `.morevibe/` is the internal harness namespace
- `canon` is authoritative over `wiki`
- `morevibe-using-morevibe` is the preferred workflow router when MoreVibe is present

## Non-destructive policy

- do not overwrite root project instruction files by default
- do not append duplicate MoreVibe bootstrap text
- do not replace `.morevibe/` unless explicitly requested
- keep backups before destructive replacement

## Current status

This adapter is documented but not yet implemented as an installer.
