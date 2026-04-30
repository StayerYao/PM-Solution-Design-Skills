# 更新日志

## v1.2.1（2026-04-30）

### 修复

- **SKILL.md description**：triggers 关键词重新合并回 description 字段，确保各平台文本匹配和 skill 自动触发正常工作
- **GEMINI.md / AGENTS.md**：恢复 `@./skills/pm-solution-design/SKILL.md` 引用，修复 Gemini CLI 和 Codex 平台上 skill 内容无法自动注入上下文的问题

---

## v1.2.0（2026-04-30）

### 新增

- **CLAUDE.md**：Claude Code 用户上下文入口，包含项目介绍、Skill 加载方式、参考文档索引
- **.cursorrules**：Cursor 用户上下文入口，含平台专属加载指引
- **references/detail.md 按门禁拆分**为 9 个模块化文件：
  - `detail-overview.md` — 角色设定与门禁总览
  - `gate-1-problem-clarity.md` — 门禁一详细检查点
  - `ideation.md` — 灵感碰撞完整流程与示例
  - `trade-off-model.md` — 取舍声明四元组模型
  - `gate-2-solution-closure.md` — 门禁二详细检查点
  - `gate-3-executable-contract.md` — 门禁三详细检查点
  - `gate-4-cost-assessment.md` — 门禁四详细检查点
  - `output-format.md` — 输出格式规范与 Callout 约定
  - `anti-patterns.md` — 常见合理化借口表
- **evals/ 可运行评估脚本**：
  - `run-eval.sh` 主入口，支持按类型筛选（--baseline/--pressure/--variant）
  - 10 个评估场景 JSON（基线 B1-B4、压力 P1-P4、变体 V1-V2）
  - 4 个输出合规检查器（门禁合规、主观词、API 越界、具体人天）

### 变更

- **SKILL.md frontmatter**：分离 `description` 与 `triggers`，description 精简为 "Use when..." 格式，触发关键词移至 `triggers` 字段
- **标题统一**：SKILL.md 和参考文件标题从 "PM Gated PRD" 统一为 "PM Solution Design"，与项目名对齐
- **GEMINI.md / AGENTS.md**：从一行 `@` 引用扩展为完整的平台入口文件，含项目介绍、平台专属加载方式、参考文档索引
- **plugin.json description**：四个平台的 description 统一为 "Use when..." 英文格式，聚焦触发场景
- **README.md**：更新项目结构说明，反映新的文件布局和平台入口

### 移除

- `references/detail.md` 单一大文件（已拆分为 9 个模块化文件）

---

## v1.1.0（2026-04-24）

### 新增

- 取舍声明模型（四元组：冲突·选择·放弃·何时重新审视）
- 灵感碰撞阶段（PM 输入灵感 → 三重检验 → 纳入/搁置/淘汰）
- 基线与压力评估场景（evaluations.md）

### 变更

- "赤线" 重命名为 "约束"，语义更准确

---

## v1.0.0（2026-04-23）

### 新增

- 初始版本：四道门禁 PRD 输出流程
- 多平台支持：Claude Code、Cursor、Codex、Gemini CLI
- Marketplace 发布支持
