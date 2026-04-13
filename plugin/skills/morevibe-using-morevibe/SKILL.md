---
name: morevibe-using-morevibe
description: Primary entry skill for projects that use MoreVibe. Route the session into the right workflow chain before implementation starts.
---

# MoreVibe Using MoreVibe

## Goal

Act as the main entry skill for a project that has MoreVibe installed.

When MoreVibe is present, do not jump straight into implementation.

First classify the task and choose the right workflow chain.

## First checks

1. Confirm the project uses MoreVibe.
2. Read the root `AGENTS.md`.
3. Read `.morevibe/schema/OPERATING_RULES.md`.
4. Use `morevibe-query-harness` first when the task needs quick retrieval of current memory.
5. Read `.morevibe/wiki/state.md` and `.morevibe/wiki/index.md`.
6. Read the relevant canon documents for the current task.

## Routing rules

### New feature or structural change

Use this chain:

1. `morevibe-start-session`
2. `morevibe-plan-feature`
3. `morevibe-execute-plan`
4. `morevibe-request-review`
5. `morevibe-apply-review-fixes` when needed
6. `morevibe-verify-change`
7. `morevibe-update-docs`
8. `morevibe-update-handoff`
9. `morevibe-sync-memory`
10. `morevibe-finish-task`

### Bug fix

Use this chain:

1. `morevibe-start-session`
2. `morevibe-debug-bug`
3. `morevibe-request-review`
4. `morevibe-apply-review-fixes` when needed
5. `morevibe-verify-change`
6. `morevibe-update-docs`
7. `morevibe-update-handoff`
8. `morevibe-sync-memory`
9. `morevibe-finish-task`

### Document or operations change

Use this chain:

1. `morevibe-start-session`
2. `morevibe-verify-change`
3. `morevibe-update-docs`
4. `morevibe-update-handoff`
5. `morevibe-sync-memory`
6. `morevibe-finish-task`

## Extra routing

- Use `morevibe-delegate-work` when parallel work genuinely helps.
- Use `morevibe-test-first` when a test-first path is viable.
- Use `morevibe-report-deployment` when the user asks about rollout or deployment state.
- Use `morevibe-ingest-item` when important new material should enter the harness.
- Use `morevibe-query-harness` when the answer should start from the harness instead of fresh rediscovery.
- Use `morevibe-writeback-answer` when the result should survive beyond chat.
- Use `morevibe-lint-harness` when you need to check harness health before or after major updates.

## Rules

- Do not bypass the workflow chain for non-trivial work.
- Do not treat wiki as more authoritative than canon.
- Do not skip review, verification, or documentation by default.
