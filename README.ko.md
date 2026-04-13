# MoreVibe

[English](./README.md) | [한국어](./README.ko.md)

MoreVibe는 모든 종류의 프로젝트에서 더 나은 바이브코딩을 돕기 위한 개인용 LLM 하네스 시스템입니다.

이 저장소는 사용자가 개발자가 아니어도, AI가 문서 구조와 작업 메모리를 계속 관리하면서 장기 프로젝트를 이어갈 수 있게 만드는 데 초점을 둡니다.

MoreVibe는 LLM이 아래와 같은 안정적인 프로젝트 기억 구조 위에서 일하도록 설계되어 있습니다.

- `sources`: 근거 자료, 메모, 로그, 스냅샷
- `canon`: 현재 프로젝트의 공식 기준 문서
- `wiki`: LLM이 유지하는 작업 메모리와 연결 레이어

중요한 점은, MoreVibe의 목적이 먼저 사람용 위키를 예쁘게 만드는 것이 아니라는 점입니다.

핵심은 세션이 바뀌어도 AI가 프로젝트를 다시 처음부터 재탐색하지 않도록, 내부 작업 기억과 규칙 구조를 안정적으로 유지하는 것입니다.

## 핵심 모델

MoreVibe는 프로젝트 지식을 네 가지 역할로 나눕니다.

- `schema`: LLM이 하네스를 어떻게 읽고 쓰고 유지할지 정의하는 운영 규칙
- `sources`: 주로 불변에 가까운 입력 자료와 근거
- `canon`: AI가 작성했더라도 현재 프로젝트의 공식 기준이면 포함되는 문서층
- `wiki`: sources와 canon을 바탕으로 LLM이 유지하는 작업 메모리층

이 구분은 누가 썼는지가 아니라, 그 문서가 무슨 역할을 맡는지로 결정됩니다.

## Core + Adapters 구조

MoreVibe는 두 층으로 구성됩니다.

- `core`: 도구와 무관하게 유지되어야 하는 공통 하네스 모델
- `adapters`: Codex, Claude Code, Antigravity 같은 도구별 통합 레이어

`core`는 웹, 게임, 앱, 자동화 프로젝트처럼 대상이 바뀌어도 그대로 재사용되는 쪽입니다.

반대로 `adapters`는 아래 같은 차이를 담당합니다.

- 전역 규칙 파일이 어디에 있는지
- 프로젝트 진입 파일을 어떤 이름으로 읽는지
- 전역 설정을 어떻게 안전하게 병합해야 하는지
- 기존 프로젝트 파일을 덮어쓰지 않고 MoreVibe를 어떻게 붙일지

즉 MoreVibe는 “Codex 전용 플러그인”이라기보다, 여러 AI 환경에 붙을 수 있는 공통 하네스 시스템이고, Codex는 그중 첫 번째로 구현된 어댑터입니다.

## MoreVibe가 필요한 이유

기존 LLM 작업 방식은 대체로 그때그때 찾아서 다시 종합하는 흐름에 가깝습니다.

- 파일을 올리고
- 질문하고
- 관련 조각을 찾고
- 다음 질문 때 다시 비슷한 종합을 반복합니다

MoreVibe는 다른 방향을 취합니다.

- 프로젝트의 근거 자료를 남기고
- 현재 공식 기준 문서를 유지하고
- LLM이 장기적으로 누적되는 작업 메모리를 유지하게 하며
- 그 메모리를 반복적으로 점검하고 갱신합니다

이렇게 하면 장기 바이브코딩 프로젝트에서 세션 복구, 작업 방향 유지, 문서 정합성 관리가 훨씬 쉬워집니다.

## 기본 운영 루프

MoreVibe는 세 가지 반복 작업을 중심으로 돌아갑니다.

1. `ingest`
새 정보를 하네스에 반영하고, `sources` 또는 `canon`에 분류한 뒤 `wiki`를 갱신합니다.

2. `query`
먼저 `wiki`를 보고 답하고, 부족하면 `canon`과 `sources`까지 내려갑니다. 가치 있는 답변은 다시 하네스에 환원합니다.

3. `lint`
하네스 안의 오래된 정보, 중복, 연결 누락, `canon/wiki` 불일치 같은 문제를 점검합니다.

## 현재 상태

MoreVibe는 아직 초기 단계이지만 실제 하네스 구조와 부트스트랩이 작동하는 상태입니다.

현재 저장소에는 아래가 포함되어 있습니다.

- Codex, Claude Code, Antigravity용 호스트 규칙 파일 부트스트랩
- Codex용 플러그인 manifest와 전달 자산
- 재사용 가능한 MoreVibe skill 세트
- Windows 설치기 시작점
- 초보자 친화적인 Windows 설치를 위한 WPF 설치 UI 골격
- `.morevibe/` 프로젝트 템플릿 네임스페이스
- core/adapters 구조
- workflow 진입 skill과 skill routing 규칙
- Claude Code와 Antigravity용 프로젝트/전역 통합 자산

## 저장소 구조

```text
core/          # 도구 공통 MoreVibe 하네스 모델
adapters/      # 도구별 통합 가이드와 어댑터
templates/     # MoreVibe가 프로젝트에 주입할 템플릿
installer/     # 설치 스크립트와 패키징 진입점
installer-ui/  # WPF 기반 Windows 설치 UI 골격
plugin/        # Codex 전달용 manifest/skills/scripts 자산
```

## 자동화된 것과 아직 완전 자동은 아닌 것

이미 구현된 것

- 프로젝트 로컬 `.morevibe/` 부트스트랩
- `-ProjectPath`를 주면 프로젝트 `AGENTS.md` 자동 부트스트랩
- Codex 전역 `AGENTS.md` 자동 부트스트랩
- Claude 프로젝트/전역 `CLAUDE.md` 자동 부트스트랩
- Antigravity 프로젝트/전역 `GEMINI.md` 자동 부트스트랩
- Codex용 로컬 플러그인 설치와 marketplace 병합
- 현재 설치 대상에 대한 교체 전 백업
- 계획, 실행, 리뷰, 검증, 문서, handoff, 배포, 분담을 위한 재사용 skill 세트
- `.morevibe/schema/`, `.morevibe/canon/`, `.morevibe/wiki/` 기본 문서 세트
- feature / bug / docs 작업을 분기하는 workflow router
- state, log, handoff를 갱신하는 session memory sync
- `sources` / `canon` 반영용 ingest 스크립트
- `wiki`, `canon`, `sources` 기반 query 보고서
- session brief 생성
- subagent orchestration 규칙

문서화되어 있지만 아직 완전 자동이라고 말할 수 없는 것

- 각 호스트가 공식적으로 지원하는 범위를 넘어서는 강제 자동 트리거
- 모든 세션에서 호스트가 전역/프로젝트 규칙 파일을 동일하게 따를 것이라는 절대 보장

## 프로젝트 통합 방식

MoreVibe는 프로젝트 루트의 `AGENTS.md`를 대체하지 않습니다.

통합 방식은 이렇습니다.

- 루트 `AGENTS.md`는 에이전트 도구가 읽는 표준 진입점으로 유지
- 각 프로젝트 내부에서는 `.morevibe/`를 MoreVibe 전용 네임스페이스로 사용
- 플러그인/marketplace 자산은 전달과 보조 실행 수단으로만 사용

권장 프로젝트 로컬 구조는 아래와 같습니다.

```text
project-root/
  AGENTS.md
  .morevibe/
    schema/
    sources/
    canon/
    wiki/
```

이 구조를 쓰면 `src`, `docs`, `sources` 같은 일반 프로젝트 폴더명과 충돌을 줄일 수 있습니다.

## 레이어 규칙

- `schema`는 MoreVibe 로컬 운영 규칙입니다.
- `sources`는 근거 자료, 외부 자료, 메모, 스냅샷, 로그 같은 입력층입니다.
- `canon`은 현재 프로젝트의 공식 기준 문서층입니다.
- `wiki`는 LLM이 유지하는 작업 메모리와 연결 레이어입니다.
- 같은 규칙이 두 곳 이상에서 동시에 권위 원본이면 안 됩니다.
- `wiki`와 `canon`이 충돌하면 먼저 `canon`을 점검합니다.
- AI가 작성한 문서라도 프로젝트가 공식 기준으로 취급하면 `canon`이 될 수 있습니다.

## 목표 설치 방식

장기적으로는 비개발자도 쉽게 설치할 수 있어야 합니다.

1. GitHub Releases에서 MoreVibe를 다운로드합니다.
2. 설치기를 실행합니다.
3. 설치기가 호스트 규칙 파일과 프로젝트 `.morevibe/`를 연결합니다.
4. 사용자는 별도 수작업 없이 MoreVibe 구조 위에서 대화를 시작합니다.

## 현재 Windows GUI 설치기 (추천)

이제 Windows 사용자들을 위해 직관적인 **WPF 기반 GUI 설치기**를 제공합니다.  
[GitHub Releases](https://github.com/c2nsored/MoreVibe/releases/latest) 페이지에서 `MoreVibeInstaller.exe`를 다운로드 받아 실행하기만 하면 클릭 몇 번으로 모든 설치 과정과 부트스트랩을 완료할 수 있습니다.

## 스크립트 기반 설치

터미널을 선호하는 경우, 기존의 파워쉘 스크립트를 직접 사용할 수 있습니다.

기본 설치 진입점:

```powershell
installer/windows/install-morevibe.ps1
```

조금 더 쉽게 실행할 수 있는 배치 런처도 함께 제공합니다:

```text
installer/windows/install-morevibe.bat
```

이 배치 설치 파일을 더블클릭하면 이제 아래 순서로 진행됩니다.

- 기본 설치 안내 표시
- 설치 계속 여부 확인
- Codex / Claude Code / Antigravity / 전체 설치 대상 선택
- 설치 대상 선택 후 실제 프로젝트 루트 경로를 선택적으로 입력
- 성공 또는 실패 결과를 콘솔에 유지해서 확인 가능

기본 사용:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1
```

MoreVibe를 설치하고 `.morevibe/`를 부트스트랩합니다:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1 -ProjectPath "C:\path\to\project"
```

프로젝트에 이미 `.morevibe/`가 있는데 의도적으로 교체하고 싶다면:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1 -ProjectPath "C:\path\to\project" -ForceProjectTemplate
```

현재 설치기는 다음을 수행합니다.

- `-ProjectPath`를 주면 프로젝트에 `.morevibe/`를 부트스트랩
- 프로젝트 루트 `AGENTS.md`에 MoreVibe 부트스트랩 블록 추가
- Codex 전역 `AGENTS.md`에 MoreVibe 전역 부트스트랩 추가
- Claude 프로젝트/전역 `CLAUDE.md`에 MoreVibe 부트스트랩 추가
- Antigravity 프로젝트/전역 `GEMINI.md`에 MoreVibe 부트스트랩 추가
- Codex 환경에서는 `~/plugins/morevibe`와 `~/.agents/plugins/marketplace.json`도 함께 정리
- 기존 플러그인 디렉터리와 marketplace 파일은 수정 전 백업

## 포함된 Skill 세트

현재 MoreVibe에는 아래 skill이 포함되어 있습니다.

- using-morevibe
- bootstrap
- start session
- plan feature
- execute plan
- debug bug
- delegate work
- request review
- apply review fixes
- verify change
- update docs
- update handoff
- finish task
- report deployment
- sync memory
- ingest item
- query harness
- session brief
- orchestrate subagents
- write back answer
- lint harness
- test first

## 어댑터 전략

### Codex

- 전역 `~/.codex/AGENTS.md`와 프로젝트 `AGENTS.md`를 주 진입점으로 사용
- `.morevibe/`를 프로젝트 내부 하네스 네임스페이스로 사용
- `plugin/`과 marketplace는 Codex 전용 자산 전달 수단으로만 사용

### Claude Code

- 프로젝트/전역 `CLAUDE.md`를 주 진입점으로 사용
- `.claude/commands`, `.claude/agents`, `Stop` hook은 보조 자산
- 설치기가 프로젝트/전역 Claude 자산을 함께 생성

### Antigravity

- 프로젝트/전역 `GEMINI.md`를 주 진입점으로 사용
- `.agents/rules/`와 `run_command` 규칙은 보조 자산
- 설치기가 프로젝트/전역 Gemini 자산을 함께 생성

## 안전한 설치 원칙

MoreVibe는 기본적으로 비파괴적 설치를 지향합니다.

- 기존 진입 파일을 명시적 의도 없이 덮어쓰지 않음
- 사용자 전역 설정을 무조건 교체하지 않음
- 교체 전 백업
- 가능하면 병합
- 각 도구에 필요한 최소 부트스트랩만 추가

이 원칙은 아래 모두에 적용됩니다.

- 사용자 전역 에이전트 설정
- 프로젝트 루트 `AGENTS.md`
- 프로젝트 루트 `CLAUDE.md`
- 프로젝트 루트 `GEMINI.md`
- 프로젝트 내부 `.morevibe/`
- 플러그인 등록 및 marketplace 파일

## 현재 다음 단계

1. Codex 설명도 `AGENTS.md + .morevibe` 중심으로 더 정리하기
2. 실제 호스트별 자동 발동 한계를 문서화하고 검증 사례 늘리기
3. 릴리스 패키지와 설치 검증 가이드를 다듬기
