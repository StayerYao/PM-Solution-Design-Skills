#!/usr/bin/env bash
# Check: No subjective words in acceptance criteria
# Usage: echo "$AGENT_OUTPUT" | ./no-subjective-words.sh

set -euo pipefail

INPUT="$(cat)"

SUBJECTIVE_WORDS="体验好|快速|方便|高效|流畅|友好|优雅|简洁|直观|易用|seamless|intuitive|fast|easy|friendly|smooth|elegant"

FAIL=0

ACCEPTANCE_BLOCK=$(printf '%s\n' "$INPUT" | awk '
  BEGIN { in_block=0 }
  {
    lower_line=tolower($0)
    is_acceptance = ($0 ~ /验收标准/ || lower_line ~ /acceptance criteria/)
  }
  /^#{1,6}[[:space:]]/ {
    if (in_block && !is_acceptance) in_block=0
  }
  is_acceptance { in_block=1 }
  in_block { print }
')

if printf '%s\n' "$ACCEPTANCE_BLOCK" | grep -qiE "$SUBJECTIVE_WORDS"; then
  echo "❌ Subjective words found in acceptance criteria"
  printf '%s\n' "$ACCEPTANCE_BLOCK" | grep -niE "$SUBJECTIVE_WORDS" || true
  FAIL=1
else
  echo "✅ No subjective words in acceptance criteria"
fi

exit $FAIL
