# MoreVibe Core

The `core` layer defines the tool-agnostic MoreVibe contract.

It should remain valid across:

- Codex
- ClaudeCode
- Antigravity
- future agent tools

## Responsibilities

- define the `sources / canon / wiki / schema` model
- define the `ingest / query / lint` operating loop
- define non-destructive integration rules
- define what `.morevibe/` means inside a project

## Non-goals

- tool-specific installer behavior
- tool-specific global config paths
- tool-specific plugin manifest details

Those belong in `adapters/`.
