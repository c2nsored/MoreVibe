---
name: review-risk
description: Inspect a planned or completed change for regressions, blast radius, and missing verification.
---

# Review Risk

## Goal

Identify what could break before or after a change.

## When to use

- before implementation when the request looks risky or broad
- after implementation when you need a regression-focused review
- before handoff or release when confidence is lower than expected

## Review method

1. Restate the intended behavior change in one short paragraph.
2. Separate direct changes from indirect impact areas.
3. Check what verification already exists and what is still missing.
4. Rank risks by severity: high, medium, low.
5. Recommend whether work is ready, needs more checks, or should pause.

## Focus

- behavior regressions
- scope expansion and hidden side effects
- dependency and contract breakage
- missing tests, missing manual verification, or missing review
- rollout, deployment, migration, or operational risk
- documentation or handoff gaps that could hide risk

## Red flags

- a change touches shared utilities, auth, payments, routing, or data flow without targeted verification
- the implementation changed behavior outside the requested scope
- docs, handoff, or deployment notes were not updated after a significant change
- a reviewer would need to guess expected behavior from code alone

## Output

- requested change summary
- affected areas
- high-risk items
- medium-risk items
- missing checks
- recommended next action: proceed / verify more / revise first
