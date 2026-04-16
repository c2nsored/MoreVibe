# Project Guide

This project uses MoreVibe as a project-local harness.

## Startup Rule

- Read this file first.
- Then read `.morevibe/schema/SESSION_BOOTSTRAP.md`.
- Then read `.morevibe/schema/PROJECT_SKILLS.md`.
- Treat `.morevibe/canon/` as authoritative over `.morevibe/wiki/`.
- Route non-trivial work through the detected project workflow before implementation.
- Prefer understanding natural-language requests first, then map them to the closest project skill chain.

## MoreVibe Layers

- `sources` = evidence, references, notes, logs, and raw inputs
- `canon` = the current authoritative project reference
- `wiki` = compiled working memory for the LLM
- `schema` = operating rules for maintaining the harness

## Rules

- Keep this root `AGENTS.md` as the main public entrypoint.
- Do not treat `wiki` as more authoritative than `canon`.
- Keep important decisions, active tasks, and handoff notes inside `.morevibe/canon/`.
- Prefer updating project files over leaving important state only in chat.
- Use explicit commands only as optional accelerators; the default experience should still work well from natural-language requests.
