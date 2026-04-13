## MoreVibe v0.4.1

This release improves one important behavior: when MoreVibe is installed into a real project, it now renders `.morevibe/schema/*` from that project's actual skills and agent roles instead of leaving generic placeholder workflow names as the primary routing model.

### Highlights

- project-specific skill rendering during install
- project-specific role rendering during install
- improved session bootstrap guidance across Codex, Claude Code, and Antigravity
- `.morevibe/schema/PROJECT_SKILLS.md` generated from detected project assets
- bootstrap/session brief now prefers detected project-native workflow chains

### Why this release matters

Previous releases could still bias AI tools toward generic `morevibe-*` placeholder names.
This release makes MoreVibe align more closely with the real project it is installed into.

### Included asset

- `MoreVibeInstaller-v0.4.1-win-x64.zip`

### Windows install

1. Download the release ZIP.
2. Extract it.
3. Run `MoreVibeInstaller.exe`.
4. Point the installer at the target project root.

### Notes

- global bootstrap still stays lightweight
- project-local `.morevibe/` remains the harness namespace
- `canon/` remains the authoritative document layer
- `wiki/` remains compiled working memory
- the installer now renders project-native skills and delegation structure into schema files when possible
