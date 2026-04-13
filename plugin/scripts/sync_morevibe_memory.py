from __future__ import annotations

import argparse
from datetime import datetime
from pathlib import Path


STATE_TEMPLATE = """# MoreVibe State

Last Updated: {timestamp}

## Current Focus
{current_focus}

## Active Risks
{active_risks}

## Recent Changes
{recent_changes}

## Next Session
{next_session}
"""


HANDOFF_TEMPLATE = """# Handoff

Last Updated: {timestamp}

## Current Stage
{current_stage}

## Current Status
{current_status}

## Just Finished
{just_finished}

## Open Issues
{open_issues}

## Next Priority
{next_priority}

## Next Steps
{next_steps}

## References
{references}
"""


def normalize_block(value: str, default_text: str = "- None recorded.") -> str:
    value = (value or "").strip()
    return value if value else default_text


def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


def write_text(path: Path, content: str) -> None:
    ensure_parent(path)
    path.write_text(content.rstrip() + "\n", encoding="utf-8")


def append_log(path: Path, timestamp: str, category: str, summary: str, details: str) -> None:
    ensure_parent(path)
    existing = path.read_text(encoding="utf-8") if path.exists() else "# MoreVibe Log\n\n"
    entry = [
        f"## {timestamp} - {category}",
        "",
        normalize_block(summary, "- No summary recorded."),
    ]
    details = details.strip()
    if details:
        entry.extend(["", details])
    text = existing.rstrip() + "\n\n" + "\n".join(entry) + "\n"
    path.write_text(text, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Update MoreVibe state, handoff, and log files.")
    parser.add_argument("--project-root", required=True, help="Project root containing .morevibe/")
    parser.add_argument("--timestamp", default="", help="Explicit timestamp; defaults to current local time.")
    parser.add_argument("--current-focus", default="")
    parser.add_argument("--active-risks", default="")
    parser.add_argument("--recent-changes", default="")
    parser.add_argument("--next-session", default="")
    parser.add_argument("--current-stage", default="")
    parser.add_argument("--current-status", default="")
    parser.add_argument("--just-finished", default="")
    parser.add_argument("--open-issues", default="")
    parser.add_argument("--next-priority", default="")
    parser.add_argument("--next-steps", default="")
    parser.add_argument("--references", default="")
    parser.add_argument("--log-category", default="session")
    parser.add_argument("--log-summary", default="")
    parser.add_argument("--log-details", default="")
    args = parser.parse_args()

    project_root = Path(args.project_root).expanduser().resolve()
    morevibe_root = project_root / ".morevibe"
    wiki_root = morevibe_root / "wiki"
    canon_root = morevibe_root / "canon"

    timestamp = args.timestamp.strip() or datetime.now().strftime("%Y-%m-%d %H:%M")

    state_content = STATE_TEMPLATE.format(
        timestamp=timestamp,
        current_focus=normalize_block(args.current_focus),
        active_risks=normalize_block(args.active_risks),
        recent_changes=normalize_block(args.recent_changes),
        next_session=normalize_block(args.next_session),
    )
    handoff_content = HANDOFF_TEMPLATE.format(
        timestamp=timestamp,
        current_stage=normalize_block(args.current_stage),
        current_status=normalize_block(args.current_status),
        just_finished=normalize_block(args.just_finished),
        open_issues=normalize_block(args.open_issues),
        next_priority=normalize_block(args.next_priority),
        next_steps=normalize_block(args.next_steps),
        references=normalize_block(args.references),
    )

    write_text(wiki_root / "state.md", state_content)
    write_text(canon_root / "HANDOFF.md", handoff_content)
    append_log(
        wiki_root / "log.md",
        timestamp=timestamp,
        category=args.log_category.strip() or "session",
        summary=args.log_summary,
        details=args.log_details,
    )


if __name__ == "__main__":
    main()
