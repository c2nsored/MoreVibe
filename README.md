# MoreVibe

MoreVibe is a personal LLM harness plugin for better vibe coding across any project.

It helps LLM agents work with a stable project memory model:

- `sources`: evidence, references, notes, snapshots
- `canon`: authoritative project documents
- `wiki`: compiled LLM working memory

## Status

MoreVibe is currently in early scaffolding.

This repository already includes:

- a Codex plugin manifest
- an initial bootstrap skill
- a Windows installer starting point
- a project template namespace for `.morevibe/`

## Repository Layout

```text
plugin/        # The installable MoreVibe plugin
installer/     # Installation scripts and packaging entrypoints
templates/     # Project bootstrap templates used by MoreVibe
```

## Intended Installation Model

The long-term goal is simple installation for non-technical users:

1. Download MoreVibe from GitHub Releases.
2. Run the installer.
3. Install the plugin into the user's local Codex plugin directory.
4. Enable MoreVibe in projects without manual setup.

## Current Next Steps

1. Finalize the plugin manifest and bootstrap workflow.
2. Build a working Windows installer.
3. Define the `.morevibe/` project template.
4. Add ingest, query, and lint skills.
