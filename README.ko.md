# MoreVibe

**AI 코딩 도구를 위한 지속형 프로젝트 메모리 하네스**

MoreVibe는 `Claude Code`, `Codex`, `Antigravity` 같은 AI 코딩 도구가 긴 프로젝트를 더 안정적으로 이어가도록 돕는 비파괴적 프로젝트 기반입니다.  
핵심은 프로젝트 지식을 아래 4개 층으로 나누는 것입니다.

- `sources`: 원자료, 참고자료, 메모, 로그
- `canon`: 현재 프로젝트의 공식 기준 문서
- `wiki`: AI가 유지하는 작업 메모리와 상태 요약
- `schema`: 무엇을 먼저 읽고, 무엇을 권위 문서로 볼지 정하는 운영 규칙

즉, 채팅 기록 하나에 모든 맥락을 몰아넣는 대신, 프로젝트 자체가 기억을 갖도록 만드는 구조입니다.

---

## MoreVibe가 해결하려는 문제

긴 AI 코딩 프로젝트는 보통 비슷한 이유로 흔들립니다.

- 중요한 결정이 예전 대화 속에 묻힘
- 같은 프로젝트 설명을 계속 반복해야 함
- 문서는 늘어나는데 무엇이 기준인지 모호해짐
- AI가 메모, 가설, 공식 사실을 섞어버림
- 세션이 길어질수록 품질이 흔들림

MoreVibe는 이 문제를 문서 구조와 운영 규칙으로 줄이려는 도구입니다.

---

## 설치하면 무엇이 생기나

대상 도구에 따라 다음이 생성되거나 갱신됩니다.

- `.morevibe/` 프로젝트 하네스 구조
- 루트 `AGENTS.md` 또는 도구별 진입 파일
- `.agents/skills/` 기본 workflow skill
- `.claude/skills/`, `.claude/agents/`
- `.codex/config.toml`, `.codex/agents/*.toml`
- 세션 부트스트랩과 프로젝트 스키마 문서

빈 프로젝트라면 시작용 `AGENTS.md`도 자동으로 준비됩니다.

---

## 기본 스타일 preset

설치 중 **기본 스타일** preset을 켜면, 일반 MoreVibe 구조 위에 더 강한 기본 운영 모델이 함께 적용됩니다.

추가되는 핵심은 다음과 같습니다.

- native workflow alias
  - `start-session`
  - `project-bootstrap`
  - `plan-feature`
  - `execute-plan`
  - `debug-bug`
  - `request-code-review`
  - `verify-change`
- 더 강한 루트 `AGENTS.md`
- richer role model
  - `pm-lead`
  - `storefront-ui`
  - `custom-editor`
  - `payments-orders`
  - `qa-reviewer`
- Codex와 Claude Code에서 같은 역할명 기반의 팀 모델

즉, “설치만 하면 바로 운영 가능한 기본 워크플로”에 더 가까운 구성을 제공합니다.

---

## 빠른 시작

### 1. Windows 설치기 사용

1. GitHub Releases에서 최신 설치 파일이나 ZIP을 받습니다.
2. 설치기를 실행합니다.
3. 사용할 AI 도구를 고릅니다.
4. 프로젝트 폴더를 선택합니다.
5. 필요하면 프로젝트 유형과 `기본 스타일` preset을 선택합니다.
6. 설치를 완료합니다.
7. 프로젝트 루트에서 AI 도구를 시작합니다.

설치가 끝나면 bootstrap health 요약이 출력되어, 진입점과 skill, agent가 실제로 생성됐는지 바로 확인할 수 있습니다.

### 2. PowerShell 스크립트 사용

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\install-morevibe.ps1
```

필요하면 `-ProjectType`, `-ProjectPreset default-style` 같은 옵션을 함께 줄 수 있습니다.

---

## 설치 후 프로젝트 모습 예시

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

`기본 스타일` preset이 켜져 있으면 native skill alias와 preset agent도 함께 들어갑니다.

---

## 권장 사용 방식

1. MoreVibe를 프로젝트에 설치합니다.
2. `canon` 문서를 현재 상태에 맞게 채웁니다.
3. 원자료는 `sources`에 둡니다.
4. AI가 현재 상태를 `wiki`에 요약하게 합니다.
5. 다음 세션은 채팅 기록이 아니라 설치된 구조부터 읽게 합니다.

이렇게 하면 세션이 끊겨도 프로젝트를 다시 이어가기 훨씬 쉬워집니다.

---

## 주의할 점

MoreVibe는 구조와 지속성을 개선하지만, 아래를 보장하지는 않습니다.

- 코드 정답
- 완벽한 설계
- 무조건 안전한 수정
- AI의 완전 자동화

여전히 필요한 것은 같습니다.

- 변경 검토
- Git 사용
- 중요한 동작 테스트
- 문서와 코드의 정합성 확인

---

## 문서

추가 문서는 아래를 참고하세요.

1. `README.md`
2. `docs/RELEASE_GUIDE.md`
3. `templates/`
4. `adapters/`

MoreVibe의 목표는 복잡한 자동화 시스템이 아니라, **비개발자도 긴 AI 프로젝트를 무너지지 않게 이어갈 수 있는 재사용 가능한 기반**을 만드는 것입니다.
