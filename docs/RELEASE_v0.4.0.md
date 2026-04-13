## MoreVibe v0.4.0

MoreVibe is a reusable LLM harness system for long-running vibe coding projects.

This release focuses on stabilizing the MoreVibe document model and aligning project bootstrap behavior across Codex, Claude Code, and Antigravity.

### Highlights

- standardized project-local `.morevibe/` structure
  - `schema/`
  - `sources/`
  - `canon/`
  - `wiki/`
- improved Windows installer flow with WPF-based installer UI
- refined global bootstrap behavior for:
  - Codex
  - Claude Code
  - Antigravity
- clarified MoreVibe as a harness system centered on host-native rule files
- reduced reliance on placeholder MoreVibe skill names
- aligned project workflows to real project-native skills and canon documents
- improved separation between:
  - global bootstrap
  - project canon
  - wiki working memory
  - tool-specific adapters

### Recommended model

MoreVibe should be understood as:

- global bootstrap in host-native rule files
- project-local `.morevibe/` as the harness namespace
- `canon/` as the authoritative project document layer
- `wiki/` as compiled working memory
- project-native skills and delegation rules as the real execution chain

### Packaging

Included release asset:

- `MoreVibeInstaller-v0.4.0-win-x64.zip`

After extracting the archive, run:

- `MoreVibeInstaller.exe`

### Notes

This release significantly improves structural consistency, but real session-start behavior is still ultimately influenced by how each host environment follows its native rule-entry model.

Codex, Claude Code, and Antigravity are now aligned much more closely around the same MoreVibe harness architecture.