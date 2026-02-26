# Agent Team 快速安装指南

> **目标**: 30分钟内完成从零到生产就绪的 AI 团队搭建

## 📋 前置要求

- [ ] 已安装 OpenClaw
- [ ] 已安装 Node.js (v18+)
- [ ] 已安装 Git
- [ ] 已安装 GitHub CLI (`gh`)
- [ ] (推荐) 已安装 tmux

---

## 🚀 第一步：安装 Claude Code / OpenCode

### 选项 A: Claude Code (Anthropic 官方)

```bash
# 安装 Claude Code
npm install -g @anthropic-ai/claude-code

# 登录认证
claude auth login

# 验证安装
claude --version
```

### 选项 B: OpenCode (开源替代)

```bash
# 安装 OpenCode
npm install -g opencode

# 登录认证
opencode auth login

# 验证安装
opencode --version
```

> **提示**: 建议同时安装两者，OpenClaw 会自动选择可用的工具

---

## 🔧 第二步：启用 Agent Teams 功能

Agent Teams 是 Claude Code 的实验性功能，需要手动启用。

### 方式一：环境变量（临时）

```bash
# macOS / Linux
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# Windows (PowerShell)
$env:CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1"
```

### 方式二：配置文件（持久化，推荐）

创建或编辑 `~/.claude/settings.json`：

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "teammateMode": "tmux"
}
```

### 方式三：OpenClaw LaunchAgent（macOS）

如果你通过 LaunchAgent 运行 OpenClaw，在 plist 中添加：

```xml
<key>EnvironmentVariables</key>
<dict>
  <key>CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS</key>
  <string>1</string>
</dict>
```

---

## 📦 第三步：安装 tmux（推荐）

Agent Teams 在 tmux 模式下效果最佳，可以同时监控多个队友。

```bash
# macOS
brew install tmux

# Ubuntu / Debian
sudo apt install tmux

# Windows (通过 WSL)
sudo apt install tmux
```

验证安装：

```bash
tmux -V
```

---

## 🛠️ 第四步：切换 OpenClaw dev 频道（可选）

如果需要最新的 Agent Teams 支持，切换到 dev 频道：

```bash
# 启用 pnpm
corepack enable pnpm

# 切换到 dev 频道
openclaw update --channel dev

# 如果自动更新失败，手动构建
cd ~/openclaw
pnpm install && pnpm build && npm install -g .

# 重启网关
openclaw gateway restart
```

---

## 📁 第五步：安装 Agent Team Skills

### 复制 Skills 到本地

```bash
# 克隆模板
git clone https://github.com/xuha233/agent-team-template.git

# 复制 skills 到 Claude Code 配置目录
cp -r agent-team-template/skills/* ~/.claude/skills/

# 验证安装
ls ~/.claude/skills/ | grep agent-
```

### Windows 用户

```powershell
# 复制 skills
Copy-Item -Recurse -Force "agent-team-template\skills\*" "$env:USERPROFILE\.claude\skills\"

# 验证安装
Get-ChildItem "$env:USERPROFILE\.claude\skills" -Directory | Where-Object { $_.Name -like "agent-*" }
```

---

## ✅ 第六步：验证安装

运行以下命令验证所有组件：

```bash
# 检查 Claude Code / OpenCode
claude --version || opencode --version

# 检查 tmux
tmux -V

# 检查 Agent Teams 启用
cat ~/.claude/settings.json | grep AGENT_TEAMS

# 检查 skills
ls ~/.claude/skills/ | grep -E "agent-|coding-|opencode"
```

全部通过后，即可开始使用！

---

## 🎯 快速开始

向 OpenClaw 发送以下消息启动团队：

```
新项目：我想做一个 [具体需求]
```

OpenClaw 会自动：
1. 评估项目复杂度
2. 配置合适的团队
3. 启动探索阶段
4. 协调 Workers 执行

---

## 🔍 故障排除

### Claude Code 未找到

```bash
# 检查 PATH
which claude || which opencode

# 重新安装
npm install -g @anthropic-ai/claude-code
# 或
npm install -g opencode
```

### Agent Teams 未生效

```bash
# 检查环境变量
echo $CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS

# 检查配置文件
cat ~/.claude/settings.json

# 重启 Claude Code 会话
```

### tmux 分屏不工作

```bash
# 确认 tmux 模式
cat ~/.claude/settings.json | grep teammateMode

# 手动启动 tmux 会话
tmux new -s agent-team
```

### Skills 未加载

```bash
# 检查 skills 目录
ls -la ~/.claude/skills/

# 确认 SKILL.md 存在
cat ~/.claude/skills/agent-orchestrator/SKILL.md
```

---

## 📚 下一步

- 阅读 [README.md](README.md) 了解 AAIF 框架
- 查看 [docs/QUICKSTART.md](docs/QUICKSTART.md) 学习使用方法
- 参考 [templates/hypotheses.md](templates/hypotheses.md) 编写假设

---

## 🆘 获取帮助

- OpenClaw 文档: https://docs.openclaw.ai
- OpenClaw 社区: https://discord.com/invite/clawd
- GitHub Issues: https://github.com/xuha233/agent-team-template/issues
