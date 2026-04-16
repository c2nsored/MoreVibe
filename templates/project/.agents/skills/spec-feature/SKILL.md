---
name: spec-feature
description: Turn a rough request into a clearer feature specification before implementation.
---

# Spec Feature

## Goal

Convert a vague feature request into a usable implementation target.

## When to use

- the request is broad, ambiguous, or underspecified
- implementation could branch in multiple reasonable directions
- a non-developer user knows the outcome they want but not the technical shape
- the work should be reviewed or delegated before coding starts

## Include

- user outcome
- included behavior
- excluded behavior
- constraints
- acceptance signals

## Spec method

1. Rewrite the request in plain language.
2. Identify the user-facing outcome.
3. Separate included scope from explicitly excluded scope.
4. Note constraints: technical, operational, UX, deployment, time, or content.
5. Record open questions only when they materially affect implementation.
6. End with acceptance criteria that a reviewer could actually check.

## Red flags

- the spec only repeats the request without reducing ambiguity
- included and excluded scope are not separated
- acceptance criteria are too vague to verify
- constraints are implied but not written down
- implementation starts before the feature target is stable

## Output

- feature summary
- user outcome
- included scope
- excluded scope
- constraints
- open questions
- acceptance criteria
