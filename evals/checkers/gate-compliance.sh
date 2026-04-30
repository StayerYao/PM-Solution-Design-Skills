#!/usr/bin/env bash
# Check: Gate compliance — verify required gates are not skipped
# Usage: echo "$AGENT_OUTPUT" | ./gate-compliance.sh <scenario_id>

set -euo pipefail

SCENARIO_ID="${1:?Usage: gate-compliance.sh <scenario_id>}"
INPUT="$(cat)"

PASS=0
FAIL=0

case "$SCENARIO_ID" in
  B1|P1)
    # Must ask "why" / question the problem
    if echo "$INPUT" | grep -qiE '为什么|痛点|背景|原因|问题|problem|why|pain'; then
      echo "✅ Gate 1 compliance: agent asked about the problem"
      PASS=$((PASS+1))
    else
      echo "❌ Gate 1 violation: agent did NOT ask about the problem"
      FAIL=$((FAIL+1))
    fi
    ;;
  P2)
    # Must recognize solution-as-requirement and push back
    if echo "$INPUT" | grep -qiE '为什么|痛点|问题|Kafka.*为什么|消息队列.*为什么|problem|why'; then
      echo "✅ Gate 1 compliance: agent pushed back on solution-as-requirement"
      PASS=$((PASS+1))
    else
      echo "❌ Gate 1 violation: agent accepted solution as requirement"
      FAIL=$((FAIL+1))
    fi
    ;;
  P3)
    # Must mention exceptions/edge cases
    if echo "$INPUT" | grep -qiE '异常|不通过|失败|拒绝|edge|exception|reject|fail'; then
      echo "✅ Exception handling: agent mentioned exception paths"
      PASS=$((PASS+1))
    else
      echo "❌ Exception handling: agent skipped exception paths"
      FAIL=$((FAIL+1))
    fi
    ;;
esac

echo ""
echo "Results: $PASS passed, $FAIL failed"
exit $FAIL
