#!/usr/bin/env pwsh
# claude-shipyard installer
# 개인 Claude skills 디렉터리에 이 repo 의 shipyard 스킬을 junction(Win)/symlink(*nix)로 링크.
# 관리자 권한 불필요(Windows junction).

$ErrorActionPreference = 'Stop'
$repoSkill = Join-Path $PSScriptRoot 'shipyard'

if (-not (Test-Path $repoSkill)) {
    Write-Error "shipyard 스킬 폴더를 찾을 수 없음: $repoSkill"
    exit 1
}

# Claude config 디렉터리 탐지: CLAUDE_CONFIG_DIR > ~/.claude-2(있으면) > ~/.claude
function Resolve-ClaudeConfigDir {
    if ($env:CLAUDE_CONFIG_DIR -and (Test-Path $env:CLAUDE_CONFIG_DIR)) {
        return $env:CLAUDE_CONFIG_DIR
    }
    $alt = Join-Path $HOME '.claude-2'
    if (Test-Path $alt) { return $alt }
    return (Join-Path $HOME '.claude')
}

$configDir = Resolve-ClaudeConfigDir
$skillsDir = Join-Path $configDir 'skills'
$link      = Join-Path $skillsDir 'shipyard'

Write-Host "Claude config dir : $configDir"
Write-Host "Skills dir        : $skillsDir"
Write-Host "Link target       : $repoSkill"

if (-not (Test-Path $skillsDir)) {
    New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
}

if (Test-Path $link) {
    $item = Get-Item $link -Force
    if ($item.LinkType) {
        Write-Host "기존 링크 제거: $link ($($item.LinkType))"
        Remove-Item $link -Force
    } else {
        Write-Error "이미 일반 폴더가 있음(링크 아님): $link — 수동 확인 필요."
        exit 1
    }
}

if ($IsWindows -or $null -eq $IsWindows) {
    New-Item -ItemType Junction -Path $link -Target $repoSkill | Out-Null
} else {
    New-Item -ItemType SymbolicLink -Path $link -Target $repoSkill | Out-Null
}

Write-Host ""
Write-Host "완료. Claude Code 에서 /shipyard 로 확인하세요." -ForegroundColor Green
Write-Host "안 뜨면 위 'Claude config dir' 이 실제 사용하는 디렉터리와 같은지 확인하세요."
