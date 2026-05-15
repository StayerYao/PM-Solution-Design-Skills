# Loading

本文件定义 reference 加载规则。目标是让简单需求轻量执行，让中等和复杂需求按状态加载必要材料。

## 基础加载

使用 `pm-solution-design` 时必须加载：

- `SKILL.md`
- `references/flow.md`

## 按状态加载

| 状态 | 简单 | 中等 | 复杂 |
|---|---|---|---|
| S3 Output Scope Selection | `output-scope.md` | `output-scope.md` | `output-scope.md` |
| S4 Ideation | 可跳过 | `practices/ideation.md` | `practices/ideation.md` |
| S5 Refinement | 可跳过 | `practices/refinement.md` | `practices/refinement.md` |
| G1-G4 | `gates.md` 摘要 | `gates.md` | `gates.md` |
| G2 五态覆盖 | 可选 | `practices/state-coverage.md` | `practices/state-coverage.md` |
| G2 业务规则 | 可选 | `practices/business-rule-design.md` | `practices/business-rule-design.md` |
| G2 场景泛化 | 可选 | `practices/scenario-generalization.md` | `practices/scenario-generalization.md` |
| G3 执行基线 | 可选 | `practices/execution-baseline.md` | `practices/execution-baseline.md` |
| 取舍 | 可选 | `practices/trade-offs.md` | `practices/trade-offs.md` |
| 输出组装 | `brief-contract.md` 或 `prd-contract.md` | `prd-contract.md` / `brief-contract.md` | `prd-contract.md` / `brief-contract.md` |
| 品质审查 | `quality-review.md` 摘要 | `quality-review.md` | `quality-review.md` |

## 加载纪律

- 不一次性加载全部 reference。
- 进入状态前加载该状态所需文件。
- 未加载对应 reference，不得声称已按完整流程完成该状态。
- 如果用户要求快速草稿，可以少加载实践层 reference，但必须记录未完成门禁和未确认项。
