# ClaudeCode Adapter

This adapter now includes project integration assets based on Claude Code's documented memory, slash command, limited hook, and subagent model.

It now also uses Claude Code's available stop-hook model to auto-sync MoreVibe session memory before running lint.
It also seeds a lightweight statusline command and a conservative permissions baseline for risky shell actions.

## Goal

Reuse the same MoreVibe core model while adapting installation and bootstrap behavior to ClaudeCode.

## Included documents

- `SPEC.md`
- `snippets/project-bootstrap.md`
- `snippets/global-bootstrap.md`
- `GLOBAL_CONFIG_TEMPLATE.md`
- `project/CLAUDE.morevibe.md`
- `project/commands/*`
- `project/agents/*`

## Constraint

ClaudeCode support should not fork the MoreVibe knowledge model.

It should only adapt the integration layer.
