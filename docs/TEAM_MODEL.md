# Team Model

MoreVibe uses an orchestrator-first delegation model for non-trivial work.

## Shared Pattern

- the main user-facing agent acts as the orchestrator
- `pm-lead` owns internal planning, routing, delegation, and synthesis
- worker agents own focused implementation areas
- `qa-reviewer` owns read-only review where available

## Project Type Presets

### `webapp`

- `pm-lead`
- `frontend-worker`
- `backend-worker`
- `qa-reviewer`

### `ecommerce`

- `pm-lead`
- `storefront-worker`
- `admin-worker`
- `orders-worker`
- `qa-reviewer`

### `blog`

- `pm-lead`
- `content-worker`
- `layout-worker`
- `qa-reviewer`

### `api`

- `pm-lead`
- `routes-worker`
- `data-worker`
- `qa-reviewer`

### `generic`

- main agent as orchestrator
- `pm-lead`
- broad worker ownership from detected project structure
- `qa-reviewer`

## Delegation Rule

Delegation is useful only when:

- ownership can be split cleanly
- multiple work streams can proceed without file conflict
- the orchestrator can still communicate clearly with the user
- the lead can still integrate and report clearly back to the orchestrator

## When Not To Delegate

Do **not** delegate just because a task is non-trivial.

Prefer direct work by the main agent or the lead when:

- the next step is small, obvious, or faster to finish directly
- the task touches only one file or one tightly-coupled code path
- the user is asking for clarification, diagnosis, or planning rather than execution
- the worker would need most of the same context the lead already has
- the cost of splitting context is likely higher than the benefit of parallelism
- the task is mostly review, synthesis, or explanation

Good practical default:

- orchestrator handles user communication and high-level routing
- `pm-lead` handles planning, integration, and small scoped execution when delegation would be wasteful
- workers are for clean ownership slices, not for every non-trivial request
