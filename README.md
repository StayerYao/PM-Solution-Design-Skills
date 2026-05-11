# PM Solution Design Skills

by Stayer

结构化 PRD 输出 Skill — 通过四道门禁 + 灵感碰撞 + 精致打磨 + 取舍声明驱动需求从模糊到出色。

## Skills

### pm-solution-design

产品经理 PRD 输出 Skill — 通过四道门禁 + 灵感碰撞 + 精致打磨 + 取舍声明，驱动需求从模糊到出色。

**适用场景：** 新功能/新产品需结构化 PRD、需求模糊需澄清、复杂业务规则需梳理

**不适用场景：** 小 UI 调整或 bug 修复、纯技术重构、已有清晰 PRD 只需实现计划

**核心原则：**
- 目标先行 — 先"为什么"再"怎么做"
- 引擎思维 — 找共性抽象为可复用原子能力
- 取舍显式 — 每个重大取舍用四元组声明：冲突·选择·放弃·何时重新审视
- 只定契约 — 描述系统行为，不涉及接口/数据模型/伪代码
- 可客观验收 — 禁用主观词，必须可测试可度量
- 品质前置 — 设计阶段的品质上限，实现阶段无法突破

**核心流程：**
```
需求输入 → 复杂度初判
  → 门禁一：问题清晰（硬）
  → 灵感碰撞：PM 输入创造性想法，Skill 作为伙伴打磨或淘汰
  → 精致打磨：把设计推到精致
  → 门禁二：方案闭环（软）— 含品质追问清单
  → 门禁三：可执行契约（硬）— 含基线约束
  → 门禁四：代价评估（软）
  → 输出 PRD
  → PRD 品质审查：保真度·一致性·克制·可读性
```

## 安装

### Claude Code

```bash
# 方式一：通过 Marketplace（推荐）
/plugin marketplace add StayerYao/marketplace
/plugin install pm-solution-design@stayer-marketplace

# 方式二：手动复制
git clone https://github.com/StayerYao/PM-Solution-Design-Skills.git
cp -r PM-Solution-Design-Skills/skills/pm-solution-design ~/.claude/skills/
```

### Cursor

在项目根目录克隆此仓库，Cursor 会自动识别 `.cursor-plugin/plugin.json` 和 `.cursorrules`。

### Codex

在项目根目录克隆此仓库，Codex 会自动识别 `.codex-plugin/plugin.json` 和 `AGENTS.md`。

### Gemini CLI

在项目根目录克隆此仓库，Gemini CLI 会自动识别 `gemini-extension.json` 和 `GEMINI.md`。

## 支持平台

| 平台 | 配置文件 | 上下文入口 | 状态 |
|------|----------|-----------|------|
| Claude Code | `.claude-plugin/plugin.json` | `CLAUDE.md` | ✅ |
| Cursor | `.cursor-plugin/plugin.json` | `.cursorrules` | ✅ |
| Codex | `.codex-plugin/plugin.json` | `AGENTS.md` | ✅ |
| Gemini CLI | `gemini-extension.json` + `GEMINI.md` | `GEMINI.md` | ✅ |

## 项目结构

```
├── CLAUDE.md                          # Claude Code 上下文入口
├── GEMINI.md                          # Gemini CLI 上下文入口
├── AGENTS.md                          # Codex 上下文入口
├── .cursorrules                       # Cursor 上下文入口
├── .claude-plugin/plugin.json         # Claude Code 插件配置
├── .cursor-plugin/plugin.json         # Cursor 插件配置
├── .codex-plugin/plugin.json          # Codex 插件配置
├── gemini-extension.json              # Gemini CLI 扩展配置
├── package.json
├── skills/
│   └── pm-solution-design/
│       ├── SKILL.md                   # 主流程与核心原则
│       ├── prd-template.md            # PRD 输出模板
│       ├── example-prd.md             # 示例 PRD
│       └── references/
│           ├── detail-overview.md     # 角色设定与门禁总览
│           ├── gate-1-problem-clarity.md
│           ├── ideation.md            # 灵感碰撞流程
│           ├── refinement.md          # 精致打磨流程
│           ├── trade-off-model.md     # 取舍声明模型
│           ├── gate-2-solution-closure.md  # 门禁二（含品质追问清单）
│           ├── gate-3-executable-contract.md
│           ├── gate-4-cost-assessment.md
│           ├── quality-review.md      # PRD 品质审查
│           ├── output-format.md       # 输出格式规范
│           ├── anti-patterns.md       # 常见合理化借口
│           └── evaluations.md         # 评估场景
└── evals/                             # 可运行的评估脚本
    ├── run-eval.sh
    ├── scenarios/                     # 评估场景定义
    └── checkers/                      # 输出合规检查器
```

## License

MIT
