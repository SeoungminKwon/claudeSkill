# claude-shipyard

Claude Code 개인 스킬 `shipyard` 의 소스 오브 트루스 repo.
기능 개발을 **요구사항 → 영향분석 → 게이트 → 검증 → 문서 현행화** 흐름으로 강제하는 범용 스킬.

- 범용 흐름은 `shipyard/SKILL.md` (이 repo).
- 프로젝트별 구체값(검증 명령·문서 경로·주의사항)은 각 프로젝트의 `.claude/shipyard.md` 에 둔다 (이 repo 아님).

## 설치 (각 컴퓨터에서 1회)

### 1. 이 repo 클론

```powershell
git clone https://github.com/<YOUR_ID>/claude-shipyard.git C:\dev\claude-shipyard
```

### 2. 개인 skills 디렉터리로 링크

`install.ps1` 이 Claude 설정 디렉터리를 자동 탐지해 junction(관리자 권한 불필요)을 만든다:

```powershell
cd C:\dev\claude-shipyard
./install.ps1
```

수동으로 하려면 — 본인의 Claude config 디렉터리 아래 `skills\shipyard` 로 junction:

```powershell
# CLAUDE_CONFIG_DIR 을 커스텀(.claude-2 등)으로 쓰면 그 경로, 아니면 $HOME\.claude
New-Item -ItemType Junction -Path "$HOME\.claude\skills\shipyard" -Target "C:\dev\claude-shipyard\shipyard"
```

macOS / Linux:

```bash
mkdir -p ~/.claude/skills
ln -s /path/to/claude-shipyard/shipyard ~/.claude/skills/shipyard
```

### 3. 확인

Claude Code 에서 `/shipyard` 입력 시 스킬이 뜨면 성공. 안 뜨면 config 디렉터리(`.claude` vs `.claude-2`)를 확인하고 그 아래 `skills\shipyard` 로 다시 링크.

## 업데이트

```powershell
cd C:\dev\claude-shipyard && git pull
```

junction 이라 모든 머신이 `git pull` 한 번으로 최신화된다.

## 새 프로젝트에 적용

해당 프로젝트에서 `/shipyard` 호출 → 처음이면 스킬이 그 프로젝트의 검증 명령/문서 경로를 묻고 `.claude/shipyard.md` 바인딩 생성을 제안한다.
