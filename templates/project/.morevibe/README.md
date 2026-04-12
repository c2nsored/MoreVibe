# .morevibe

This folder is the project-local namespace managed by MoreVibe.

It exists to help the LLM maintain stable project memory without replacing the project's normal root structure.

Recommended layers:

- `schema/`: MoreVibe-local operating rules
- `sources/`: evidence, references, notes, snapshots
- `canon/`: authoritative project documents
- `wiki/`: compiled working memory for the LLM

Recommended minimum wiki files:

- `wiki/index.md`
- `wiki/state.md`
- `wiki/log.md`
- `schema/README.md`
- `schema/OPERATING_RULES.md`
- `canon/PROJECT_OVERVIEW.md`
- `canon/ARCHITECTURE.md`
- `canon/SCHEMA.md`
- `canon/TASKS.md`
- `canon/DECISIONS.md`
- `canon/HANDOFF.md`
- `canon/OPERATIONS.md`

The project root `AGENTS.md` remains the main entrypoint.

## Rules

- `sources` is for inputs and evidence.
- `canon` is for the current official project reference.
- `wiki` is for compiled memory, summaries, links, and reusable answers.
- `schema` is for MoreVibe-local operating rules.
- `wiki` should not replace `canon`.
- If the same rule appears in two places, one place must be designated authoritative.

## Intended workflow

1. Ingest new material.
2. Update or verify canon when needed.
3. Refresh wiki state, index, and log.
4. Lint for drift and stale memory.
