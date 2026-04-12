# MoreVibe

[English](./README.md) | [한국어](./README.ko.md)

MoreVibe는 어떤 프로젝트에서든 더 나은 바이브코딩을 가능하게 하기 위한 개인용 LLM 하네스 플러그인입니다.

이 플러그인은 사용자가 프로그래머가 아닐 수도 있고, 구조 설계, 문서 작성, 유지보수 같은 작업의 대부분을 AI에 맡기는 워크플로를 전제로 설계되었습니다.

MoreVibe는 LLM이 아래와 같은 안정적인 프로젝트 메모리 구조로 일할 수 있게 돕습니다.

- `sources`: 근거 자료, 레퍼런스, 메모, 스냅샷
- `canon`: 현재 프로젝트의 공식 기준 문서
- `wiki`: LLM이 유지하는 컴파일된 작업 메모리

중요한 점은, 먼저 사람이 보기 좋은 위키를 만드는 것이 목적이 아니라는 것입니다.

목적은 LLM이 매 세션마다 다시 탐색하지 않고도 누적된 문맥을 바탕으로 더 안정적으로 일할 수 있는 내부 하네스를 주는 데 있습니다.

## 핵심 모델

MoreVibe는 프로젝트 지식을 네 가지 역할로 나눕니다.

- `schema`: LLM이 하네스를 어떻게 읽고, 쓰고, 유지할지 설명하는 운영 규칙
- `sources`: 주로 불변에 가까운 입력과 근거 자료
- `canon`: AI가 작성했더라도 현재 프로젝트의 공식 기준으로 쓰이는 문서
- `wiki`: sources와 canon을 바탕으로 LLM이 유지하는 메모리 레이어

이 구분의 기준은 누가 썼는지가 아니라, 그 파일이 어떤 역할을 맡는지입니다.

즉, AI가 쓴 문서도 현재 프로젝트의 공식 참조 문서라면 `canon`이 될 수 있습니다.

## Core + Adapters 구조

MoreVibe는 이제 두 레이어를 기준으로 구조화됩니다.

- `core`: 여러 에이전트 도구에서 공통으로 써야 하는 하네스 모델
- `adapters`: Codex, ClaudeCode, Antigravity 같은 도구별 통합 레이어

`core`는 웹, 게임, 도구, 자동화 프로젝트처럼 프로젝트 종류가 달라도 최대한 그대로 재사용되어야 합니다.

반대로 `adapters`는 아래 같은 도구별 차이를 담당합니다.

- 전역 규칙 파일이 어디에 있는지
- 프로젝트 진입점을 어떻게 찾는지
- 사용자 전역 설정을 어떻게 건드려야 하는지
- 기존 파일을 덮어쓰지 않고 MoreVibe를 어떻게 붙일지

즉, MoreVibe는 "Codex 전용 플러그인"이라기보다, Codex를 첫 번째 어댑터로 구현한 공통 하네스 시스템으로 보는 편이 맞습니다.

## MoreVibe가 필요한 이유

많은 LLM 워크플로는 사실상 즉석 검색에 가깝습니다.

- 파일을 넣고
- 질문하고
- 관련 조각을 찾아 답하고
- 다음 질문 때 다시 비슷한 종합을 반복합니다

MoreVibe는 이 방식 대신 아래 관점을 택합니다.

- 프로젝트의 근거 자료를 보존하고
- 현재 기준 문서를 관리하고
- LLM이 지속되는 작업 메모리를 컴파일하게 하며
- 그 메모리를 반복적으로 점검하고 건강하게 유지합니다

이렇게 하면 장기 프로젝트에서도 세션 복구, 방향 유지, 구조적 확장이 훨씬 쉬워집니다.

## 기본 운영 루프

MoreVibe는 세 가지 반복 작업을 중심으로 동작합니다.

1. `ingest`
새 정보를 하네스에 반영하고, 어떤 자료가 `sources` 또는 `canon`에 속하는지 분류한 뒤 `wiki`를 갱신합니다.

2. `query`
가능하면 먼저 `wiki`를 바탕으로 답하고, 부족할 때 `canon`과 `sources`로 내려갑니다. 가치 있는 답변은 다시 하네스에 환원합니다.

3. `lint`
드리프트, 오래된 정보, 중복, 빠진 연결, `canon/wiki` 불일치 같은 문제를 점검합니다.

## 현재 상태

MoreVibe는 아직 초기 스캐폴딩 단계입니다.

현재 저장소에는 아래가 포함되어 있습니다.

- Codex 중심 플러그인 manifest
- 초기 bootstrap skill
- Windows 설치기 시작점
- `.morevibe/` 프로젝트 템플릿 네임스페이스
- core/adapters 구조의 기본 설계

## 저장소 구조

```text
plugin/        # 설치 가능한 MoreVibe 플러그인 본체
installer/     # 설치 스크립트와 패키징 진입점
templates/     # MoreVibe가 프로젝트에 주입할 템플릿
core/          # 도구 공통 MoreVibe 하네스 모델
adapters/      # 도구별 통합 가이드와 어댑터
```

## 자동화된 것과 아직 자동화되지 않은 것

이미 구현된 것:

- Codex 스타일 로컬 플러그인 설치
- marketplace 등록 병합/갱신
- 프로젝트 로컬 `.morevibe/` 부트스트랩
- 현재 설치 대상에 대한 교체 전 백업

문서화만 되었고 아직 자동화되지 않은 것:

- 루트 `AGENTS.md`에 최소 MoreVibe 부트스트랩 블록 삽입
- 도구별 전역 설정 파일 패치
- 현재 Codex 중심 경로를 넘어서는 도구별 실제 지원

## 프로젝트 통합 방식

MoreVibe는 프로젝트 루트의 `AGENTS.md`를 대체하지 않습니다.

의도한 통합 방식은 이렇습니다.

- 루트 `AGENTS.md`는 에이전트 도구가 읽는 표준 진입점으로 유지
- MoreVibe는 재사용 가능한 플러그인으로 설치
- 각 프로젝트 내부에서는 `.morevibe/`를 플러그인 전용 네임스페이스로 사용

권장 프로젝트 로컬 구조는 아래와 같습니다.

```text
project-root/
  AGENTS.md
  .morevibe/
    sources/
    canon/
    wiki/
```

이 구조를 쓰면 `src`, `docs`, `sources` 같은 일반 프로젝트 폴더명과 충돌을 줄일 수 있습니다.

## 레이어 규칙

- `sources`에는 근거 자료, 외부 자료, 메모, 스냅샷, 원시 입력을 둡니다.
- `canon`에는 프로젝트의 현재 공식 기준 문서를 둡니다.
- `wiki`에는 LLM의 내부 작업 메모리와 연결된 요약을 둡니다.
- 같은 규칙이 여러 곳에서 동시에 권위 원본이 되면 안 됩니다.
- `wiki`와 `canon`이 충돌하면 먼저 `canon`을 점검하거나 갱신해야 합니다.
- AI가 작성한 문서라도 프로젝트가 공식 기준으로 취급하면 `canon`입니다.

## 목표 설치 방식

장기적으로는 비개발자도 쉽게 설치할 수 있어야 합니다.

1. GitHub Releases에서 MoreVibe를 다운로드합니다.
2. 설치기를 실행합니다.
3. 사용자의 로컬 Codex 플러그인 디렉터리에 플러그인을 설치합니다.
4. 별도 수작업 없이 프로젝트에서 MoreVibe를 사용할 수 있게 합니다.

## 현재 Windows 설치기

현재 설치 진입점은 아래 파일입니다.

```powershell
installer/windows/install-morevibe.ps1
```

기본 사용:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1
```

플러그인을 설치하면서 프로젝트에 `.morevibe/`도 함께 부트스트랩:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1 -ProjectPath "C:\path\to\project"
```

이미 `.morevibe/`가 있는 프로젝트에서 의도적으로 교체하고 싶을 때:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-morevibe.ps1 -ProjectPath "C:\path\to\project" -ForceProjectTemplate
```

현재 설치기는 다음을 수행합니다.

- `~/plugins/morevibe`에 MoreVibe 플러그인 설치
- `~/.agents/plugins/marketplace.json` 생성 또는 갱신
- 기존 플러그인 디렉터리를 교체하기 전에 백업
- 현재 marketplace 파일을 쓰기 전에 백업
- 필요하면 프로젝트에 `.morevibe/`를 부트스트랩

## 어댑터 전략

### Codex

- 현재 가장 먼저 구현 중인 대상
- `plugin/`의 현재 구조를 사용
- 프로젝트 루트 `AGENTS.md`를 표준 진입점으로 유지

### ClaudeCode

- 이후 추가할 어댑터
- 자체 부트스트랩 규칙과 설치 지점이 필요할 가능성이 큼
- 그래도 `.morevibe/`와 core 하네스 규칙은 공통으로 재사용해야 함

### Antigravity

- 이후 추가할 어댑터
- 자체 부트스트랩 규칙과 설치 지점이 필요할 가능성이 큼
- 그래도 `.morevibe/`와 core 하네스 규칙은 공통으로 재사용해야 함

## 안전한 설치 원칙

MoreVibe는 기본적으로 비파괴적 설치를 지향해야 합니다.

- 기존 프로젝트 진입 파일을 명시적 의도 없이 덮어쓰지 않음
- 사용자 전역 설정을 무조건 교체하지 않음
- 교체 전 백업
- 가능하면 병합
- 대상 도구에 필요한 최소 부트스트랩만 추가

이 원칙은 아래 모두에 적용됩니다.

- 사용자 전역 에이전트 설정
- 프로젝트 루트 `AGENTS.md`
- 프로젝트 내부 `.morevibe/`
- 플러그인 등록 및 marketplace 파일

## 현재 다음 단계

1. 현재 Codex 중심 구현에서 프로젝트 `AGENTS.md` 안전 삽입까지 구현하기
2. ClaudeCode와 Antigravity의 전역 통합 명세 구체화하기
3. 도구별 실제 설치 경로와 어댑터 동작 정의하기
4. ingest, query, lint 스킬 확장하기
