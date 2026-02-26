# Agent Team 快速开始指南

## 安装

### 1. 安装 ship-faster skills

```bash
# 方法 1: 使用 npx (推荐)
npx --yes skills add Heyvhuang/ship-faster --yes --agent claude-code

# 方法 2: 手动安装
git clone https://github.com/Heyvhuang/ship-faster.git
cp -r ship-faster/skills/* ~/.claude/skills/
```

### 2. 克隆 Agent Team 模板

```bash
git clone https://github.com/YOUR_USERNAME/agent-team-template.git
cd agent-team-template
```

### 3. 安装到项目

```bash
# 复制配置文件到你的项目
cp agent-team.yaml YOUR_PROJECT/
cp -r skills/ ~/.claude/skills/
```

## 使用方法

### 方式 1: 通过 OpenClaw

直接向 OpenClaw 发送需求：

```
我想做一个 AI 图片清理工具
```

OpenClaw 会自动：
1. 使用 `workflow-project-intake` 澄清需求
2. 生成 `proposal.md` 和 `context.json`
3. 分发任务给 Workers
4. 追踪进度并报告

### 方式 2: 手动初始化

```bash
python scripts/init.py --path . --name "My Project" --goal "Build a tool"
```

然后向 OpenClaw 发送：

```
读取 runs/intake/active/{run_id}/ 并继续
```

## 核心概念

### Orchestrator vs Worker

| 角色 | 工具 | 职责 |
|------|------|------|
| Orchestrator | OpenClaw | 需求澄清、任务分发、进度追踪 |
| Worker | Claude Code / OpenCode | 执行任务、代码实现、测试验证 |

### 工作流程

```
用户 → OpenClaw (Intake) → Workers (Execute) → Review → 交付
```

### 关键文件

| 文件 | 作用 |
|------|------|
| `proposal.md` | 需求文档 |
| `context.json` | 配置和状态 |
| `tasks.md` | 任务清单 |
| `evidence/` | 证据文档 |
| `logs/` | 日志 |

## 配置开关

在 `context.json` 中设置：

```json
{
  "switches": {
    "need_database": true,   // 启用 Supabase
    "need_billing": true,    // 启用 Stripe
    "need_auth": false,      // 无需认证
    "need_deploy": true,     // 部署到 Vercel
    "need_seo": false        // 无需 SEO
  }
}
```

## 常用命令

### 查看进度

```
进度 / 状态
```

### 触发审查

```
审查 / review
```

### 部署

```
部署 / 交付
```

## 故障排除

### Worker 卡住

向 OpenClaw 发送：
```
检查 Workers 状态
```

### 任务失败

检查 `logs/events.jsonl` 了解详情。

### 恢复中断

OpenClaw 会自动从 `tasks.md` 恢复进度。
