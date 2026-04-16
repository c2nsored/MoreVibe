# MoreVibe

**A project memory and workflow harness for long-running AI coding.**

MoreVibe helps tools such as **Codex**, **Claude Code**, and **Antigravity** keep working consistently across long projects by moving important context out of fragile chat history and into a durable project structure.

It is designed for people who want:

- better continuity across many sessions
- clear separation between raw notes, working memory, and authoritative project truth
- reusable workflow skills instead of repeating the same process in every chat
- a setup that non-programmers can install without building an operating model by hand

---

## What MoreVibe Solves

Long AI coding projects often lose quality in predictable ways:

- important decisions disappear into old conversations
- the same context must be re-explained over and over
- notes, plans, and official documentation get mixed together
- agent behavior becomes inconsistent between sessions
- non-programmers have no stable structure for planning, review, and handoff

MoreVibe addresses that by giving the project its own memory system and workflow scaffolding.

---

## Core Model

MoreVibe separates project knowledge into four layers:

- `sources/`
  Raw references, research, notes, logs, and imported material.
- `canon/`
  The current source of truth for the project: overview, architecture, tasks, decisions, operations, and handoff.
- `wiki/`
  AI-maintained working memory that helps future sessions resume faster.
- `schema/`
  Operating rules that define what to read first, how the harness behaves, and how memory should be maintained.

This reduces confusion between:

- evidence and truth
- temporary memory and durable memory
- raw notes and official decisions
- session chatter and project structure

---

## What Gets Installed

Depending on the selected tools, MoreVibe can create or update:

- a project-local `.morevibe/` harness
- a root `AGENTS.md` entrypoint when one does not already exist
- `.agents/skills/` with both generic `morevibe-*` skills and native workflow aliases
- `.claude/skills/` and `.claude/agents/`
- `.codex/config.toml` and `.codex/agents/*.toml`
- rendered schema files that reflect the workflow and delegation model actually installed

The result is a project that carries more of its own operating context instead of depending on a single conversation thread.

---

## Native Workflow

MoreVibe installs a shared native workflow layer that can be used across project types:

- `start-session`
- `project-bootstrap`
- `plan-feature`
- `execute-plan`
- `debug-bug`
- `request-code-review`
- `apply-review-fixes`
- `verify-change`
- `finish-task`
- `update-docs`
- `update-handoff`
- `delegate-work`
- `tdd-or-test-first`
- `report-deployment-status`

These aliases sit on top of the generic `morevibe-*` skills so a project can keep a readable, repeatable operating model without being tied to a special-purpose domain preset.

MoreVibe also includes specialist support skills for work such as:

- risk review
- UI QA
- release preparation
- shipping status reporting
- failure investigation
- safe refactor planning
- feature specification
- stronger session handoff
- documentation drift checks
- first-session project onboarding

The intended experience is still natural-language first:

- users can ask in plain language
- MoreVibe should interpret the request and route it to the right workflow
- explicit command-style shortcuts can exist, but they are optional

---

## Project Type Presets

MoreVibe keeps the workflow consistent while adapting role templates to the project type.

- `webapp`
  `pm-lead`, `frontend-worker`, `backend-worker`, `qa-reviewer`
  specialist examples: `webapp-ui-flow-check`, `webapp-state-review`
- `ecommerce`
  `pm-lead`, `storefront-worker`, `admin-worker`, `orders-worker`, `qa-reviewer`
  specialist examples: `ecommerce-order-flow-check`, `ecommerce-admin-audit`
- `blog`
  `pm-lead`, `content-worker`, `layout-worker`, `qa-reviewer`
  specialist examples: `blog-publishing-check`, `blog-content-structure-audit`
- `api`
  `pm-lead`, `routes-worker`, `data-worker`, `qa-reviewer`
  specialist examples: `api-contract-check`, `api-data-flow-trace`
- `generic`
  fallback role model when no specific project type is selected

This keeps MoreVibe broadly useful for non-programmers while avoiding project-specific custom roles that only make sense in one product.

---

## Who It Is For

MoreVibe is especially useful for:

- non-programmers building real products with AI coding tools
- solo builders running long projects over many sessions
- teams or individuals who want explicit workflow, memory, and ownership rules
- projects where continuity matters more than one-off prompting

It is less suitable for users who want:

- a document-free workflow
- fully autonomous behavior with no review
- identical behavior across every AI host and version

---

## Quick Start

### Option 1. Windows Installer

1. Download the latest release from GitHub Releases.
2. Run `MoreVibeInstaller.exe` or extract the packaged ZIP.
3. Choose your target AI tool(s).
4. Choose the target project folder.
5. Choose the project type that best matches the project.
6. Complete installation.
7. Start your AI tool from the project root.

A good first message is:

- "start by understanding this project and tell me the safest next step"

The installer prints a bootstrap health summary so you can confirm that entrypoints, skills, and role files were actually created.

### Option 2. PowerShell Script

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\installer\windows\install-morevibe.ps1 -InstallCodex -InstallClaudeCode -ProjectPath "C:\path\to\your-project" -ProjectType webapp
```

---

## Typical Project Layout

```text
your-project/
├─ .agents/skills/
├─ .morevibe/
│  ├─ sources/
│  ├─ canon/
│  ├─ wiki/
│  └─ schema/
├─ .codex/              # when Codex integration is installed
├─ .claude/             # when Claude Code integration is installed
├─ AGENTS.md
└─ ...project files...
```

---

## Recommended Usage Pattern

1. Install MoreVibe into the project.
2. Update `canon/` so it reflects the real current state.
3. Keep raw notes and research in `sources/`.
4. Let the AI summarize active state into `wiki/`.
5. Keep `schema/` stable and use `canon/` as authority.
6. Resume future sessions from the installed project structure, not from old chat history alone.

---

## Supported Tools

- **Claude Code**
  Project-local skills, agents, and memory bootstrap support.
- **Codex**
  Project-local skills, `.codex/` role templates, and plugin-based integration support.
- **Antigravity**
  Adapter-level bootstrap and project entry support.

---

## Design Principles

- **Non-destructive by default**
  MoreVibe should preserve existing project work whenever possible.
- **Authority must be explicit**
  Not every document should carry the same weight.
- **AI memory should be externalized**
  Important continuity should live in files, not only in chat.
- **Workflow should be reusable**
  Common task patterns should be installed as skills and repeatable operating rules.
- **Non-programmers need structure**
  The product is intentionally designed to reduce hidden process burden.

---

## Expectations

MoreVibe improves continuity, workflow discipline, and project structure. It does **not** guarantee:

- correct code
- correct architecture
- safe edits without review
- perfect autonomous behavior

Version control, testing, and human judgment still matter.

---

## Documentation

Recommended reading order:

1. `README.md`
2. `README.ko.md`
3. `docs/METHOD.md`
4. `docs/WORKFLOW_MAP.md`
5. `docs/TEAM_MODEL.md`
6. `docs/MEMORY_MODEL.md`
7. `docs/NON_PROGRAMMER_GUIDE.md`
8. `docs/OPTIONAL_COMMANDS.md`
9. `docs/RELEASE_GUIDE.md`
10. `templates/`
11. `adapters/`

---

## Final Note

MoreVibe comes from a simple practical observation:

> AI coding tools are powerful, but long projects fail when memory, authority, workflow, and ownership are not structured well enough.

MoreVibe exists to make those projects easier to continue, easier to recover, and easier to operate with confidence.
