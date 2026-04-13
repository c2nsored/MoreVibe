from __future__ import annotations

import argparse
import re
from datetime import datetime
from pathlib import Path


OUTPUT_TEMPLATE = """# {title}

Created: {timestamp}
Category: {category}

## Summary
{summary}

## Details
{details}

## References
{references}
"""


def slugify(value: str) -> str:
    value = value.strip().lower()
    value = re.sub(r"[^a-z0-9]+", "-", value)
    return value.strip("-") or "entry"


def normalize_block(value: str, default_text: str) -> str:
    value = (value or "").strip()
    return value if value else default_text


def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


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
    path.write_text(existing.rstrip() + "\n\n" + "\n".join(entry) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Write a reusable query/result artifact back into MoreVibe wiki outputs.")
    parser.add_argument("--project-root", required=True, help="Project root containing .morevibe/")
    parser.add_argument("--title", required=True)
    parser.add_argument("--category", default="query")
    parser.add_argument("--slug", default="")
    parser.add_argument("--timestamp", default="")
    parser.add_argument("--summary", default="")
    parser.add_argument("--details", default="")
    parser.add_argument("--references", default="")
    parser.add_argument("--log-category", default="writeback")
    parser.add_argument("--skip-log", action="store_true")
    args = parser.parse_args()

    project_root = Path(args.project_root).expanduser().resolve()
    morevibe_root = project_root / ".morevibe"
    wiki_root = morevibe_root / "wiki"
    outputs_root = wiki_root / "outputs"
    timestamp = args.timestamp.strip() or datetime.now().strftime("%Y-%m-%d %H:%M")
    slug = args.slug.strip() or slugify(args.title)
    file_stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    output_path = outputs_root / f"{file_stamp}-{slug}.md"

    content = OUTPUT_TEMPLATE.format(
        title=args.title.strip(),
        timestamp=timestamp,
        category=args.category.strip() or "query",
        summary=normalize_block(args.summary, "- No summary recorded."),
        details=normalize_block(args.details, "- No details recorded."),
        references=normalize_block(args.references, "- No references recorded."),
    )

    ensure_parent(output_path)
    output_path.write_text(content.rstrip() + "\n", encoding="utf-8")

    if not args.skip_log:
        append_log(
            wiki_root / "log.md",
            timestamp=timestamp,
            category=args.log_category.strip() or "writeback",
            summary=f"Stored reusable output: `{output_path.name}`",
            details=normalize_block(args.summary, "- No summary recorded."),
        )

    print(output_path)


if __name__ == "__main__":
    main()
