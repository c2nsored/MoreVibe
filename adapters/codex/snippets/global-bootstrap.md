# MoreVibe Global Bootstrap for Codex

If a project contains `.morevibe/`, interpret it as a project-local harness namespace.

Default rules:

- keep the project's root `AGENTS.md` as the public entrypoint
- treat `.morevibe/canon/` as authoritative reference
- treat `.morevibe/wiki/` as compiled working memory
- when `.morevibe/` exists, prefer `morevibe-session-brief` and `morevibe-query-harness` at session start
- use `morevibe-using-morevibe` as the first MoreVibe workflow router when a project contains `.morevibe/`
- use `morevibe-orchestrate-subagents` when a task requires explicit orchestrator/worker separation
- prefer merge and backup over overwrite when applying MoreVibe changes
