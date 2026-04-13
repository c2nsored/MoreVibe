from __future__ import annotations

import argparse
from datetime import datetime
from pathlib import Path


FILES_TO_SCAN = [
    ("canon/HANDOFF.md", "Handoff"),
    ("canon/TASKS.md", "Tasks"),
    ("canon/DECISIONS.md", "Decisions"),
    ("wiki/state.md", "State"),
    ("wiki/index.md", "Index"),
]


def first_nonempty_lines(text: str, limit: int = 5) -> list[str]:
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    return lines[:limit]


def append_log(log_path: Path, timestamp: str, summary: str, details: str) -> None:
    existing = log_path.read_text(encoding="utf-8") if log_path.exists() else "# MoreVibe Log\n\n"
    block = [
        f"## {timestamp} - bootstrap",
        "",
        summary,
    ]
    if details.strip():
        block.extend(["", details.strip()])
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(existing.rstrip() + "\n\n" + "\n".join(block) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Create a session-start brief from a MoreVibe harness.")
    parser.add_argument("--project-root", required=True)
    parser.add_argument("--timestamp", default="")
    parser.add_argument("--write-report", action="store_true")
    parser.add_argument("--skip-log", action="store_true")
    args = parser.parse_args()

    project_root = Path(args.project_root).expanduser().resolve()
    morevibe_root = project_root / ".morevibe"
    timestamp = args.timestamp.strip() or datetime.now().strftime("%Y-%m-%d %H:%M")

    report_lines = [
        "# MoreVibe Session Brief",
        "",
        f"Generated: {timestamp}",
        "",
        "## Startup Order",
        "- Read the root `AGENTS.md` first.",
        "- Use `morevibe-query-harness` if a quick memory scan is needed.",
        "- Read `wiki/state.md` and the current canon files before coding.",
        "- Route the task with `morevibe-using-morevibe`.",
        "",
        "## Current Snapshot",
    ]

    for rel_path, label in FILES_TO_SCAN:
        path = morevibe_root / rel_path
        report_lines.append(f"### {label}")
        if not path.exists():
            report_lines.append(f"- Missing `{rel_path}`.")
            report_lines.append("")
            continue

        preview = first_nonempty_lines(path.read_text(encoding="utf-8", errors="ignore"))
        if not preview:
            report_lines.append(f"- `{rel_path}` is empty.")
        else:
            for line in preview:
                report_lines.append(f"- {line}")
        report_lines.append("")

    report_lines.extend(
        [
            "## Subagent Reminder",
            "- Use `morevibe-delegate-work` only when ownership can be split cleanly.",
            "- Keep the main agent focused on orchestration and integration.",
        ]
    )

    report = "\n".join(report_lines).rstrip() + "\n"

    if args.write_report:
        query_dir = morevibe_root / "wiki" / "queries"
        query_dir.mkdir(parents=True, exist_ok=True)
        (query_dir / "session-brief-latest.md").write_text(report, encoding="utf-8")
        stamped = query_dir / f"session-brief-{datetime.now().strftime('%Y%m%d-%H%M%S')}.md"
        stamped.write_text(report, encoding="utf-8")

    if not args.skip_log:
        append_log(
            morevibe_root / "wiki" / "log.md",
            timestamp=timestamp,
            summary="Prepared a MoreVibe session brief.",
            details="Use the session brief before implementation to restore current project context.",
        )

    print(report)


if __name__ == "__main__":
    main()
