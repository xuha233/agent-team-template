# Agent Team Template

一套即开即用的多 Agent 协作模板，深度集成 ship-faster 工具链。

## 架构概览

```
┌─────────────────────────────────────────────────────────────────┐
│                        用户 / 外部系统                            │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    OpenClaw (Orchestrator)                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   Intake    │  │  Dispatcher │  │   Tracker   │              │
│  │  需求澄清    │  │  任务分发    │  │  进度追踪    │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└───────────────────────────────┬─────────────────────────────────┘
                                │
            ┌───────────────────┼───────────────────┐
            ▼                   ▼                   ▼
   ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
   │  Claude Code    │ │  Claude Code    │ │  Claude Code    │
   │   Worker #1     │ │   Worker #2     │ │   Worker #N     │
   │  (或 OpenCode)  │ │  (或 OpenCode)  │ │  (或 OpenCode)  │
   └─────────────────┘ └─────────────────┘ └─────────────────┘
            │                   │                   │
            └───────────────────┴───────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Ship-Faster Skills                          │
│  workflow-*  │  review-*  │  tool-*  │  supabase/stripe/...     │
└─────────────────────────────────────────────────────────────────┘
```

## 角色分工

### OpenClaw (Orchestrator)
- **职责**：需求澄清、任务分发、进度追踪、协调冲突
- **核心 Skills**：`workflow-project-intake`, `workflow-brainstorm`
- **输出**：`proposal.md`, `context.json`, `tasks.md`

### Claude Code / OpenCode (Worker)
- **职责**：执行具体任务、代码实现、测试验证
- **核心 Skills**：`workflow-feature-shipper`, `review-*`, `tool-*`
- **输出**：代码变更、`evidence/` 文档、验证报告

## 快速开始

### 1. 安装依赖

```bash
# 安装 ship-faster skills
git clone https://github.com/Heyvhuang/ship-faster.git
cp -r ship-faster/skills/* ~/.claude/skills/

# 克隆此模板
git clone https://github.com/YOUR_USERNAME/agent-team-template.git
```

### 2. 启动新项目

向 OpenClaw 发送：
```
使用 workflow-project-intake 开始一个新项目
```

OpenClaw 会：
1. 使用 `workflow-project-intake` 澄清需求
2. 生成 `proposal.md` 和 `context.json`
3. 根据需求决定分发策略

### 3. 执行任务

OpenClaw 分发任务后，Workers 自动：
1. 使用 `workflow-feature-shipper` 实现功能
2. 使用 `review-quality` 进行代码审查
3. 输出 evidence 文档

## 工作流程

### Phase 1: Intake (需求澄清)

**触发词**：`新项目`, `需求澄清`, `brainstorm`

**流程**：
1. OpenClaw 使用 `workflow-project-intake`
2. 一次只问一个问题
3. 确认核心循环、验收标准、非目标
4. 输出 `proposal.md`, `context.json`

### Phase 2: Planning (任务规划)

**触发词**：`规划`, `拆解任务`

**流程**：
1. OpenClaw 分析 `context.json`
2. 决定需要哪些 skills
3. 拆分为可并行的子任务
4. 输出 `tasks.md`

### Phase 3: Execution (并行执行)

**触发词**：`开始执行`, `实现`

**流程**：
1. OpenClaw 分发任务给 Workers
2. Workers 使用 `workflow-feature-shipper`
3. 每个 Worker 独立工作
4. 定期报告进度

### Phase 4: Review (质量审查)

**触发词**：`审查`, `review`

**流程**：
1. Workers 完成任务后触发
2. 使用 `review-quality` 进行审查
3. 发现问题则修复
4. 输出审查报告

### Phase 5: Delivery (交付)

**触发词**：`交付`, `部署`

**流程**：
1. 合并所有变更
2. 使用 `workflow-ship-faster` 部署
3. 输出 `final.md`

## 文件结构

```
project/
├── runs/                          # 运行目录
│   └── intake/
│       └── active/
│           └── <run_id>/
│               ├── proposal.md    # 需求文档
│               ├── context.json   # 上下文配置
│               ├── tasks.md       # 任务清单
│               └── evidence/      # 证据文档
├── .claude/
│   └── skills/                    # Claude Code skills
└── agent-team.yaml                # Agent Team 配置
```

## 配置文件

### agent-team.yaml

```yaml
version: "1.0"
orchestrator:
  name: openclaw
  role: dispatcher
  
workers:
  - name: claude-code
    role: executor
    skills:
      - workflow-feature-shipper
      - review-quality
      - tool-systematic-debugging
    max_parallel: 3
    
  - name: opencode
    role: executor
    alternative_to: claude-code
    skills:
      - workflow-feature-shipper
      - review-quality

workflows:
  intake: workflow-project-intake
  feature: workflow-feature-shipper
  ship: workflow-ship-faster
  review: review-quality

settings:
  artifact_store: runs/
  checkpoint_enabled: true
  auto_review: true
```

## Skills 清单

### Workflows
| Skill | 用途 | 使用者 |
|-------|------|--------|
| `workflow-project-intake` | 需求澄清 | Orchestrator |
| `workflow-brainstorm` | 头脑风暴 | Orchestrator |
| `workflow-feature-shipper` | 单功能开发 | Worker |
| `workflow-ship-faster` | 端到端交付 | Worker |

### Reviews
| Skill | 用途 | 使用者 |
|-------|------|--------|
| `review-quality` | 代码质量审查 | Worker |
| `review-merge-readiness` | 合并就绪检查 | Worker |
| `review-react-best-practices` | React 最佳实践 | Worker |

### Tools
| Skill | 用途 | 使用者 |
|-------|------|--------|
| `tool-design-style-selector` | 设计系统生成 | Worker |
| `tool-systematic-debugging` | 系统化调试 | Worker |
| `tool-ui-ux-pro-max` | UI/UX 参考 | Worker |

## 最佳实践

### 1. 一次只问一个问题
OpenClaw 在 Intake 阶段遵循这个原则，避免信息过载。

### 2. 文件优先
所有状态都持久化到文件，支持中断恢复。

### 3. 小步提交
Workers 使用 `workflow-feature-shipper` 拆分为 PR 级别的小任务。

### 4. 自动审查
每个任务完成后自动触发 `review-quality`。

### 5. 证据驱动
所有决策都有 `evidence/` 文档支持。

## 示例对话

### 启动新项目

```
User: 我想做一个 AI 图片清理工具

OpenClaw: 好的，让我澄清一下需求。这个工具的核心功能是什么？
  A) 自动识别并删除相似/重复图片
  B) 智能推荐哪些图片可以删除
  C) 手动标记 + AI 辅助分类

User: B

OpenClaw: 理解。验收标准是什么？
  1) 能扫描指定文件夹
  2) 能识别相似图片
  3) 能生成删除建议列表
  还需要补充吗？

User: 加上：支持预览和一键清理

OpenClaw: 已记录。非目标是什么？
  1) 不支持视频处理
  2) 不支持云端存储
  对吗？

User: 对

OpenClaw: 需要数据库吗？(Supabase)
User: 不需要，本地工具

OpenClaw: 需要部署吗？
User: 不需要，桌面应用

OpenClaw: 好的，需求已澄清。正在生成 proposal.md...
[创建 runs/intake/active/20260227-001/proposal.md]

准备启动 Workers 实现。是否开始？
```

## License

MIT
