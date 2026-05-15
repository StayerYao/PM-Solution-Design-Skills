@./skills/pm-solution-design/SKILL.md

## 平台说明

Codex 会自动识别本仓库的 `.codex-plugin/plugin.json` 和 `AGENTS.md`。当你的需求涉及 PRD、需求文档、产品方案、写PRD、出方案、需求模糊、方案不清、功能规划、新功能设计、灵感碰撞、取舍时，加载 `pm-solution-design` Skill。

中等/复杂需求时，按需 Read 对应的 `skills/pm-solution-design/references/` 下的拆分文件获取详细检查点。

## Skill 执行要求

当使用 `pm-solution-design` 或其他 skill 产出 PRD、需求文档、产品方案时，必须遵守以下执行要求：

1. **声明 skill**：回复中明确声明使用了哪些 skill。
2. **复杂度初判**：在进入正文前判定需求复杂度：简单 / 中等 / 复杂。
3. **Reference 加载**：中等/复杂需求必须先读取 `skills/pm-solution-design/references/detail-overview.md`，再按当前门禁读取对应 reference。
4. **门禁优先**：未完成必须停顿的门禁时，不得声明 PRD/方案已完成。
5. **草稿降级**：如果用户明确要求“不要问问题，直接输出”“跳过门禁”“先给草稿”，可以输出草稿，但必须显式声明“未完成完整 skill 门禁，不得视为最终 PRD”。
6. **禁止默认假设绕门禁**：不得用“合理默认假设”“先补齐假设”替代必须由用户确认的问题定义、边界或成功指标。
7. **结果报告**：final 回复必须简要报告门禁状态、是否有未确认项，以及是否执行了输出前检查。
