# PM Solution Design Skills

> 把模糊需求推进成可评审、可执行的 PRD / 方案 Brief。

[![version](https://img.shields.io/badge/version-2.0.1-2f6feb)](./CHANGELOG.md)
[![license](https://img.shields.io/badge/license-MIT-green)](./LICENSE)
[![platforms](https://img.shields.io/badge/platforms-Claude%20Code%20%7C%20Codex%20%7C%20Cursor%20%7C%20Gemini%20CLI-6f42c1)](#支持平台)

`pm-solution-design` 是面向产品方案和 PRD 写作的 Skill。它不是一个“模板填空器”，而是一套带流程、门禁和输出契约的方案设计工作流：先把问题讲清楚，再让方案站得住，最后交付能被评审和继续推进的文档。

它不抢工程师的活：接口、数据模型、伪代码、具体人天和纯代码实现不在输出范围内。

## 能力地图

| 能力 | 它解决什么 |
|---|---|
| Flow Engine | 用 S0-S8 状态机推进需求澄清、方案生成和质量复核。 |
| G1-G4 Gates | 守住问题定义、方案成立、执行契约和评审就绪四条质量线。 |
| Output Contracts | 区分完整 PRD、方案 Brief 和快速草稿，避免输出形态混乱。 |
| PM Practices | 覆盖取舍、灵感碰撞、场景泛化、业务规则设计、五态覆盖和执行基线。 |

## 适用场景

- 写 PRD、需求文档、产品方案。
- 澄清一句话需求、老板想法或还没成形的功能点。
- 规划新功能，并明确边界、状态、异常和验收标准。
- 做方案取舍，让 trade-off 可以解释、可以复盘。
- 梳理复杂规则，例如权限、边界品类、异步等待态、不可逆操作和错误下一步。

## 工作流一览

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

四个门禁会决定文档能不能继续向后推进：

- G1 问题定义：为什么做，边界是什么，成功如何判断。
- G2 方案成立：核心流程、状态、五态覆盖、边界品类、业务规则设计、异常、权限、场景泛化是否成立。
- G3 执行契约：用户故事、界面交互、异步等待态、不可逆确认机制、错误下一步、验收标准、测试场景是否可执行。
- G4 交付可评审：输出是否能被评审、交接、继续推进。

## 项目结构

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

核心文件分工：

- `SKILL.md`：启动器和守门员。
- `flow.md`：流程引擎和状态机。
- `gates.md`：G1-G4 的准入、准出和失败处理。
- `output-scope.md`：询问用户 PRD 包含或不包含哪些内容。
- `prd-contract.md` / `brief-contract.md`：输出内容契约。
- `practices/*`：灵感、精致打磨、取舍、场景泛化、业务规则设计、五态覆盖、执行基线。

## 支持平台

| 平台 | 配置文件 | 上下文入口 |
|---|---|---|
| Claude Code | `.claude-plugin/plugin.json` | `CLAUDE.md` |
| Codex | `.codex-plugin/plugin.json` | `AGENTS.md` |
| Cursor | `.cursor-plugin/plugin.json` | `.cursorrules` |
| Gemini CLI | `gemini-extension.json` | `GEMINI.md` |

## 安装方式

Claude Code 推荐通过 Stayer Marketplace 安装；其他平台使用常规 `git clone` 获取仓库后，从本地路径安装或复制入口文件。

### Claude Code

通过 Stayer Marketplace 安装：

```text
/plugin marketplace add StayerYao/marketplace
/plugin install pm-solution-design@stayer-marketplace
```

安装后使用 `/pm-solution-design:pm-solution-design`，或输入 PRD、需求文档、产品方案、功能规划等关键词触发。

本地验证或临时使用时，也可以直接通过 `--plugin-dir` 加载当前仓库：

```bash
claude --plugin-dir "$PWD"
```

通过 `--plugin-dir` 加载后，进入 Claude Code 运行 `/reload-plugins` 让插件生效。

### Codex

获取仓库代码：

```bash
git clone https://github.com/StayerYao/PM-Solution-Design-Skills.git
cd PM-Solution-Design-Skills
```

安装 skill 到本机 Codex skills 目录：

```bash
mkdir -p ~/.codex/skills
cp -R skills/pm-solution-design ~/.codex/skills/
```

如果希望在某个项目中显式启用，把 `AGENTS.md` 复制到目标项目根目录，或将其中的 `pm-solution-design` 触发规则合并进目标项目已有的 `AGENTS.md`。Codex 会根据 `AGENTS.md` 和已安装的 skill，在相关需求场景下加载 `pm-solution-design`。

### Cursor

Cursor 项目级使用时，先获取仓库代码，再将以下内容复制到目标项目根目录：

```bash
git clone https://github.com/StayerYao/PM-Solution-Design-Skills.git
cd PM-Solution-Design-Skills
```

```bash
cp .cursorrules /path/to/your-project/.cursorrules
mkdir -p /path/to/your-project/skills
cp -R skills/pm-solution-design /path/to/your-project/skills/
```

如果你的 Cursor 版本支持插件目录，也可以保留仓库根目录结构，通过 `.cursor-plugin/plugin.json`、`.cursorrules` 和 `skills/` 作为插件入口。

### Gemini CLI

获取仓库代码：

```bash
git clone https://github.com/StayerYao/PM-Solution-Design-Skills.git
cd PM-Solution-Design-Skills
```

从本地路径安装到 Gemini CLI：

```bash
gemini extensions install "$PWD"
```

本地开发时可以改用链接方式，修改后无需反复安装：

```bash
gemini extensions link "$PWD"
```

Gemini CLI 会读取 `gemini-extension.json` 中的 `contextFileName`，并加载 `GEMINI.md` 作为上下文入口。安装或更新扩展后，重启 Gemini CLI 会话让变更生效。

### 手动复制

如果你的客户端不支持插件目录，先获取仓库代码，再把以下文件复制到目标项目根目录：

```bash
git clone https://github.com/StayerYao/PM-Solution-Design-Skills.git
cd PM-Solution-Design-Skills
```

- `skills/pm-solution-design/`
- 对应平台的上下文入口：`CLAUDE.md`、`AGENTS.md`、`.cursorrules` 或 `GEMINI.md`
- 对应平台的配置文件：`.claude-plugin/plugin.json`、`.codex-plugin/plugin.json`、`.cursor-plugin/plugin.json` 或 `gemini-extension.json`

## 升级方式

### Claude Code

```text
/plugin marketplace update stayer-marketplace
/plugin update pm-solution-design@stayer-marketplace
```

更新后重启 Claude Code，或重新进入会话让新版插件生效。

### Codex

```bash
cd PM-Solution-Design-Skills
git pull
cp -R skills/pm-solution-design ~/.codex/skills/
```

如果目标项目使用了本仓库的 `AGENTS.md`，同步复制或手动合并新版 `AGENTS.md`。

### Cursor

如果使用项目级复制安装，重新获取仓库最新代码后覆盖目标项目中的同名文件：

```bash
cp .cursorrules /path/to/your-project/.cursorrules
cp -R skills/pm-solution-design /path/to/your-project/skills/
```

### Gemini CLI

```bash
cd PM-Solution-Design-Skills
git pull
gemini extensions install "$PWD"
```

如果是通过 `gemini extensions link "$PWD"` 链接的本地开发目录，更新本仓库代码后重启 Gemini CLI 会话即可。

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
