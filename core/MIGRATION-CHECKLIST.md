# MoreVibe Migration Checklist

This checklist captures the harness features extracted from Stick3r and maps them into MoreVibe.

## Core harness requirements

- [x] `sources / canon / wiki / schema` model defined
- [x] `.morevibe/` project namespace defined
- [x] `ingest / query / lint` loop documented
- [x] Codex adapter spec defined
- [x] ClaudeCode adapter spec scaffolded
- [x] Antigravity adapter spec scaffolded
- [x] safe project `AGENTS.md` bootstrap insertion implemented

## Project memory requirements

- [x] `.morevibe/wiki/index.md`
- [x] `.morevibe/wiki/state.md`
- [x] `.morevibe/wiki/log.md`
- [x] `.morevibe/schema/README.md`
- [x] `.morevibe/canon/PROJECT_OVERVIEW.md`
- [x] `.morevibe/canon/ARCHITECTURE.md`
- [x] `.morevibe/canon/DECISIONS.md`
- [x] `.morevibe/canon/TASKS.md`
- [x] `.morevibe/canon/HANDOFF.md`
- [x] `.morevibe/canon/OPERATIONS.md`
- [x] `.morevibe/canon/SCHEMA.md`

## Workflow skill requirements

- [x] bootstrap
- [x] start session
- [x] session brief
- [x] plan feature
- [x] execute plan
- [x] debug bug
- [x] delegate work
- [x] orchestrate subagents
- [x] request review
- [x] apply review fixes
- [x] verify change
- [x] update docs
- [x] update handoff
- [x] finish task
- [x] report deployment
- [x] test first

## Still missing for full automation

- [ ] automatic skill triggering outside tool support
- [x] Claude Code session-start hook bootstrap
- [x] Antigravity global and project rule bootstrap
- [x] scripted ingest into `sources` or `canon`
- [x] scripted harness query across `wiki / canon / sources`
- [x] scripted session bootstrap summary
- [x] scripted wiki write-back for reusable answers
- [x] scripted harness lint and drift reporting
- [x] ClaudeCode adapter export package installation
- [x] Antigravity adapter export package installation
