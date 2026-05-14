#!/usr/bin/env bash
# Check: No API design or interface definitions in PRD output
# Usage: echo "$AGENT_OUTPUT" | ./no-api-design.sh

set -euo pipefail

INPUT="$(cat)"

FAIL=0

HTTP_ENDPOINT_PATTERN='(GET|POST|PUT|DELETE|PATCH)[[:space:]]+/api/'
API_TERM_PATTERN='requestBody|request[[:space:]]+body|响应体|请求体|接口路径|endpoint'
NEGATIVE_CONTEXT='不(应|该|会|要|能)?(写|包含|涉及|写入|列出)|拒绝|超出|边界|不属于|不写|排除|避免'

# Concrete HTTP endpoints are implementation details even when shown as an anti-example.
if printf '%s\n' "$INPUT" | grep -qiE "$HTTP_ENDPOINT_PATTERN"; then
  echo "❌ API endpoint design found in PRD output"
  printf '%s\n' "$INPUT" | grep -niE "$HTTP_ENDPOINT_PATTERN" || true
  FAIL=1
else
  SUSPECT_LINES=$(printf '%s\n' "$INPUT" | grep -iE "$API_TERM_PATTERN" || true)

  if [ -z "$SUSPECT_LINES" ]; then
    echo "✅ No API design in PRD output"
  else
    VIOLATION_LINES=$(printf '%s\n' "$SUSPECT_LINES" | grep -viE "$NEGATIVE_CONTEXT" || true)

    if [ -n "$VIOLATION_LINES" ]; then
      echo "❌ API design found in PRD output"
      printf '%s\n' "$VIOLATION_LINES" | grep -niE "$API_TERM_PATTERN" || true
      FAIL=1
    else
      echo "✅ API keywords mentioned only in rejection context"
    fi
  fi
fi

exit $FAIL
