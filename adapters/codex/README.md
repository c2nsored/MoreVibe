# Codex Adapter

Codex is the first active MoreVibe adapter.

## Current assumptions

- the project root `AGENTS.md` is the standard project entrypoint
- the global `~/.codex/AGENTS.md` file is the strongest global bootstrap lever
- project-local MoreVibe data lives in `.morevibe/`
- plugin and marketplace assets are secondary delivery helpers

## Current implementation status

- installable plugin manifest exists in `plugin/.codex-plugin/plugin.json`
- bootstrap skill exists in `plugin/skills/morevibe-bootstrap/`
- Windows installer can install the local plugin, bootstrap `.morevibe/`, create or update project `AGENTS.md`, install default project skills, and install project-local `.codex/` files
- adapter specification exists in `SPEC.md`
- bootstrap snippet templates exist in `snippets/`

## Adapter rules

- keep root `AGENTS.md` in place
- treat project/global `AGENTS.md` as the primary startup path
- add only minimal MoreVibe bootstrap instructions when needed
- prefer backup and merge over overwrite
- treat plugin assets as support for Codex delivery, not as the main authority

## Documents

- `SPEC.md`: Codex adapter behavior contract
- `snippets/project-agents-bootstrap.md`: minimal project-level insertion text
- `snippets/global-bootstrap.md`: minimal global-level bootstrap text
- `project/config.toml`: default project-local Codex config template
- `project/agents/*.toml`: default project-local Codex role templates
