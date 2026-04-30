#!/usr/bin/env bash
# Check: No specific person-day estimates in cost assessment
# Usage: echo "$AGENT_OUTPUT" | ./no-specific-estimates.sh

set -euo pipefail

INPUT="$(cat)"

FAIL=0

# Match patterns like "合计 38 人天" or "3 天" or "2人天" but NOT "—" or template placeholders
if echo "$INPUT" | grep -qiE '合计\s+\d+\s*(人天|天)|预估\s+\d+\s*(人天|天)|开发.*\d+\s*(人天|天)'; then
  echo "❌ Specific person-day estimates found in cost assessment"
  echo "$INPUT" | grep -niE '合计\s+\d+\s*(人天|天)|预估\s+\d+\s*(人天|天)|开发.*\d+\s*(人天|天)' || true
  FAIL=1
else
  echo "✅ No specific person-day estimates in cost assessment"
fi

exit $FAIL
