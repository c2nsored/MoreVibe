# MoreVibe Adapters

Adapters connect the shared MoreVibe core to specific agent tools.

Each adapter should answer:

- What is the global entrypoint for this tool?
- What project-level entry files does it use?
- What should be added, referenced, or patched during installation?
- How can MoreVibe integrate without destructive overwrite?

Current adapter targets:

- `codex/`
- `claudecode/`
- `antigravity/`
