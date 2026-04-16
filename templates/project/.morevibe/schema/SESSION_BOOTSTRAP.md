# Session Bootstrap

Use this file to standardize what should happen at the start of every session.

## Default startup order

1. Read the root `AGENTS.md`
2. Read `.morevibe/schema/OPERATING_RULES.md`
3. Read `.morevibe/schema/PROJECT_SKILLS.md`
4. Read `.morevibe/wiki/state.md`
5. Read `.morevibe/canon/HANDOFF.md`
6. Read `.morevibe/canon/TASKS.md`
7. Read additional canon files only when needed
8. Follow the detected startup chain before implementation

## Natural-language rule

Start from the user's natural request.

- First interpret what kind of work they want.
- Then route it to the right project skill chain.
- Do not force explicit command syntax unless the user chooses it.

## Quick interpretation hints

- "understand the project first" -> startup / onboarding
- "plan this before coding" -> planning / spec
- "find the cause first" -> failure investigation / bug work
- "review before finishing" -> review / risk / verify
- "update docs too" -> docs / handoff
- "prepare release" -> release / ship status
- "check the UI flow" -> review / UI QA / type-specific checks
- "check the API contract" -> review / contract safety / type-specific checks

## Rule

Do not start implementation before the current state has been restored and the request type has been classified.
