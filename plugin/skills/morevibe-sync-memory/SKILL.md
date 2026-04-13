---
name: morevibe-sync-memory
description: Update MoreVibe session memory by refreshing wiki state, canon handoff, and log entries after meaningful work.
---

# MoreVibe Sync Memory

## Goal

Keep MoreVibe's session memory alive instead of leaving important state only in chat history.

## When to use

- after a meaningful work chunk
- before ending a session
- after finishing a feature, bug fix, or document change
- after updating canon in a way the next session must know

## What to update

- `.morevibe/wiki/state.md`
- `.morevibe/wiki/log.md`
- `.morevibe/canon/HANDOFF.md`

## Preferred method

Use the bundled script:

```text
plugin/scripts/sync_morevibe_memory.py
```

## Required content

- current focus
- active risks
- recent changes
- next session pickup
- current stage
- current status
- just finished
- open issues
- next priority
- next steps
- references
- a log summary

## Rule

Do not finish meaningful work without syncing MoreVibe memory.
