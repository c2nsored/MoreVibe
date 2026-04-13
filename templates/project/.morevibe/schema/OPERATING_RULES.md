# MoreVibe Operating Rules

## Default model

- `schema` = MoreVibe-local operating rules
- `sources` = evidence and raw inputs
- `canon` = authoritative project reference
- `wiki` = compiled working memory

## Canon priority

Prefer canon over wiki when there is a conflict.

## Maintenance loop

1. ingest
2. query
3. lint

## Session entry

When a session starts on a MoreVibe project:

1. read the root `AGENTS.md`
2. read `.morevibe/schema/OPERATING_RULES.md`
3. read `.morevibe/wiki/state.md`
4. use `morevibe-using-morevibe` as the main workflow router

## Workflow routing

### Feature or structure change

- `morevibe-start-session`
- `morevibe-plan-feature`
- `morevibe-execute-plan`
- `morevibe-request-review`
- `morevibe-apply-review-fixes` when needed
- `morevibe-verify-change`
- `morevibe-update-docs`
- `morevibe-update-handoff`
- `morevibe-finish-task`

### Bug fix

- `morevibe-start-session`
- `morevibe-debug-bug`
- `morevibe-request-review`
- `morevibe-apply-review-fixes` when needed
- `morevibe-verify-change`
- `morevibe-update-docs`
- `morevibe-update-handoff`
- `morevibe-finish-task`

### Document or operations change

- `morevibe-start-session`
- `morevibe-verify-change`
- `morevibe-update-docs`
- `morevibe-update-handoff`
- `morevibe-finish-task`

## Extra skills

- `morevibe-delegate-work`
- `morevibe-test-first`
- `morevibe-report-deployment`
