# Changelog

All notable changes to this project will be documented in this file.
이 파일은 본 프로젝트의 모든 주요 변경사항을 기록합니다.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
형식은 [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)를 따릅니다.

각 버전은 영어(EN) 원문과 한국어(KO) 번역을 함께 표기합니다.

---

## [Unreleased]

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
