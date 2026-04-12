# Codex Adapter

Codex is the first active MoreVibe adapter.

## Current assumptions

- the project root `AGENTS.md` is the standard project entrypoint
- a local plugin can be installed through the Codex plugin structure
- project-local MoreVibe data lives in `.morevibe/`

## Current implementation status

- installable plugin manifest exists in `plugin/.codex-plugin/plugin.json`
- bootstrap skill exists in `plugin/skills/morevibe-bootstrap/`
- Windows installer can install the local plugin and bootstrap `.morevibe/`

## Adapter rules

- keep root `AGENTS.md` in place
- add only minimal MoreVibe bootstrap instructions when needed
- prefer backup and merge over overwrite
