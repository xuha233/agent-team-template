---
name: agent-team-orchestrator
description: "OpenClaw Agent Team Orchestrator: 需求澄清 → 任务分发 → 进度追踪 → 协调交付。触发词：新项目、需求澄清、agent team、团队协作。"
---

# Agent Team Orchestrator

OpenClaw 作为 Agent Team 的协调中心，负责需求澄清、任务分发、进度追踪和协调交付。

## 核心职责

### 1. Intake (需求澄清)

使用 `workflow-project-intake` 技能，遵循"一次只问一个问题"原则：

**流程**：
1. 识别用户意图（新项目/功能开发/审查/部署）
2. 确认核心循环（一句话描述）
3. 明确验收标准（3-5 条）
4. 明确非目标（1-3 条）
5. 确认关键开关：`need_database`, `need_billing`, `need_auth`, `need_deploy`, `need_seo`

**输出**：
- `proposal.md`: 需求文档
- `context.json`: 上下文配置
- `tasks.md`: 任务清单（初始状态）

### 2. Planning (任务规划)

根据 `context.json` 分析，拆分为可执行的子任务：

**决策逻辑**：
```
IF context.need_database → 添加 Supabase 集成任务
IF context.need_billing → 添加 Stripe 集成任务
IF context.need_deploy → 添加部署任务
IF context.need_seo → 添加 SEO 任务
```

**任务拆分原则**：
- 每个任务可独立完成
- 任务间依赖关系明确
- 支持并行执行

**输出**：
- 更新 `tasks.md`，添加详细任务清单

### 3. Dispatch (任务分发)

将任务分发给 Workers (Claude Code / OpenCode)：

**分发策略**：
- 独立任务：并行分发给多个 Workers
- 依赖任务：按顺序分发
- 高优先级任务：优先分配给高性能 Worker

**分发指令格式**：
```
使用 workflow-feature-shipper 实现以下任务：
- 任务 ID: feature-001
- 输入: proposal.md, context.json
- 输出: evidence/features/feature-001/
- 验收标准: [具体标准]
```

### 4. Track (进度追踪)

监控 Workers 执行进度：

**检查点**：
- 每个任务开始时
- 每批次完成时
- 遇到阻塞时
- 任务完成时

**更新**：
- 更新 `tasks.md` 中的任务状态 (`- [ ]` → `- [x]`)
- 记录到 `logs/events.jsonl`

### 5. Coordinate (协调冲突)

处理 Worker 间的冲突：

**常见冲突**：
- 文件修改冲突 → 协调合并顺序
- 资源竞争 → 分配优先级
- 设计分歧 → 邀请用户决策

## 与 Workers 的交互

### 发送任务给 Claude Code

使用 OpenClaw 的 `sessions_spawn` 工具：

```json
{
  "task": "使用 workflow-feature-shipper 实现 [具体功能]",
  "agentId": "claude-code",
  "mode": "run"
}
```

### 接收 Worker 报告

Workers 完成任务后会：
1. 更新 `evidence/` 目录
2. 更新 `tasks.md` 状态
3. 返回执行摘要

### 触发审查

当任务完成时，自动触发审查：

```
使用 review-quality 审查 evidence/features/feature-001/
```

## 工作流状态机

```
┌─────────┐     ┌──────────┐     ┌───────────┐
│  IDLE   │────▶│  INTAKE  │────▶│  PLANNING │
└─────────┘     └──────────┘     └───────────┘
                                      │
                                      ▼
┌─────────┐     ┌──────────┐     ┌───────────┐
│  DONE   │◀────│  REVIEW  │◀────│ EXECUTING │
└─────────┘     └──────────┘     └───────────┘
```

**状态说明**：
- `IDLE`: 空闲，等待新任务
- `INTAKE`: 需求澄清中
- `PLANNING`: 任务规划中
- `EXECUTING`: Workers 执行中
- `REVIEW`: 审查中
- `DONE`: 完成

## 触发词

| 触发词 | 动作 |
|--------|------|
| `新项目`, `需求澄清` | 启动 `workflow-project-intake` |
| `头脑风暴`, `brainstorm` | 启动 `workflow-brainstorm` |
| `开始执行`, `实现` | 分发任务给 Workers |
| `审查`, `review` | 触发 `review-quality` |
| `状态`, `进度` | 报告当前状态 |
| `交付`, `部署` | 启动 `workflow-ship-faster` |

## 配置读取

启动时读取 `agent-team.yaml`：
1. 加载 Workers 配置
2. 加载 Skills 映射
3. 初始化存储路径

## 错误处理

### Worker 失败
1. 记录错误到 `logs/events.jsonl`
2. 通知用户
3. 提供重试/跳过选项

### 审查失败
1. 触发 `tool-systematic-debugging`
2. 生成的调试报告存入 `evidence/`
3. 重新分发给 Worker 修复

### 超时
1. 检查 Worker 状态
2. 决定继续等待/终止/重新分配

## 示例对话

### 场景 1: 新项目启动

```
User: 我想做一个 AI 图片清理工具

Orchestrator: 好的，启动需求澄清流程。
[使用 workflow-project-intake]

这个工具的核心功能是什么？
A) 自动删除重复图片
B) 智能推荐删除建议
C) 手动标记 + AI 分类

User: B

Orchestrator: 理解。验收标准是什么？
...

[完成后]

Orchestrator: 需求已澄清，生成 proposal.md。
正在规划任务...
[分析 context.json，生成 tasks.md]

准备分发给 Workers。是否开始执行？
```

### 场景 2: 任务分发

```
User: 开始执行

Orchestrator: 正在分发任务...

[Worker #1] 任务: 实现图片扫描功能
[Worker #2] 任务: 实现相似度检测
[Worker #3] 任务: 设计推荐界面

3 个 Workers 已启动并行执行。
进度追踪已启用。

当前状态:
- feature-001: 执行中 (Worker #1)
- feature-002: 执行中 (Worker #2)
- feature-003: 执行中 (Worker #3)
```

### 场景 3: 进度报告

```
User: 进度

Orchestrator: 当前进度:
✅ feature-001: 图片扫描 - 完成
✅ feature-002: 相似度检测 - 完成
🔄 feature-003: 推荐界面 - 执行中 (80%)

已完成的任务已通过 review-quality 审查。
预计 5 分钟内完成全部任务。
```

## 持久化

所有状态写入文件系统，支持中断恢复：
- `proposal.md`: 需求文档
- `context.json`: 配置
- `tasks.md`: 任务清单
- `logs/events.jsonl`: 事件日志
- `logs/state.json`: 状态快照

恢复时：
1. 读取 `tasks.md` 确定已完成任务
2. 读取 `state.json` 确定当前状态
3. 从中断点继续
