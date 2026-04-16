# MoreVibe

**장기 AI 코딩 프로젝트를 위한 구조화된 프로젝트 메모리 하네스**

MoreVibe는 `Claude Code`, `Codex`, `Antigravity` 같은 AI 코딩 도구가 긴 프로젝트를 더 안정적으로 이어가도록 돕는 프로젝트 기반입니다.  
핵심은 채팅 기록 하나에 모든 맥락을 몰아넣는 대신, 프로젝트 자체가 기억과 운영 규칙을 갖게 만드는 것입니다.

MoreVibe는 특히 이런 목적에 맞습니다.

- 세션이 바뀌어도 프로젝트 맥락을 안정적으로 이어가고 싶을 때
- 원자료와 공식 기준 문서를 명확히 분리하고 싶을 때
- Skill과 역할 분담을 반복 가능한 운영 방식으로 만들고 싶을 때
- 비개발자도 설치만으로 일정 수준의 운영 체계를 바로 쓰고 싶을 때

---

## MoreVibe가 해결하는 문제

장기 AI 코딩 프로젝트는 보통 비슷한 이유로 흔들립니다.

- 중요한 결정이 예전 대화 속에 묻힘
- 같은 설명을 AI에게 계속 반복해야 함
- 메모, 작업 목록, 공식 문서가 뒤섞임
- 세션마다 AI의 작업 방식이 달라짐
- 비개발자는 프로젝트를 유지하는 운영 구조를 직접 만들기 어려움

MoreVibe는 이 문제를 문서 구조, workflow skill, 역할 기반 분담으로 줄이려는 도구입니다.

---

## 핵심 모델

MoreVibe는 프로젝트 지식을 4개 층으로 나눕니다.

- `sources/`
  참고자료, 메모, 로그, 조사 내용 같은 원자료
- `canon/`
  현재 프로젝트의 공식 기준 문서
- `wiki/`
  AI가 유지하는 작업 메모리와 상태 요약
- `schema/`
  무엇을 먼저 읽고, 무엇을 권위 문서로 볼지 정하는 운영 규칙

이 구조 덕분에 아래가 섞이지 않게 됩니다.

- 증거와 공식 사실
- 임시 메모와 장기 메모리
- 개인 메모와 기준 문서
- 채팅 흐름과 프로젝트 구조

---

## 설치 시 생성되는 것

선택한 도구에 따라 MoreVibe는 다음을 생성하거나 갱신합니다.

- `.morevibe/` 프로젝트 하네스 구조
- 루트 `AGENTS.md` 진입점
- `.agents/skills/` workflow skill
- `.claude/skills/`, `.claude/agents/`
- `.codex/config.toml`, `.codex/agents/*.toml`
- 실제 설치된 workflow를 반영한 schema 문서

즉, 프로젝트가 스스로 더 많은 운영 맥락을 갖게 됩니다.

---

## 기본 스타일 preset

MoreVibe에는 더 강한 기본 운영 모델을 원하는 사용자를 위한 **기본 스타일** preset이 있습니다.

이 preset을 켜면 아래가 함께 적용됩니다.

- native workflow alias
  - `start-session`
  - `project-bootstrap`
  - `plan-feature`
  - `execute-plan`
  - `debug-bug`
  - `request-code-review`
  - `verify-change`
- 더 강한 프로젝트 `AGENTS.md`
- richer role model
  - `pm-lead`
  - `storefront-ui`
  - `custom-editor`
  - `payments-orders`
  - `qa-reviewer`
- Codex와 Claude에서 같은 역할명을 쓰는 프로젝트 로컬 팀 모델

즉, 새 빈 프로젝트도 첫 세션부터 실제 운영 환경에 가까운 형태로 시작할 수 있습니다.

---

## 어떤 사용자에게 맞는가

MoreVibe는 특히 아래 사용자에게 잘 맞습니다.

- AI 코딩 도구로 실제 제품을 만드는 비개발자
- 여러 세션에 걸쳐 프로젝트를 이어가는 1인 빌더
- 문서, workflow, ownership을 명확히 나누고 싶은 사용자
- 일회성 프롬프트보다 장기 운영 구조가 중요한 프로젝트

반대로 아래 성향과는 덜 맞을 수 있습니다.

- 문서 없는 완전 즉흥형 작업 방식
- 검토 없는 완전 자동화 기대
- 모든 AI 도구에서 완전히 같은 동작을 기대하는 경우

---

## 빠른 시작

### 1. Windows 설치기 사용

1. GitHub Releases에서 최신 릴리스를 받습니다.
2. `MoreVibeInstaller.exe`를 실행하거나 ZIP을 압축 해제합니다.
3. 사용할 AI 도구를 선택합니다.
4. 프로젝트 폴더를 선택합니다.
5. 필요하면 프로젝트 유형과 **기본 스타일** preset을 선택합니다.
6. 설치를 완료합니다.
7. 프로젝트 루트에서 AI 도구를 시작합니다.

설치가 끝나면 bootstrap health 요약이 출력되어, 진입점과 skill, 역할 파일이 실제로 생성됐는지 확인할 수 있습니다.

### 2. PowerShell 스크립트 사용

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\install-morevibe.ps1
```

필요하면 아래 옵션도 함께 줄 수 있습니다.

```powershell
-ProjectPreset default-style
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

`기본 스타일` preset을 켜면 native skill alias와 preset 전용 agent 템플릿도 함께 들어갑니다.

---

## 권장 사용 방식

1. MoreVibe를 프로젝트에 설치합니다.
2. `canon/`을 현재 상태에 맞게 채웁니다.
3. 원자료와 참고 내용은 `sources/`에 둡니다.
4. AI가 현재 상태를 `wiki/`에 요약하게 합니다.
5. `schema/`는 안정적으로 유지하고, `canon/`을 기준 문서로 씁니다.
6. 다음 세션은 오래된 채팅 기록이 아니라 설치된 프로젝트 구조부터 읽게 합니다.

---

## 지원 도구

- **Claude Code**
  프로젝트 로컬 skills, agents, memory bootstrap 지원
- **Codex**
  프로젝트 로컬 skills, `.codex/` 역할 템플릿, plugin 기반 통합 지원
- **Antigravity**
  adapter 기반 bootstrap과 프로젝트 진입 지원

---

## 설계 원칙

- **기본은 비파괴적**
  기존 프로젝트 파일을 가능하면 보존합니다.
- **권위는 명확해야 함**
  모든 문서가 같은 무게를 가지면 안 됩니다.
- **AI 메모리는 파일로 외부화해야 함**
  중요한 맥락은 채팅뿐 아니라 프로젝트 파일에 남아야 합니다.
- **Workflow는 재사용 가능해야 함**
  자주 반복되는 작업은 Skill과 운영 규칙으로 설치돼야 합니다.
- **비개발자일수록 구조가 더 중요함**
  MoreVibe는 숨겨진 운영 부담을 줄이는 쪽에 초점을 둡니다.

---

## 기대치

MoreVibe는 프로젝트 구조와 지속성을 개선하지만, 아래를 보장하지는 않습니다.

- 코드 정답
- 완벽한 설계
- 리뷰 없는 안전한 수정
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

## 마지막 한 줄

MoreVibe는 아주 현실적인 문제에서 출발했습니다.

> AI 코딩 도구는 강력하지만, 장기 프로젝트는 기억, 권위, workflow, ownership이 약하면 쉽게 무너집니다.

MoreVibe의 목적은 그런 프로젝트를 더 오래, 더 안정적으로, 더 자신 있게 이어갈 수 있게 만드는 것입니다.
