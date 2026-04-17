---
name: migrate-existing-project
description: One-time adaptation of a freshly installed MoreVibe harness to an existing project that already has its own docs, agent rules, or previous MoreVibe install.
---

# Migrate Existing Project

## Goal

Turn a freshly installed MoreVibe skeleton into a harness that actually
reflects this specific project, without the user having to hand-copy
content from their existing `README.md`, `docs/`, or previous agent
rule files.

## When to use

- immediately after the first MoreVibe install on an existing project
- when `.morevibe/.migration_complete` is missing and the session brief
  flagged existing-project signals
- when the user asks: "migrate this project", "adapt MoreVibe to this
  repo", "마이그레이션해줘", "기존 구조랑 통합해줘"

Do **not** re-run automatically. Repeat runs require explicit consent.

## Principles

- non-destructive: back up every file before modifying it
  (`*.pre-migration-YYYYMMDD-HHMM`)
- ask before writing: each step ends with an approval gate
- `canon/` is the target authority; existing docs are extraction sources
- idempotent: sentinel prevents silent re-runs

## Steps

1. **Inventory**
   Scan `README.md`, `docs/`, `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`,
   manifests, CI, Dockerfiles, and existing MoreVibe backups. Show the
   user the inventory and confirm nothing important is missing.

2. **Canon draft**
   Propose draft content for each placeholder `canon/*` file, derived
   from the inventory. Show diffs. Write only approved drafts.

3. **Workflow extraction**
   Move operational procedures from `docs/**` into
   `canon/OPERATIONS.md`. Flag any workflow that does not map to a
   default skill so the user can decide whether to add a specialist.

4. **Authority conflict resolution**
   If `docs/` currently owns authoritative rules that also exist in
   `canon/`, ask the user to choose: redirect `docs/`, absorb `docs/`,
   or declare `canon/` authoritative via `AGENTS.md`. Record the choice
   in `canon/DECISIONS.md`.

5. **Legacy MoreVibe cleanup**
   Detect older MoreVibe install traces (extra backup generations,
   stale `.claude/settings.json` hooks, orphaned schema files). Propose
   removal. Keep at most the two most recent backups of each top-level
   file. Never delete without approval.

6. **Lint auto-repair**
   Run the lint skill. For warnings with a mechanical fix (missing
   timestamp header, missing MoreVibe Bootstrap block in `AGENTS.md`,
   empty required wiki files), propose a patch. Leave judgment-calls
   for the user.

7. **Sentinel record**
   Write `.morevibe/.migration_complete` with timestamp, previous
   detected MoreVibe version, current version, list of files touched,
   and count of decisions recorded.

8. **Wiki log**
   Append "Migration completed" to `.morevibe/wiki/log.md` summarizing
   what was done, what was deferred, and what the user should verify
   in the next session. Refresh `wiki/state.md` `Current Focus` and
   `Recent Changes`.

## Dry-run

When asked for `--dry-run`, produce steps 1–6 as a report at
`.morevibe/wiki/outputs/migration-preview-<timestamp>.md` and do not
modify anything else.

## Output

- inventory report
- canon files now carrying real content
- authority decision recorded in `canon/DECISIONS.md`
- legacy cleanup summary
- remaining lint warnings (with reason why they were not auto-fixed)
- `.morevibe/.migration_complete` written
- one-line closing: "MoreVibe is now adapted to this project. Next,
  run `start-session`."

## Failure handling

If any step fails after partial writes, do not reach step 7. Report the
partial state, list which backups exist, and leave the sentinel
**unwritten** so the next run can retry.
