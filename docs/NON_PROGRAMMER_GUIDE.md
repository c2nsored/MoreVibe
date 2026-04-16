# Non-Programmer Guide

MoreVibe is meant to help you get stronger AI coding results without needing to memorize a complicated engineering process.

## The Main Idea

You do not need to learn internal skill names first.

You can start with natural requests like:

- "start by understanding this project"
- "plan this feature before building it"
- "find the cause of this bug first"
- "review this before we finish"
- "update the docs and handoff too"
- "check the UI flow before release"
- "make sure the API change is still compatible"

MoreVibe is designed so the AI can map these requests onto the correct workflow.

## What You Should Do

1. keep the project files and docs in the project
2. let the AI read `AGENTS.md` and `.morevibe/` first
3. ask for planning, review, docs, and handoff explicitly in plain language when needed
4. treat command-style shortcuts as optional, not required

## Good Request Examples

- "restore context and tell me the safest next step"
- "plan this feature before coding"
- "check what could break if we change this"
- "finish this and leave the next session ready"
- "prepare this for release and tell me what is still missing"
- "check whether the order flow could break before release"
- "review this API change for compatibility before we ship it"

## Optional Command Shortcuts

MoreVibe may provide command-style shortcuts such as a start or sync command.

These are optional.

- use them if they make you faster
- ignore them if plain-language requests already work for you
- you should never need to memorize commands just to get the main MoreVibe benefits

## First Session Suggestion

If you just installed MoreVibe, a good first message is:

- "start by understanding this project and tell me the safest next step"

You can also be more specific:

- "read the project first and plan this feature before coding"
- "restore context and review what could break before we change anything"
- "understand this project and leave the next session ready when you finish"

The installed project also includes `.morevibe/schema/FIRST_SESSION_GUIDE.md`.

Use it if you want a quick reminder of:

- what to read first
- how the orchestrator / lead / worker flow works
- which plain-language first requests work well

## What MoreVibe Helps With

- keeping context across sessions
- giving the AI a more stable working structure
- making review and handoff more repeatable
- reducing the amount of hidden process you have to invent yourself
