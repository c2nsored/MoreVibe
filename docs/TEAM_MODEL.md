# Team Model

MoreVibe uses a lead-first delegation model for non-trivial work.

## Shared Pattern

- `pm-lead` owns planning, routing, delegation, and synthesis
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

- `pm-lead` or fallback orchestrator
- broad worker ownership from detected project structure
- optional reviewer

## Delegation Rule

Delegation is useful only when:

- ownership can be split cleanly
- multiple work streams can proceed without file conflict
- the lead can still integrate and report clearly
