from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path


FILES_TO_SCAN = [
    ('canon/HANDOFF.md', 'Handoff'),
    ('canon/TASKS.md', 'Tasks'),
    ('canon/DECISIONS.md', 'Decisions'),
    ('wiki/state.md', 'State'),
    ('wiki/index.md', 'Index'),
]


def first_nonempty_lines(text: str, limit: int = 5) -> list[str]:
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    return lines[:limit]


def append_log(log_path: Path, timestamp: str, summary: str, details: str) -> None:
    existing = log_path.read_text(encoding='utf-8') if log_path.exists() else '# MoreVibe Log\n\n'
    block = [f'## {timestamp} - bootstrap', '', summary]
    if details.strip():
        block.extend(['', details.strip()])
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(existing.rstrip() + '\n\n' + '\n'.join(block) + '\n', encoding='utf-8')


def load_project_skill_map(schema_root: Path) -> dict[str, object]:
    mapping_path = schema_root / 'project_skill_map.json'
    if not mapping_path.exists():
        return {}
    try:
        return json.loads(mapping_path.read_text(encoding='utf-8'))
    except json.JSONDecodeError:
        return {}


def main() -> None:
    parser = argparse.ArgumentParser(description='Create a session-start brief from a MoreVibe harness.')
    parser.add_argument('--project-root', required=True)
    parser.add_argument('--timestamp', default='')
    parser.add_argument('--write-report', action='store_true')
    parser.add_argument('--skip-log', action='store_true')
    parser.add_argument('--once', action='store_true', help='Skip output if bootstrap already ran within the last hour.')
    args = parser.parse_args()

    project_root = Path(args.project_root).expanduser().resolve()
    morevibe_root = project_root / '.morevibe'
    schema_root = morevibe_root / 'schema'
    timestamp = args.timestamp.strip() or datetime.now().strftime('%Y-%m-%d %H:%M')

    if args.once:
        session_flag = project_root / '.claude' / 'morevibe' / '.session_bootstrapped'
        now_ts = datetime.now(tz=timezone.utc).timestamp()
        if session_flag.exists():
            try:
                last_run = float(session_flag.read_text(encoding='utf-8').strip())
                if now_ts - last_run < 3600:
                    return
            except (ValueError, OSError):
                pass
        session_flag.parent.mkdir(parents=True, exist_ok=True)
        session_flag.write_text(str(now_ts), encoding='utf-8')

    project_map = load_project_skill_map(schema_root)
    skills = project_map.get('skills', {}) if isinstance(project_map, dict) else {}
    roles = project_map.get('roles', {}) if isinstance(project_map, dict) else {}
    startup = skills.get('startup', []) if isinstance(skills, dict) else []
    query_skill = skills.get('query') if isinstance(skills, dict) else None
    delegate_skill = skills.get('delegate') if isinstance(skills, dict) else None
    lead_role = roles.get('lead') if isinstance(roles, dict) else None
    worker_roles = roles.get('workers', []) if isinstance(roles, dict) else []
    reviewer_role = roles.get('reviewer') if isinstance(roles, dict) else None

    report_lines = [
        '# MoreVibe Session Brief',
        '',
        f'Generated: {timestamp}',
        '',
        '## Startup Order',
        '- Read the root `AGENTS.md` first.',
        '- Read `.morevibe/schema/OPERATING_RULES.md` early in the session.',
    ]
    if startup:
        report_lines.append(f"- Follow the detected startup skill chain: {', '.join(f'`{name}`' for name in startup)}.")
    if query_skill:
        report_lines.append(f'- Use `{query_skill}` only when a focused memory scan is needed.')
    report_lines.extend([
        '- Read `wiki/state.md` and the current canon files before coding.',
        '',
        '## Current Snapshot',
    ])

    for rel_path, label in FILES_TO_SCAN:
        path = morevibe_root / rel_path
        report_lines.append(f'### {label}')
        if not path.exists():
            report_lines.append(f'- Missing `{rel_path}`.')
            report_lines.append('')
            continue

        preview = first_nonempty_lines(path.read_text(encoding='utf-8', errors='ignore'))
        if not preview:
            report_lines.append(f'- `{rel_path}` is empty.')
        else:
            for line in preview:
                report_lines.append(f'- {line}')
        report_lines.append('')

    report_lines.extend(['## Delegation Reminder'])
    if lead_role:
        report_lines.append(f'- Lead role: `{lead_role}`')
    if worker_roles:
        report_lines.append(f"- Worker roles: {', '.join(f'`{name}`' for name in worker_roles)}")
    if reviewer_role:
        report_lines.append(f'- Reviewer role: `{reviewer_role}`')
    if delegate_skill:
        report_lines.append(f'- Use `{delegate_skill}` only when ownership can be split cleanly.')
    else:
        report_lines.append('- No project-native delegation skill was detected; keep orchestration with the main agent.')

    report = '\n'.join(report_lines).rstrip() + '\n'

    if args.write_report:
        query_dir = morevibe_root / 'wiki' / 'queries'
        query_dir.mkdir(parents=True, exist_ok=True)
        (query_dir / 'session-brief-latest.md').write_text(report, encoding='utf-8')
        stamped = query_dir / f"session-brief-{datetime.now().strftime('%Y%m%d-%H%M%S')}.md"
        stamped.write_text(report, encoding='utf-8')

    if not args.skip_log:
        append_log(
            morevibe_root / 'wiki' / 'log.md',
            timestamp=timestamp,
            summary='Prepared a MoreVibe session brief.',
            details='Use the detected project skill chain before implementation to restore current project context.',
        )

    print(report)


if __name__ == '__main__':
    main()
