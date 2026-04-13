---
name: morevibe-delegate-work
description: Split work safely across subagents only when parallelism genuinely helps and ownership can be kept clean.
---

# MoreVibe Delegate Work

## Goal

Use subagents deliberately instead of by reflex.

## Steps

1. Decide whether delegation actually helps.
2. Split ownership by file or subsystem boundaries.
3. Avoid assigning the same file to multiple agents.
4. Keep review-only roles read-only when possible.
5. Let the main agent focus on planning and integration.
6. Use `morevibe-orchestrate-subagents` when the task needs an explicit orchestrator-first split.

## Rules

- Do not delegate for its own sake.
- Do not create ownership collisions.
