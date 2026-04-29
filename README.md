# PM Solution Design Skills

by Stayer

Stayer 的实验工具，用于增强 AI Coding Agent 的能力，干掉你团队的那个产品经理。

## Skills

### pm-solution-design

产品经理 PRD 输出 Skill — 通过四道门禁 + 灵感碰撞 + 取舍声明，驱动需求从模糊到出色。

**适用场景：** 新功能/新产品需结构化 PRD、需求模糊需澄清、复杂业务规则需梳理

**不适用场景：** 小 UI 调整或 bug 修复、纯技术重构、已有清晰 PRD 只需实现计划

**核心原则：**
- 目标先行 — 先"为什么"再"怎么做"
- 引擎思维 — 找共性抽象为可复用原子能力
- 取舍显式 — 每个重大取舍用四元组声明：冲突·选择·放弃·何时重新审视
- 只定契约 — 描述系统行为，不涉及接口/数据模型/伪代码
- 可客观验收 — 禁用主观词，必须可测试可度量

**核心流程：**
```
需求输入 → 复杂度初判
  → 门禁一：问题清晰（硬）
  → 灵感碰撞：PM 输入创造性想法，Skill 作为伙伴打磨或淘汰
  → 门禁二：方案闭环（软）
  → 门禁三：可执行契约（硬）
  → 门禁四：代价评估（软）
  → 输出 PRD
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

在项目根目录克隆此仓库，Cursor 会自动识别 `.cursor-plugin/plugin.json`。

### Codex

在项目根目录克隆此仓库，Codex 会自动识别 `.codex-plugin/plugin.json`。

### Gemini CLI

在项目根目录克隆此仓库，Gemini CLI 会自动识别 `gemini-extension.json` 和 `GEMINI.md`。

## 支持平台

| 平台 | 配置文件 | 状态 |
|------|----------|------|
| Claude Code | `.claude-plugin/plugin.json` | ✅ |
| Cursor | `.cursor-plugin/plugin.json` | ✅ |
| Codex | `.codex-plugin/plugin.json` | ✅ |
| Gemini CLI | `gemini-extension.json` + `GEMINI.md` | ✅ |

## License

MIT
