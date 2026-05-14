#!/usr/bin/env bash
# Check: No technical data model definitions in PRD output
# Usage: echo "$AGENT_OUTPUT" | ./no-data-model-design.sh

set -euo pipefail

INPUT="$(cat)"

FAIL=0

MODEL_TERM_PATTERN='数据库表|表结构|字段类型|主键|外键|索引|customers|segment_rules|segment_results|created_at|updated_at|customer_id|result_id|rule_json|bigint|varchar|datetime|timestamp|boolean|bool|json[[:space:]]*\|'
NEGATIVE_CONTEXT='不(应|该|会|要|能)?(写|包含|涉及|定义|输出|列出)|拒绝|超出|边界|不属于|不写|排除|避免|禁止|只定义业务语义'

SUSPECT_LINES=$(echo "$INPUT" | grep -iE "$MODEL_TERM_PATTERN" || true)

if [ -z "$SUSPECT_LINES" ]; then
  echo "✅ No technical data model in PRD output"
else
  VIOLATION_LINES=$(echo "$SUSPECT_LINES" | grep -viE "$NEGATIVE_CONTEXT" || true)

  if [ -n "$VIOLATION_LINES" ]; then
    echo "❌ Technical data model found in PRD output"
    echo "$VIOLATION_LINES" | grep -niE "$MODEL_TERM_PATTERN" || true
    FAIL=1
  else
    echo "✅ Data model keywords mentioned only in boundary context"
  fi
fi

exit $FAIL
