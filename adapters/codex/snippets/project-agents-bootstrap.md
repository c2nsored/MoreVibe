## MoreVibe Bootstrap

This project uses MoreVibe as a project-local harness.

- Keep the root `AGENTS.md` as the main public entrypoint.
- Treat `.morevibe/` as the MoreVibe-managed namespace.
- Treat `.morevibe/canon/` as authoritative over `.morevibe/wiki/`.
- At session start, prefer `morevibe-session-brief` and `morevibe-query-harness` before broad re-reading.
- Use `.morevibe/wiki/state.md` and `.morevibe/wiki/index.md` as the first internal MoreVibe navigation points when relevant.
- Use `morevibe-using-morevibe` as the main MoreVibe entry skill before implementation.
- Use `morevibe-orchestrate-subagents` when the task is large enough for explicit delegation.
- Route non-trivial work through the MoreVibe workflow chain instead of jumping straight into coding.

## Team Structure

| Agent | Role | File scope |
|---|---|---|
| **pm-lead** | Orchestrator — planning, delegation, integration, canon/wiki sync | All files — does not own files directly |
| **frontend-worker** | Frontend UI, pages, components, layout | Frontend directories (customize per project) |
| **backend-worker** | Backend API, server logic, DB, integrations | Backend directories (customize per project) |
| **qa-reviewer** | Read-only regression, risk, and documentation gap checks | All files — read-only |

Customize agent names and file ownership to match your project's domain.
For domain-specific splits (e.g. payments vs. orders), add new worker agents and update the team table.

### File ownership rules
- One agent owns one file at a time.
- Workers report scope creep to the lead instead of silently expanding ownership.
- Do not assign the same file to multiple agents in the same work unit.
