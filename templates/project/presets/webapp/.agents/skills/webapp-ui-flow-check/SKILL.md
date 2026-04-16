---
name: webapp-ui-flow-check
description: Review a web app's user journey, state transitions, and screen-to-screen consistency.
---

# Webapp UI Flow Check

## Goal

Check whether a user-facing web app flow still feels coherent after a change.

## When to use

- after changing navigation, page structure, or screen flow
- after changing loading, error, or empty states
- before release when a user-facing flow changed
- when the user asks whether the UI still feels consistent

## Check method

1. Name the affected user journey in plain language.
2. Trace the flow screen by screen.
3. Check the transitions, state continuity, and recovery states.
4. Note what still needs manual verification.
5. Decide whether the flow is ready, risky, or incomplete.

## Focus

- route-to-route transitions
- state changes across screens
- empty, loading, and error handling
- desktop and mobile flow consistency
- navigation clarity and return paths
- form progress, confirmation, and cancellation behavior

## Red flags

- a user can enter a flow but not recover or go back cleanly
- loading or error states break continuity between screens
- a state change is visible on one screen but not reflected on the next
- desktop and mobile behavior diverge in meaningful ways

## Output

- affected user journey
- likely UI flow regressions
- manual checks to run
- remaining concerns
- release recommendation: safe / verify more / not ready
