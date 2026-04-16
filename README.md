# MoreVibe

**A document-centered workflow harness for long-running AI coding projects.**

MoreVibe helps tools such as **Codex**, **Claude Code**, and **Antigravity** work more consistently over long projects by moving important context out of fragile chat history and into a durable project structure.

It is built for people who want:

- better continuity across many sessions
- a clear separation between raw notes, working memory, and project truth
- reusable workflow skills instead of re-explaining the same process in every chat
- a setup that non-programmers can install without inventing an operating model by hand

---

## What MoreVibe Solves

Long AI coding projects often degrade in predictable ways:

- important decisions disappear into old conversations
- the same project context must be explained again and again
- plans, notes, handoff, and official docs get mixed together
- agent behavior changes from one session to the next
- non-programmers have no stable structure for planning, review, and handoff

MoreVibe addresses that by giving the project its own memory model and workflow scaffold.

---

## Core Model

MoreVibe separates project knowledge into four layers:

- `sources/`
  Raw references, imported material, research, notes, and evidence.
- `canon/`
  The authoritative project reference: overview, architecture, tasks, decisions, operations, and handoff.
- `wiki/`
  AI-maintained working memory that helps future sessions resume faster.
- `schema/`
  Operating rules that define what to read first, how the harness behaves, and how memory should be maintained.

This keeps the project clearer by separating:

- evidence from truth
- temporary memory from durable memory
- raw notes from official decisions
- session chatter from structured project state

---

## What Gets Installed

Depending on the selected tool targets, MoreVibe can create or update:

- a project-local `.morevibe/` harness
- a root `AGENTS.md` entrypoint when one does not already exist
- `.agents/skills/` with native workflow aliases plus MoreVibe compatibility skills
- `.claude/skills/` and `.claude/agents/`
- `.codex/config.toml` and `.codex/agents/*.toml`
- rendered schema files that reflect the workflow and delegation model actually installed

The result is a project that carries more of its own operating context instead of depending on a single conversation thread.

---

## Orchestration Model

MoreVibe uses a three-layer operating model for non-trivial work:

1. **Main agent = orchestrator**
   The user talks to the main session in natural language.
2. **`pm-lead` = internal team lead**
   The lead interprets project scope, chooses the workflow, decides ownership, and integrates results.
3. **Workers = scoped executors**
   Worker agents own focused implementation areas, while `qa-reviewer` stays read-only when available.

The intended flow is:

- the user speaks to the main agent
- the main agent classifies the request and routes execution through `pm-lead`
- `pm-lead` decides whether to act directly or delegate to workers
- workers report back to `pm-lead`
- `pm-lead` reports back to the orchestrator
- the orchestrator explains progress and outcomes back to the user in plain language

This keeps the user experience simple while preserving a structured internal execution model.

---

## Skill Model

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

It also installs specialist support skills for work such as:

- risk review
- UI QA
- release preparation
- shipping status reporting
- failure investigation
- safe refactor planning
- feature specification
- handoff preparation
- documentation drift checks
- first-session onboarding

Project-type presets can add extra specialist skills such as:

- `webapp-ui-flow-check`
- `ecommerce-order-flow-check`
- `blog-publishing-check`
- `api-contract-check`

### Active, Fallback, and Dormant Skills

MoreVibe now classifies installed skills into:

- **active**
  Skills that are part of the primary installed workflow
- **fallback**
  Compatibility skills such as `morevibe-*` equivalents that remain available when needed
- **dormant**
  Installed skills not currently mapped into the active workflow

This means the project can keep readable native workflow names while still preserving a compatibility layer. In normal installs, fallback skills are intentional, not meaningless leftovers.

---

## Natural-Language First

The default MoreVibe experience is still natural-language first:

- users can ask in plain language
- MoreVibe should interpret the request and route it to the right workflow
- explicit command-style shortcuts can exist, but they are optional accelerators

The product is intentionally designed so non-programmers do **not** need to memorize commands to benefit from the harness.

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
  broad fallback preset when no specific project type is selected

This keeps MoreVibe broadly useful for non-programmers while avoiding project-specific custom roles that only make sense in one product.

---

## Tool Support

- **Codex**
  Project-local skills, `.codex/` role templates, and plugin-based integration support.
- **Claude Code**
  Project-local skills, agents, memory bootstrap, and optional commands.
- **Antigravity**
  Adapter-level bootstrap plus project-type-aware role partitioning rules.

Important note:

- `Codex` and `Claude Code` can install actual project-local agent files.
- `Antigravity` currently uses a single-agent role partitioning model rather than true project-local subagent files.

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
2. Keep `canon/` aligned with the real current state.
3. Store raw notes and research in `sources/`.
4. Let the AI summarize active state into `wiki/`.
5. Keep `schema/` stable and use `canon/` as authority.
6. Resume future sessions from the installed project structure, not from old chat history alone.

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
