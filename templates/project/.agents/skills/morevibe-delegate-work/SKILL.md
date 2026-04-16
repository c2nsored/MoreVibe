---
name: morevibe-delegate-work
description: Split work safely across subagents only when parallelism genuinely helps and ownership can be kept clean.
---

# MoreVibe Delegate Work

## Goal

Use subagents deliberately instead of by reflex.

## Steps

1. Let the main agent classify the user request and decide whether delegation is worth it.
2. Route non-trivial delegated work through the project lead first.
3. Split ownership by file or subsystem boundaries.
4. Avoid assigning the same file to multiple agents.
5. Keep review-only roles read-only when possible.
6. Let the main agent focus on orchestration and user communication, and let the project lead focus on internal execution decisions.
7. Use `morevibe-orchestrate-subagents` when the task needs an explicit orchestrator -> lead -> worker split.

## Rules

- Do not delegate for its own sake.
- Do not create ownership collisions.
