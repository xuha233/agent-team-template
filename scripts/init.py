#!/usr/bin/env python3
"""
Agent Team Initializer
初始化 Agent Team 项目结构
"""

import os
import json
import argparse
from datetime import datetime
from pathlib import Path

def create_run_directory(base_path: str, workflow: str = "intake") -> str:
    """创建运行目录"""
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    run_id = f"{timestamp}-{workflow}"
    run_dir = Path(base_path) / "runs" / workflow / "active" / run_id
    
    run_dir.mkdir(parents=True, exist_ok=True)
    (run_dir / "evidence").mkdir(exist_ok=True)
    (run_dir / "logs").mkdir(exist_ok=True)
    
    return str(run_dir), run_id

def init_proposal(run_dir: str, project_name: str, goal: str) -> str:
    """初始化 proposal.md"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    content = f"""# proposal.md

## 项目概述

**项目名称**: {project_name}
**创建时间**: {timestamp}
**状态**: active

## 目标

{goal}

## 核心循环

_待澄清_

## 验收标准

- [ ] _待澄清_
- [ ] _待澄清_
- [ ] _待澄清_

## 非目标

- _待澄清_

## 约束条件

| 约束 | 值 |
|------|-----|
| 时间线 | _待澄清_ |
| 风险偏好 | balanced |
| 技术栈 | _待澄清_ |

## 变更历史

| 日期 | 变更 | 原因 |
|------|------|------|
| {timestamp} | 创建项目 | 初始化 |
"""
    
    path = Path(run_dir) / "proposal.md"
    path.write_text(content, encoding="utf-8")
    return str(path)

def init_context(run_dir: str, run_id: str, workflow: str = "intake") -> str:
    """初始化 context.json"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    context = {
        "run_id": run_id,
        "workflow": workflow,
        "status": "active",
        "created_at": timestamp,
        "updated_at": timestamp,
        "entry_type": "idea",
        "repo_root": "",
        "scope": "full",
        "switches": {
            "need_database": False,
            "need_billing": False,
            "need_auth": False,
            "need_deploy": False,
            "need_seo": False
        },
        "constraints": {
            "timeline": None,
            "risk_preference": "balanced",
            "tech_stack": None
        },
        "workers": {
            "assigned": [],
            "completed": [],
            "failed": []
        },
        "artifacts": {
            "proposal": "proposal.md",
            "tasks": "tasks.md",
            "evidence": "evidence/",
            "logs": "logs/"
        }
    }
    
    path = Path(run_dir) / "context.json"
    path.write_text(json.dumps(context, indent=2, ensure_ascii=False), encoding="utf-8")
    return str(path)

def init_tasks(run_dir: str, run_id: str, workflow: str = "intake") -> str:
    """初始化 tasks.md"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    content = f"""# tasks.md

**Run ID**: {run_id}
**Workflow**: {workflow}
**Status**: active
**Updated**: {timestamp}

---

## Next Actions

1. 澄清核心功能
2. 确定验收标准
3. 确定非目标

---

## Tasks

### Phase 1: Intake
- [ ] Clarify core loop
- [ ] Define acceptance criteria
- [ ] Define non-goals
- [ ] Confirm switches (database, billing, deploy, etc.)
- [ ] Generate proposal.md
- [ ] Generate context.json

### Phase 2: Planning
- [ ] Analyze requirements
- [ ] Break down into tasks
- [ ] Assign workers

### Phase 3: Execution
- [ ] _待规划_

### Phase 4: Review
- [ ] Code review
- [ ] Quality check

### Phase 5: Delivery
- [ ] Merge changes
- [ ] Generate final.md

---

## Approvals

> High-risk actions require explicit confirmation

| ID | Action | Impact | Status |
|----|--------|--------|--------|
| - | - | - | - |

---

## Notes

初始化项目，等待需求澄清。
"""
    
    path = Path(run_dir) / "tasks.md"
    path.write_text(content, encoding="utf-8")
    return str(path)

def main():
    parser = argparse.ArgumentParser(description="Initialize Agent Team project")
    parser.add_argument("--path", default=".", help="Project root path")
    parser.add_argument("--name", required=True, help="Project name")
    parser.add_argument("--goal", default="", help="Project goal")
    parser.add_argument("--workflow", default="intake", help="Initial workflow")
    args = parser.parse_args()
    
    # 创建运行目录
    run_dir, run_id = create_run_directory(args.path, args.workflow)
    print(f"Created run directory: {run_dir}")
    
    # 初始化文件
    proposal_path = init_proposal(run_dir, args.name, args.goal)
    context_path = init_context(run_dir, run_id, args.workflow)
    tasks_path = init_tasks(run_dir, run_id, args.workflow)
    
    print(f"""
Agent Team initialized!

Run ID: {run_id}
Files:
  - proposal.md: {proposal_path}
  - context.json: {context_path}
  - tasks.md: {tasks_path}

Next steps:
1. Send your requirements to OpenClaw
2. OpenClaw will use workflow-project-intake to clarify
3. Workers will be assigned to execute tasks
""")

if __name__ == "__main__":
    main()
