# Claude Skills

by Stayer

Stayer 的实验工具，用于增强 Claude Code 的能力，干掉你团队的那个产品经理。

## Skills

### pm-solution-design

产品经理 PRD 输出 Skill — 通过四道门禁（问题清晰 → 方案闭环 → 可执行契约 → 代价评估）驱动结构化 PRD 产出。

**适用场景：** 新功能/新产品需结构化 PRD、需求模糊需澄清、复杂业务规则需梳理

**不适用场景：** 小 UI 调整或 bug 修复、纯技术重构、已有清晰 PRD 只需实现计划

**核心原则：**
- 目标先行 — 先"为什么"再"怎么做"
- 引擎思维 — 找共性抽象为可复用原子能力
- 只定契约 — 描述系统行为，不涉及接口/数据模型/伪代码
- 可客观验收 — 禁用主观词，必须可测试可度量

## 安装

将对应 skill 目录复制到 `~/.claude/skills/` 下即可：

```bash
# 克隆仓库
git clone https://github.com/StayerYao/claude-skills.git

# 复制单个 skill
cp -r claude-skills/pm-solution-design ~/.claude/skills/

# 或复制全部
cp -r claude-skills/* ~/.claude/skills/
```

## License

MIT
