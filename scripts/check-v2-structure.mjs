#!/usr/bin/env node
import { existsSync, readFileSync } from 'node:fs';

const errors = [];
const read = (path) => readFileSync(path, 'utf8');
const mustExist = (path) => {
  if (!existsSync(path)) errors.push(`缺少文件：${path}`);
};

const requiredReferences = [
  'skills/pm-solution-design/references/flow.md',
  'skills/pm-solution-design/references/loading.md',
  'skills/pm-solution-design/references/gates.md',
  'skills/pm-solution-design/references/output-scope.md',
  'skills/pm-solution-design/references/prd-contract.md',
  'skills/pm-solution-design/references/brief-contract.md',
  'skills/pm-solution-design/references/quality-review.md',
  'skills/pm-solution-design/references/practices/ideation.md',
  'skills/pm-solution-design/references/practices/refinement.md',
  'skills/pm-solution-design/references/practices/trade-offs.md',
  'skills/pm-solution-design/references/practices/scenario-generalization.md',
  'skills/pm-solution-design/references/practices/business-rule-design.md',
  'skills/pm-solution-design/references/practices/state-coverage.md',
  'skills/pm-solution-design/references/practices/execution-baseline.md',
];

for (const path of requiredReferences) mustExist(path);

const loading = existsSync('skills/pm-solution-design/references/loading.md')
  ? read('skills/pm-solution-design/references/loading.md')
  : '';

for (const path of requiredReferences.filter((path) => path.includes('/references/practices/'))) {
  const name = path.split('/').pop();
  if (!loading.includes(name)) errors.push(`loading.md 未引用 practice：${name}`);
}

for (const path of requiredReferences.filter((path) => !path.includes('/references/practices/') && !path.endsWith('/loading.md'))) {
  const name = path.split('/').pop();
  if (!loading.includes(name) && name !== 'flow.md') errors.push(`loading.md 未引用 reference：${name}`);
}

const platformFiles = ['CLAUDE.md', 'AGENTS.md', '.cursorrules', 'GEMINI.md'];
const requiredProtocolLines = [
  '声明使用 `pm-solution-design`。',
  '判定复杂度：简单 / 中等 / 复杂。',
  '判定输出模式：完整 PRD / 方案 Brief / 快速草稿。',
  '必须读取 `skills/pm-solution-design/references/flow.md`，并按状态机执行。',
  '按 `skills/pm-solution-design/references/loading.md` 加载当前状态需要的 reference。',
  '未完成必须停顿的门禁时，不得声明最终 PRD 完成。',
  '用户要求直接输出时，只能降级为快速草稿，并声明未完成完整门禁。',
  '不得输出 API、数据模型、伪代码或具体人天。',
  'final 必须报告输出模式、G1-G4 门禁状态、未确认项和输出前检查结果。',
];

for (const file of platformFiles) {
  mustExist(file);
  if (!existsSync(file)) continue;
  const text = read(file);
  for (const line of requiredProtocolLines) {
    if (!text.includes(line)) errors.push(`${file} 缺少执行要求：${line}`);
  }
}

const platformSkillReference = {
  'AGENTS.md': true,
  'GEMINI.md': true,
  'CLAUDE.md': false,
  '.cursorrules': false,
};

for (const [file, shouldHaveReference] of Object.entries(platformSkillReference)) {
  if (!existsSync(file)) continue;
  const hasReference = read(file).includes('@./skills/pm-solution-design/SKILL.md');
  if (shouldHaveReference && !hasReference) errors.push(`${file} 应包含 @./skills/pm-solution-design/SKILL.md 引用`);
  if (!shouldHaveReference && hasReference) errors.push(`${file} 不应包含 @./skills/pm-solution-design/SKILL.md 引用`);
}

const coverageScenarioIds = ['coverage-baseline', 'complex-rules', 'ui-interaction'];
for (const id of coverageScenarioIds) {
  const scenarioPath = `evals/scenarios/${id}.json`;
  if (!existsSync(scenarioPath)) {
    errors.push(`缺少 coverage 场景：${scenarioPath}`);
    continue;
  }
  try {
    const scenario = JSON.parse(read(scenarioPath));
    if (scenario.coverageBaseline !== true) errors.push(`${scenarioPath} 缺少 coverageBaseline=true`);
  } catch (error) {
    errors.push(`${scenarioPath} 不是合法 JSON：${error.message}`);
  }
}

const gateText = existsSync('skills/pm-solution-design/references/gates.md') ? read('skills/pm-solution-design/references/gates.md') : '';
for (const term of ['state-coverage.md', 'business-rule-design.md', 'scenario-generalization.md', 'execution-baseline.md']) {
  if (!gateText.includes(term)) errors.push(`gates.md 未显式引用 ${term}`);
}

const quality = existsSync('skills/pm-solution-design/references/quality-review.md') ? read('skills/pm-solution-design/references/quality-review.md') : '';
for (const term of ['简单', '中等', '复杂', '回退 G2', '回退 G3', '回退 G1']) {
  if (!quality.includes(term)) errors.push(`quality-review.md 缺少 ${term}`);
}

const prd = existsSync('skills/pm-solution-design/references/prd-contract.md') ? read('skills/pm-solution-design/references/prd-contract.md') : '';
for (const term of ['五态覆盖', '执行基线', '异步操作', '不可逆操作', '错误响应']) {
  if (!prd.includes(term)) errors.push(`prd-contract.md 缺少 ${term}`);
}

if (errors.length) {
  console.error('v2 结构检查失败：');
  for (const error of errors) console.error(`- ${error}`);
  process.exit(1);
}

console.log('v2 结构检查通过');
