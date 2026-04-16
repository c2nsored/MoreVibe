# MoreVibe Subagent Orchestration

Antigravity does not expose Claude-style custom subagent files.
Apply the MoreVibe team model as a conceptual ownership structure within a single session,
and use `run_command` where MoreVibe scripts are available.

## Team model

| Role | Responsibility | File scope |
|---|---|---|
[TEAM_MODEL_ROWS]

## Ownership rules

- Track which files belong to which role before implementation begins.
- Do not modify files outside the current role's scope without explicit reason.
- Workers report scope creep to the lead role instead of expanding silently.
- One role owns one file at a time within a work unit.

## Orchestration in Antigravity

Since Antigravity runs as a single agent, apply the team model as a mental partitioning strategy:

1. Start as `pm-lead` — restore context from `.morevibe/`, plan the work, decide ownership.
2. [FOCUS_SWITCH_GUIDE]
3. Switch to `qa-reviewer` focus for regression and risk checks before finalizing.
4. Return to `pm-lead` to integrate, update canon/wiki, and report.

Use `run_command` with MoreVibe scripts when available:
- `morevibe/scripts/bootstrap_morevibe_session.py` — restore session context
- `morevibe/scripts/lint_morevibe.py` — check harness for drift
- `morevibe/scripts/sync_morevibe_memory.py` — sync state and log

## When to split work

Even within a single Antigravity session, apply the split when:
- The task touches both frontend and backend boundaries.
- A documentation sync is needed alongside implementation.
- A regression check should happen before the final answer.

[TYPE_SPECIFIC_HINTS]
