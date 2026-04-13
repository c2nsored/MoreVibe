from __future__ import annotations

import argparse
import re
from datetime import datetime
from pathlib import Path


INGEST_TEMPLATE = """# {title}

Created: {timestamp}
Layer: {layer}
Category: {category}

## Summary
{summary}

## Content
{content}

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


def append_log(log_path: Path, timestamp: str, category: str, summary: str, details: str) -> None:
    ensure_parent(log_path)
    existing = log_path.read_text(encoding="utf-8") if log_path.exists() else "# MoreVibe Log\n\n"
    lines = [
        f"## {timestamp} - {category}",
        "",
        normalize_block(summary, "- No summary recorded."),
    ]
    details = details.strip()
    if details:
        lines.extend(["", details])
    log_path.write_text(existing.rstrip() + "\n\n" + "\n".join(lines) + "\n", encoding="utf-8")


def refresh_index(index_path: Path, canonical_path: str, layer: str) -> None:
    ensure_parent(index_path)
    existing = index_path.read_text(encoding="utf-8") if index_path.exists() else "# MoreVibe Wiki Index\n\n"
    heading = "## Recent Ingested Items"
    bullet = f"- `{layer}/{canonical_path}`"

    if bullet in existing:
        return

    if heading not in existing:
        existing = existing.rstrip() + f"\n\n{heading}\n{bullet}\n"
    else:
        existing = existing.rstrip() + f"\n{bullet}\n"

    index_path.write_text(existing, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Ingest a new MoreVibe item into sources or canon.")
    parser.add_argument("--project-root", required=True)
    parser.add_argument("--layer", choices=["sources", "canon"], default="sources")
    parser.add_argument("--title", required=True)
    parser.add_argument("--category", default="note")
    parser.add_argument("--subdir", default="")
    parser.add_argument("--slug", default="")
    parser.add_argument("--timestamp", default="")
    parser.add_argument("--summary", default="")
    parser.add_argument("--content", default="")
    parser.add_argument("--references", default="")
    parser.add_argument("--log-category", default="ingest")
    args = parser.parse_args()

    project_root = Path(args.project_root).expanduser().resolve()
    morevibe_root = project_root / ".morevibe"
    timestamp = args.timestamp.strip() or datetime.now().strftime("%Y-%m-%d %H:%M")
    slug = args.slug.strip() or slugify(args.title)

    layer_root = morevibe_root / args.layer
    if args.subdir.strip():
        layer_root = layer_root / args.subdir.strip().replace("\\", "/")
    output_path = layer_root / f"{slug}.md"

    content = INGEST_TEMPLATE.format(
        title=args.title.strip(),
        timestamp=timestamp,
        layer=args.layer,
        category=args.category.strip() or "note",
        summary=normalize_block(args.summary, "- No summary recorded."),
        content=normalize_block(args.content, "- No content recorded."),
        references=normalize_block(args.references, "- No references recorded."),
    )

    ensure_parent(output_path)
    output_path.write_text(content.rstrip() + "\n", encoding="utf-8")

    relative = output_path.relative_to(morevibe_root).as_posix()
    append_log(
        morevibe_root / "wiki" / "log.md",
        timestamp=timestamp,
        category=args.log_category.strip() or "ingest",
        summary=f"Ingested `{relative}` into `{args.layer}`.",
        details=normalize_block(args.summary, "- No summary recorded."),
    )
    refresh_index(morevibe_root / "wiki" / "index.md", output_path.relative_to(morevibe_root / args.layer).as_posix(), args.layer)
    print(output_path)


if __name__ == "__main__":
    main()
