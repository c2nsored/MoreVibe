from __future__ import annotations

import argparse
import json
from pathlib import Path


SESSION_START_COMMAND = 'python .claude/morevibe/scripts/bootstrap_morevibe_session.py --project-root . --once --skip-log'
SESSION_END_COMMAND = 'python .claude/morevibe/scripts/auto_sync_morevibe_session.py --project-root . --run-lint'
STATUS_LINE_COMMAND = 'powershell -NoProfile -ExecutionPolicy Bypass -File .claude/morevibe/scripts/statusline_morevibe.ps1'
PERMISSION_ASK_RULES = [
    "Bash(git push *)",
    "Bash(git reset --hard*)",
    "Bash(git clean -f*)",
    "Bash(git clean -fd*)",
    "Bash(rm -rf*)",
]


# MoreVibe-managed script basenames. Any Stop / UserPromptSubmit hook whose
# command references one of these scripts is considered "ours" and is
# replaced during reinstall. This prevents stale hook entries from a previous
# MoreVibe version (e.g. a Stop hook that only ran lint_morevibe.py) from
# piling up alongside the new canonical entry.
MOREVIBE_SCRIPT_BASENAMES = (
    "bootstrap_morevibe_session.py",
    "auto_sync_morevibe_session.py",
    "lint_morevibe.py",
    "sync_morevibe_memory.py",
)


def load_json(path: Path) -> dict:
    if not path.exists():
        return {}
    raw = path.read_text(encoding="utf-8-sig").strip()
    if not raw:
        return {}
    return json.loads(raw)


def _is_morevibe_command(command: str) -> bool:
    if not command:
        return False
    return any(basename in command for basename in MOREVIBE_SCRIPT_BASENAMES)


def _entry_has_only_morevibe_commands(entry: dict) -> bool:
    hooks = entry.get("hooks", [])
    if not hooks:
        return False
    for hook in hooks:
        if hook.get("type") != "command":
            return False
        if not _is_morevibe_command(hook.get("command", "")):
            return False
    return True


def ensure_event(hooks: dict, event_name: str, command: str) -> None:
    """Install the canonical MoreVibe command for this event.

    Behaviour:
    - Remove any existing entry that only contains MoreVibe-managed commands
      (including legacy versions such as lint_morevibe.py on Stop). This
      guarantees that a reinstall replaces the previous MoreVibe command
      instead of leaving both the old and the new entries in place.
    - Preserve unrelated user-defined entries untouched.
    - Append a single fresh entry with the canonical command.
    """
    existing = hooks.get(event_name, []) or []
    preserved: list[dict] = []
    for entry in existing:
        if isinstance(entry, dict) and _entry_has_only_morevibe_commands(entry):
            continue
        preserved.append(entry)
    preserved.append(
        {
            "hooks": [
                {
                    "type": "command",
                    "command": command,
                }
            ]
        }
    )
    hooks[event_name] = preserved


def ensure_status_line(settings: dict) -> None:
    settings["statusLine"] = {
        "type": "command",
        "command": STATUS_LINE_COMMAND,
        "padding": 1,
        "refreshInterval": 5,
    }


def ensure_permissions(settings: dict) -> None:
    permissions = settings.setdefault("permissions", {})
    ask_rules = permissions.setdefault("ask", [])
    for rule in PERMISSION_ASK_RULES:
        if rule not in ask_rules:
            ask_rules.append(rule)


def main() -> None:
    parser = argparse.ArgumentParser(description="Merge MoreVibe hooks into Claude Code settings.json.")
    parser.add_argument("--settings-path", required=True)
    args = parser.parse_args()

    settings_path = Path(args.settings_path).expanduser().resolve()
    settings = load_json(settings_path)
    hooks = settings.setdefault("hooks", {})
    ensure_event(hooks, "UserPromptSubmit", SESSION_START_COMMAND)
    ensure_event(hooks, "Stop", SESSION_END_COMMAND)
    ensure_status_line(settings)
    ensure_permissions(settings)

    settings_path.parent.mkdir(parents=True, exist_ok=True)
    settings_path.write_text(json.dumps(settings, indent=2) + "\n", encoding="utf-8")
    print(settings_path)


if __name__ == "__main__":
    main()
