# MoreVibe Core Contract

This document defines the minimum shared contract that every MoreVibe adapter must preserve.

## 1. Project Knowledge Model

Every supported tool must preserve these roles:

- `schema`: operating rules for how the harness should be maintained
- `sources`: evidence, inputs, references, logs, and snapshots
- `canon`: the current authoritative project reference
- `wiki`: compiled LLM working memory

## 2. Authority Rules

- `canon` is authoritative over `wiki`
- `wiki` is a working memory layer, not the source of truth
- AI-authored documents can still be part of `canon`
- a rule should have only one authoritative home

## 3. Project Structure Rules

Adapters should preserve this default layout whenever possible:

```text
project-root/
  AGENTS.md
  .morevibe/
    sources/
    canon/
    wiki/
```

## 4. Integration Rules

- keep the project's main public entry file in place
- do not replace project entry files unless explicitly requested
- prefer backup and merge over overwrite
- add only minimal bootstrap text to connect the tool to MoreVibe

## 5. Operating Loop

Every adapter should support the same loop:

1. `ingest`
2. `query`
3. `lint`

Tool-specific workflows may differ, but the core loop must stay compatible.

## 6. Minimum Wiki Files

The default minimum wiki files are:

- `wiki/index.md`
- `wiki/state.md`
- `wiki/log.md`

## 7. Adapter Responsibility Boundary

Adapters are allowed to define:

- tool-specific global config touchpoints
- tool-specific install paths
- tool-specific bootstrap wording
- tool-specific registration mechanics

Adapters must not redefine the core knowledge model.
