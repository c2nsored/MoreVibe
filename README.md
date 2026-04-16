# MoreVibe

**A structured project memory harness for long-running AI coding workflows.**

MoreVibe helps AI coding tools such as **Claude Code**, **Codex**, and **Antigravity** work more consistently over long projects by moving project memory out of fragile chat history and into a maintainable project structure.

It is designed for builders who want:

- durable project continuity across sessions
- clear authority between raw notes and official project truth
- reusable workflow skills and role-based delegation
- a setup that non-programmers can install and use without hand-building an operating model

---

## What MoreVibe Solves

Long-running AI projects often degrade in predictable ways:

- important decisions disappear into old chat logs
- the same context must be re-explained repeatedly
- notes, plans, and official documentation become mixed together
- agent behavior becomes inconsistent across sessions
- non-programmers have no stable project operating model

MoreVibe addresses that by giving the project itself a structured memory system.

---

## Core Model

MoreVibe separates project knowledge into four layers:

- `sources/`
  Raw inputs, references, notes, logs, and research. Useful, but not automatically authoritative.
- `canon/`
  The current source of truth for the project: overview, architecture, tasks, decisions, operations, and handoff.
- `wiki/`
  AI-maintained working memory that helps future sessions resume quickly.
- `schema/`
  Operating rules that define what should be read first, how the harness behaves, and how project memory should be maintained.

This distinction reduces confusion between:

- evidence and truth
- temporary memory and durable memory
- private notes and official decisions
- session chatter and project structure

---

## What Gets Installed

Depending on the selected tools, MoreVibe can create or update:

- a project-local `.morevibe/` harness
- a root `AGENTS.md` entrypoint when one does not already exist
- `.agents/skills/` project workflow skills
- `.claude/skills/` and `.claude/agents/`
- `.codex/config.toml` and `.codex/agents/*.toml`
- session bootstrap and schema files generated from the actual installed workflow

The result is a project that carries more of its own operating context, instead of depending on a single conversation thread.

---

## Default Style Preset

MoreVibe includes a user-facing **default style** preset for teams or solo builders who want a stronger project operating model out of the box.

When enabled, it adds:

- native workflow aliases such as:
  - `start-session`
  - `project-bootstrap`
  - `plan-feature`
  - `execute-plan`
  - `debug-bug`
  - `request-code-review`
  - `verify-change`
- a stronger project `AGENTS.md`
- richer role templates such as:
  - `pm-lead`
  - `storefront-ui`
  - `custom-editor`
  - `payments-orders`
  - `qa-reviewer`
- aligned Codex and Claude project-local role models for the same project

This makes a new or empty project feel much closer to a real operating environment from the first session.

---

## Who It Is For

MoreVibe is especially useful for:

- non-programmers building real products with AI coding tools
- solo builders running long projects across many sessions
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
5. Optionally choose a project type and the **default style** preset.
6. Complete installation.
7. Start your AI tool from the project root.

The installer prints a bootstrap health summary so you can confirm that entrypoints, skills, and role files were actually created.

### Option 2. PowerShell Script

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\install-morevibe.ps1
```

Useful options include project type selection and:

```powershell
-ProjectPreset default-style
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

If the **default style** preset is enabled, native skill aliases and preset-specific agent templates are added on top of the base MoreVibe structure.

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
  The product is intentionally designed to reduce the hidden process burden on users without a formal engineering background.

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
3. `docs/RELEASE_GUIDE.md`
4. `templates/`
5. `adapters/`

---

## Final Note

MoreVibe was created from a practical observation:

> AI coding tools are powerful, but long projects fail when memory, authority, workflow, and ownership are not structured well enough.

MoreVibe exists to make those projects easier to continue, easier to recover, and easier to operate with confidence.
