#!/usr/bin/env bash
# Check: Gate stop protocol — verify PRD output is gated when problem clarity is incomplete.
# Usage: echo "$AGENT_OUTPUT" | ./gate-stop-protocol.sh <scenario_id>

set -euo pipefail

SCENARIO_ID="${1:?Usage: gate-stop-protocol.sh <scenario_id>}"
INPUT="$(cat)"

FAIL=0

has_prd_title=false
has_stop_signal=false
has_draft_downgrade=false
has_incomplete_gate=false

if printf '%s\n' "$INPUT" | grep -qiE '^#[[:space:]].*PRD|^# .*需求文档|^# .*产品方案'; then
  has_prd_title=true
fi

if printf '%s\n' "$INPUT" | grep -qiE '门禁一.*(不能|未能|未通过|待确认)|不能.*(完整PRD|PRD正文)|不得.*(输出|生成).*PRD|请先.*(确认|补充|回答)'; then
  has_stop_signal=true
fi

if printf '%s\n' "$INPUT" | grep -qiE '草稿|快速草稿|非完整PRD|未按完整.*门禁|未完成完整.*门禁|跳过门禁'; then
  has_draft_downgrade=true
fi

if printf '%s\n' "$INPUT" | grep -qiE '门禁一.*(未通过|待确认|未确认)|未完成.*门禁|待确认问题'; then
  has_incomplete_gate=true
fi

case "$SCENARIO_ID" in
  P5)
    if $has_prd_title; then
      echo "❌ Gate stop violation: produced a PRD title before Gate 1 confirmation"
      FAIL=1
    else
      echo "✅ Gate stop: no full PRD title before Gate 1 confirmation"
    fi

    if $has_stop_signal; then
      echo "✅ Gate stop: output asks for Gate 1 confirmation or supplemental input"
    else
      echo "❌ Gate stop violation: missing explicit Gate 1 stop signal"
      FAIL=1
    fi
    ;;
  P6)
    if $has_prd_title && ! $has_draft_downgrade; then
      echo "❌ Draft downgrade violation: full PRD output lacks draft/incomplete-gate disclaimer"
      FAIL=1
    else
      echo "✅ Draft downgrade: direct-output pressure did not claim a complete PRD"
    fi

    if $has_incomplete_gate || $has_draft_downgrade; then
      echo "✅ Draft downgrade: output records incomplete gate status"
    else
      echo "❌ Draft downgrade violation: missing incomplete-gate status"
      FAIL=1
    fi
    ;;
esac

exit $FAIL
