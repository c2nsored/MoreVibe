# Project Guide

This project uses MoreVibe as a project-local harness.

## Operating Style

- `기본 스타일` preset is active for this project.
- Read this file first, then `.morevibe/schema/SESSION_BOOTSTRAP.md`.
- Treat `.morevibe/canon/` as authoritative over `.morevibe/wiki/`.
- Route non-trivial work through the detected project workflow before implementation.

## Default Workflow

- Startup: `start-session` -> `project-bootstrap`
- Feature work: `plan-feature` -> `execute-plan`
- Bug work: `debug-bug`
- Review and finish: `request-code-review` -> `apply-review-fixes` -> `verify-change` -> `finish-task`
- Docs and handoff: `update-docs` -> `update-handoff`

## Team Model

- Lead: `pm-lead`
- Product UI: `storefront-ui`
- Custom editing flow: `custom-editor`
- Orders and payments: `payments-orders`
- Review: `qa-reviewer`

## Rules

- Keep this root `AGENTS.md` as the main public entrypoint.
- Do not treat `wiki` as more authoritative than `canon`.
- Prefer the preset's native skill names when they exist.
- Keep important decisions, active tasks, and handoff notes inside `.morevibe/canon/`.
- Prefer updating project files over leaving important state only in chat.
