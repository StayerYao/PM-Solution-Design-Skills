# PM Solution Design Skills

`pm-solution-design` 是面向产品方案和 PRD 写作的 Skill。2.x 以流程引擎为核心：`SKILL.md` 负责触发和硬约束，`references/flow.md` 负责状态机和门禁流转。

## 适用场景

- 写 PRD、需求文档、产品方案。
- 澄清模糊需求。
- 规划新功能。
- 做方案取舍、灵感碰撞、场景泛化和业务规则设计。

不用于纯代码实现、bug 修复、接口设计、数据库设计或具体排期估算。

## 2.x 架构

```text
skills/pm-solution-design/
  SKILL.md
  prd-template.md
  example-prd.md
  references/
    flow.md
    loading.md
    gates.md
    output-scope.md
    prd-contract.md
    brief-contract.md
    quality-review.md
    practices/
      ideation.md
      refinement.md
      trade-offs.md
      scenario-generalization.md
      business-rule-design.md
      state-coverage.md
      execution-baseline.md
```

核心分工：

- `SKILL.md`：启动器和守门员。
- `flow.md`：流程引擎和状态机。
- `gates.md`：G1-G4 的准入、准出和失败处理。
- `output-scope.md`：询问用户 PRD 包含或不包含哪些内容。
- `prd-contract.md` / `brief-contract.md`：输出内容契约。
- `practices/*`：灵感、精致打磨、取舍、场景泛化、业务规则设计、五态覆盖、执行基线。

## 核心流程

```text
需求输入
→ S0 Intake
→ S1 Complexity Check
→ S2 Mode Selection
→ G1 Problem Definition
→ S3 Output Scope Selection
→ S4 Ideation
→ S5 Refinement
→ G2 Solution Validity
→ G3 Execution Contract
→ G4 Review Readiness
→ S6 Output Assembly
→ S7 Quality Review
→ S8 Final Report
```

四个门禁：

- G1 问题定义：为什么做，边界是什么，成功如何判断。
- G2 方案成立：核心流程、状态、五态覆盖、边界品类、业务规则设计、异常、权限、场景泛化是否成立。
- G3 执行契约：用户故事、界面交互、异步等待态、不可逆确认机制、错误下一步、验收标准、测试场景是否可执行。
- G4 交付可评审：输出是否能被评审、交接、继续推进。

## 支持平台

| 平台 | 配置文件 | 上下文入口 |
|---|---|---|
| Claude Code | `.claude-plugin/plugin.json` | `CLAUDE.md` |
| Codex | `.codex-plugin/plugin.json` | `AGENTS.md` |
| Cursor | `.cursor-plugin/plugin.json` | `.cursorrules` |
| Gemini CLI | `gemini-extension.json` | `GEMINI.md` |

## 本地评估

```bash
npm test
```

或直接运行：

```bash
./evals/test-eval-suite.sh
```

真实模型评估：

```bash
./evals/run-eval.sh
./evals/run-eval.sh complex-rules
```

## License

MIT
