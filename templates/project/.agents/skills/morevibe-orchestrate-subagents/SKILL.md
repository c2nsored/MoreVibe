---
name: morevibe-orchestrate-subagents
description: Apply MoreVibe's orchestrator-first subagent model so planning, ownership, and integration stay coherent.
---

# MoreVibe Orchestrate Subagents

## Goal

Use subagents in a structured way instead of treating them as ad hoc helpers.

## Default team

| Role | Agent | Default file scope |
|---|---|---|
| Lead | `pm-lead` | All — orchestrates, does not own files directly |
| Frontend | `frontend-worker` | UI, pages, components, layout |
| Backend | `backend-worker` | API, server logic, DB, integrations |
| Reviewer | `qa-reviewer` | Read-only — regressions, risks, doc gaps |

Rename or extend agents to match your project's domain structure.
Agent definitions live in `.claude/agents/` — customize the `Focus on:` section in each worker file.

## Action

1. Confirm the task is large enough to justify delegation.
2. Identify which agents own which file ranges for this task.
3. Confirm there is no file ownership overlap.
4. Record the ownership split before implementation begins.
5. Route implementation to workers only after the plan is stable.
6. Collect worker outputs and integrate them in the main thread.
7. Run `qa-reviewer` before finalizing.
8. Keep final integration, documentation sync, and reporting with the main agent.

## Completion criteria

1. Delegation was justified by task size or parallelism benefit.
2. File ownership is non-overlapping and recorded.
3. Review and integration responsibilities are explicit.
4. Canon/wiki updated after integration is complete.
