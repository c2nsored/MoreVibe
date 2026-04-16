# Workflow Map

This document explains how common natural-language requests should map onto MoreVibe workflow skills.

## Session Start

- "start the session"
- "restore the project context"
- "what should we read first?"

Expected routing:

- `start-session`
- `project-bootstrap`

## Feature Planning

- "plan this feature first"
- "structure this before building"
- "spec this request"

Expected routing:

- `spec-feature`
- `plan-feature`

## Feature Implementation

- "build this feature"
- "implement this change"

Expected routing:

- `plan-feature`
- `execute-plan`
- `request-code-review`
- `verify-change`
- `finish-task`

## Bug and Failure Work

- "find the cause of this bug"
- "why did this fail?"

Expected routing:

- `investigate-failure`
- `debug-bug`

## Review and Risk

- "review this before we finish"
- "what could break?"
- "check the UI too"
- "check the order flow too"
- "make sure this API change is still compatible"

Expected routing:

- `request-code-review`
- `review-risk`
- `qa-ui` for user-facing work
- project-type specialist checks when relevant, such as `webapp-ui-flow-check`, `ecommerce-order-flow-check`, `blog-publishing-check`, or `api-contract-check`
- `verify-change`

## Docs and Handoff

- "update the docs too"
- "leave this ready for the next session"

Expected routing:

- `update-docs`
- `audit-doc-drift`
- `handoff-session`
- `update-handoff`

## Release and Shipping

- "prepare this for release"
- "what is the actual ship status?"
- "is this safe to ship?"

Expected routing:

- `prepare-release`
- `ship-change`
- `report-deployment-status`
- project-type specialist checks when release risk depends on UI, order flow, publishing flow, or API compatibility
