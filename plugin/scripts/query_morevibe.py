from __future__ import annotations

import argparse
import re
from collections import Counter
from datetime import datetime
from pathlib import Path


SEARCH_ROOTS = ("wiki", "canon", "sources")


def tokenize(query: str) -> list[str]:
    return [token for token in re.split(r"[^a-zA-Z0-9]+", query.lower()) if token]


def score_text(path: Path, tokens: list[str]) -> tuple[int, int]:
    text = path.read_text(encoding="utf-8", errors="ignore").lower()
    name = path.name.lower()
    text_hits = sum(text.count(token) for token in tokens)
    name_hits = sum(name.count(token) for token in tokens)
    return text_hits, name_hits


def append_log(log_path: Path, timestamp: str, summary: str, details: str) -> None:
    existing = log_path.read_text(encoding="utf-8") if log_path.exists() else "# MoreVibe Log\n\n"
    lines = [
        f"## {timestamp} - query",
        "",
        summary,
    ]
    if details.strip():
        lines.extend(["", details.strip()])
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(existing.rstrip() + "\n\n" + "\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Search a MoreVibe harness for relevant sources, canon, and wiki files.")
    parser.add_argument("--project-root", required=True)
    parser.add_argument("--query", required=True)
    parser.add_argument("--limit", type=int, default=8)
    parser.add_argument("--timestamp", default="")
    parser.add_argument("--skip-log", action="store_true")
    parser.add_argument("--write-report", action="store_true")
    args = parser.parse_args()

    project_root = Path(args.project_root).expanduser().resolve()
    morevibe_root = project_root / ".morevibe"
    tokens = tokenize(args.query)
    timestamp = args.timestamp.strip() or datetime.now().strftime("%Y-%m-%d %H:%M")

    matches: list[tuple[int, int, str]] = []
    counts = Counter()

    for root_name in SEARCH_ROOTS:
        base = morevibe_root / root_name
        if not base.exists():
            continue
        for path in base.rglob("*.md"):
            text_hits, name_hits = score_text(path, tokens)
            score = text_hits + (name_hits * 2)
            if score <= 0:
                continue
            relative = path.relative_to(morevibe_root).as_posix()
            counts[root_name] += 1
            matches.append((score, name_hits, relative))

    matches.sort(key=lambda item: (-item[0], -item[1], item[2]))
    selected = matches[: max(args.limit, 1)]

    report_lines = [
        "# MoreVibe Query Report",
        "",
        f"Generated: {timestamp}",
        f"Query: {args.query}",
        "",
        "## Match Counts",
        f"- wiki: {counts.get('wiki', 0)}",
        f"- canon: {counts.get('canon', 0)}",
        f"- sources: {counts.get('sources', 0)}",
        "",
        "## Top Matches",
    ]
    if selected:
        for score, _, relative in selected:
            report_lines.append(f"- `{relative}` (score: {score})")
    else:
        report_lines.append("- No matches found.")

    report = "\n".join(report_lines).rstrip() + "\n"

    if args.write_report:
        query_dir = morevibe_root / "wiki" / "queries"
        query_dir.mkdir(parents=True, exist_ok=True)
        (query_dir / "latest.md").write_text(report, encoding="utf-8")
        stamped = query_dir / f"{datetime.now().strftime('%Y%m%d-%H%M%S')}.md"
        stamped.write_text(report, encoding="utf-8")

    if not args.skip_log:
        append_log(
            morevibe_root / "wiki" / "log.md",
            timestamp=timestamp,
            summary=f"Queried MoreVibe harness for `{args.query}`.",
            details="Top results were written to the query report." if args.write_report else "Top results were returned in the command output.",
        )

    print(report)


if __name__ == "__main__":
    main()
