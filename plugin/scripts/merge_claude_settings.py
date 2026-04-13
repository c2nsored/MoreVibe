from __future__ import annotations

import argparse
import json
from pathlib import Path


SESSION_END_COMMAND = 'python .claude/morevibe/scripts/lint_morevibe.py --project-root .'


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


def main() -> None:
    parser = argparse.ArgumentParser(description="Merge MoreVibe hooks into Claude Code settings.json.")
    parser.add_argument("--settings-path", required=True)
    args = parser.parse_args()

    settings_path = Path(args.settings_path).expanduser().resolve()
    settings = load_json(settings_path)
    hooks = settings.setdefault("hooks", {})
    ensure_event(hooks, "Stop", SESSION_END_COMMAND)

    settings_path.parent.mkdir(parents=True, exist_ok=True)
    settings_path.write_text(json.dumps(settings, indent=2) + "\n", encoding="utf-8")
    print(settings_path)


if __name__ == "__main__":
    main()
