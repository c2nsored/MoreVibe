---
name: morevibe-bootstrap
description: Bootstrap the MoreVibe harness for a project by separating sources, canon, and wiki responsibilities.
---

# MoreVibe Bootstrap

## Goal

Set up a project so the LLM can operate with a stable harness:

- `sources` for evidence and inputs
- `canon` for authoritative project documents
- `wiki` for compiled LLM working memory

## Rules

- Keep authoritative rules in the project root `AGENTS.md`.
- Do not move or replace the root `AGENTS.md`.
- Treat `.morevibe/` as the plugin-managed namespace when the project adopts MoreVibe.
- Keep `sources`, `canon`, and `wiki` as separate layers.
- Do not duplicate the same rule as authoritative text in more than one place.

## Minimum bootstrap output

1. Confirm the project's authoritative entrypoint.
2. Create or verify the MoreVibe namespace.
3. Define what belongs in `sources`, `canon`, and `wiki`.
4. Add or update an index and current state file for the wiki.
5. Record the bootstrap action in the MoreVibe log.
