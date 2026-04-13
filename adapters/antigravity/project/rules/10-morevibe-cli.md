# MoreVibe CLI Routing

Use `run_command` with the provided MoreVibe scripts.

- Query first: `python .agents/morevibe/scripts/query_morevibe.py --project-root . --query "<query>" --write-report`
- Ingest new material: `python .agents/morevibe/scripts/ingest_morevibe_item.py --project-root . --layer sources --title "<title>" --summary "<summary>" --content "<content>"`
- Write back reusable answers: `python .agents/morevibe/scripts/writeback_morevibe_output.py --project-root . --title "<title>" --summary "<summary>" --details "<details>"`
- Sync memory: `python .agents/morevibe/scripts/sync_morevibe_memory.py --project-root . ...`
- Lint before close: `python .agents/morevibe/scripts/lint_morevibe.py --project-root .`

Do not bypass MoreVibe CLI routing for non-trivial work when `.morevibe/` exists.
