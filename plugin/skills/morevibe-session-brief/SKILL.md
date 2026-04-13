---
name: morevibe-session-brief
description: Build a concise startup brief from the MoreVibe harness before implementation begins.
---

# MoreVibe Session Brief

## Goal

Restore the working context quickly and consistently at the start of a session.

## Action

Run `plugin/scripts/bootstrap_morevibe_session.py` with:

- project root
- `--write-report` when the brief itself should be kept in `wiki/queries/`

## Completion

1. The current state is summarized from `wiki` and `canon`
2. The session startup order is restated clearly
3. The brief is available in output, and optionally saved to `wiki/queries/`
