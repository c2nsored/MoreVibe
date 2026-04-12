# ClaudeCode Adapter

This adapter is planned but not implemented yet.

## Goal

Reuse the same MoreVibe core model while adapting installation and bootstrap behavior to ClaudeCode.

## Must define

- ClaudeCode global rule/config entrypoint
- project-level bootstrap touchpoints
- how `.morevibe/` should be referenced
- how non-destructive install and merge should work

## Constraint

ClaudeCode support should not fork the MoreVibe knowledge model.

It should only adapt the integration layer.
