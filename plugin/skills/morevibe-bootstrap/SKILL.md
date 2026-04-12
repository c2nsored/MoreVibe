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

The goal is not to create a human-first wiki.

The goal is to give the LLM a persistent internal memory layer that can survive long-running work across many sessions.

## When to use

- when a project is starting to accumulate rules, docs, logs, references, or decisions
- when the user wants the AI to maintain project memory instead of manually curating everything
- when the user wants a reusable harness that can work for web, game, app, automation, or mixed projects

## Knowledge model

Separate knowledge by role, not authorship:

- `sources`: evidence, references, captured inputs, logs, snapshots, external materials
- `canon`: the current official project reference, even if written by AI
- `wiki`: the compiled LLM memory layer
- `schema`: the operating rules that explain how MoreVibe should maintain the other layers

The project's root `AGENTS.md` remains the standard public entrypoint.

The project-local `.morevibe/` namespace is where MoreVibe organizes its internal layers.

## Rules

- Keep authoritative rules in the project root `AGENTS.md`.
- Do not move or replace the root `AGENTS.md`.
- Treat `.morevibe/` as the plugin-managed namespace when the project adopts MoreVibe.
- Keep `sources`, `canon`, and `wiki` as separate layers.
- Do not duplicate the same rule as authoritative text in more than one place.
- `canon` must not be treated as "human-maintained only".
- `wiki` must not be treated as the authoritative source of truth.
- If `wiki` and `canon` disagree, inspect and repair `canon` first.

## Operating loop

### Ingest

- classify new material into `sources` or `canon`
- update `wiki` summaries, links, and state
- note contradictions or missing canon updates

### Query

- answer from `wiki` first when possible
- fall back to `canon` and `sources` when the wiki is insufficient
- preserve valuable answers in `wiki` instead of losing them in chat history

### Lint

- check for drift between `wiki` and `canon`
- detect duplicate or conflicting summaries
- detect stale state, missing links, and gaps in coverage

## Minimum bootstrap output

1. Confirm the project's authoritative entrypoint.
2. Create or verify the project-local `.morevibe/` namespace.
3. Define what belongs in `sources`, `canon`, and `wiki`.
4. Add or update at least:
   - `wiki/index.md`
   - `wiki/state.md`
   - `wiki/log.md`
5. Record the bootstrap action in the MoreVibe log.
6. Explain to the user which existing project documents count as canon.
