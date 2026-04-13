---
name: morevibe-ingest-item
description: Ingest new evidence or official project documents into the MoreVibe harness and update the wiki index.
---

# MoreVibe Ingest Item

## Goal

Do not leave important new information floating only in chat.

Classify it into `sources` or `canon`, store it in `.morevibe/`, and record the ingest in the wiki log.

## Choose the layer

- Use `sources` for evidence, notes, snapshots, and raw inputs.
- Use `canon` for the project's current official reference documents.

## Action

Run `plugin/scripts/ingest_morevibe_item.py` with:

- project root
- target layer
- title
- category
- summary
- content
- references

## Completion

1. A markdown artifact exists under `.morevibe/sources/` or `.morevibe/canon/`
2. `.morevibe/wiki/log.md` records the ingest
3. `.morevibe/wiki/index.md` points to the new item
