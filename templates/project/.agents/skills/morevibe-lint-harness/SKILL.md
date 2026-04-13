---
name: morevibe-lint-harness
description: Check a project .morevibe harness for missing structure, stale memory files, and bootstrap gaps.
---

# MoreVibe Lint Harness

## Goal

Run a repeatable lint pass over `.morevibe/` instead of guessing whether the harness is healthy.

## Action

Run `plugin/scripts/lint_morevibe.py` against the project root.

## Checkpoints

- required directories exist
- required canon/wiki/schema files exist and are not empty
- state and handoff files expose timestamp headers
- root `AGENTS.md` bootstrap presence is reported
- a report is written to `.morevibe/wiki/lint/latest.md`
- the lint event is logged in `.morevibe/wiki/log.md`

## Completion

1. `wiki/lint/latest.md` exists
2. Key issues and warnings are surfaced to the user
3. Missing or stale areas become concrete follow-up work
