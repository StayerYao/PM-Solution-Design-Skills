#!/usr/bin/env bash
set -euo pipefail

cd "$(cd "$(dirname "$0")/.." && pwd)"

bash -n evals/run-eval.sh
bash -n evals/test-eval-suite.sh
for f in evals/checkers/*.sh; do bash -n "$f"; done

python3 -m json.tool package.json >/dev/null
python3 -m json.tool .claude-plugin/plugin.json >/dev/null
python3 -m json.tool .codex-plugin/plugin.json >/dev/null
python3 -m json.tool .cursor-plugin/plugin.json >/dev/null
python3 -m json.tool gemini-extension.json >/dev/null
for f in evals/scenarios/*.json; do python3 -m json.tool "$f" >/dev/null; done

node scripts/check-release.mjs
node scripts/check-v2-structure.mjs

for f in evals/scenarios/*.json; do
  slug=$(basename "$f" .json)
  PM_EVAL_FIXTURE_DIR=evals/fixtures/pass ./evals/run-eval.sh "$slug"
done

for f in evals/scenarios/*.json; do
  slug=$(basename "$f" .json)
  if PM_EVAL_FIXTURE_DIR=evals/fixtures/fail ./evals/run-eval.sh "$slug"; then
    echo "Expected failing fixture to fail: $slug"
    exit 1
  fi
done

echo "Eval suite regression checks passed"
