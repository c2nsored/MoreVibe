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
- adapter specification exists in `SPEC.md`
- bootstrap snippet templates exist in `snippets/`

## Adapter rules

- keep root `AGENTS.md` in place
- add only minimal MoreVibe bootstrap instructions when needed
- prefer backup and merge over overwrite

## Documents

- `SPEC.md`: Codex adapter behavior contract
- `snippets/project-agents-bootstrap.md`: minimal project-level insertion text
- `snippets/global-bootstrap.md`: minimal global-level bootstrap text
