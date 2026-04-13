# Subagent Orchestration

Use this file to keep multi-agent work safe and predictable.

## Default model

- Main agent: orchestrates, plans, integrates, reports
- Worker agent: owns a file range or subsystem
- Review agent: focuses on risks and regressions

## Rules

- Do not assign the same file to multiple agents
- Delegate only when parallel work truly helps
- Keep review roles read-only when possible
- Record ownership before implementation begins
