from __future__ import annotations

import argparse
from datetime import datetime
from pathlib import Path


REQUIRED_DIRS = [
    "schema",
    "sources",
    "canon",
    "wiki",
    "wiki/outputs",
    "wiki/lint",
    "wiki/queries",
]

REQUIRED_FILES = [
    "schema/README.md",
    "schema/OPERATING_RULES.md",
    "schema/SESSION_BOOTSTRAP.md",
    "schema/SKILL_ROUTING.md",
    "schema/PROJECT_SKILLS.md",
    "canon/PROJECT_OVERVIEW.md",
    "canon/ARCHITECTURE.md",
    "canon/SCHEMA.md",
    "canon/TASKS.md",
    "canon/DECISIONS.md",
    "canon/HANDOFF.md",
    "canon/OPERATIONS.md",
    "wiki/index.md",
    "wiki/state.md",
    "wiki/log.md",
    "wiki/outputs/README.md",
    "wiki/lint/README.md",
    "wiki/queries/README.md",
    "sources/README.md",
    "canon/README.md",
]


def file_has_content(path: Path) -> bool:
    if not path.exists() or not path.is_file():
        return False
    return bool(path.read_text(encoding="utf-8").strip())


def check_timestamp_header(path: Path) -> bool:
    if not path.exists():
        return False
    text = path.read_text(encoding="utf-8")
    return "Last Updated:" in text or "Created:" in text


def append_log(log_path: Path, timestamp: str, summary: str, details: str) -> None:
    existing = log_path.read_text(encoding="utf-8") if log_path.exists() else "# MoreVibe Log\n\n"
    entry = "\n".join(
        [
            f"## {timestamp} - lint",
            "",
            summary,
            "",
            details.strip() or "- No details recorded.",
        ]
    )
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(existing.rstrip() + "\n\n" + entry + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Lint a .morevibe harness and write a report.")
    parser.add_argument("--project-root", required=True)
    parser.add_argument("--timestamp", default="")
    parser.add_argument("--skip-log", action="store_true")
    args = parser.parse_args()

    project_root = Path(args.project_root).expanduser().resolve()
    morevibe_root = project_root / ".morevibe"
    timestamp = args.timestamp.strip() or datetime.now().strftime("%Y-%m-%d %H:%M")

    issues: list[str] = []
    warnings: list[str] = []
    passes: list[str] = []

    if not morevibe_root.exists():
        issues.append("- Missing `.morevibe/` root.")
    else:
        passes.append("- Found `.morevibe/` root.")

    for rel in REQUIRED_DIRS:
        path = morevibe_root / rel
        if path.exists() and path.is_dir():
            passes.append(f"- Found directory `{rel}`.")
        else:
            issues.append(f"- Missing directory `{rel}`.")

    for rel in REQUIRED_FILES:
        path = morevibe_root / rel
        if not path.exists():
            issues.append(f"- Missing file `{rel}`.")
            continue
        if not file_has_content(path):
            issues.append(f"- Empty file `{rel}`.")
            continue
        passes.append(f"- Found content in `{rel}`.")

    for rel in ["wiki/state.md", "canon/HANDOFF.md"]:
        path = morevibe_root / rel
        if path.exists() and file_has_content(path):
            if check_timestamp_header(path):
                passes.append(f"- Timestamp header present in `{rel}`.")
            else:
                warnings.append(f"- No timestamp header found in `{rel}`.")

    agents_path = project_root / "AGENTS.md"
    if agents_path.exists():
        text = agents_path.read_text(encoding="utf-8")
        if "## MoreVibe Bootstrap" in text:
            passes.append("- Root `AGENTS.md` includes MoreVibe bootstrap block.")
        else:
            warnings.append("- Root `AGENTS.md` exists but does not include a MoreVibe bootstrap block.")
    else:
        warnings.append("- Root `AGENTS.md` is missing.")

    project_skills_path = morevibe_root / "schema" / "PROJECT_SKILLS.md"
    if project_skills_path.exists() and file_has_content(project_skills_path):
        project_skills_text = project_skills_path.read_text(encoding="utf-8")
        if "Detected specialist skills" in project_skills_text:
            passes.append("- Specialist skill section detected in `schema/PROJECT_SKILLS.md`.")
        else:
            warnings.append("- No specialist skill section detected in `schema/PROJECT_SKILLS.md`.")
        if "Active skills" in project_skills_text:
            passes.append("- Active skill section detected in `schema/PROJECT_SKILLS.md`.")
        else:
            warnings.append("- No active skill section detected in `schema/PROJECT_SKILLS.md`.")
        if "Fallback skills" in project_skills_text:
            passes.append("- Fallback skill section detected in `schema/PROJECT_SKILLS.md`.")
        else:
            warnings.append("- No fallback skill section detected in `schema/PROJECT_SKILLS.md`.")
        if "Natural-language routing notes" in project_skills_text:
            passes.append("- Natural-language routing notes detected in `schema/PROJECT_SKILLS.md`.")
        else:
            warnings.append("- No natural-language routing notes detected in `schema/PROJECT_SKILLS.md`.")

    routing_path = morevibe_root / "schema" / "SKILL_ROUTING.md"
    if routing_path.exists() and file_has_content(routing_path):
        routing_text = routing_path.read_text(encoding="utf-8")
        if "Natural-language examples" in routing_text:
            passes.append("- Natural-language examples detected in `schema/SKILL_ROUTING.md`.")
        else:
            warnings.append("- No natural-language examples detected in `schema/SKILL_ROUTING.md`.")
        if "Fallback skills" in routing_text:
            passes.append("- Fallback skill section detected in `schema/SKILL_ROUTING.md`.")
        else:
            warnings.append("- No fallback skill section detected in `schema/SKILL_ROUTING.md`.")

    summary_line = f"- Issues: {len(issues)} | Warnings: {len(warnings)} | Passes: {len(passes)}"
    report_lines = [
        "# MoreVibe Lint Report",
        "",
        f"Generated: {timestamp}",
        "",
        "## Summary",
        summary_line,
        "",
        "## Issues",
        *(issues or ["- None."]),
        "",
        "## Warnings",
        *(warnings or ["- None."]),
        "",
        "## Passes",
        *(passes or ["- None."]),
    ]
    report = "\n".join(report_lines).rstrip() + "\n"

    lint_dir = morevibe_root / "wiki" / "lint"
    lint_dir.mkdir(parents=True, exist_ok=True)
    (lint_dir / "latest.md").write_text(report, encoding="utf-8")
    stamped = lint_dir / f"{datetime.now().strftime('%Y%m%d-%H%M%S')}.md"
    stamped.write_text(report, encoding="utf-8")

    if not args.skip_log:
        append_log(
            morevibe_root / "wiki" / "log.md",
            timestamp=timestamp,
            summary=f"Linted MoreVibe harness. Issues={len(issues)}, warnings={len(warnings)}.",
            details="See `wiki/lint/latest.md` for the full report.",
        )

    print(report)


if __name__ == "__main__":
    main()
