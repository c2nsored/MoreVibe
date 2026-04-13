# ClaudeCode Global Config Template

Use this as a reference when wiring MoreVibe into ClaudeCode's global instructions.

## Minimum bootstrap

- If a project contains `.morevibe/`, treat it as a MoreVibe harness namespace.
- Keep the root project guide as the main public entrypoint.
- Prefer `.morevibe/canon/` over `.morevibe/wiki/` when they conflict.
- Use `morevibe-using-morevibe` to route non-trivial work into the right workflow chain.
- Prefer project hooks and slash commands that restore MoreVibe context at session start.
