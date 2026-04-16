---
name: audit-doc-drift
description: Compare code, workflow, and docs to find where project documentation has fallen behind reality.
---

# Audit Doc Drift

## Goal

Find documentation that no longer matches the project.

## When to use

- after significant implementation work
- before handoff or release
- when a session feels confusing because docs and code may disagree
- when the user asks whether the project memory is still trustworthy

## Check

- canon vs code
- schema vs actual workflow
- handoff vs current status
- tasks vs actual completion state
- deployment notes vs actual release state
- role model or skill routing docs vs installed project files

## Audit method

1. Identify the most authoritative document for each topic.
2. Compare the document with the current code or generated schema.
3. Mark whether the doc is correct, stale, incomplete, or contradictory.
4. Prioritize what must be updated now versus later.

## Red flags

- two docs describe the same rule differently
- generated schema and handwritten docs disagree on workflow or team model
- handoff says work is pending but code and tasks show it is complete
- code changed significantly but canon still describes the old structure

## Output

- drift summary
- affected docs
- corrections needed
- urgency of update
- recommended update order
