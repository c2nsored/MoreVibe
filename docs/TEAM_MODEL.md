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
