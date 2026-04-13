# MoreVibe for Antigravity

This project uses MoreVibe as an internal harness.

## Startup Rule

- If `.morevibe/` exists, restore context from MoreVibe before broad rediscovery.
- Keep the root `AGENTS.md` or project guide as the public entrypoint.
- Read `.morevibe/schema/PROJECT_SKILLS.md` to determine the real project skill and role chain.
- Prefer `.morevibe/canon/` over `.morevibe/wiki/` when they conflict.

## Lifecycle Rule

- At session start, run the MoreVibe bootstrap command before substantive analysis.
- Before final reporting, run the MoreVibe lint command.

## Command Rule

- Use `run_command` for MoreVibe lifecycle actions.
- Prefer the detected project-native workflow recorded in `.morevibe/schema/PROJECT_SKILLS.md`.
- Fall back to generic MoreVibe helper commands only when the project does not define a native equivalent.
