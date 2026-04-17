---
name: morevibe-migrate-existing-project
description: Adapt MoreVibe to an existing project on first install by inventorying current docs, drafting canon content, resolving authority conflicts, cleaning legacy traces, and recording a one-time migration sentinel.
---

# MoreVibe Migrate Existing Project

## Goal

When MoreVibe is installed into a project that **already has** its own
README, docs, agent rules, or a previous version of MoreVibe, the
installer can only lay down placeholders and skeletons. The real work
of shaping MoreVibe to that specific project still has to happen.

This skill performs that one-time adaptation, so the user does not have
to manually transcribe existing content into the `canon / wiki / schema`
layers.

It is explicitly aimed at non-programmers: every destructive-looking
step must surface an approval gate before touching files.

## When to use

- immediately after the very first MoreVibe install on a project that
  already has real content (existing `README.md`, `docs/`, `AGENTS.md`,
  existing CI, existing deploy model, etc.)
- when `.morevibe/.migration_complete` is missing and the session brief
  flagged "existing-project signals detected"
- when the user asks in natural language: "migrate this project",
  "adapt MoreVibe to this repo", "마이그레이션해줘", "기존 구조랑 통합해줘",
  "MoreVibe에 맞춰줘"

Do **not** auto-run this skill at every session start. It is a one-shot
adaptation; repeat runs require explicit user confirmation.

## Non-goals

- rewriting product code
- making release decisions
- replacing `plan-feature`, `execute-plan`, or other normal workflow skills

## Required inputs

- project root path
- confirmation from the user that this is the intended project
- `--dry-run` flag when the user wants to preview without writing

## Operating principles

- **non-destructive by default**: every modified file gets a
  `*.pre-migration-YYYYMMDD-HHMM` backup before being touched
- **approval gates**: each of the 8 steps below ends by showing a
  summary of proposed changes and asking for explicit OK before moving
  on
- **idempotency**: if `.morevibe/.migration_complete` already exists,
  greet with "migration was already completed on <date>, run again?" and
  proceed only on confirmation
- **authority first**: `canon/` is the target authority; `docs/`,
  root `README.md`, and existing `AGENTS.md` are treated as sources of
  truth to **extract from**, not as long-term authority

## 8-step operating loop

### Step 1 — Inventory
- scan project root for: `README.md`, `docs/**`, `AGENTS.md`,
  `CLAUDE.md`, `GEMINI.md`, `package.json` / `pyproject.toml` /
  `Cargo.toml` / similar, `.github/workflows/`, `Dockerfile`,
  `docker-compose.yml`, any `AGENTS.md.backup-*` or `CLAUDE.md.backup-*`
- produce a short inventory report with file sizes and last-modified
  timestamps
- ask the user to confirm the inventory is complete before proceeding

### Step 2 — Canon draft
- propose draft content for each placeholder file in `canon/`
  (`PROJECT_OVERVIEW.md`, `ARCHITECTURE.md`, `TASKS.md`, `OPERATIONS.md`,
  `DECISIONS.md`, `HANDOFF.md`) derived from the existing inventory
- show each draft as a diff against the current placeholder
- do not write until the user approves the draft for that file
- keep per-file backups of anything overwritten

### Step 3 — Workflow extraction
- read existing `docs/**` for operational procedures
  (deployment, backup, testing, onboarding)
- summarize these into `canon/OPERATIONS.md`
- flag any workflow that cannot be mapped onto MoreVibe's default
  skill chain so the user can decide whether to add a specialist skill

### Step 4 — Authority conflict resolution
- if `docs/` currently carries authoritative rules that now live in
  `canon/`, ask the user to choose:
  (a) convert `docs/` into thin redirect stubs that point to `canon/`,
  (b) absorb `docs/` fully and delete the originals (only after backup),
  (c) keep both with `canon/` declared authoritative in `AGENTS.md`
- record the decision in `canon/DECISIONS.md`

### Step 5 — Legacy MoreVibe trace cleanup
- detect previous MoreVibe installs via multi-generational backups
  (`AGENTS.md.backup-*` older than the most recent two), stale
  `.claude/settings.json` hooks, orphaned `.morevibe/schema/` files
  from an older version
- propose removal or consolidation; keep at most the two most recent
  backups of each top-level file
- never delete anything without approval

### Step 6 — Lint auto-repair
- run `lint_morevibe.py`
- for each warning that has a mechanical fix (missing timestamp header,
  missing MoreVibe Bootstrap block in root `AGENTS.md`, empty required
  wiki files), propose a patch
- leave warnings that require human judgment untouched and list them
  for the user

### Step 7 — Sentinel record
- write `.morevibe/.migration_complete` with content:
  ```
  migrated_at: <ISO timestamp>
  from_version: <detected previous MoreVibe version or "none">
  to_version: <current MoreVibe version>
  files_touched: <newline-separated list>
  decisions_recorded: <count from step 4>
  ```
- this sentinel prevents `bootstrap_morevibe_session.py` from re-nagging
  the user to migrate

### Step 8 — Wiki log
- append a "Migration completed" entry to `.morevibe/wiki/log.md`
  summarizing what was done, what was deferred, and what the user
  should double-check in the next session
- update `.morevibe/wiki/state.md` `## Current Focus` and
  `## Recent Changes` to reflect that the migration just happened

## Dry-run behaviour

When invoked with `--dry-run`, produce steps 1–6 as a report written
to `.morevibe/wiki/outputs/migration-preview-<timestamp>.md` and do not
create backups, modify canon, or write the sentinel. The user can
review the preview and then re-invoke without `--dry-run` to apply.

## Failure modes

- if any step fails after partial writes, do not proceed to step 7
- report the partial state clearly, tell the user which backups exist,
  and leave the sentinel **unwritten** so a subsequent run can retry
- never auto-delete backups of failed runs

## Reporting

At the end of a successful run, report to the user:

- what was inventoried
- which canon files now have real content (versus still placeholder)
- which conflicts were resolved and how
- how many legacy traces were cleaned
- how many lint warnings remain and why
- a one-line "MoreVibe is now adapted to this project. Start with
  `start-session`."
