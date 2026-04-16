# MoreVibe

**Persistent project memory for AI coding tools.**  
MoreVibe is a non-destructive project harness for long-running vibe-coding workflows with tools like **Claude Code**, **Codex**, and **Antigravity**.

It helps AI tools stay consistent across long sessions by separating:

- **sources** → raw evidence, notes, references, and inputs
- **canon** → official current project truth
- **wiki** → AI-maintained working memory and state summaries
- **schema** → operating rules for how the system behaves

Instead of letting everything collapse into one giant, wasteful conversation history, MoreVibe gives your project a structured memory model that is easier to resume, easier to maintain, and more resistant to context drift.

---

## Why MoreVibe Exists

Long-running AI coding projects usually break down in the same ways:

- important decisions get buried in old chat history
- the same project facts must be re-explained again and again
- documents multiply but become scattered and inconsistent
- AI starts mixing raw notes, assumptions, and official project truth
- session quality drops as context windows fill up
- non-programmers have no stable operating model for keeping projects alive

MoreVibe exists to solve that.

It is not a magic prompt pack.  
It is not a replacement for engineering skill.  
It is not a fully autonomous agent framework.

It is a **practical harness** that helps AI coding tools work more reliably by giving them a stable structure for memory, rules, and project continuity.

---

## Who This Is For

MoreVibe is designed for:

- **non-programmers** using AI coding tools to build real projects
- **solo builders** who lose momentum when sessions reset or drift
- **long-running projects** that need durable memory across many sessions
- users who want a cleaner operating model than “just keep chatting”

MoreVibe may be especially useful if you have already experienced:

- context exhaustion
- repeated explanations to the AI
- document sprawl
- broken continuity across sessions
- unstable edits caused by poorly scoped agent behavior

---

## Who This Is Not For

MoreVibe may not be ideal yet for:

- users who want a completely document-free workflow
- users expecting identical behavior across every AI tool and version
- teams that already have a mature internal engineering process
- users who want full autonomy with no need to review AI output

MoreVibe improves structure and continuity.  
It does **not** remove the need for judgment, review, or project ownership.

---

## What MoreVibe Does

MoreVibe provides a structured project harness built around a local `.morevibe/` folder and adapter-specific bootstrap files for supported AI tools.

Depending on the tool, it can install or generate:

- project-local `.morevibe/` structure
- tool-specific entry files such as `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md`
- project-native skill folders for supported tools
- project-local agent and routing files for tools that support role-based orchestration
- reusable rules and operating instructions
- durable project memory layout
- optional bootstrap or plugin helpers for supported tools
- Windows installer support for guided setup

The goal is simple:

> Make long-running AI coding projects easier to continue, easier to recover, and less wasteful in context usage.

---

## Core Model

MoreVibe works by separating project knowledge into different layers with different responsibilities.

### `sources/`
Raw material.  
This includes notes, references, drafts, logs, meeting notes, copied research, and anything that should **not** automatically become official truth.

### `canon/`
Official project truth.  
This is where the current source of truth lives: project overview, architecture decisions, accepted workflows, current goals, and active task definitions.

### `wiki/`
AI-maintained working memory.  
This is where the AI can write summaries, current state snapshots, session continuity notes, and compiled memory that helps future sessions resume efficiently.

### `schema/`
Operating rules.  
This defines how the harness should behave: what belongs where, what should be read first, what can be treated as authoritative, and how the AI should update the system.

This separation reduces confusion between:

- **evidence** and **truth**
- **temporary memory** and **stable memory**
- **notes** and **official decisions**
- **project structure** and **session chatter**

---

## Without MoreVibe vs With MoreVibe

| Without MoreVibe | With MoreVibe |
|---|---|
| Project facts are repeatedly re-explained | Durable project memory reduces repetition |
| Chat history becomes the main memory system | Memory is written into structured project files |
| Notes, decisions, and assumptions get mixed together | Sources, canon, wiki, and schema are separated |
| Sessions drift after resets or long gaps | Resumption is more stable and predictable |
| AI behavior depends too much on fragile chat context | The project itself carries more of the continuity |
| Document sprawl grows without clear authority | Canon and schema define clearer authority |

---

## Quick Start

## Option 1 — Windows Installer (Recommended)

If you want the easiest path on Windows:

1. Go to **GitHub Releases**
2. Download the latest **MoreVibe installer** or packaged release ZIP
3. Run the installer
4. Choose your target AI tool(s)
5. Select your project folder
6. Complete installation
7. Start your AI tool from the project root

After installation, MoreVibe will place the project harness and supported adapter files into the selected project.
For a new or empty project, it can also create a starter `AGENTS.md`, install the default MoreVibe skill set, and generate project-local role files for supported tools.

If you enable the **default style** preset during installation, MoreVibe also adds:

- native workflow aliases such as `start-session`, `project-bootstrap`, `plan-feature`, and `execute-plan`
- a stronger preset-specific `AGENTS.md`
- richer project-local roles such as `pm-lead`, `storefront-ui`, `custom-editor`, `payments-orders`, and `qa-reviewer`
- matching Codex and Claude role models for the same project

---

## Option 2 — PowerShell Script

If you prefer script-based installation on Windows:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\install-morevibe.ps1
````

You may also use supported flags depending on your setup and release structure.

---

## Option 3 — Manual Setup

If you want to inspect everything and install manually:

1. Copy the project template into your target repository
2. Create the `.morevibe/` folder structure
3. Add the adapter entry files for your tool
4. Review and customize the initial documents
5. Start your AI tool and instruct it to follow the MoreVibe structure

Manual setup is slower, but useful if you want full control over every installed file.

---

## Recommended First Run

After installation, start your AI tool in the project root and do something like this:

> Read the project’s MoreVibe files first, understand the current canon and wiki, and continue work using the MoreVibe structure.

You can also be more explicit:

> Bootstrap this project using MoreVibe.
> Read the adapter entry file, then `.morevibe/schema`, `.morevibe/canon`, and `.morevibe/wiki`, and continue from the current project state.

The exact wording is less important than the behavior.
The goal is to make the AI read the installed structure before it begins editing.

---

## Supported Tools

MoreVibe is built around adapter-specific integration for major AI coding workflows.

### Claude Code

Supports project and global entry behavior through Claude-oriented files and bootstrap guidance.

### Codex

Supports Codex-oriented entry files, plugin/helper structure, and project-local `.codex/` role templates.

### Antigravity

Supports Antigravity-oriented bootstrap behavior and adapter-level project entry.

---

## Compatibility Notes

Current support is strongest for workflows built around the adapters already included in this repository.

Behavior may vary depending on:

* tool version
* local configuration
* whether project-level or global-level files are respected
* whether hooks or plugins are available in that environment
* how aggressively the tool compresses or ignores prior context

MoreVibe is designed to be **tool-aware**, but not every host exposes the same automation surface.

---

## Current Reality

MoreVibe is already useful, but it is important to describe its current state honestly.

### What already exists

* a working MoreVibe core structure
* project templates
* adapter-specific integration structure
* default project skill installation for supported tools
* project-local Codex role templates
* Windows installer support
* PowerShell install flow
* repository layout intended for real-world project bootstrap

### What is still evolving

* stronger automation parity across all supported tools
* more polished onboarding flows
* better screenshots and guided examples
* expanded documentation for edge cases and rollback
* more refined host-specific behavior over time

This project is real and usable, but still actively maturing.

---

## Repository Structure

A typical high-level layout looks like this:

```text
.
├─ adapters/
├─ core/
├─ docs/
├─ installer-ui/
├─ release/
├─ scripts/
├─ templates/
└─ README.md
```

### Key areas

* **`adapters/`**
  Tool-specific integration logic and bootstrap assets

* **`core/`**
  Core MoreVibe concepts, shared content, and system-level structure

* **`templates/`**
  Template files used to initialize a project with MoreVibe

* **`scripts/`**
  Installation and packaging scripts

* **`installer-ui/`**
  Windows GUI installer source

* **`release/`**
  Packaged release assets or release-oriented build outputs

* **`docs/`**
  Supporting project documentation, release guidance, and future user docs

---

## Typical Project Layout After Installation

A MoreVibe-enabled project will usually contain something like:

```text
your-project/
├─ .agents/skills/
├─ .morevibe/
│  ├─ schema/
│  ├─ sources/
│  ├─ canon/
│  └─ wiki/
├─ .codex/             # when Codex project integration is installed
├─ .claude/            # when Claude Code project integration is installed
├─ AGENTS.md / CLAUDE.md / GEMINI.md
└─ ...your project files...
```

### What each folder is for

| Path                 | Purpose                                     |
| -------------------- | ------------------------------------------- |
| `.morevibe/schema/`  | rules, conventions, and operating behavior  |
| `.morevibe/sources/` | raw inputs, evidence, notes, and references |
| `.morevibe/canon/`   | official current project truth              |
| `.morevibe/wiki/`    | AI-maintained summaries and working memory  |

Depending on the selected target tools, installation may also add:

- `AGENTS.md` as the project's public entrypoint when it does not already exist
- `.agents/skills/` with the default MoreVibe workflow skills
- `.claude/skills/` and `.claude/agents/` for Claude Code
- `.codex/config.toml` and `.codex/agents/*.toml` for Codex

If the **default style** preset is enabled, installation may additionally add:

- native alias skills layered on top of the generic `morevibe-*` skills
- preset-specific project `AGENTS.md` guidance
- `storefront-ui`, `custom-editor`, and `payments-orders` role templates for both Codex and Claude Code
- a generated project schema that prefers the native startup chain over generic fallback names

---

## Recommended Usage Pattern

A practical workflow looks like this:

1. **Install MoreVibe into the project**
2. **Define or update canon**

   * project overview
   * goals
   * current architecture
   * current tasks
3. **Store raw notes in sources**
4. **Let the AI summarize active state into wiki**
5. **Keep schema stable**
6. **Use canon as the authority**
7. **Resume future sessions from the installed structure instead of raw chat history**

This keeps the project more stable over time and reduces the need to “re-teach” the same context in every session.

The installer also prints a small bootstrap health report so you can confirm the entrypoint, skills, and agent files were actually created.

---

## Example Workflow

### Without structure

You spend 2 weeks building a project with an AI tool.
By the third or fourth major session:

* the AI forgets prior decisions
* task state is fuzzy
* old explanations must be repeated
* documents exist, but nobody knows which one is authoritative

### With MoreVibe

You install MoreVibe and maintain:

* `sources/` for raw notes and imports
* `canon/` for project truth
* `wiki/` for current summarized state
* `schema/` for operating rules

Now a new session can begin by reading the project harness first, instead of depending on fragile chat memory alone.

---

## Design Principles

MoreVibe is built around a few strong principles:

### 1. Non-destructive by default

It should avoid unnecessary overwrites and preserve existing project work whenever possible.

### 2. Authority must be explicit

Not every document should have the same status.
Canon exists so the project can have a clearer source of truth.

### 3. AI memory should be externalized

Important project continuity should live in files, not only in chat history.

### 4. Raw evidence should not automatically become truth

Sources and canon are intentionally separated.

### 5. Resume quality matters

A long-running project is only useful if it can survive session breaks, context compression, and tool changes.

### 6. Non-programmers need structure even more

MoreVibe is especially motivated by users who do not already have professional engineering habits or infrastructure.

---

## Safety and Expectation Setting

MoreVibe improves continuity and organization, but it does **not** guarantee:

* correct code
* correct architecture
* safe edits
* perfect agent behavior
* automatic project success

You should still:

* review generated changes
* use version control
* keep backups
* test important behavior
* treat AI output as something to validate, not blindly trust

---

## FAQ

### Does MoreVibe replace normal documentation?

No.
It gives your documentation system clearer structure and clearer responsibilities.

### Does MoreVibe work only for programmers?

No.
In fact, one of its main goals is helping non-programmers run long AI-assisted projects more reliably.

### Is this just a prompt pack?

No.
It is a project harness and memory structure, not just a collection of prompts.

### Does it fully automate every supported tool?

Not yet.
Support depends on the tool and the automation surface it exposes.

### Can I use MoreVibe manually?

Yes.
You can install and maintain the structure manually if you prefer.

### Do I still need Git?

Yes, strongly recommended.
MoreVibe is not a replacement for version control.

---

## Rollback / Removal

If you want to remove MoreVibe from a project:

1. Delete the adapter entry files you added for your AI tool
2. Remove the `.morevibe/` folder
3. Restore any backed-up files if you replaced or merged existing project files
4. Confirm your project still starts normally without the harness files

If you are using the installer or scripts in a production workflow, it is wise to commit your project before installation so rollback is easy.

---

## Documentation

Additional project documentation lives in the `docs/` directory.

Suggested reading order for new users:

1. `README.md`
2. `docs/RELEASE_GUIDE.md`
3. template documentation under `templates/`
4. adapter-specific files under `adapters/`

As the project matures, more user-facing guides, examples, and troubleshooting docs will be added there.

---

## Roadmap Direction

The long-term goal of MoreVibe is not to become “the most complex AI workflow system.”

The goal is narrower and more practical:

* make long-running AI coding projects more durable
* reduce context waste
* improve session resumption
* help non-programmers keep projects coherent
* provide a reusable harness that can adapt across multiple AI coding tools

In other words:

> MoreVibe is about making AI coding projects easier to continue without falling apart.

---

## Contributing

Contributions, issue reports, and practical feedback are welcome.

Especially useful feedback includes:

* installer problems
* adapter-specific behavior differences
* onboarding confusion
* documentation gaps
* examples of what worked or failed in real usage
* suggestions that make MoreVibe easier for non-programmers to adopt

If you open an issue, practical reproduction steps are extremely helpful.

---

## License

Please see the repository license file for current licensing terms.

---

## Final Note

MoreVibe was created from a very practical observation:

AI coding tools are powerful, but long projects often fail because memory, authority, and continuity are poorly structured.

MoreVibe is an attempt to fix that with a project harness that is simple in concept, durable in practice, and especially useful for people trying to build with AI without a traditional engineering background.
