# MoreVibe for Claude Code

This project uses MoreVibe as an internal harness.

## Startup Rule

- If `.morevibe/` exists, start by restoring context from MoreVibe before broad project rediscovery.
- Prefer the root `AGENTS.md` or project guide as the public entrypoint.
- Prefer `.morevibe/canon/` over `.morevibe/wiki/` when they conflict.

## Preferred Flow

1. Use `/morevibe-start`
2. Review `.morevibe/wiki/state.md` and relevant canon docs
3. Route non-trivial work through the MoreVibe workflow
4. Use `/morevibe-sync` before wrapping up major work

## Subagent Rule

- Use the `morevibe-orchestrator` subagent for non-trivial work that needs explicit routing
- Use the `morevibe-reviewer` subagent for focused regression and risk review
