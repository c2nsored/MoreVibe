# MoreVibe for Claude Code

This project uses MoreVibe as an internal harness.

## Startup Rule

- If `.morevibe/` exists, do not begin with broad project rediscovery.
- First read `.morevibe/schema/SESSION_BOOTSTRAP.md`.
- Then read `.morevibe/schema/PROJECT_SKILLS.md`.
- Then read `.morevibe/wiki/state.md`.
- Prefer the root `AGENTS.md` or project guide as the public entrypoint.
- Prefer `.morevibe/canon/` over `.morevibe/wiki/` when they conflict.

## Preferred Flow

1. Restore context through `.morevibe/schema/SESSION_BOOTSTRAP.md`
2. Review `.morevibe/schema/PROJECT_SKILLS.md` for the real project skill chain
3. Review `.morevibe/wiki/state.md` and relevant canon docs
4. Route non-trivial work through the detected project-native workflow
5. Use `/morevibe-start` only as an optional convenience command
6. Use `/morevibe-sync` before wrapping up major work

## Subagent Rule

- Use the project's actual agent names when `.claude/agents/*` defines them.
- Fall back to MoreVibe helper agents only when the project does not define a native role model.
