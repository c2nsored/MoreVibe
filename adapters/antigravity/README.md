# Antigravity Adapter

This adapter is planned but not implemented yet.

## Goal

Reuse the same MoreVibe core model while adapting installation and bootstrap behavior to Antigravity.

## Must define

- Antigravity global rule/config entrypoint
- project-level bootstrap touchpoints
- how `.morevibe/` should be referenced
- how non-destructive install and merge should work

## Constraint

Antigravity support should not fork the MoreVibe knowledge model.

It should only adapt the integration layer.
