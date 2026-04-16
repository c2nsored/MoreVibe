---
name: morevibe-orchestrate-subagents
description: Apply MoreVibe's orchestrator-first subagent model so planning, ownership, and integration stay coherent.
---

# MoreVibe Orchestrate Subagents

## Goal

Use subagents in a structured way instead of treating them as ad hoc helpers.

## Model

- The main user-facing agent is the orchestrator.
- `pm-lead` is the internal team lead.
- workers own scoped execution.
- `qa-reviewer` is a read-only reviewer when available.

## Default team

| Role | Agent | Default file scope |
|---|---|---|
| Team lead | `pm-lead` | All — plans, routes, and integrates; does not own files directly |
| Frontend | `frontend-worker` | UI, pages, components, layout |
| Backend | `backend-worker` | API, server logic, DB, integrations |
| Reviewer | `qa-reviewer` | Read-only — regressions, risks, doc gaps |

Rename or extend agents to match your project's domain structure.
Agent definitions live in `.claude/agents/` — customize the `Focus on:` section in each worker file.

## Action

1. Confirm the task is large enough to justify delegation.
2. Let the main agent interpret the user request and hand execution planning to `pm-lead`.
3. Let `pm-lead` decide whether to work directly or route implementation to workers.
4. Identify which agents own which file ranges for this task.
5. Confirm there is no file ownership overlap.
6. Record the ownership split before implementation begins.
7. Route implementation to workers only after the plan is stable.
8. Collect worker outputs and integrate them through `pm-lead`.
9. Run `qa-reviewer` before finalizing.
10. Keep final documentation sync and user-facing reporting with the main agent.

## Completion criteria

1. Delegation was justified by task size or parallelism benefit.
2. File ownership is non-overlapping and recorded.
3. Orchestrator, lead, worker, and reviewer responsibilities are explicit.
4. Canon/wiki updated after integration is complete.
