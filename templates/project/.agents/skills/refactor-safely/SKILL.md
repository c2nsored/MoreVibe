---
name: refactor-safely
description: Improve structure without losing behavior by defining invariants, scope, and verification first.
---

# Refactor Safely

## Goal

Refactor code or structure while protecting existing behavior.

## Rules

- define preserved behavior before edits
- keep scope narrow
- call out risky dependencies
- require verification after refactor

## Output

- refactor target
- behavior to preserve
- risky areas
- step plan
- verification expectations
