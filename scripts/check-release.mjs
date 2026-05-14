#!/usr/bin/env node
import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';

const requireTag = process.argv.includes('--require-tag');

const jsonFiles = [
  'package.json',
  '.claude-plugin/plugin.json',
  '.codex-plugin/plugin.json',
  '.cursor-plugin/plugin.json',
  'gemini-extension.json',
];

const errors = [];

function readJson(path) {
  try {
    return JSON.parse(readFileSync(path, 'utf8'));
  } catch (error) {
    errors.push(`${path} 不是合法 JSON：${error.message}`);
    return null;
  }
}

function git(args) {
  return execFileSync('git', args, { encoding: 'utf8' }).trim();
}

if (!existsSync('LICENSE')) {
  errors.push('缺少 LICENSE 文件');
}

const packageJson = readJson('package.json');
const version = packageJson?.version;

if (!version) {
  errors.push('package.json 缺少 version');
}

if (packageJson?.license !== 'MIT') {
  errors.push(`package.json license=${packageJson?.license ?? '<missing>'}，应为 MIT`);
}

for (const path of jsonFiles.slice(1)) {
  const data = readJson(path);
  if (!data) continue;

  if (data.version !== version) {
    errors.push(`${path} version=${data.version ?? '<missing>'}，应为 ${version}`);
  }

  if (data.license !== 'MIT') {
    errors.push(`${path} license=${data.license ?? '<missing>'}，应为 MIT`);
  }
}

if (version) {
  const changelog = existsSync('CHANGELOG.md') ? readFileSync('CHANGELOG.md', 'utf8') : '';
  if (!changelog.includes(`## v${version}`)) {
    errors.push(`CHANGELOG.md 缺少 ## v${version}`);
  }

  if (requireTag) {
    const status = git(['status', '--porcelain']);
    if (status) {
      errors.push('工作区存在未提交改动，不能做发布检查');
    }

    const tags = git(['tag', '--points-at', 'HEAD']).split('\n').filter(Boolean);
    if (!tags.includes(`v${version}`)) {
      errors.push(`当前提交缺少 tag v${version}`);
    }
  }
}

if (errors.length > 0) {
  console.error('发布检查失败：');
  for (const error of errors) {
    console.error(`- ${error}`);
  }
  process.exit(1);
}

console.log(`发布检查通过：v${version}`);
