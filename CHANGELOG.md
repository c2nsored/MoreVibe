# Changelog

All notable changes to this project will be documented in this file.
이 파일은 본 프로젝트의 모든 주요 변경사항을 기록합니다.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
형식은 [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)를 따릅니다.

각 버전은 영어(EN) 원문과 한국어(KO) 번역을 함께 표기합니다.

---

## [Unreleased]

---

## [1.2.3] - 2026-04-17

### Fixed / 수정

**EN**
- Migration Advisory now actually surfaces to the user. Three linked issues were making it invisible in real Claude Code sessions on Windows:
  1. The advisory body used passive "consider running..." language, so the model read it as optional context and did not mention it when the user opened with a trivial greeting such as "안녕". The advisory is now a direct instruction telling the assistant to explicitly raise the migration question in its very next reply, before engaging with the greeting.
  2. The bootstrap state flipped `migration_advisory_shown` to `True` after the first print even if the user never got to see or act on the advisory, causing subsequent prompts in the same hour to suppress the brief entirely. The flag now only flips to `True` once the `.morevibe/.migration_complete` sentinel exists, so the advisory replays on every prompt until the migration is actually run or declined.
  3. The Windows PowerShell installer printed its bilingual "Next step / 다음 단계" completion block through the OEM code page, so Hangul arrived on the console as mojibake. `install-morevibe.ps1` now forces `[Console]::OutputEncoding = UTF8` at startup.

**KO**
- 실사용 Windows Claude Code 세션에서 Migration Advisory가 실제로는 사용자에게 보이지 않던 세 가지 원인을 함께 고쳤습니다.
  1. 기존 advisory 문구가 "consider running..."처럼 수동형이어서, 사용자가 "안녕" 같은 짧은 인사로 세션을 시작하면 모델이 advisory를 선택적 컨텍스트로만 받아들이고 실제로 안내하지 않았습니다. 이제는 "다음 답변에서 반드시 사용자에게 마이그레이션 필요성을 먼저 언급하고 확인을 받으라"는 지시형 문구로 바꿨습니다.
  2. 기존에는 advisory가 첫 출력 직후 `migration_advisory_shown`을 `True`로 올려버려서, 같은 시간대 내 이어지는 프롬프트에서는 session brief가 완전히 억제되었습니다. 이제는 `.morevibe/.migration_complete` sentinel이 있을 때만 `True`가 되므로, 사용자가 마이그레이션을 실행하거나 명시적으로 거절할 때까지 매 프롬프트마다 advisory가 재노출됩니다.
  3. Windows PowerShell 설치기 완료 출력의 이중언어 "Next step / 다음 단계" 블록이 OEM 코드페이지를 거치면서 한글이 깨져 사용자가 읽을 수 없었습니다. `install-morevibe.ps1` 시작부에서 `[Console]::OutputEncoding = UTF8`을 강제하도록 수정했습니다.

---

## [1.2.2] - 2026-04-17

### Fixed / 수정

**EN**
- Hook scripts (`bootstrap_morevibe_session.py`, `auto_sync_morevibe_session.py`, `lint_morevibe.py`) now force UTF-8 on stdout and stderr. On Windows the default Python stream encoding is the ANSI code page (e.g. `cp949` on Korean systems, `cp1252` elsewhere); Claude Code reads hook output as UTF-8, so Korean content in the Migration Advisory and lint guidance was arriving garbled and being dropped silently. With this fix, the advisory reaches the model intact on Windows.

**KO**
- Windows에서 hook 스크립트(`bootstrap_morevibe_session.py`, `auto_sync_morevibe_session.py`, `lint_morevibe.py`)의 stdout/stderr를 명시적으로 UTF-8로 고정했습니다. 기존에는 Python 기본 스트림 인코딩이 ANSI 코드페이지(한국어 Windows 기준 `cp949`)라서 Claude Code(Node.js)가 UTF-8로 읽는 과정에서 Migration Advisory와 lint guidance의 한국어가 깨진 바이트로 전달되어 실사용 프로젝트에서 Migration 안내가 표시되지 않았습니다. 이 수정으로 Windows에서도 안내 문구가 모델에 정상 전달됩니다.

---

## [1.2.1] - 2026-04-17

### Fixed / 수정

**EN**
- Existing projects now replay the migration advisory once even when a legacy `.claude/morevibe/.session_bootstrapped` timestamp survives from an older MoreVibe version. After that first replay, the advisory returns to normal `--once` throttling and the bootstrap state is upgraded to the new JSON format.

**KO**
- 이전 MoreVibe 버전에서 남은 레거시 `.claude/morevibe/.session_bootstrapped` 타임스탬프 파일이 있어도, 기존 프로젝트에서는 마이그레이션 안내를 한 번 다시 보여주도록 수정했습니다. 첫 재노출 이후에는 다시 일반 `--once` 스로틀을 따르며 bootstrap 상태 파일도 새 JSON 형식으로 승격됩니다.

---

## [1.2.0] - 2026-04-17

### Added / 추가

**EN**
- New `migrate-existing-project` skill for the one-time adaptation of MoreVibe to an existing project. The skill runs an 8-step operating loop: inventory existing docs, draft canon content, extract workflows, resolve authority conflicts, clean legacy MoreVibe traces, auto-repair mechanical lint warnings, write a `.morevibe/.migration_complete` sentinel, and log the migration in `wiki/log.md` and `wiki/state.md`. Every destructive step has an approval gate, all modified files get `*.pre-migration-*` backups, and `--dry-run` previews without writing.
- `bootstrap_morevibe_session.py` now detects existing-project signals (existing `docs/`, substantial root `README.md`, prior `AGENTS.md.backup-*` files, project manifests such as `package.json`) when the sentinel is absent, and injects a one-line "Migration Advisory" into the session brief so users are prompted to migrate before normal work.
- Installer completion output now ends with a bilingual "Next step" block that tells new-project users to start the session and existing-project users to run the migration skill first.
- `docs/WORKFLOW_MAP.md` now documents the natural-language routes for migrating an existing project (EN and KO phrases).
- README Quick Start (EN and KO) now distinguishes between first-message advice for new projects versus existing projects.

**KO**
- 기존 프로젝트에 MoreVibe를 처음 설치한 뒤 한 번만 수행하는 적응 작업을 자동화하는 `migrate-existing-project` skill을 추가했습니다. 8단계 흐름(기존 문서 인벤토리, canon 초안 작성, 워크플로 추출, 권위 충돌 해소, 레거시 MoreVibe 흔적 정리, 기계적 lint 경고 자동 수정, `.morevibe/.migration_complete` sentinel 기록, wiki 로그 남기기)을 거치며, 파괴적 작업 직전마다 사용자 승인 게이트를 두고 수정되는 모든 파일은 `*.pre-migration-*` 백업을 남기며 `--dry-run` 미리보기를 지원합니다.
- sentinel이 없는 상태에서 기존 프로젝트 신호(기존 `docs/`, 상당 분량의 루트 `README.md`, 이전 설치의 `AGENTS.md.backup-*`, `package.json` 등 매니페스트)를 `bootstrap_morevibe_session.py`가 감지하면, session brief 상단에 "Migration Advisory" 한 줄을 주입해서 사용자가 본 작업 전에 마이그레이션을 실행하도록 안내합니다.
- 설치기 완료 출력 끝에 이중언어 "Next step / 다음 단계" 블록을 추가해, 신규 프로젝트와 기존 프로젝트의 첫 메시지 예시를 각각 표시합니다.
- `docs/WORKFLOW_MAP.md`에 기존 프로젝트 마이그레이션용 자연어 라우팅 경로(영/한)를 문서화했습니다.
- README Quick Start(영/한)에서 신규 프로젝트와 기존 프로젝트의 첫 메시지 예시를 구분해서 안내합니다.

### Changed / 변경

**EN**
- The initial onboarding flow for existing projects now treats migration as an explicit one-shot pre-step, not a manual user responsibility.

**KO**
- 기존 프로젝트 초기 온보딩 흐름이 "사용자가 직접 정리"가 아니라 "일회성 사전 작업으로 명시적 마이그레이션 수행" 구조로 바뀌었습니다.

---

## [1.1.1] - 2026-04-17

### Fixed / 수정

**EN**
- Reinstalling MoreVibe over a previous version no longer leaves a duplicate Stop hook. The settings merger now replaces legacy MoreVibe-managed Stop and UserPromptSubmit entries (for example an older `lint_morevibe.py`-only Stop hook) with the canonical `auto_sync_morevibe_session.py` entry, while preserving any user-defined hooks.
- Reinstall smoke test now seeds a legacy Stop hook plus a user-custom hook and asserts that after reinstall only the canonical MoreVibe entry and the user-custom entry remain.

**KO**
- 이전 버전 MoreVibe 위에 재설치할 때 Stop hook이 중복 등록되던 문제를 해결했습니다. 설정 병합 로직이 구버전 MoreVibe가 남긴 Stop / UserPromptSubmit 엔트리(예: 이전의 `lint_morevibe.py` 전용 Stop hook)를 공식 `auto_sync_morevibe_session.py` 엔트리로 교체하며, 사용자가 직접 추가한 hook은 보존합니다.
- 재설치 smoke test에 구버전 Stop hook과 사용자 커스텀 hook을 미리 주입한 뒤, 재설치 후에 공식 MoreVibe 엔트리와 사용자 커스텀 엔트리만 남는지 검증하는 시나리오를 추가했습니다.

---

## [1.1.0] - 2026-04-17

### Added / 추가

**EN**
- Session-end auto-sync for `.morevibe/wiki/state.md`, `.morevibe/wiki/log.md`, and `.morevibe/canon/HANDOFF.md`.
- Periodic documentation drift audit generation during long-running sessions.
- Claude statusline baseline so project context is visible without opening schema files.
- Claude dangerous-command confirmation baseline for risky shell actions.
- Reinstall smoke test for preserving existing `canon/` and `wiki/` content.

**KO**
- 세션 종료 시 `.morevibe/wiki/state.md`, `.morevibe/wiki/log.md`, `.morevibe/canon/HANDOFF.md` 자동 동기화를 추가했습니다.
- 장기 실행 세션에서 주기적으로 문서 drift 감사(doc-drift audit)를 생성합니다.
- 스키마 파일을 열지 않아도 프로젝트 맥락이 보이도록 Claude statusline 기본값을 추가했습니다.
- 위험한 셸 명령을 실행하기 전에 사용자에게 확인을 요구하는 Claude 권한 기본값을 추가했습니다.
- 기존 `canon/`과 `wiki/` 내용이 보존되는지 확인하는 재설치 smoke test를 추가했습니다.

### Changed / 변경

**EN**
- Lint guidance is now bridged into session-end automation output.
- Installer health checks now verify Claude statusline and permissions baseline.
- Delegation rules now document when not to split work across subagents.

**KO**
- lint 결과에 자연어 guidance가 포함되어 세션 종료 자동화 출력으로 이어집니다.
- 설치기 health check가 Claude statusline과 권한 기본값 설치 여부까지 확인합니다.
- 위임 규칙에 "SubAgent로 일을 나누지 말아야 할 때"를 명시했습니다.

---

## [1.0.0] - 2026-04-16

### Added / 추가

**EN**
- First stable Windows installer release package for MoreVibe.
- Document-centered `sources / canon / wiki / schema` harness model for long-running AI coding projects.
- Natural-language-first workflow routing for non-programmers.
- Shared native workflow skills plus active / fallback classification in generated schema.
- Project-type specialist presets for `webapp`, `ecommerce`, `blog`, `api`, and `generic`.

**KO**
- MoreVibe의 첫 안정 버전 Windows 설치기 릴리스 패키지를 공개했습니다.
- 장기 AI 코딩 프로젝트를 위한 문서 중심 `sources / canon / wiki / schema` 하네스 모델을 도입했습니다.
- 비개발자를 위한 자연어 우선 workflow 라우팅을 제공합니다.
- 공통 native workflow skill과 생성된 스키마 내 active / fallback 분류 체계를 포함합니다.
- `webapp`, `ecommerce`, `blog`, `api`, `generic` 프로젝트 타입별 스페셜리스트 프리셋을 제공합니다.

### Changed / 변경

**EN**
- Standardized the orchestration model as `main agent -> pm-lead -> workers`.
- Strengthened specialist skills, type-specific checks, and onboarding documentation.
- Improved lint and health reporting around routing, parity, and placeholder detection.

**KO**
- 오케스트레이션 모델을 `메인 에이전트 -> pm-lead -> worker` 로 표준화했습니다.
- 스페셜리스트 skill, 프로젝트 타입별 점검, 온보딩 문서를 강화했습니다.
- 라우팅, 도구 간 parity, 플레이스홀더 감지에 대한 lint 및 health 보고를 개선했습니다.

---

## [0.5.1] - 2026-04-16

### Changed / 변경

**EN**
- Refined repository messaging and product positioning in English and Korean documentation.
- Polished release-facing documentation to better explain the harness model and installation flow.

**KO**
- 영어/한국어 저장소 메시지와 제품 포지셔닝 문구를 정돈했습니다.
- 하네스 모델과 설치 흐름이 더 잘 전달되도록 릴리스용 문서를 다듬었습니다.

---

## [0.5.0] - 2026-04-16

### Added / 추가

**EN**
- First specialist skill expansion layer for review, release, debugging, handoff, onboarding, and drift checks.
- Natural-language routing guidance across project docs and schema files.
- Methodology documents such as `METHOD.md`, `WORKFLOW_MAP.md`, `TEAM_MODEL.md`, `MEMORY_MODEL.md`, and `NON_PROGRAMMER_GUIDE.md`.
- Optional command guidance and stronger non-programmer onboarding examples.

**KO**
- 리뷰, 릴리스, 디버깅, 인수인계, 온보딩, drift 점검을 위한 첫 스페셜리스트 skill 확장 레이어를 추가했습니다.
- 프로젝트 문서와 스키마 파일 전반에 자연어 라우팅 가이드를 반영했습니다.
- `METHOD.md`, `WORKFLOW_MAP.md`, `TEAM_MODEL.md`, `MEMORY_MODEL.md`, `NON_PROGRAMMER_GUIDE.md` 등 방법론 문서를 추가했습니다.
- 선택형 커맨드 가이드와 비개발자 온보딩 예시를 강화했습니다.

### Changed / 변경

**EN**
- Elevated MoreVibe from a basic installer harness into a more explicit methodology product.
- Improved project-type skill support and quality guardrails around workflow usage.

**KO**
- MoreVibe를 단순 설치기 하네스에서 보다 명확한 방법론 제품으로 격상했습니다.
- 프로젝트 타입별 skill 지원과 workflow 품질 가드레일을 개선했습니다.

---

## [0.4.x] - 2026-04-16

### Added / 추가

**EN**
- Initial Windows installer flow and WPF installer packaging.
- Project-local `.morevibe/` template, `AGENTS.md` bootstrap, and generated schema rendering.
- Codex / Claude Code / Antigravity integration scaffolding.
- Shared project skill installation, native workflow aliases, and project-type role presets.

**KO**
- 초기 Windows 설치기 흐름과 WPF 설치기 패키징을 구현했습니다.
- 프로젝트 로컬 `.morevibe/` 템플릿, `AGENTS.md` bootstrap, 스키마 렌더링 기능을 추가했습니다.
- Codex / Claude Code / Antigravity 통합 스캐폴딩을 구축했습니다.
- 공통 프로젝트 skill 설치, native workflow alias, 프로젝트 타입별 역할 프리셋을 포함합니다.

### Changed / 변경

**EN**
- Generalized project presets away from project-specific custom roles.
- Improved README quality, installer messaging, and release packaging through the 0.4 series.

**KO**
- 특정 프로젝트 전용 역할에서 벗어나 범용 프로젝트 프리셋으로 일반화했습니다.
- 0.4 시리즈를 거치며 README 품질, 설치기 메시지, 릴리스 패키징을 개선했습니다.
