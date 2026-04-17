# MoreVibe Operating Rules

## Default model

- `schema` = project-local operating rules
- `sources` = evidence and raw inputs
- `canon` = authoritative project reference
- `wiki` = compiled working memory

## Canon priority

Prefer canon over wiki when there is a conflict.

## Natural-language routing

The default user experience should work from plain-language requests.

- Do not require the user to know internal skill names.
- Interpret the request first, then map it to the closest workflow chain.
- Treat explicit commands as optional accelerators, not mandatory controls.

## Session entry

When a session starts on a MoreVibe project:

1. read the root `AGENTS.md`
2. read `.morevibe/schema/SESSION_BOOTSTRAP.md`
3. read `.morevibe/schema/PROJECT_SKILLS.md`
4. read `.morevibe/wiki/state.md`
5. read `.morevibe/canon/HANDOFF.md`
6. read `.morevibe/canon/TASKS.md`
7. restore enough context before implementation begins

## Natural request mapping

### Session restore requests

Examples:

- "start the session"
- "restore the project context"
- "what should we read first?"

Expected routing:

- `start-session`
- `project-bootstrap`

### Planning requests

Examples:

- "plan this feature first"
- "spec this before building"
- "structure this safely"

Expected routing:

- `spec-feature`
- `plan-feature`
- `refactor-safely` when the request is structural

### Implementation requests

Examples:

- "build this feature"
- "implement this change"

Expected routing:

- `plan-feature`
- `execute-plan`
- `request-code-review`
- `verify-change`
- `finish-task`

### Bug and failure requests

Examples:

- "find the cause of this bug"
- "why did this fail?"

Expected routing:

- `investigate-failure`
- `debug-bug`

### Review and safety requests

Examples:

- "review this before we finish"
- "what could break?"
- "check the UI too"
- "check the order flow too"
- "make sure the API contract still works"

Expected routing:

- `request-code-review`
- `review-risk`
- `qa-ui` for user-visible work
- project-type specialist checks when relevant
- `verify-change`

### Docs, handoff, and release requests

Examples:

- "update the docs too"
- "leave this ready for the next session"
- "prepare this for release"
- "tell me the real ship status"
- "is this safe to ship?"

Expected routing:

- `update-docs`
- `audit-doc-drift`
- `handoff-session`
- `update-handoff`
- `prepare-release`
- `ship-change`
- `report-deployment-status`
- project-type specialist checks when release readiness depends on the affected domain

## Maintenance loop

1. restore context
2. classify the request
3. choose the workflow chain
4. implement, review, or delegate
5. verify
6. update docs and handoff
7. sync durable memory

## Delegation restraint

- Do not delegate by default just because work is non-trivial.
- Keep execution with the lead when the next step is small, obvious, tightly coupled, or mostly explanatory.
- Delegate only when ownership is clean enough that splitting context will save real time or reduce risk.
