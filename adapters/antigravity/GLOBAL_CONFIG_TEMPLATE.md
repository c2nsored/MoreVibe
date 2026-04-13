# Antigravity Global Config Template

Use this as a reference when wiring MoreVibe into Antigravity's global instructions.

## Minimum bootstrap

- If a project contains `.morevibe/`, treat it as a MoreVibe harness namespace.
- Keep the root project guide as the main public entrypoint.
- Prefer `.morevibe/canon/` over `.morevibe/wiki/` when they conflict.
- Use `morevibe-using-morevibe` to route non-trivial work into the right workflow chain.
- At session start, force a MoreVibe bootstrap command through `run_command`.
- Before final reporting, force a MoreVibe lint command through `run_command`.
