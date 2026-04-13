---
name: morevibe-start-session
description: Restore project context at the start of a session by checking the main entrypoint, current canon, active tasks, and handoff state.
---

# MoreVibe Start Session

## Goal

Recover project context quickly before implementation starts.

## Steps

1. Confirm the current workspace, repo, and branch.
2. Read the project's main public entrypoint first.
3. Use `morevibe-session-brief` when a quick, repeatable startup summary will help.
4. Use `morevibe-query-harness` when you need to locate relevant memory before opening many files.
5. Check current canon documents for:
   - project overview
   - active tasks
   - latest handoff
   - recent decisions when needed
6. Restate the current goal in one short paragraph.
7. Identify the code or document scope to touch.
8. Note unknowns before implementation begins.

## Rules

- Do not start coding before recovering the current state.
- Prefer the project's public entrypoint and canon before wiki.
- Use wiki to accelerate navigation, not to replace canon.
