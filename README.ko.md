# MoreVibe

**장기 AI 코딩 프로젝트를 위한 프로젝트 메모리 및 workflow 하네스**

MoreVibe는 **Codex**, **Claude Code**, **Antigravity** 같은 AI 코딩 도구가 긴 프로젝트를 더 안정적으로 이어갈 수 있도록, 중요한 맥락을 일회성 채팅 기록이 아니라 프로젝트 구조 안에 정리해 두는 도구입니다.

MoreVibe는 이런 목적에 맞습니다.

- 여러 세션에 걸쳐 프로젝트를 더 안정적으로 이어가고 싶을 때
- 메모, 작업 상태, 공식 문서를 명확히 분리하고 싶을 때
- 매번 같은 작업 절차를 채팅으로 반복하지 않고 skill로 재사용하고 싶을 때
- 비개발자도 직접 운영 모델을 설계하지 않고 설치만으로 시작하고 싶을 때

---

## MoreVibe가 해결하는 문제

장기 AI 코딩 프로젝트는 보통 아래 이유로 흔들립니다.

- 중요한 결정이 오래된 대화 속에 묻힘
- 같은 맥락을 매 세션마다 다시 설명해야 함
- 메모, 계획, 공식 문서가 뒤섞임
- 세션마다 에이전트의 작업 방식이 달라짐
- 비개발자가 프로젝트 운영 구조를 직접 만들어야 함

MoreVibe는 이 문제를 프로젝트 자체의 메모리 구조와 workflow scaffold로 해결합니다.

---

## 핵심 모델

MoreVibe는 프로젝트 지식을 네 층으로 나눕니다.

- `sources/`
  조사 자료, 참고 문서, 메모, 로그, 가져온 원본 자료
- `canon/`
  프로젝트의 공식 기준 문서. 개요, 구조, 작업, 결정, 운영, handoff가 들어갑니다.
- `wiki/`
  AI가 다음 세션을 빠르게 이어가기 위해 유지하는 작업 메모리
- `schema/`
  무엇을 먼저 읽고, 무엇을 권위 문서로 보고, 하네스를 어떻게 운영할지 정하는 규칙

이 구조 덕분에 아래가 분리됩니다.

- 참고 자료와 공식 사실
- 임시 메모와 장기 메모리
- 개인 메모와 기준 문서
- 채팅 흐름과 프로젝트 구조

---

## 설치 시 들어가는 것

선택한 도구에 따라 MoreVibe는 다음을 생성하거나 갱신합니다.

- 프로젝트 로컬 `.morevibe/` 하네스
- 루트 `AGENTS.md` 진입점
- generic `morevibe-*` skill과 native workflow alias가 함께 있는 `.agents/skills/`
- `.claude/skills/`, `.claude/agents/`
- `.codex/config.toml`, `.codex/agents/*.toml`
- 실제 설치된 workflow와 delegation 모델을 반영한 schema 문서

즉, 프로젝트가 스스로 더 많은 운영 맥락을 갖게 됩니다.

---

## 공통 native workflow

MoreVibe는 프로젝트 유형과 상관없이 사용할 수 있는 공통 native workflow를 설치합니다.

- `start-session`
- `project-bootstrap`
- `plan-feature`
- `execute-plan`
- `debug-bug`
- `request-code-review`
- `apply-review-fixes`
- `verify-change`
- `finish-task`
- `update-docs`
- `update-handoff`
- `delegate-work`
- `tdd-or-test-first`
- `report-deployment-status`

이 alias들은 generic `morevibe-*` skill 위에 놓이는 읽기 쉬운 workflow 이름입니다. 특정 프로젝트 전용 기능 없이도, 반복 가능한 작업 구조를 유지할 수 있게 해줍니다.

---

## 프로젝트 유형 프리셋

MoreVibe는 workflow는 공통으로 유지하고, 역할 템플릿만 프로젝트 유형에 맞게 조정합니다.

- `webapp`
  `pm-lead`, `frontend-worker`, `backend-worker`, `qa-reviewer`
- `ecommerce`
  `pm-lead`, `storefront-worker`, `admin-worker`, `orders-worker`, `qa-reviewer`
- `blog`
  `pm-lead`, `content-worker`, `layout-worker`, `qa-reviewer`
- `api`
  `pm-lead`, `routes-worker`, `data-worker`, `qa-reviewer`
- `generic`
  특정 유형을 고르지 않았을 때 사용하는 범용 fallback

이 구조는 비개발자에게 필요한 기본 운영 방식은 제공하면서, 특정 프로젝트에만 맞는 특수 역할까지 제품 안에 넣지는 않는 방향을 지향합니다.

---

## 어떤 사용자에게 맞는가

MoreVibe는 특히 아래 사용자에게 잘 맞습니다.

- AI 코딩 도구로 실제 제품을 만드는 비개발자
- 여러 세션에 걸쳐 프로젝트를 이어가는 1인 빌더
- 문서, workflow, ownership 규칙을 분명히 두고 싶은 팀 또는 개인
- 일회성 프롬프트보다 장기 지속성이 더 중요한 프로젝트

반대로 아래 성향과는 덜 맞을 수 있습니다.

- 문서 없이 즉흥적으로만 작업하고 싶은 경우
- 검토 없이 완전 자율 동작만 원하는 경우
- 모든 AI 도구에서 완전히 똑같은 동작을 기대하는 경우

---

## 빠른 시작

### 1. Windows 설치기 사용

1. GitHub Releases에서 최신 버전을 받습니다.
2. `MoreVibeInstaller.exe`를 실행하거나 ZIP을 풀어 설치기를 엽니다.
3. 적용할 AI 도구를 선택합니다.
4. 대상 프로젝트 폴더를 선택합니다.
5. 프로젝트 유형을 선택합니다.
6. 설치를 완료합니다.
7. 프로젝트 루트에서 AI 도구를 시작합니다.

설치가 끝나면 bootstrap health 요약이 출력되어 진입점, skill, 역할 파일이 실제로 생성되었는지 확인할 수 있습니다.

### 2. PowerShell 스크립트 사용

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\installer\windows\install-morevibe.ps1 -InstallCodex -InstallClaudeCode -ProjectPath "C:\path\to\your-project" -ProjectType webapp
```

---

## 설치 후 프로젝트 구조 예시

```text
your-project/
├─ .agents/skills/
├─ .morevibe/
│  ├─ sources/
│  ├─ canon/
│  ├─ wiki/
│  └─ schema/
├─ .codex/              # Codex 통합 시
├─ .claude/             # Claude Code 통합 시
├─ AGENTS.md
└─ ...project files...
```

---

## 권장 사용 방식

1. 프로젝트에 MoreVibe를 설치합니다.
2. `canon/`을 현재 상태에 맞게 채웁니다.
3. 원본 메모와 조사 자료는 `sources/`에 둡니다.
4. AI가 현재 작업 상태를 `wiki/`에 요약하게 합니다.
5. `schema/`는 안정적으로 유지하고, `canon/`을 기준 문서로 삼습니다.
6. 다음 세션은 오래된 채팅보다 설치된 프로젝트 구조를 먼저 읽고 시작합니다.

---

## 지원 도구

- **Claude Code**
  프로젝트 로컬 skills, agents, memory bootstrap 지원
- **Codex**
  프로젝트 로컬 skills, `.codex/` 역할 템플릿, plugin 기반 통합 지원
- **Antigravity**
  adapter 수준 bootstrap과 프로젝트 진입 지원

---

## 설계 원칙

- **기본은 비파괴적 적용**
  기존 프로젝트 파일은 가능한 한 보존합니다.
- **권위는 명확해야 함**
  모든 문서가 같은 무게를 가지면 안 됩니다.
- **AI 메모리는 파일로 외부화**
  중요한 지속성은 채팅뿐 아니라 파일에도 남아야 합니다.
- **Workflow는 재사용 가능해야 함**
  반복 작업은 skill과 운영 규칙으로 정리되어야 합니다.
- **비개발자일수록 구조가 중요함**
  MoreVibe는 숨은 운영 부담을 줄이는 데 초점을 둡니다.

---

## 기대치

MoreVibe는 지속성, workflow discipline, 프로젝트 구조를 개선합니다. 하지만 아래를 보장하지는 않습니다.

- 코드 정답
- 최적의 설계
- 검토 없는 안전한 수정
- 완전한 자율 작업

Git, 테스트, 검토, 사용자 판단은 여전히 중요합니다.

---

## 문서

추천 읽기 순서는 아래와 같습니다.

1. `README.md`
2. `README.ko.md`
3. `docs/RELEASE_GUIDE.md`
4. `templates/`
5. `adapters/`

---

## 마지막으로

MoreVibe는 아주 현실적인 문제에서 출발했습니다.

> AI 코딩 도구는 강력하지만, 장기 프로젝트는 기억, 권위, workflow, ownership 구조가 약하면 쉽게 흔들립니다.

MoreVibe의 목적은 그런 프로젝트를 더 오래, 더 안정적으로, 더 자신 있게 이어갈 수 있게 만드는 것입니다.
