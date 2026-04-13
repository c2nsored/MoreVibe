# Subagent Orchestration

Use this file to keep multi-agent work safe and predictable.

## Default team model

| Role | Agent name | Responsibility |
|---|---|---|
| Team lead | `pm-lead` | Planning, delegation, integration, reporting, canon/wiki sync |
| Frontend | `frontend-worker` | UI, pages, components, layout |
| Backend | `backend-worker` | API routes, server logic, DB, integrations |
| Reviewer | `qa-reviewer` | Read-only regression, risk, and documentation gaps |

Customize agent names and file ownership to match your project's domain.
For domain-specific splits (e.g. payments vs. orders), add new worker agents and update `pm-lead` tools list.

## Orchestration rules

- Main agent (`pm-lead`) orchestrates, plans, integrates, and reports.
- Worker agents own a specific file range or subsystem — defined in each agent's `Focus on:` section.
- `qa-reviewer` is read-only by default.
- Do not assign the same file to multiple agents at the same time.
- Delegate only when parallel work genuinely helps — do not split trivial tasks.
- Record ownership before implementation begins.
- Final integration and reporting always stay with the main agent.

## When to scale the team

Add a new worker agent when:
- A domain is large enough that a single worker would own too many unrelated files.
- Parallel implementation would significantly reduce total work time.
- A new specialized role (e.g. infra, data pipeline) has no overlap with existing workers.

Remove or merge worker agents when:
- A domain is too small to justify a dedicated agent.
- Ownership boundaries are causing confusion rather than clarity.

## File ownership rules

- One agent owns one file at a time.
- If ownership is unclear, the lead decides before delegation begins.
- Workers report scope creep to the lead instead of silently expanding ownership.
