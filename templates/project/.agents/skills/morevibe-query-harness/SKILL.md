---
name: morevibe-query-harness
description: Search the MoreVibe harness before falling back to raw project rediscovery.
---

# MoreVibe Query Harness

## Goal

Start from `.morevibe/` before re-reading the whole project.

Use the harness to find the most relevant wiki, canon, and source files for the current question.

## Action

Run `plugin/scripts/query_morevibe.py` with:

- project root
- query text
- a reasonable result limit
- `--write-report` when the search result itself should remain in the harness

## Completion

1. Relevant MoreVibe files are surfaced to the current session
2. The query is logged in `.morevibe/wiki/log.md`
3. A query report exists in `.morevibe/wiki/queries/` when write-back is requested
