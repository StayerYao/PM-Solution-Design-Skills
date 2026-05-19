---
name: pm-solution-design
description: Use when starting a product initiative, writing or reviewing a PRD, clarifying ambiguous requirements, planning a feature, comparing product trade-offs, or turning an idea into a product solution. Triggers include PRD, 需求文档, 产品方案, 写PRD, 出方案, 需求模糊, 方案不清, 功能规划, 新功能设计, 灵感碰撞, 取舍.
---

# PM Solution Design

## 用途

使用本 skill 处理产品方案、PRD、需求澄清、功能规划、方案取舍和灵感碰撞。

不用于纯代码实现、bug 修复、接口设计、数据库设计、排期估算或已有完整 PRD 的研发执行计划。

## 启动协议

1. 声明使用 `pm-solution-design`。
2. 判定复杂度：简单 / 中等 / 复杂。
3. 判定输出模式：完整 PRD / 方案 Brief / 快速草稿。
4. 读取 `references/flow.md` 并按状态机执行。
5. 按 `references/loading.md` 加载当前状态需要的 reference。
6. 在 final 中报告输出模式、门禁状态、未确认项和输出前检查结果。

## 核心原则

- 目标先行：先确认为什么做、做什么、不做什么，再讨论怎么做。
- 系统性设计：识别同类场景、共性规则、差异边界，避免一次性堆功能。
- 取舍显式：重大取舍必须说明冲突、选择、放弃、何时重新审视。
- 只定契约：PRD 定义产品行为，不写 API、数据模型、伪代码或具体人天。
- 可客观验收：验收标准必须可判断、可测试、无主观词。
- 品质前置：状态、异常、边界、响应和一致性必须在设计阶段被覆盖。

## 硬约束

- 门禁未通过，不得输出最终 PRD。
- 用户要求“不要问问题，直接输出”时，只能进入快速草稿，并标注未完成门禁。
- 不得用默认假设替代用户确认的问题定义、边界或成功指标。
- 用户可以裁剪输出篇幅，不能裁剪产品判断底线。
- 涉及界面操作时，必须至少定义正常流程、异常流程和用户可见响应。
- 涉及多状态、多角色、多条件或可配置规则时，必须检查状态流转和业务规则设计。
- 不得输出接口路径、请求体、响应体、字段类型、表结构、索引、伪代码或具体人天。

## 输出前报告

交付前必须报告：

- 使用的 skill 和 reference。
- 复杂度和输出模式。
- G1-G4 门禁状态。
- 未确认项。
- 是否完成占位符、术语一致性、主观词、技术越界和优先级检查。

如果不确定当前处于流程哪个状态，必须重新读取 `references/flow.md` 确认，不得凭记忆继续。
