# MoreVibe Lifecycle Management

- Session Start Hook: if `.morevibe/` exists, run `python .agents/morevibe/scripts/bootstrap_morevibe_session.py --project-root . --write-report` before broad project analysis.
- Session End Hook: before final reporting, run `python .agents/morevibe/scripts/lint_morevibe.py --project-root .`.
- If useful results appear during the session, run the appropriate MoreVibe command instead of leaving them only in chat.
