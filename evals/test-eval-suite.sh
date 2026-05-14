#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_DIR"

for f in evals/run-eval.sh evals/checkers/*.sh evals/test-eval-suite.sh; do
  bash -n "$f"
done

python3 -m json.tool .codex-plugin/plugin.json >/dev/null
python3 -m json.tool .claude-plugin/plugin.json >/dev/null
python3 -m json.tool .cursor-plugin/plugin.json >/dev/null
python3 -m json.tool gemini-extension.json >/dev/null
for f in evals/scenarios/*.json; do
  python3 -m json.tool "$f" >/dev/null
done

node scripts/check-release.mjs

PM_EVAL_FIXTURE_DIR=evals/fixtures/pass ./evals/run-eval.sh P4
PM_EVAL_FIXTURE_DIR=evals/fixtures/pass ./evals/run-eval.sh V1
PM_EVAL_FIXTURE_DIR=evals/fixtures/pass ./evals/run-eval.sh V2
PM_EVAL_FIXTURE_DIR=evals/fixtures/pass ./evals/run-eval.sh V3
PM_EVAL_FIXTURE_DIR=evals/fixtures/pass ./evals/run-eval.sh B2

if PM_EVAL_FIXTURE_DIR=evals/fixtures/fail ./evals/run-eval.sh P4; then
  echo "Expected failing P4 fixture to fail"
  exit 1
fi

if PM_EVAL_FIXTURE_DIR=evals/fixtures/fail ./evals/run-eval.sh V1; then
  echo "Expected failing V1 fixture to fail"
  exit 1
fi

if PM_EVAL_FIXTURE_DIR=evals/fixtures/fail ./evals/run-eval.sh V2; then
  echo "Expected failing V2 fixture to fail"
  exit 1
fi

if PM_EVAL_FIXTURE_DIR=evals/fixtures/fail ./evals/run-eval.sh V3; then
  echo "Expected failing V3 fixture to fail"
  exit 1
fi

if PM_EVAL_FIXTURE_DIR=evals/fixtures/fail ./evals/run-eval.sh B2; then
  echo "Expected failing B2 fixture to fail"
  exit 1
fi

echo "Eval suite regression checks passed"
