#!/usr/bin/env node
import { readFileSync, writeFileSync } from 'node:fs';

const nextVersion = process.argv[2];

if (!nextVersion || !/^\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?$/.test(nextVersion)) {
  console.error('用法：node scripts/bump-version.mjs <semver>');
  process.exit(1);
}

const files = [
  'package.json',
  '.claude-plugin/plugin.json',
  '.codex-plugin/plugin.json',
  '.cursor-plugin/plugin.json',
  'gemini-extension.json',
];

for (const path of files) {
  const data = JSON.parse(readFileSync(path, 'utf8'));
  data.version = nextVersion;
  if (path === 'package.json' || path.endsWith('plugin.json') || path === 'gemini-extension.json') {
    data.license = 'MIT';
  }
  writeFileSync(path, `${JSON.stringify(data, null, 2)}\n`);
}

console.log(`已更新版本号：${nextVersion}`);
console.log(`请补充 CHANGELOG.md 的 ## v${nextVersion} 条目，并在发布提交上打 tag v${nextVersion}`);
