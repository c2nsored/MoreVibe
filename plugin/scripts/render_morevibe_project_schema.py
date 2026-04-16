from __future__ import annotations

import argparse
import json
from pathlib import Path


def find_skill_names(project_root: Path) -> set[str]:
    names: set[str] = set()
    for skills_root in (
        project_root / '.agents' / 'skills',
        project_root / '.claude' / 'skills',
    ):
        if not skills_root.exists():
            continue
        for skill_file in skills_root.glob('*/SKILL.md'):
            names.add(skill_file.parent.name)
    return names


def find_agent_names(project_root: Path) -> dict[str, list[str]]:
    claude_agents = sorted(p.stem for p in (project_root / '.claude' / 'agents').glob('*.md')) if (project_root / '.claude' / 'agents').exists() else []
    codex_agents = sorted(p.stem for p in (project_root / '.codex' / 'agents').glob('*.toml')) if (project_root / '.codex' / 'agents').exists() else []
    return {
        'claude': claude_agents,
        'codex': codex_agents,
        'all': sorted(set(claude_agents + codex_agents)),
    }


def pick_first(existing: set[str], *names: str) -> str | None:
    for name in names:
        if name in existing:
            return name
    return None


def pick_many(existing: set[str], *names: str) -> list[str]:
    return [name for name in names if name in existing]


def unique(items: list[str]) -> list[str]:
    return list(dict.fromkeys(items))


def choose_skill_map(existing: set[str]) -> dict[str, object]:
    start = pick_first(existing, 'start-session', 'morevibe-start-session', 'morevibe-session-brief')
    bootstrap = pick_first(existing, 'project-bootstrap', 'morevibe-session-brief')
    plan = pick_first(existing, 'plan-feature', 'morevibe-plan-feature')
    execute = pick_first(existing, 'execute-plan', 'morevibe-execute-plan')
    debug = pick_first(existing, 'debug-bug', 'morevibe-debug-bug')
    review = pick_first(existing, 'request-code-review', 'morevibe-request-review')
    review_fix = pick_first(existing, 'apply-review-fixes', 'morevibe-apply-review-fixes')
    verify = pick_first(existing, 'verify-change', 'morevibe-verify-change')
    finish = pick_first(existing, 'finish-task', 'morevibe-finish-task')
    update_docs = pick_first(existing, 'update-docs', 'morevibe-update-docs')
    update_handoff = pick_first(existing, 'update-handoff', 'morevibe-update-handoff')
    delegate = pick_first(existing, 'delegate-work', 'morevibe-delegate-work', 'morevibe-orchestrate-subagents')
    test_first = pick_first(existing, 'tdd-or-test-first', 'morevibe-test-first')
    report = pick_first(existing, 'report-deployment-status', 'morevibe-report-deployment')
    query = pick_first(existing, 'morevibe-query-harness')
    sync = pick_first(existing, 'morevibe-sync-memory')
    ingest = pick_first(existing, 'morevibe-ingest-item')
    writeback = pick_first(existing, 'morevibe-writeback-answer')
    lint = pick_first(existing, 'morevibe-lint-harness')
    review_risk = pick_first(existing, 'review-risk')
    qa_ui = pick_first(existing, 'qa-ui')
    prepare_release = pick_first(existing, 'prepare-release')
    ship_change = pick_first(existing, 'ship-change')
    investigate_failure = pick_first(existing, 'investigate-failure')
    refactor_safely = pick_first(existing, 'refactor-safely')
    spec_feature = pick_first(existing, 'spec-feature')
    handoff_session = pick_first(existing, 'handoff-session')
    audit_doc_drift = pick_first(existing, 'audit-doc-drift')
    onboard_project = pick_first(existing, 'onboard-project')

    startup = [name for name in [start, bootstrap] if name]
    support = [name for name in [delegate, test_first, report, query, sync, ingest, writeback, lint] if name]

    feature = [name for name in [start, bootstrap, plan, execute, review, review_fix, verify, finish, update_docs, update_handoff, sync] if name]
    feature = unique(feature)
    bug = [name for name in [start, bootstrap, debug, review, review_fix, verify, finish, update_docs, update_handoff, sync] if name]
    bug = unique(bug)
    docs_flow = [name for name in [start, bootstrap, verify, finish, update_docs, update_handoff, sync] if name]
    docs_flow = unique(docs_flow)
    known_specialist = [
        name for name in [
            review_risk,
            qa_ui,
            prepare_release,
            ship_change,
            investigate_failure,
            refactor_safely,
            spec_feature,
            handoff_session,
            audit_doc_drift,
            onboard_project,
        ] if name
    ]
    active = unique(startup + feature + bug + docs_flow + support + known_specialist)
    active_set = set(active)
    fallback = sorted(name for name in existing if name.startswith('morevibe-') and name not in active_set)
    fallback_set = set(fallback)
    claimed = set(feature + bug + docs_flow + support + known_specialist)
    specialist = list(dict.fromkeys(known_specialist + sorted(name for name in existing if name not in claimed and not name.startswith('morevibe-'))))
    dormant = sorted(name for name in existing if name not in active_set and name not in fallback_set and name not in specialist)

    return {
        'startup': startup,
        'feature': feature,
        'bug': bug,
        'docs': docs_flow,
        'support': support,
        'specialist': specialist,
        'active': active,
        'fallback': fallback,
        'dormant': dormant,
        'delegate': delegate,
        'query': query,
        'sync': sync,
        'available_skills': sorted(existing),
    }


def choose_role_model(agents: dict[str, list[str]]) -> dict[str, object]:
    all_agents = agents['all']
    lead = 'pm-lead' if 'pm-lead' in all_agents else ('morevibe-orchestrator' if 'morevibe-orchestrator' in all_agents else 'main-agent')
    reviewer = 'qa-reviewer' if 'qa-reviewer' in all_agents else ('morevibe-reviewer' if 'morevibe-reviewer' in all_agents else None)
    alias_exclusions: set[str] = set()
    if lead == 'pm-lead' and 'morevibe-orchestrator' in all_agents:
        alias_exclusions.add('morevibe-orchestrator')
    if reviewer == 'qa-reviewer' and 'morevibe-reviewer' in all_agents:
        alias_exclusions.add('morevibe-reviewer')
    worker_candidates = [a for a in all_agents if a not in {lead, reviewer} and a not in alias_exclusions]
    if not worker_candidates:
        worker_candidates = ['implementation-owner']
    return {
        'lead': lead,
        'reviewer': reviewer,
        'workers': worker_candidates,
        'claude_agents': agents['claude'],
        'codex_agents': agents['codex'],
    }


def bullets(items: list[str], empty: str) -> str:
    if not items:
        return f'- {empty}'
    return '\n'.join(f'- `{item}`' for item in items)


def build_session_bootstrap(skill_map: dict[str, object]) -> str:
    startup = skill_map['startup']
    query = skill_map['query']
    specialist = skill_map['specialist']
    lines = [
        '# Session Bootstrap',
        '',
        'Use this file to standardize what should happen at the start of every session.',
        '',
        '## Default startup order',
        '',
        '1. Read the root `AGENTS.md`',
        '2. Read `.morevibe/schema/OPERATING_RULES.md`',
        '3. Read `.morevibe/wiki/state.md`',
        '4. Read `.morevibe/canon/HANDOFF.md`',
        '5. Read `.morevibe/canon/TASKS.md`',
        '6. Read additional canon files only when needed',
    ]
    if startup:
        lines.append(f"7. Follow the project's real startup skill chain: {', '.join(f'`{s}`' for s in startup)}")
    else:
        lines.append('7. No project-native startup skill was detected; use the current canon/wiki state directly.')
    if query:
        lines.append(f"8. Use `{query}` only when a focused memory scan is needed")
    lines.extend([
        '',
        '## Natural-language rule',
        '',
        '- Interpret the user request first.',
        '- Then map it to the closest project workflow.',
        '- Treat explicit command syntax as optional, not required.',
        '',
        '## Quick request hints',
        '',
        '- "understand the project first" -> startup / onboarding',
        '- "plan this before coding" -> feature planning',
        '- "find the cause first" -> failure investigation / bug work',
        '- "review this before we finish" -> review / risk / verify',
        '- "update docs too" -> docs / handoff',
        '- "prepare release" -> release / ship status',
    ])
    if specialist:
        lines.extend([
            '',
            '## Specialist skills available',
            '',
            bullets(specialist, 'No specialist skills detected.'),
        ])
    lines.extend([
        '',
        '## Rule',
        '',
        'Do not start implementation before the current state has been restored.',
    ])
    return '\n'.join(lines) + '\n'


def build_first_session_guide(skill_map: dict[str, object], role_map: dict[str, object]) -> str:
    worker_text = ', '.join(f'`{worker}`' for worker in role_map['workers']) if role_map['workers'] else '`implementation-owner`'
    reviewer_text = f"`{role_map['reviewer']}`" if role_map['reviewer'] else 'the lead'
    lines = [
        '# First Session Guide',
        '',
        'Use this file when MoreVibe was just installed and you want a safe first conversation.',
        '',
        '## Team model',
        '',
        '- The main user-facing agent acts as the orchestrator.',
        f"- `{role_map['lead']}` is the internal lead who classifies work, decides delegation, and integrates results.",
        f'- Workers handle focused execution: {worker_text}',
        f'- Review should stay with {reviewer_text} unless the lead keeps it directly.',
        '',
        '## What to do first',
        '',
        '1. Read the root `AGENTS.md`.',
        '2. Read `.morevibe/schema/SESSION_BOOTSTRAP.md` and `.morevibe/schema/PROJECT_SKILLS.md`.',
        '3. Read `.morevibe/wiki/state.md`, `.morevibe/canon/HANDOFF.md`, and `.morevibe/canon/TASKS.md`.',
        '4. Tell the user the safest next step before changing code.',
        '',
        '## Good first messages',
        '',
        '- "start by understanding this project and tell me the safest next step"',
        '- "restore context first and plan this before coding"',
        '- "understand the project, then review what could break before we change anything"',
        '- "prepare a safe plan and leave docs ready for the next session"',
        '',
        '## Natural-language routing reminders',
        '',
        '- You do not need command syntax to get the main MoreVibe benefits.',
        '- Interpret the user request first, then map it to the closest workflow.',
        '- Keep planning, review, docs, and handoff visible in the response.',
    ]
    if skill_map['specialist']:
        lines.extend([
            '',
            '## Specialist help available',
            '',
            bullets(skill_map['specialist'], 'No specialist skills detected.'),
        ])
    return '\n'.join(lines) + '\n'


def build_skill_routing(skill_map: dict[str, object]) -> str:
    lines = [
        '# MoreVibe Skill Routing',
        '',
        'This file reflects the real skills detected in the current project.',
        '',
        '## Main entry',
        '',
        bullets(skill_map['startup'], 'No project-native startup skill detected.'),
        '',
        '## Feature work',
        '',
        bullets(skill_map['feature'], 'No project-native feature chain detected.'),
        '',
        '## Bug work',
        '',
        bullets(skill_map['bug'], 'No project-native bug chain detected.'),
        '',
        '## Docs / ops work',
        '',
        bullets(skill_map['docs'], 'No project-native docs/ops chain detected.'),
        '',
        '## Support skills',
        '',
        bullets(skill_map['support'], 'No extra support skills detected.'),
        '',
        '## Specialist skills',
        '',
        bullets(skill_map['specialist'], 'No specialist skills detected.'),
        '',
        '## Active skills',
        '',
        bullets(skill_map['active'], 'No active skills detected.'),
        '',
        '## Fallback skills',
        '',
        bullets(skill_map['fallback'], 'No fallback compatibility skills detected.'),
        '',
        '## Dormant skills',
        '',
        bullets(skill_map['dormant'], 'No dormant skills detected.'),
        '',
        '## Natural-language examples',
        '',
        '- "plan this feature first" -> feature work + specialist planning skills',
        '- "why did this fail?" -> bug work + `investigate-failure`',
        '- "review this before finishing" -> review path + `review-risk`',
        '- "check the UI too" -> `qa-ui`',
        '- "update docs and leave handoff" -> docs/ops work + `handoff-session` + `audit-doc-drift`',
        '- "prepare this for release" -> `prepare-release` + `ship-change` + deployment reporting',
    ]
    return '\n'.join(lines) + '\n'


def build_subagent_orchestration(role_map: dict[str, object], skill_map: dict[str, object]) -> str:
    lines = [
        '# Subagent Orchestration',
        '',
        'This file reflects the real delegation model detected in the current project.',
        '',
        '## Default model',
        '',
        '- The main user-facing agent is the orchestrator.',
        f"- Lead: `{role_map['lead']}`",
        f"- Workers: {', '.join(f'`{w}`' for w in role_map['workers'])}",
    ]
    if role_map['reviewer']:
        lines.append(f"- Reviewer: `{role_map['reviewer']}`")
    else:
        lines.append('- Reviewer: no dedicated reviewer agent detected; keep review with the lead.')
    if skill_map['delegate']:
        lines.extend([
            '',
            '## Delegation rule',
            '',
            '- The orchestrator should translate the user request into a clear assignment for the lead.',
            '- The lead decides whether to work directly or split clean ownership to workers.',
            '- Workers report back to the lead; the lead integrates and reports back to the orchestrator.',
            f"- Use `{skill_map['delegate']}` only when ownership can be split cleanly.",
            '- Keep final integration and reporting with the lead.',
        ])
    lines.extend([
        '',
        '## Tool parity',
        '',
        f"- Claude agents: {', '.join(f'`{a}`' for a in role_map['claude_agents']) if role_map['claude_agents'] else 'none detected'}",
        f"- Codex agents: {', '.join(f'`{a}`' for a in role_map['codex_agents']) if role_map['codex_agents'] else 'none detected'}",
    ])
    return '\n'.join(lines) + '\n'


def build_project_skills(skill_map: dict[str, object], role_map: dict[str, object]) -> str:
    lines = [
        '# Project Skills Map',
        '',
        'This file is generated from the actual project skills and agents detected at install/render time.',
        '',
        '## Detected startup chain',
        '',
        bullets(skill_map['startup'], 'No project-native startup skill detected.'),
        '',
        '## Detected feature chain',
        '',
        bullets(skill_map['feature'], 'No project-native feature chain detected.'),
        '',
        '## Detected bug chain',
        '',
        bullets(skill_map['bug'], 'No project-native bug chain detected.'),
        '',
        '## Detected support skills',
        '',
        bullets(skill_map['support'], 'No extra support skills detected.'),
        '',
        '## Detected specialist skills',
        '',
        bullets(skill_map['specialist'], 'No specialist skills detected.'),
        '',
        '## Active skills',
        '',
        bullets(skill_map['active'], 'No active skills detected.'),
        '',
        '## Fallback skills',
        '',
        bullets(skill_map['fallback'], 'No fallback compatibility skills detected.'),
        '',
        '## Dormant skills',
        '',
        bullets(skill_map['dormant'], 'No dormant skills detected.'),
        '',
        '## Natural-language routing notes',
        '',
        '- Planning requests should prefer `spec-feature` and `plan-feature` before implementation.',
        '- Failure requests should prefer `investigate-failure` before or alongside `debug-bug`.',
        '- Review requests should prefer `request-code-review`, `review-risk`, and `verify-change`.',
        '- Release requests should prefer `prepare-release`, `ship-change`, and `report-deployment-status`.',
        '- Docs or handoff requests should prefer `update-docs`, `audit-doc-drift`, `handoff-session`, and `update-handoff`.',
        '',
        '## Detected role model',
        '',
        f"- Lead: `{role_map['lead']}`",
        f"- Workers: {', '.join(f'`{w}`' for w in role_map['workers'])}",
    ]
    if role_map['reviewer']:
        lines.append(f"- Reviewer: `{role_map['reviewer']}`")
    if role_map['claude_agents']:
        lines.append(f"- Claude agents: {', '.join(f'`{a}`' for a in role_map['claude_agents'])}")
    if role_map['codex_agents']:
        lines.append(f"- Codex agents: {', '.join(f'`{a}`' for a in role_map['codex_agents'])}")
    return '\n'.join(lines) + '\n'


def main() -> None:
    parser = argparse.ArgumentParser(description='Render MoreVibe schema files from actual project skills and agents.')
    parser.add_argument('--project-root', required=True)
    args = parser.parse_args()

    project_root = Path(args.project_root).expanduser().resolve()
    schema_root = project_root / '.morevibe' / 'schema'
    schema_root.mkdir(parents=True, exist_ok=True)

    skills = find_skill_names(project_root)
    agents = find_agent_names(project_root)
    skill_map = choose_skill_map(skills)
    role_map = choose_role_model(agents)

    (schema_root / 'project_skill_map.json').write_text(json.dumps({'skills': skill_map, 'roles': role_map}, indent=2), encoding='utf-8')
    (schema_root / 'SESSION_BOOTSTRAP.md').write_text(build_session_bootstrap(skill_map), encoding='utf-8')
    (schema_root / 'FIRST_SESSION_GUIDE.md').write_text(build_first_session_guide(skill_map, role_map), encoding='utf-8')
    (schema_root / 'SKILL_ROUTING.md').write_text(build_skill_routing(skill_map), encoding='utf-8')
    (schema_root / 'SUBAGENT_ORCHESTRATION.md').write_text(build_subagent_orchestration(role_map, skill_map), encoding='utf-8')
    (schema_root / 'PROJECT_SKILLS.md').write_text(build_project_skills(skill_map, role_map), encoding='utf-8')

    print(f'Rendered MoreVibe project schema for {project_root}')


if __name__ == '__main__':
    main()
