# MoreVibe Method

MoreVibe is designed around one core idea:

> long AI coding projects become more reliable when memory, workflow, and ownership are externalized into project files.

## Core Principles

- Keep project truth in files, not only in chat.
- Separate raw material from authoritative decisions.
- Use repeatable skill chains for common work.
- Prefer role-based ownership for non-trivial work.
- Make the default experience work from natural language, not command memorization.

## Operating Shape

MoreVibe expects projects to rely on four layers:

- `sources/` for raw material
- `canon/` for current truth
- `wiki/` for working memory
- `schema/` for operational rules

## Workflow Shape

The baseline operating loop is:

1. restore context
2. classify the request
3. choose the right skill chain
4. delegate only when ownership can be split cleanly
5. implement or review
6. verify
7. write back docs and handoff

## Product Stance

MoreVibe is intentionally aimed at non-programmers and long-running AI-assisted builds.

That means:

- natural-language requests should work well by default
- explicit commands can exist, but they should remain optional
- documentation and handoff are first-class parts of the workflow
