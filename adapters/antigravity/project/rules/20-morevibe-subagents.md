# MoreVibe Subagent Orchestration

Use the MoreVibe orchestration model even though Antigravity does not expose Claude-style custom subagents.

- Main agent: orchestrator, planner, final integrator
- Worker role: file- or subsystem-scoped executor
- Review role: regression and canon/wiki drift checker

If the task needs an orchestrator split, follow `morevibe-orchestrate-subagents` principles and use `run_command` where MoreVibe scripts are available.
