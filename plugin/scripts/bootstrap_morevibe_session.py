from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

# Hook output is read by Claude Code (Node.js) as UTF-8. On Windows the default
# Python stdout is the ANSI code page (e.g. cp949), which garbles Korean text in
# the session brief. Force UTF-8 so the Migration Advisory reaches the model intact.
for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8")
    except (AttributeError, OSError):
        pass

SESSION_BOOTSTRAP_STATE_VERSION = 2
SESSION_BOOTSTRAP_INTERVAL_SECONDS = 3600


FILES_TO_SCAN = [
    ('canon/HANDOFF.md', 'Handoff'),
    ('canon/TASKS.md', 'Tasks'),
    ('canon/DECISIONS.md', 'Decisions'),
    ('wiki/state.md', 'State'),
    ('wiki/index.md', 'Index'),
]


def first_nonempty_lines(text: str, limit: int = 5) -> list[str]:
    lines = [line.lstrip('\ufeff').strip() for line in text.splitlines() if line.strip()]
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


def load_session_bootstrap_state(state_path: Path) -> dict[str, object]:
    if not state_path.exists():
        return {}

    raw = state_path.read_text(encoding='utf-8', errors='ignore').strip()
    if not raw:
        return {}

    try:
        parsed = json.loads(raw)
        if isinstance(parsed, dict):
            return parsed
    except json.JSONDecodeError:
        pass

    try:
        return {
            'version': 1,
            'last_run': float(raw),
            'migration_advisory_shown': False,
        }
    except ValueError:
        return {}


def write_session_bootstrap_state(state_path: Path, timestamp_utc: float, migration_advisory_shown: bool) -> None:
    state = {
        'version': SESSION_BOOTSTRAP_STATE_VERSION,
        'last_run': timestamp_utc,
        'migration_advisory_shown': migration_advisory_shown,
        'updated_at': datetime.now(tz=timezone.utc).isoformat(),
    }
    state_path.parent.mkdir(parents=True, exist_ok=True)
    state_path.write_text(json.dumps(state, indent=2) + '\n', encoding='utf-8')


def detect_migration_needed(project_root: Path) -> tuple[bool, list[str]]:
    """Detect whether this looks like an existing project that has not yet
    been adapted to MoreVibe (i.e. migrate-existing-project skill should run).

    Returns (needed, signals). `needed` is True only if the sentinel is
    absent AND at least one existing-project signal is present.
    """
    sentinel = project_root / '.morevibe' / '.migration_complete'
    if sentinel.exists():
        return False, []

    signals: list[str] = []

    docs_dir = project_root / 'docs'
    if docs_dir.is_dir():
        try:
            has_content = any(p.is_file() for p in docs_dir.rglob('*'))
        except OSError:
            has_content = False
        if has_content:
            signals.append('existing `docs/` directory with files')

    readme = project_root / 'README.md'
    if readme.is_file():
        try:
            line_count = sum(1 for _ in readme.open(encoding='utf-8', errors='ignore'))
        except OSError:
            line_count = 0
        if line_count >= 40:
            signals.append(f'substantial root `README.md` ({line_count} lines)')

    for pattern in ('AGENTS.md.backup-*', 'CLAUDE.md.backup-*', 'GEMINI.md.backup-*'):
        matches = list(project_root.glob(pattern))
        if matches:
            signals.append(f'{len(matches)} `{pattern}` file(s) from prior installs')

    manifests = ['package.json', 'pyproject.toml', 'Cargo.toml', 'go.mod', 'composer.json']
    present_manifests = [m for m in manifests if (project_root / m).is_file()]
    if present_manifests:
        signals.append(f'project manifests present: {", ".join(present_manifests)}')

    return (bool(signals), signals)


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
    migration_needed, migration_signals = detect_migration_needed(project_root)

    if args.once:
        session_flag = project_root / '.claude' / 'morevibe' / '.session_bootstrapped'
        now_ts = datetime.now(tz=timezone.utc).timestamp()
        session_state = load_session_bootstrap_state(session_flag)
        last_run = float(session_state.get('last_run', 0) or 0)
        migration_advisory_shown = bool(session_state.get('migration_advisory_shown'))
        recently_bootstrapped = last_run and (now_ts - last_run < SESSION_BOOTSTRAP_INTERVAL_SECONDS)

        # While migration is still pending, the advisory must replay on every
        # prompt until the user either completes the migration (sentinel) or
        # declines it. Passive once-per-hour throttling let trivial greetings
        # like "안녕" pass through without Claude ever surfacing the advisory.
        should_suppress_output = recently_bootstrapped and not migration_needed

        # Only flip `migration_advisory_shown` to True when migration is no
        # longer needed (i.e. the sentinel exists). Otherwise keep it False
        # so the advisory keeps replaying in future prompts.
        write_session_bootstrap_state(
            session_flag,
            timestamp_utc=now_ts,
            migration_advisory_shown=not migration_needed,
        )

        if should_suppress_output:
            return

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
    ]

    if migration_needed:
        report_lines.extend([
            '## Migration Advisory — MUST surface to user now',
            '',
            '**Instruction to the assistant:** Before answering the user\'s current',
            'message on its own terms, explicitly tell them in your very next reply',
            'that this project appears to be an **existing codebase** with prior docs,',
            'a previous MoreVibe install, or project manifests, and that MoreVibe has',
            'not yet been adapted to it. Offer to run the `migrate-existing-project`',
            'skill first (a one-shot, non-destructive adaptation with `--dry-run`',
            'preview and `*.pre-migration-*` backups) and wait for their confirmation',
            'before doing any normal work. Do this even for short greetings such as',
            '"안녕" or "hi" — the migration question outranks the greeting.',
            '',
            'Speak in the user\'s language (Korean if they wrote Korean, English',
            'otherwise). Natural-language triggers the user can reply with:',
            '"migrate this project", "마이그레이션해줘", "adapt MoreVibe to this repo",',
            'or "기존 구조랑 통합해줘".',
            '',
            'Detected existing-project signals:',
        ])
        for signal in migration_signals:
            report_lines.append(f'- {signal}')
        report_lines.extend([
            '',
            'This advisory replays until the user either runs the migration or',
            'explicitly declines it.',
            '',
        ])

    report_lines.extend([
        '## Startup Order',
        '- Read the root `AGENTS.md` first.',
        '- Read `.morevibe/schema/OPERATING_RULES.md` early in the session.',
    ])
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
