#!/usr/bin/env bash
# Check: No API design or interface definitions in PRD output
# Usage: echo "$AGENT_OUTPUT" | ./no-api-design.sh

set -euo pipefail

INPUT="$(cat)"

FAIL=0

# Check for API paths, HTTP methods with endpoints, request/response bodies
if echo "$INPUT" | grep -qiE '(GET|POST|PUT|DELETE|PATCH)\s+/api/|requestBody|request body|响应体|请求体|接口路径|endpoint'; then
  echo "❌ API design found in PRD output"
  echo "$INPUT" | grep -niE '(GET|POST|PUT|DELETE|PATCH)\s+/api/|requestBody|request body|响应体|请求体|接口路径|endpoint' || true
  FAIL=1
else
  echo "✅ No API design in PRD output"
fi

exit $FAIL
