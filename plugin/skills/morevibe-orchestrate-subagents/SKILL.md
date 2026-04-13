---
name: morevibe-orchestrate-subagents
description: Apply MoreVibe's orchestrator-first subagent model so planning, ownership, and integration stay coherent.
---

# MoreVibe Orchestrate Subagents

## Goal

Use subagents in a structured way instead of treating them as ad hoc helpers.

## Model

- Main agent: user-facing orchestrator
- Planning agent: optional task splitter and ownership planner
- Worker agents: file- or subsystem-scoped executors
- Review agent: read-only regression and risk checker when possible

## Action

1. Confirm the task is large enough to justify delegation.
2. Split ownership by files or subsystems.
3. Record the ownership split in the current working notes or response.
4. Route implementation to workers only after the plan is stable.
5. Keep final integration and reporting with the main agent.

## Completion

1. Delegation was justified
2. File ownership is non-overlapping
3. Review and integration responsibilities are explicit
