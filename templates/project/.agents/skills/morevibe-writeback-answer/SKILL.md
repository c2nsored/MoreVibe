---
name: morevibe-writeback-answer
description: Save reusable answers, plans, and findings back into .morevibe/wiki/outputs and log the write-back.
---

# MoreVibe Write Back Answer

## Goal

If an answer, plan, or analysis will be useful again, do not leave it only in chat.

Write it back into `.morevibe/wiki/outputs/` and record the event in `.morevibe/wiki/log.md`.

## Use this when

- the answer can help a later session
- the answer captures a reusable decision or investigation result
- the answer explains a workflow or operating rule worth keeping

## Do not use this when

- the response is trivial and disposable
- the content belongs directly in canon instead of wiki outputs

## Action

Run `plugin/scripts/writeback_morevibe_output.py` with:

- project root
- title
- category
- concise summary
- detailed body
- references when available

## Completion

1. A markdown artifact exists in `.morevibe/wiki/outputs/`
2. `.morevibe/wiki/log.md` records the write-back unless intentionally skipped
3. The saved output does not contradict canon
