#!/bin/bash
# Agent Team 一键安装脚本
# 用法: ./install.sh [--dev]

set -e

echo "🚀 Agent Team Template 安装脚本"
echo "================================"

# 检测操作系统
OS="$(uname -s)"
case "$OS" in
  Darwin*) OS="macos" ;;
  Linux*)  OS="linux" ;;
  MINGW*|MSYS*|CYGWIN*) OS="windows" ;;
  *)       OS="unknown" ;;
esac

echo "检测到操作系统: $OS"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查命令是否存在
check_command() {
  if command -v "$1" &> /dev/null; then
    echo -e "${GREEN}✓${NC} $1 已安装"
    return 0
  else
    echo -e "${RED}✗${NC} $1 未安装"
    return 1
  fi
}

# 检查前置要求
echo ""
echo "📋 检查前置要求..."

REQUIREMENTS_MET=true

check_command node || REQUIREMENTS_MET=false
check_command git || REQUIREMENTS_MET=false
check_command gh || REQUIREMENTS_MET=false

# 检查 Claude Code 或 OpenCode
if check_command claude; then
  CLI_TOOL="claude"
elif check_command opencode; then
  CLI_TOOL="opencode"
else
  echo -e "${YELLOW}!${NC} 请安装 Claude Code 或 OpenCode"
  REQUIREMENTS_MET=false
fi

if [ "$REQUIREMENTS_MET" = false ]; then
  echo ""
  echo -e "${RED}请先安装缺失的前置要求，然后重新运行此脚本${NC}"
  exit 1
fi

# 检查 tmux
echo ""
echo "📦 检查可选依赖..."
if check_command tmux; then
  TMUX_MODE="tmux"
else
  echo -e "${YELLOW}!${NC} tmux 未安装，将使用 in-process 模式"
  TMUX_MODE="in-process"
fi

# 创建配置目录
echo ""
echo "📁 创建配置目录..."
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"

mkdir -p "$SKILLS_DIR"
echo -e "${GREEN}✓${NC} 创建 $SKILLS_DIR"

# 启用 Agent Teams
echo ""
echo "🔧 配置 Agent Teams..."

SETTINGS_FILE="$CLAUDE_DIR/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
  # 检查是否已配置
  if grep -q "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS" "$SETTINGS_FILE"; then
    echo -e "${GREEN}✓${NC} Agent Teams 已启用"
  else
    # 添加配置
    echo -e "${YELLOW}!${NC} 需要手动添加环境变量到 $SETTINGS_FILE"
    echo '在 "env" 中添加: "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"'
  fi
else
  # 创建配置文件
  cat > "$SETTINGS_FILE" << EOF
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "teammateMode": "$TMUX_MODE"
}
EOF
  echo -e "${GREEN}✓${NC} 创建 $SETTINGS_FILE"
fi

# 复制 skills
echo ""
echo "📦 安装 Agent Team Skills..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$SCRIPT_DIR/skills"

if [ -d "$SKILLS_SOURCE" ]; then
  for skill_dir in "$SKILLS_SOURCE"/*; do
    if [ -d "$skill_dir" ]; then
      skill_name=$(basename "$skill_dir")
      cp -r "$skill_dir" "$SKILLS_DIR/"
      echo -e "${GREEN}✓${NC} 安装 $skill_name"
    fi
  done
else
  echo -e "${RED}✗${NC} 未找到 skills 目录"
  exit 1
fi

# 复制模板
echo ""
echo "📄 安装模板..."

TEMPLATES_SOURCE="$SCRIPT_DIR/templates"
TEMPLATES_DEST="$CLAUDE_DIR/templates"

mkdir -p "$TEMPLATES_DEST"

if [ -d "$TEMPLATES_SOURCE" ]; then
  for template_file in "$TEMPLATES_SOURCE"/*; do
    if [ -f "$template_file" ]; then
      cp "$template_file" "$TEMPLATES_DEST/"
      echo -e "${GREEN}✓${NC} 安装 $(basename "$template_file")"
    fi
  done
fi

# 验证安装
echo ""
echo "✅ 验证安装..."

INSTALLED_SKILLS=$(ls "$SKILLS_DIR" 2>/dev/null | grep -E "agent-|coding-|opencode" | wc -l)
echo -e "${GREEN}✓${NC} 已安装 $INSTALLED_SKILLS 个 skills"

echo ""
echo "================================"
echo -e "${GREEN}安装完成！${NC}"
echo ""
echo "🎯 快速开始:"
echo "   向 OpenClaw 发送: 新项目：我想做一个 [具体需求]"
echo ""
echo "📚 更多信息:"
echo "   阅读 SETUP.md 了解详细配置"
echo "   阅读 README.md 了解 AAIF 框架"
