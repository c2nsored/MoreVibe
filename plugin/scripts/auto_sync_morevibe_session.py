from __future__ import annotations

import argparse
import json
import subprocess
import sys
from datetime import datetime
from pathlib import Path


PLACEHOLDER_MARKERS = (
    "[TODO]",
    "The highest-priority task currently in progress.",
    "The next most important task after the current one.",
    "Lower-priority tasks that matter, but are not active yet.",
    "Tasks waiting on a decision, missing information, or another dependency.",
    "Keep tasks short and outcome-focused so a new session can resume quickly.",
    "What the project is actively trying to accomplish right now.",
    "What could break progress, quality, or deployment right now.",
    "The most recent meaningful updates worth remembering next session.",
    "What should be checked or resumed first in the next session.",
    "What stage the project is currently in.",
    "The most important current truth in 1-3 bullets.",
    "What changed in the most recent meaningful work.",
    "Risks, bugs, missing decisions, or known weak spots.",
    "The single next task to pick up first.",
)

STATE_HEADINGS = (
    "Current Focus",
    "Active Risks",
    "Recent Changes",
    "Next Session",
)

HANDOFF_HEADINGS = (
    "Current Stage",
    "Current Status",
    "Just Finished",
    "Open Issues",
    "Next Priority",
    "Next Steps",
    "References",
)

AUTO_SYNC_STATE_FILENAME = ".auto_sync_state.json"
DRIFT_AUDIT_INTERVAL = 10


def parse_sections(path: Path) -> dict[str, str]:
    if not path.exists():
        return {}
    sections: dict[str, list[str]] = {}
    current_key: str | None = None
    for line in path.read_text(encoding="utf-8", errors="ignore").splitlines():
        if line.startswith("## "):
            current_key = line[3:].strip()
            sections[current_key] = []
            continue
        if current_key is not None:
            sections[current_key].append(line)
    return {key: "\n".join(value).strip() for key, value in sections.items()}


def has_real_content(text: str | None) -> bool:
    if not text:
        return False
    normalized = text.strip()
    if not normalized:
        return False
    return not any(marker in normalized for marker in PLACEHOLDER_MARKERS)


def is_placeholder_text(text: str) -> bool:
    normalized = (text or "").strip()
    return not normalized or any(marker in normalized for marker in PLACEHOLDER_MARKERS)


def clean_line(line: str) -> str:
    stripped = line.strip()
    if not stripped:
        return ""
    return stripped


def parse_bullets(section_text: str | None) -> list[str]:
    if not section_text:
        return []
    results: list[str] = []
    for raw in section_text.splitlines():
        line = clean_line(raw)
        if not line:
            continue
        if is_placeholder_text(line):
            continue
        if line.startswith(("- ", "* ")):
            results.append(line)
        elif line[0].isdigit() and ". " in line:
            results.append(line)
        else:
            results.append(f"- {line}")
    return results


def section_or_default(existing_sections: dict[str, str], key: str, fallback_lines: list[str]) -> list[str]:
    existing = existing_sections.get(key)
    if has_real_content(existing):
        return parse_bullets(existing)
    return fallback_lines


def run_git(project_root: Path, *args: str) -> str:
    top_level = ""
    if args and args[0] != "rev-parse":
        top_level = run_git(project_root, "rev-parse", "--show-toplevel")
        if not top_level:
            return ""
        try:
            if Path(top_level).resolve() != project_root.resolve():
                return ""
        except OSError:
            return ""
    try:
        result = subprocess.run(
            ["git", *args],
            cwd=project_root,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="ignore",
            check=False,
        )
    except OSError:
        return ""
    if result.returncode != 0:
        return ""
    return result.stdout.strip()


def git_changed_files(project_root: Path, limit: int = 6) -> list[str]:
    output = run_git(project_root, "status", "--short")
    if not output:
        return []
    files: list[str] = []
    for line in output.splitlines():
        if len(line) < 4:
            continue
        files.append(line[3:].strip())
        if len(files) >= limit:
            break
    return files


def summarize_tasks(project_root: Path) -> tuple[list[str], list[str], list[str], list[str]]:
    tasks_sections = parse_sections(project_root / ".morevibe" / "canon" / "TASKS.md")
    now_lines = parse_bullets(tasks_sections.get("Now"))
    next_lines = parse_bullets(tasks_sections.get("Next"))
    blocked_lines = parse_bullets(tasks_sections.get("Blocked"))
    notes_lines = parse_bullets(tasks_sections.get("Notes"))
    return now_lines, next_lines, blocked_lines, notes_lines


def build_state_content(timestamp: str, current_focus: list[str], active_risks: list[str], recent_changes: list[str], next_session: list[str]) -> str:
    lines = [
        "# MoreVibe State",
        "",
        f"Last Updated: {timestamp}",
        "",
        "## Current Focus",
        *(current_focus or ["- No current focus recorded."]),
        "",
        "## Active Risks",
        *(active_risks or ["- No active risks recorded."]),
        "",
        "## Recent Changes",
        *(recent_changes or ["- No recent changes recorded."]),
        "",
        "## Next Session",
        *(next_session or ["- No next-session guidance recorded."]),
        "",
    ]
    return "\n".join(lines)


def build_handoff_content(
    timestamp: str,
    current_stage: list[str],
    current_status: list[str],
    just_finished: list[str],
    open_issues: list[str],
    next_priority: list[str],
    next_steps: list[str],
    references: list[str],
) -> str:
    lines = [
        "# Handoff",
        "",
        f"Last Updated: {timestamp}",
        "",
        "## Current Stage",
        *(current_stage or ["- Stage not recorded."]),
        "",
        "## Current Status",
        *(current_status or ["- Current status not recorded."]),
        "",
        "## Just Finished",
        *(just_finished or ["- Nothing recorded yet."]),
        "",
        "## Open Issues",
        *(open_issues or ["- No open issues recorded."]),
        "",
        "## Next Priority",
        *(next_priority or ["- No next priority recorded."]),
        "",
        "## Next Steps",
        *(next_steps or ["1. Re-open the current tasks and continue from the top priority."]),
        "",
        "## References",
        *(references or ["- `AGENTS.md`", "- `.morevibe/schema/SESSION_BOOTSTRAP.md`"]),
        "",
    ]
    return "\n".join(lines)


def append_log(log_path: Path, timestamp: str, summary: str, details: list[str]) -> None:
    existing = log_path.read_text(encoding="utf-8") if log_path.exists() else "# MoreVibe Log\n\n"
    block = [
        f"## {timestamp} - auto-sync",
        "",
        summary,
    ]
    if details:
        block.extend(["", *details])
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(existing.rstrip() + "\n\n" + "\n".join(block) + "\n", encoding="utf-8")


def run_lint(project_root: Path) -> tuple[int, str]:
    script_path = Path(__file__).with_name("lint_morevibe.py")
    result = subprocess.run(
        [sys.executable, str(script_path), "--project-root", str(project_root), "--skip-log"],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="ignore",
        check=False,
    )
    return result.returncode, (result.stdout or result.stderr or "").strip()


def load_auto_sync_state(wiki_root: Path) -> dict[str, int | str]:
    state_path = wiki_root / AUTO_SYNC_STATE_FILENAME
    if not state_path.exists():
        return {"runs": 0, "last_drift_audit": ""}
    try:
        return json.loads(state_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {"runs": 0, "last_drift_audit": ""}


def save_auto_sync_state(wiki_root: Path, state: dict[str, int | str]) -> None:
    state_path = wiki_root / AUTO_SYNC_STATE_FILENAME
    state_path.parent.mkdir(parents=True, exist_ok=True)
    state_path.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")


def extract_friendly_guidance(lint_output: str) -> str:
    if not lint_output:
        return ""
    lines = lint_output.splitlines()
    collected: list[str] = []
    in_guidance = False
    for line in lines:
        if line.startswith("## "):
            if line == "## Friendly Guidance":
                in_guidance = True
                collected.append(line)
                continue
            if in_guidance:
                break
        elif in_guidance:
            collected.append(line)
    return "\n".join(collected).strip()


def generate_drift_audit(
    project_root: Path,
    wiki_root: Path,
    canon_root: Path,
    timestamp: str,
    changed_files: list[str],
    current_focus: list[str],
    active_risks: list[str],
) -> Path:
    outputs_root = wiki_root / "outputs"
    outputs_root.mkdir(parents=True, exist_ok=True)
    report_name = f"{datetime.now().strftime('%Y%m%d-%H%M%S')}-doc-drift-audit.md"
    report_path = outputs_root / report_name

    candidate_paths = [
        canon_root / "PROJECT_OVERVIEW.md",
        canon_root / "TASKS.md",
        canon_root / "HANDOFF.md",
        wiki_root / "state.md",
        wiki_root / "index.md",
    ]
    placeholder_files = [
        path.relative_to(project_root).as_posix()
        for path in candidate_paths
        if path.exists() and is_placeholder_text(path.read_text(encoding="utf-8", errors="ignore"))
    ]

    lines = [
        "# MoreVibe Drift Audit",
        "",
        f"Generated: {timestamp}",
        f"Run cadence: every {DRIFT_AUDIT_INTERVAL} session-end syncs",
        "",
        "## Summary",
        "- This report was generated automatically by session-end auto-sync.",
        "- Use it as a quick prompt to reconcile canon/wiki state with the codebase before drift compounds.",
        "",
        "## Current Focus Snapshot",
        *(current_focus or ["- No current focus recorded."]),
        "",
        "## Active Risks Snapshot",
        *(active_risks or ["- No active risks recorded."]),
        "",
        "## Working Tree Signals",
    ]
    if changed_files:
        lines.extend(f"- `{name}`" for name in changed_files)
    else:
        lines.append("- No git working-tree summary was available for this project root.")
    lines.extend(["", "## Placeholder-Or-Template Files"])
    if placeholder_files:
        lines.extend(f"- `{name}` still looks like template or placeholder content." for name in placeholder_files)
    else:
        lines.append("- No obvious placeholder-heavy canon/wiki files were detected.")
    lines.extend(
        [
            "",
            "## Recommended Follow-up",
            "1. Re-open `.morevibe/canon/TASKS.md` and confirm the top task still matches the real code state.",
            "2. Reconcile any placeholder-heavy canon/wiki files with current implementation decisions.",
            "3. If the project changed substantially, run the `audit-doc-drift` workflow before the next major handoff.",
            "",
        ]
    )
    report_path.write_text("\n".join(lines), encoding="utf-8")
    return report_path


def main() -> None:
    parser = argparse.ArgumentParser(description="Auto-sync MoreVibe session state on session end.")
    parser.add_argument("--project-root", required=True)
    parser.add_argument("--timestamp", default="")
    parser.add_argument("--run-lint", action="store_true")
    parser.add_argument("--skip-log", action="store_true")
    args = parser.parse_args()

    project_root = Path(args.project_root).expanduser().resolve()
    morevibe_root = project_root / ".morevibe"
    wiki_root = morevibe_root / "wiki"
    canon_root = morevibe_root / "canon"

    timestamp = args.timestamp.strip() or datetime.now().strftime("%Y-%m-%d %H:%M")

    state_sections = parse_sections(wiki_root / "state.md")
    handoff_sections = parse_sections(canon_root / "HANDOFF.md")
    now_lines, next_lines, blocked_lines, notes_lines = summarize_tasks(project_root)

    git_branch = run_git(project_root, "branch", "--show-current")
    last_commit = run_git(project_root, "log", "-1", "--pretty=format:%h %s")
    changed_files = git_changed_files(project_root)

    current_focus = section_or_default(
        state_sections,
        "Current Focus",
        now_lines or ["- Continue from the highest-priority item in `.morevibe/canon/TASKS.md`."],
    )
    active_risks = section_or_default(
        state_sections,
        "Active Risks",
        blocked_lines or ["- Re-check document drift, verification gaps, and release readiness before closing work."],
    )

    recent_changes_fallback: list[str] = []
    if last_commit:
        recent_changes_fallback.append(f"- Last commit: `{last_commit}`")
    if git_branch:
        recent_changes_fallback.append(f"- Current branch: `{git_branch}`")
    if changed_files:
        recent_changes_fallback.append(f"- Working tree changes: {', '.join(f'`{name}`' for name in changed_files)}")
    if not recent_changes_fallback:
        recent_changes_fallback.append("- No git-based change summary was detected; review current canon/wiki updates manually.")

    next_session_fallback = next_lines or notes_lines or ["- Start from `.morevibe/schema/FIRST_SESSION_GUIDE.md` and the top item in `canon/TASKS.md`."]

    recent_changes = section_or_default(state_sections, "Recent Changes", recent_changes_fallback)
    next_session = section_or_default(state_sections, "Next Session", next_session_fallback)

    current_stage = section_or_default(
        handoff_sections,
        "Current Stage",
        ["- Active implementation / review cycle in progress."],
    )
    current_status = section_or_default(
        handoff_sections,
        "Current Status",
        [
            "- The project state was auto-synced at session end.",
            "- Review `canon/TASKS.md`, `wiki/state.md`, and generated schema before the next code change.",
        ],
    )
    just_finished = section_or_default(
        handoff_sections,
        "Just Finished",
        recent_changes_fallback,
    )
    open_issues = section_or_default(
        handoff_sections,
        "Open Issues",
        active_risks,
    )
    next_priority = section_or_default(
        handoff_sections,
        "Next Priority",
        next_lines[:1] or ["- Resume the highest-priority task in `canon/TASKS.md`."],
    )
    next_steps = section_or_default(
        handoff_sections,
        "Next Steps",
        [
            "1. Re-open `.morevibe/schema/FIRST_SESSION_GUIDE.md` and `.morevibe/schema/PROJECT_SKILLS.md`.",
            "2. Confirm the current top task and any blockers in `.morevibe/canon/TASKS.md`.",
        ],
    )
    references = section_or_default(
        handoff_sections,
        "References",
        [
            "- `AGENTS.md`",
            "- `.morevibe/schema/SESSION_BOOTSTRAP.md`",
            "- `.morevibe/canon/TASKS.md`",
            "- `.morevibe/wiki/state.md`",
        ],
    )

    (wiki_root / "state.md").write_text(
        build_state_content(timestamp, current_focus, active_risks, recent_changes, next_session),
        encoding="utf-8",
    )
    (canon_root / "HANDOFF.md").write_text(
        build_handoff_content(timestamp, current_stage, current_status, just_finished, open_issues, next_priority, next_steps, references),
        encoding="utf-8",
    )

    auto_sync_state = load_auto_sync_state(wiki_root)
    run_count = int(auto_sync_state.get("runs", 0)) + 1
    auto_sync_state["runs"] = run_count

    drift_report_path: Path | None = None
    if run_count % DRIFT_AUDIT_INTERVAL == 0:
        drift_report_path = generate_drift_audit(
            project_root=project_root,
            wiki_root=wiki_root,
            canon_root=canon_root,
            timestamp=timestamp,
            changed_files=changed_files,
            current_focus=current_focus,
            active_risks=active_risks,
        )
        auto_sync_state["last_drift_audit"] = timestamp
    save_auto_sync_state(wiki_root, auto_sync_state)

    lint_details: list[str] = []
    friendly_guidance = ""
    if args.run_lint:
        lint_code, lint_output = run_lint(project_root)
        if lint_output:
            summary_line = next((line for line in lint_output.splitlines() if line.startswith("- Issues:")), "")
            if summary_line:
                lint_details.append(summary_line)
            friendly_guidance = extract_friendly_guidance(lint_output)
        if lint_code != 0:
            lint_details.append("- Lint command returned a non-zero exit code; inspect `wiki/lint/latest.md` manually.")

    if not args.skip_log:
        log_details = [
            "- Refreshed `wiki/state.md` and `canon/HANDOFF.md` on session end.",
            "- Preserved existing manual content where it was already present.",
        ]
        log_details.append(f"- Session-end auto-sync run count: {run_count}.")
        if changed_files:
            log_details.append(f"- Observed working tree changes: {', '.join(f'`{name}`' for name in changed_files)}")
        if drift_report_path is not None:
            log_details.append(f"- Generated periodic drift audit: `{drift_report_path.relative_to(project_root).as_posix()}`")
        log_details.extend(lint_details)
        append_log(
            wiki_root / "log.md",
            timestamp=timestamp,
            summary="Auto-synced session memory at session end.",
            details=log_details,
        )

    print(f"Auto-synced MoreVibe session memory for {project_root}")
    print(f"Auto-sync run count: {run_count}")
    if drift_report_path is not None:
        print(f"Generated periodic drift audit: {drift_report_path}")
    if friendly_guidance:
        print()
        print(friendly_guidance)


if __name__ == "__main__":
    main()
