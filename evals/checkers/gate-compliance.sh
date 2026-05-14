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
  P4)
    # Must reject API implementation details as outside the PRD/product boundary.
    if echo "$INPUT" | grep -qiE '接口.*(超出|边界)|API.*(超出|边界)|不写接口|不应写接口|研发边界|技术实现'; then
      echo "✅ Gate compliance: agent rejected API design overreach"
      PASS=$((PASS+1))
    else
      echo "❌ Gate violation: agent did not reject API design overreach"
      FAIL=$((FAIL+1))
    fi
    ;;
  V1)
    # Minimal requirement should stay simple and avoid heavyweight modeling.
    if echo "$INPUT" | grep -qiE '复杂度[:： ]*简单|简单复杂度'; then
      echo "✅ Complexity compliance: minimal requirement classified as simple"
      PASS=$((PASS+1))
    else
      echo "❌ Complexity violation: minimal requirement not classified as simple"
      FAIL=$((FAIL+1))
    fi
    OVER_MODEL_LINES=$(printf '%s\n' "$INPUT" | grep -iE '规则引擎|状态机|IFTTT|编排' | grep -viE '不(新增|引入|设计|需要|做)|无需|避免|排除' || true)
    if [ -n "$OVER_MODEL_LINES" ]; then
      echo "❌ Scope violation: minimal requirement over-modeled"
      printf '%s\n' "$OVER_MODEL_LINES"
      FAIL=$((FAIL+1))
    else
      echo "✅ Scope compliance: minimal requirement not over-modeled"
      PASS=$((PASS+1))
    fi
    ;;
  V2)
    # Pricing-rule requirement should be treated as complex and abstracted.
    if echo "$INPUT" | grep -qiE '复杂度[:： ]*复杂|复杂复杂度'; then
      echo "✅ Complexity compliance: pricing requirement classified as complex"
      PASS=$((PASS+1))
    else
      echo "❌ Complexity violation: pricing requirement not classified as complex"
      FAIL=$((FAIL+1))
    fi
    if echo "$INPUT" | grep -qiE '规则引擎|配置化|规则编排' && echo "$INPUT" | grep -qiE '硬编码|枚举|穷举'; then
      echo "✅ Abstraction compliance: agent identified rule engine need and hardcoding risk"
      PASS=$((PASS+1))
    else
      echo "❌ Abstraction violation: missing rule engine abstraction or hardcoding risk"
      FAIL=$((FAIL+1))
    fi
    ;;
esac

echo ""
echo "Results: $PASS passed, $FAIL failed"
exit $FAIL
