from __future__ import annotations

import argparse
import json
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
    "schema/FIRST_SESSION_GUIDE.md",
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

TODO_MARKERS = ("[TODO]", "TODO", "[no ", "One-sentence summary of the product")


def file_has_content(path: Path) -> bool:
    if not path.exists() or not path.is_file():
        return False
    return bool(path.read_text(encoding="utf-8").strip())


def check_timestamp_header(path: Path) -> bool:
    if not path.exists():
        return False
    text = path.read_text(encoding="utf-8")
    return "Last Updated:" in text or "Created:" in text


def has_placeholder_markers(path: Path) -> bool:
    if not path.exists() or not path.is_file():
        return False
    text = path.read_text(encoding="utf-8")
    return any(marker in text for marker in TODO_MARKERS)


def read_json_file(path: Path) -> dict | None:
    if not path.exists() or not path.is_file():
        return None
    raw = path.read_text(encoding="utf-8").strip()
    if not raw:
        return None
    return json.loads(raw)


def to_plain_guidance(warnings: list[str]) -> list[str]:
    guidance: list[str] = []
    for item in warnings:
        if "Placeholder text still exists" in item:
            guidance.append("- Some project memory files still contain starter template text. Replace those placeholders with the real project state before relying on them.")
        elif "does not use `pm-lead`" in item:
            guidance.append("- The installed role model does not clearly show `pm-lead` as the internal lead. Re-render the schema or inspect the installed agents.")
        elif "not fully aligned" in item:
            guidance.append("- Claude and Codex do not currently expose the same installed role set. Reinstall or inspect the project-local agent templates.")
        elif "Natural-language" in item:
            guidance.append("- The generated schema is missing some natural-language routing hints. Re-render the project schema so non-programmer prompts stay discoverable.")
        elif "Fallback" in item:
            guidance.append("- The fallback compatibility layer is missing from generated schema. Re-render the project schema and confirm fallback skills are still documented.")
        elif "active skill section" in item.lower():
            guidance.append("- The generated project skill map is missing the primary active workflow section. Re-render the schema before relying on the harness.")
        elif "Root `AGENTS.md` is missing" in item:
            guidance.append("- The project entrypoint is missing. Re-run installation or create the root `AGENTS.md` before starting a new session.")
    return list(dict.fromkeys(guidance))


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

    for rel in ["canon/PROJECT_OVERVIEW.md", "canon/TASKS.md", "canon/HANDOFF.md", "wiki/state.md"]:
        path = morevibe_root / rel
        if path.exists() and file_has_content(path):
            if has_placeholder_markers(path):
                warnings.append(f"- Placeholder text still exists in `{rel}`.")
            else:
                passes.append(f"- No obvious placeholder text detected in `{rel}`.")

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

    first_session_path = morevibe_root / "schema" / "FIRST_SESSION_GUIDE.md"
    if first_session_path.exists() and file_has_content(first_session_path):
        first_session_text = first_session_path.read_text(encoding="utf-8")
        if "orchestrator" in first_session_text and "pm-lead" in first_session_text:
            passes.append("- First-session guide includes the orchestrator -> pm-lead model.")
        else:
            warnings.append("- First-session guide exists but does not clearly explain the orchestrator -> pm-lead model.")

    role_map_path = morevibe_root / "schema" / "project_skill_map.json"
    role_map_data = read_json_file(role_map_path)
    if role_map_data and isinstance(role_map_data, dict):
        roles = role_map_data.get("roles") or {}
        lead = roles.get("lead")
        claude_agents = roles.get("claude_agents") or []
        codex_agents = roles.get("codex_agents") or []
        workers = roles.get("workers") or []
        reviewer = roles.get("reviewer")

        if lead == "pm-lead":
            passes.append("- Generated role map uses `pm-lead` as the internal lead.")
        else:
            warnings.append("- Generated role map does not use `pm-lead` as the internal lead.")

        if workers:
            passes.append("- Generated role map includes worker ownership.")
        else:
            warnings.append("- Generated role map does not include workers.")

        if reviewer == "qa-reviewer":
            passes.append("- Generated role map includes `qa-reviewer`.")
        else:
            warnings.append("- Generated role map does not include `qa-reviewer`.")

        if claude_agents and codex_agents:
            claude_set = set(claude_agents)
            codex_set = set(codex_agents)
            if claude_set == codex_set:
                passes.append("- Claude and Codex agent sets are aligned.")
            else:
                warnings.append("- Claude and Codex agent sets are not fully aligned.")
        elif claude_agents or codex_agents:
            warnings.append("- Only one tool-specific agent set was detected; parity could not be fully checked.")

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
        "## Friendly Guidance",
        *(to_plain_guidance(warnings) or ["- The harness looks healthy enough to keep using. Replace any remaining template placeholders with real project state as work progresses."]),
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
