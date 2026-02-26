# Agent Team 一键安装脚本 (Windows)
# 用法: .\install.ps1 [-Dev]

param(
  [switch]$Dev
)

Write-Host "🚀 Agent Team Template 安装脚本" -ForegroundColor Cyan
Write-Host "================================"

# 检查前置要求
Write-Host ""
Write-Host "📋 检查前置要求..." -ForegroundColor Yellow

$requirementsMet = $true

# 检查 Node.js
if (Get-Command node -ErrorAction SilentlyContinue) {
  Write-Host "✓ Node.js 已安装" -ForegroundColor Green
} else {
  Write-Host "✗ Node.js 未安装" -ForegroundColor Red
  $requirementsMet = $false
}

# 检查 Git
if (Get-Command git -ErrorAction SilentlyContinue) {
  Write-Host "✓ Git 已安装" -ForegroundColor Green
} else {
  Write-Host "✗ Git 未安装" -ForegroundColor Red
  $requirementsMet = $false
}

# 检查 GitHub CLI
if (Get-Command gh -ErrorAction SilentlyContinue) {
  Write-Host "✓ GitHub CLI 已安装" -ForegroundColor Green
} else {
  Write-Host "✗ GitHub CLI 未安装" -ForegroundColor Red
  $requirementsMet = $false
}

# 检查 Claude Code 或 OpenCode
$cliTool = $null
if (Get-Command claude -ErrorAction SilentlyContinue) {
  $cliTool = "claude"
  Write-Host "✓ Claude Code 已安装" -ForegroundColor Green
} elseif (Get-Command opencode -ErrorAction SilentlyContinue) {
  $cliTool = "opencode"
  Write-Host "✓ OpenCode 已安装" -ForegroundColor Green
} else {
  Write-Host "! 请安装 Claude Code 或 OpenCode" -ForegroundColor Yellow
  $requirementsMet = $false
}

if (-not $requirementsMet) {
  Write-Host ""
  Write-Host "请先安装缺失的前置要求，然后重新运行此脚本" -ForegroundColor Red
  exit 1
}

# 创建配置目录
Write-Host ""
Write-Host "📁 创建配置目录..." -ForegroundColor Yellow

$claudeDir = "$env:USERPROFILE\.claude"
$skillsDir = "$claudeDir\skills"

if (-not (Test-Path $claudeDir)) {
  New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
}
if (-not (Test-Path $skillsDir)) {
  New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
}
Write-Host "✓ 创建 $skillsDir" -ForegroundColor Green

# 启用 Agent Teams
Write-Host ""
Write-Host "🔧 配置 Agent Teams..." -ForegroundColor Yellow

$settingsFile = "$claudeDir\settings.json"

if (Test-Path $settingsFile) {
  $settings = Get-Content $settingsFile | ConvertFrom-Json
  if ($settings.env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS -eq "1") {
    Write-Host "✓ Agent Teams 已启用" -ForegroundColor Green
  } else {
    Write-Host "! 需要手动添加环境变量到 $settingsFile" -ForegroundColor Yellow
    Write-Host '在 "env" 中添加: "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"'
  }
} else {
  $settings = @{
    env = @{
      CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1"
    }
    teammateMode = "in-process"
  }
  $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile
  Write-Host "✓ 创建 $settingsFile" -ForegroundColor Green
}

# 复制 skills
Write-Host ""
Write-Host "📦 安装 Agent Team Skills..." -ForegroundColor Yellow

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $scriptDir) {
  $scriptDir = Get-Location
}
$skillsSource = Join-Path $scriptDir "skills"

if (Test-Path $skillsSource) {
  Get-ChildItem $skillsSource -Directory | ForEach-Object {
    $skillName = $_.Name
    $destPath = Join-Path $skillsDir $skillName
    Copy-Item -Path $_.FullName -Destination $destPath -Recurse -Force
    Write-Host "✓ 安装 $skillName" -ForegroundColor Green
  }
} else {
  Write-Host "✗ 未找到 skills 目录" -ForegroundColor Red
  exit 1
}

# 复制模板
Write-Host ""
Write-Host "📄 安装模板..." -ForegroundColor Yellow

$templatesSource = Join-Path $scriptDir "templates"
$templatesDest = "$claudeDir\templates"

if (-not (Test-Path $templatesDest)) {
  New-Item -ItemType Directory -Path $templatesDest -Force | Out-Null
}

if (Test-Path $templatesSource) {
  Get-ChildItem $templatesSource -File | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $templatesDest -Force
    Write-Host "✓ 安装 $($_.Name)" -ForegroundColor Green
  }
}

# 验证安装
Write-Host ""
Write-Host "✅ 验证安装..." -ForegroundColor Yellow

$installedSkills = (Get-ChildItem $skillsDir -Directory | Where-Object { $_.Name -match "agent-|coding-|opencode" }).Count
Write-Host "✓ 已安装 $installedSkills 个 skills" -ForegroundColor Green

Write-Host ""
Write-Host "================================"
Write-Host "安装完成！" -ForegroundColor Green
Write-Host ""
Write-Host "🎯 快速开始:"
Write-Host "   向 OpenClaw 发送: 新项目：我想做一个 [具体需求]"
Write-Host ""
Write-Host "📚 更多信息:"
Write-Host "   阅读 SETUP.md 了解详细配置"
Write-Host "   阅读 README.md 了解 AAIF 框架"
