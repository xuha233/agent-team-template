# Agent Team Template v2.0

基于 AAIF 框架（AI敏捷孵化框架）设计的多 Agent 协作模板。

## 核心理念

### 从"任务分发"到"假设验证"

传统模式：
```
需求 → 任务拆分 → 分发执行 → 交付
```

AAIF 模式：
```
假设 → 实验设计 → 构建 → 验证 → 学习
```

### 六大支柱

| 支柱 | Agent 角色 | 核心职责 |
|------|-----------|---------|
| 探索导向规划 | Orchestrator + Product Owner | 假设驱动开发 |
| 跨职能协作 | 多角色 Agent 团队 | 专业协作 |
| 数据-模型双驱动 | Data Agent + ML Agent | 同步迭代 |
| 价值驱动验证 | Product Owner + Domain Expert | 业务价值优先 |
| 适应性治理 | Orchestrator | 轻量级治理 |
| 持续学习 | All Agents | 经验捕获 |

---

## Agent 角色

### 核心团队

```
┌─────────────────────────────────────────────────────────────┐
│                    Orchestrator (OpenClaw)                   │
│  职责：协调、治理、学习捕获                                    │
└───────────────────────────┬─────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ Product Owner │   │  Data Agent   │   │   ML Agent    │
│ 需求/价值/优先级│   │ 数据/质量/管道 │   │ 模型/训练/评估 │
└───────────────┘   └───────────────┘   └───────────────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│  Dev Agent    │   │  UX Agent     │   │  DevOps Agent │
│ 代码/功能/集成 │   │ 体验/交互/原型 │   │ 部署/监控/运维 │
└───────────────┘   └───────────────┘   └───────────────┘
```

### 角色定义

#### Orchestrator (OpenClaw)
- **职责**：协调整个团队、适应性治理、学习捕获
- **核心能力**：
  - 项目复杂度评估
  - 策略选择与调整
  - 冲突协调
  - 经验教训捕获

#### Product Owner Agent
- **职责**：假设定义、价值验证、优先级管理
- **核心能力**：
  - 业务需求翻译
  - 假设驱动开发
  - 成功标准定义
  - 利益相关者沟通

#### Data Agent
- **职责**：数据探索、质量评估、管道构建
- **核心能力**：
  - 数据质量评估
  - 数据预处理
  - 特征工程
  - 数据管道开发

#### ML Agent
- **职责**：模型设计、训练、评估
- **核心能力**：
  - 算法选择
  - 模型架构设计
  - 超参数调优
  - 性能评估

#### Dev Agent (Claude Code / OpenCode)
- **职责**：应用开发、功能实现、系统集成
- **核心能力**：
  - 前后端开发
  - API 设计
  - 集成测试
  - 代码质量

#### UX Agent
- **职责**：用户体验设计、交互原型、可用性测试
- **核心能力**：
  - 用户研究
  - 交互设计
  - 原型设计
  - 可用性测试

#### DevOps Agent
- **职责**：部署、监控、运维
- **核心能力**：
  - CI/CD 管道
  - 容器化
  - 监控告警
  - 性能优化

### 扩展团队（按需）

#### Domain Expert Agent
- **职责**：领域知识、业务验证
- **触发**：高业务复杂度项目

#### Ethics Agent
- **职责**：伦理评估、公平性检查
- **触发**：高风险、合规敏感项目

---

## 工作流程：探索→构建→验证→学习

### Phase 1: 探索 (Explore)

**目标**：理解问题空间，识别数据可用性，形成初步假设

**参与者**：Orchestrator + Product Owner + Data Agent + Domain Expert

**流程**：
```
1. 业务问题细化
   Product Owner: "问题是什么？业务价值是什么？"
   
2. 数据可用性评估
   Data Agent: "有什么数据？质量如何？需要什么预处理？"
   
3. 假设形成
   Orchestrator: "基于数据和能力，我们的假设是什么？"
   
4. 成功标准定义
   Product Owner: "如何验证假设？成功/失败标准是什么？"
```

**输出**：
- `hypotheses.md` - 假设清单
- `data-assessment.md` - 数据评估报告
- `success-criteria.md` - 成功标准
- `exploration-log.md` - 探索日志

### Phase 2: 构建 (Build)

**目标**：开发数据管道、训练模型、构建产品原型

**参与者**：Data Agent + ML Agent + Dev Agent + UX Agent

**流程**：
```
1. 数据管道构建
   Data Agent: 开发数据预处理管道
   
2. 模型训练实验
   ML Agent: 设计实验，训练模型
   
3. 应用开发
   Dev Agent: 实现功能，集成模型
   
4. 用户体验设计
   UX Agent: 设计交互，构建原型
```

**输出**：
- `data-pipeline/` - 数据管道代码
- `model-experiments/` - 模型实验记录
- `feature-code/` - 功能代码
- `ux-design.md` - UX 设计文档

### Phase 3: 验证 (Validate)

**目标**：评估解决方案在实际环境中的表现和价值

**参与者**：Product Owner + ML Agent + Dev Agent + Domain Expert

**流程**：
```
1. 模型性能评估
   ML Agent: 评估模型性能，分析偏差
   
2. 用户测试
   UX Agent: 可用性测试，收集反馈
   
3. 业务价值验证
   Product Owner: A/B 测试，转化率分析
   
4. 合规检查（如需要）
   Ethics Agent: 公平性、隐私检查
```

**输出**：
- `performance-report.md` - 性能报告
- `user-feedback.md` - 用户反馈
- `value-validation.md` - 价值验证结果
- `compliance-check.md` - 合规检查报告

### Phase 4: 学习 (Learn)

**目标**：整合验证结果，决定下一步行动

**参与者**：Orchestrator + All Agents

**流程**：
```
1. 回顾会议
   All: "什么有效？什么无效？我们学到了什么？"
   
2. 假设状态更新
   Orchestrator: 更新假设清单（验证/部分验证/证伪）
   
3. 方向决策
   Product Owner: 继续、转向、停止？
   
4. 经验捕获
   Orchestrator: 记录经验教训，更新知识库
```

**输出**：
- `learning-log.md` - 学习日志
- `hypotheses-updated.md` - 更新的假设清单
- `lessons-learned.md` - 经验教训
- `next-actions.md` - 下一步行动

---

## 项目类型与策略选择

### 复杂度评估矩阵

| 维度 | 低 | 中 | 高 |
|------|----|----|-----|
| 问题清晰度 | 明确 | 需细化 | 模糊 |
| 数据可用性 | 充足 | 有限 | 稀缺 |
| 技术新颖性 | 成熟 | 部分 | 前沿 |
| 业务风险 | 低 | 中 | 高 |

### 四种项目类型

#### 类型 1: 探索型
- **特征**：问题模糊、数据稀缺、技术新颖
- **策略**：极短迭代（1-2周）、学习优先、快速失败
- **团队**：精简（Product Owner + Data Agent + ML Agent）
- **关键指标**：学习速度、假设验证数量

#### 类型 2: 优化型
- **特征**：问题明确、数据充足、技术成熟
- **策略**：标准敏捷（2-3周）、交付优先、可预测
- **团队**：标准（+ Dev Agent + DevOps）
- **关键指标**：功能交付速度、性能提升

#### 类型 3: 转型型
- **特征**：中等清晰度、中等风险、高业务影响
- **策略**：混合模式、价值门控、平衡探索与交付
- **团队**：完整（所有核心角色）
- **关键指标**：阶段性价值实现、用户采纳率

#### 类型 4: 合规敏感型
- **特征**：高风险、需合规审查
- **策略**：中等迭代（3-4周）、严格检查、可解释性优先
- **团队**：完整 + Ethics Agent
- **关键指标**：合规符合度、公平性指标

---

## 假设驱动开发 (HDD)

### 假设模板

```markdown
## 假设 H-001

### 假设陈述
如果我们 [采取什么行动/实现什么功能]，
那么 [预期什么结果/价值]。

### 验证方法
[如何验证这个假设？A/B测试？用户访谈？]

### 成功标准
- [量化指标达到X]
- [统计显著性 p < 0.05]

### 失败标准
- [量化指标低于Y]
- [用户反馈负面]

### 最小验证实验
[用最小成本验证假设的方法]

### 状态
- [ ] 待验证
- [ ] 验证中
- [ ] 已验证
- [ ] 部分验证
- [ ] 已证伪
```

### 假设优先级矩阵

```
        高影响
           │
    ┌──────┼──────┐
    │ 重大赌注  │ 快速取胜 │
    │ (Big Bet) │(Quick Win)│
────┼──────────┼──────────┼───►
    │ 探索研究  │ 低优先级 │
    │(Research) │(Low Pri) │
    └──────┼──────┘
           │
        低影响
         高不确定性 ◄────► 低不确定性
```

---

## 文件结构

```
project/
├── runs/
│   └── <run_id>/
│       ├── hypotheses.md          # 假设清单
│       ├── success-criteria.md    # 成功标准
│       ├── context.json           # 上下文配置
│       ├── exploration/           # 探索阶段
│       │   ├── data-assessment.md
│       │   └── exploration-log.md
│       ├── build/                 # 构建阶段
│       │   ├── data-pipeline/
│       │   ├── model-experiments/
│       │   └── feature-code/
│       ├── validate/              # 验证阶段
│       │   ├── performance-report.md
│       │   ├── user-feedback.md
│       │   └── value-validation.md
│       ├── learn/                 # 学习阶段
│       │   ├── learning-log.md
│       │   ├── lessons-learned.md
│       │   └── next-actions.md
│       └── artifacts/             # 最终交付物
└── .claude/
    └── skills/
        ├── agent-orchestrator/
        ├── agent-product-owner/
        ├── agent-data/
        ├── agent-ml/
        ├── agent-dev/
        ├── agent-ux/
        └── agent-devops/
```

---

## 快速开始

### 1. 启动新项目

向 Orchestrator 发送：
```
新项目：我想做一个 [具体需求]
```

### 2. Orchestrator 评估

```
正在评估项目复杂度...

维度评估：
- 问题清晰度：中
- 数据可用性：低
- 技术新颖性：中
- 业务风险：中

项目类型：转型型

推荐团队配置：
- Product Owner Agent
- Data Agent
- ML Agent
- Dev Agent
- DevOps Agent

推荐策略：混合迭代模式，阶段价值门控
```

### 3. 开始探索

```
Orchestrator: 让我们开始探索阶段。

[Product Owner Agent] 问题是什么？
你: [回答]

[Data Agent] 有什么数据？
你: [回答]

[Orchestrator] 基于以上，我形成以下假设：
- H-001: 如果我们...那么...
- H-002: 如果我们...那么...

假设清单已保存到 hypotheses.md
```

### 4. 迭代循环

```
探索 → 构建 → 验证 → 学习 → (下一轮)
```

---

## 与 Ship-Faster 的集成

| Agent | 使用的 Skills |
|-------|--------------|
| Orchestrator | workflow-project-intake, workflow-brainstorm |
| Product Owner | workflow-feature-shipper (plan-only) |
| Data Agent | supabase, tool-systematic-debugging |
| ML Agent | review-quality |
| Dev Agent | workflow-feature-shipper, review-quality |
| UX Agent | tool-design-style-selector, tool-ui-ux-pro-max |
| DevOps Agent | cloudflare, deploy-* |

---

## License

MIT
