# MoreVibe

**장기 AI 코딩 프로젝트를 위한 문서 중심 workflow 하네스**

MoreVibe는 **Codex**, **Claude Code**, **Antigravity** 같은 AI 코딩 도구가 장기 프로젝트에서도 더 안정적으로 일할 수 있도록, 중요한 맥락을 휘발성 채팅 기록이 아니라 프로젝트 내부 구조에 정리해 두는 도구입니다.

이런 목적에 맞습니다.

- 여러 세션에 걸쳐 프로젝트를 안정적으로 이어가고 싶을 때
- 원본 자료, 작업 메모리, 공식 프로젝트 문서를 분리하고 싶을 때
- 같은 작업 절차를 매번 채팅으로 다시 설명하지 않고 skill로 재사용하고 싶을 때
- 비개발자도 운영 모델을 직접 설계하지 않고 설치만으로 시작하고 싶을 때

---

## MoreVibe가 해결하는 문제

장기 AI 코딩 프로젝트는 보통 아래 이유로 흔들립니다.

- 중요한 결정이 오래된 대화 안에 묻힘
- 같은 프로젝트 맥락을 세션마다 반복 설명해야 함
- 계획, 메모, handoff, 공식 문서가 뒤섞임
- 세션이 바뀔 때마다 에이전트의 작업 방식이 흔들림
- 비개발자가 계획, 검토, 인수인계를 위한 구조를 직접 만들어야 함

MoreVibe는 프로젝트 내부에 전용 메모리 구조와 workflow scaffold를 설치해서 이 문제를 줄입니다.

---

## 핵심 구조

MoreVibe는 프로젝트 지식을 네 층으로 나눕니다.

- `sources/`
  조사 자료, 외부 참고 문서, 메모, 로그, 원본 입력 자료
- `canon/`
  프로젝트의 공식 기준 문서. 개요, 구조, 작업, 결정, 운영, handoff가 들어감
- `wiki/`
  다음 세션을 더 빨리 이어가기 위한 AI 작업 메모리
- `schema/`
  무엇을 먼저 읽고, 어떻게 하네스를 유지하고, 어떤 규칙으로 움직일지 정하는 운영 규칙

이 구조 덕분에 아래가 분리됩니다.

- 참고 자료와 공식 사실
- 임시 메모와 장기 메모리
- 개인 메모와 공식 프로젝트 문서
- 채팅 흐름과 구조화된 프로젝트 상태

---

## 설치되는 것

선택한 도구에 따라 MoreVibe는 아래를 생성하거나 갱신할 수 있습니다.

- 프로젝트 로컬 `.morevibe/` 하네스
- 없는 경우 루트 `AGENTS.md`
- native workflow alias와 MoreVibe 호환 skill이 함께 들어간 `.agents/skills/`
- `.claude/skills/`, `.claude/agents/`
- `.codex/config.toml`, `.codex/agents/*.toml`
- 실제 설치된 workflow와 역할 모델을 반영하는 schema 문서

즉 프로젝트가 단일 채팅 세션에 의존하지 않고, 스스로 더 많은 운영 맥락을 갖게 됩니다.

---

## 오케스트레이션 모델

MoreVibe는 비사소한 작업에서 아래 3단계 운영 모델을 사용합니다.

1. **메인 에이전트 = 오케스트레이터**
   사용자는 자연어로 메인 세션과 대화합니다.
2. **`pm-lead` = 내부 팀장**
   팀장은 프로젝트 범위를 이해하고, workflow를 고르고, 분담을 결정하고, 결과를 통합합니다.
3. **worker = 팀원**
   worker는 좁은 범위의 구현을 맡고, `qa-reviewer`는 가능한 한 읽기 전용으로 검토를 맡습니다.

의도한 흐름은 아래와 같습니다.

- 사용자는 메인 에이전트에게 자연어로 요청함
- 메인 에이전트가 요청을 해석하고 실행을 `pm-lead` 중심으로 계획함
- `pm-lead`가 직접 처리할지, worker에게 나눌지 판단함
- worker가 작업 결과를 `pm-lead`에게 보고함
- `pm-lead`가 결과를 통합해 오케스트레이터에게 전달함
- 오케스트레이터가 다시 사용자가 이해하기 쉬운 자연어로 설명함

즉 사용자 경험은 단순하게 유지하면서, 내부 실행 구조는 정리된 팀 모델을 갖도록 설계되어 있습니다.

---

## Skill 모델

MoreVibe는 프로젝트 타입과 무관하게 공통 native workflow를 설치합니다.

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

또한 아래와 같은 specialist support skill도 함께 설치합니다.

- risk review
- UI QA
- release preparation
- shipping status reporting
- failure investigation
- safe refactor planning
- feature specification
- handoff preparation
- documentation drift checks
- first-session onboarding

프로젝트 타입에 따라 아래 같은 specialist skill도 추가될 수 있습니다.

- `webapp-ui-flow-check`
- `ecommerce-order-flow-check`
- `blog-publishing-check`
- `api-contract-check`

### Active / Fallback / Dormant

이제 MoreVibe는 설치된 skill을 아래처럼 구분합니다.

- **active**
  실제 기본 workflow에서 우선 사용하는 skill
- **fallback**
  `morevibe-*` 계열처럼 호환성 보조 레이어로 유지되는 skill
- **dormant**
  설치는 되었지만 현재 active workflow에는 연결되지 않은 skill

즉 skill 수가 많아 보여도, 지금은 “무의미하게 남아 있는 잉여”가 아니라 “active와 fallback이 구분된 구조”로 보는 게 맞습니다.

---

## 자연어 우선

MoreVibe의 기본 사용 경험은 자연어 우선입니다.

- 사용자는 평범한 말로 요청해도 됨
- MoreVibe가 요청을 해석해서 적절한 workflow로 라우팅해야 함
- 명령형 shortcut은 있을 수 있지만, 어디까지나 선택 기능이어야 함

즉 비개발자는 명령어를 외우지 않아도 MoreVibe의 이점을 누릴 수 있어야 합니다.

---

## 프로젝트 타입 프리셋

MoreVibe는 workflow는 공통으로 유지하고, 역할 프리셋만 프로젝트 타입에 맞춰 조정합니다.

- `webapp`
  `pm-lead`, `frontend-worker`, `backend-worker`, `qa-reviewer`
  specialist 예시: `webapp-ui-flow-check`, `webapp-state-review`
- `ecommerce`
  `pm-lead`, `storefront-worker`, `admin-worker`, `orders-worker`, `qa-reviewer`
  specialist 예시: `ecommerce-order-flow-check`, `ecommerce-admin-audit`
- `blog`
  `pm-lead`, `content-worker`, `layout-worker`, `qa-reviewer`
  specialist 예시: `blog-publishing-check`, `blog-content-structure-audit`
- `api`
  `pm-lead`, `routes-worker`, `data-worker`, `qa-reviewer`
  specialist 예시: `api-contract-check`, `api-data-flow-trace`
- `generic`
  특정 프로젝트 타입을 고르지 않았을 때 사용하는 넓은 범용 프리셋

이 방향은 비개발자에게 필요한 구조를 제공하면서도, 특정 프로젝트에만 맞는 특수 역할명을 제품 기본값으로 밀어넣지 않기 위한 선택입니다.

---

## 도구별 지원 범위

- **Codex**
  프로젝트 로컬 skills, `.codex/` 역할 템플릿, plugin 기반 통합 지원
- **Claude Code**
  프로젝트 로컬 skills, agents, memory bootstrap, optional commands 지원
- **Antigravity**
  adapter bootstrap과 프로젝트 타입 기반 역할 분할 규칙 지원

중요한 차이:

- `Codex`와 `Claude Code`는 실제 프로젝트 로컬 agent 파일을 설치할 수 있습니다.
- `Antigravity`는 현재 진짜 subagent 파일 시스템이 아니라, 단일 에이전트 안에서 역할을 나눠 사고하는 방식입니다.

---

## 빠른 시작

### 1. Windows 설치기 사용

1. GitHub Releases에서 최신 버전을 받습니다.
2. `MoreVibeInstaller.exe`를 실행하거나 ZIP을 압축 해제합니다.
3. 적용할 AI 도구를 선택합니다.
4. 대상 프로젝트 폴더를 선택합니다.
5. 프로젝트 타입을 선택합니다.
6. 설치를 완료합니다.
7. 프로젝트 루트에서 AI 도구를 시작합니다.

첫 세션 메시지는 아래처럼 시작하면 좋습니다.

- "이 프로젝트부터 먼저 이해하고 가장 안전한 다음 작업을 알려줘"

설치가 끝나면 bootstrap health 요약이 출력되어, entrypoint, skill, 역할 파일이 실제로 생성되었는지 확인할 수 있습니다.

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
2. `canon/`을 실제 현재 상태와 맞게 유지합니다.
3. 원본 메모와 조사 자료는 `sources/`에 둡니다.
4. AI가 현재 작업 상태를 `wiki/`에 요약하게 합니다.
5. `schema/`는 안정적으로 유지하고, `canon/`을 기준 문서로 삼습니다.
6. 다음 세션은 오래된 채팅보다 설치된 프로젝트 구조를 먼저 읽고 시작합니다.

---

## 설계 원칙

- **기본값은 비파괴적 적용**
  기존 프로젝트 파일을 가능한 한 보존합니다.
- **권위는 명확해야 함**
  모든 문서가 같은 무게를 가지면 안 됩니다.
- **AI 메모리는 파일로 남아야 함**
  중요한 지속성은 채팅이 아니라 파일에도 있어야 합니다.
- **Workflow는 재사용 가능해야 함**
  반복 작업은 skill과 운영 규칙으로 정리되어야 합니다.
- **비개발자에게는 구조가 중요함**
  MoreVibe는 숨은 운영 부담을 줄이는 방향으로 설계됩니다.

---

## 기대치

MoreVibe는 지속성, workflow discipline, 프로젝트 구조를 개선합니다. 하지만 아래를 보장하지는 않습니다.

- 코드 정답
- 최적 구조
- 검토 없는 안전한 수정
- 완전한 자율 작업

Git, 테스트, 검토, 사용자 판단은 여전히 중요합니다.

---

## 문서

추천 읽기 순서는 아래와 같습니다.

1. `README.md`
2. `README.ko.md`
3. `docs/METHOD.md`
4. `docs/WORKFLOW_MAP.md`
5. `docs/TEAM_MODEL.md`
6. `docs/MEMORY_MODEL.md`
7. `docs/NON_PROGRAMMER_GUIDE.md`
8. `docs/OPTIONAL_COMMANDS.md`
9. `docs/RELEASE_GUIDE.md`
10. `templates/`
11. `adapters/`

---

## 마지막으로

MoreVibe는 아주 실용적인 문제의식에서 출발했습니다.

> AI 코딩 도구는 강력하지만, 장기 프로젝트는 기억, 권위, workflow, ownership 구조가 약하면 쉽게 흔들립니다.

MoreVibe의 목적은 그런 프로젝트를 더 오래, 더 안정적으로, 더 자신 있게 이어갈 수 있게 만드는 것입니다.
