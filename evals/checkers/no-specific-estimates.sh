#!/usr/bin/env bash
# Check: No specific person-day estimates in cost assessment
# Usage: echo "$AGENT_OUTPUT" | ./no-specific-estimates.sh

set -euo pipefail

INPUT="$(cat)"

FAIL=0

ESTIMATE_PATTERN='(前端|后端|测试|设计|开发|联调|合计|预估|总计)[：:，,]?[[:space:]]*[0-9]+([.][0-9]+)?[[:space:]]*(人天|天)|[0-9]+([.][0-9]+)?[[:space:]]*(人天|天)[，,]?[[:space:]]*(合计|总计|共)'

if printf '%s\n' "$INPUT" | grep -qiE "$ESTIMATE_PATTERN"; then
  echo "❌ Specific person-day estimates found in cost assessment"
  printf '%s\n' "$INPUT" | grep -niE "$ESTIMATE_PATTERN" || true
  FAIL=1
else
  echo "✅ No specific person-day estimates in cost assessment"
fi

exit $FAIL
