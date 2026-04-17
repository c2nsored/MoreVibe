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


def load_json(path: Path) -> dict:
    if not path.exists():
        return {}
    raw = path.read_text(encoding="utf-8").strip()
    if not raw:
        return {}
    return json.loads(raw)


def ensure_event(hooks: dict, event_name: str, command: str) -> None:
    event_items = hooks.setdefault(event_name, [])
    for item in event_items:
        for hook in item.get("hooks", []):
            if hook.get("type") == "command" and hook.get("command") == command:
                return
    event_items.append(
        {
            "hooks": [
                {
                    "type": "command",
                    "command": command,
                }
            ]
        }
    )


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
