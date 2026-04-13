# MoreVibe for Claude Code

This project uses MoreVibe as an internal harness.

## Startup Rule

- If `.morevibe/` exists, do not begin with broad project rediscovery.
- First read `.morevibe/schema/SESSION_BOOTSTRAP.md`.
- Then read `.morevibe/wiki/state.md`.
- Then follow the `morevibe-start-session` flow before implementation.
- Prefer the root `AGENTS.md` or project guide as the public entrypoint.
- Prefer `.morevibe/canon/` over `.morevibe/wiki/` when they conflict.

## Preferred Flow

1. Restore context through `.morevibe/schema/SESSION_BOOTSTRAP.md`
2. Review `.morevibe/wiki/state.md` and relevant canon docs
3. Route non-trivial work through the MoreVibe workflow
4. Use `/morevibe-start` only as an optional convenience command
5. Use `/morevibe-sync` before wrapping up major work

## Subagent Rule

- Use the `morevibe-orchestrator` subagent for non-trivial work that needs explicit routing
- Use the `morevibe-reviewer` subagent for focused regression and risk review
