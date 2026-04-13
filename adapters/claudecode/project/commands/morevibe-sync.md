Sync MoreVibe state before finishing.

1. Update canon and handoff if needed.
2. Run `python .claude/morevibe/scripts/lint_morevibe.py --project-root .`
3. If the answer or result is reusable, run `python .claude/morevibe/scripts/writeback_morevibe_output.py ...`
4. Summarize what was updated in `.morevibe/`.
