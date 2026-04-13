# MoreVibe for Antigravity

This project uses MoreVibe as an internal harness.

## Startup Rule

- If `.morevibe/` exists, restore context from MoreVibe before broad rediscovery.
- Keep the root `AGENTS.md` or project guide as the public entrypoint.
- Prefer `.morevibe/canon/` over `.morevibe/wiki/` when they conflict.

## Lifecycle Rule

- At session start, run the MoreVibe bootstrap command before substantive analysis.
- Before final reporting, run the MoreVibe lint command.

## Command Rule

- Use `run_command` for MoreVibe lifecycle actions.
- Prefer MoreVibe query, ingest, writeback, sync, and lint commands over ad hoc rediscovery.
