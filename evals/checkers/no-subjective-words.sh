#!/usr/bin/env bash
# Check: No subjective words in acceptance criteria
# Usage: echo "$AGENT_OUTPUT" | ./no-subjective-words.sh

set -euo pipefail

INPUT="$(cat)"

SUBJECTIVE_WORDS="体验好|快速|方便|高效|流畅|友好|优雅|简洁|直观|易用|seamless|intuitive|fast|easy|friendly|smooth|elegant"

FAIL=0

if echo "$INPUT" | grep -qiP "验收.*($SUBJECTIVE_WORDS)|($SUBJECTIVE_WORDS).*验收|acceptance.*($SUBJECTIVE_WORDS)|($SUBJECTIVE_WORDS).*acceptance"; then
  echo "❌ Subjective words found in acceptance criteria"
  echo "$INPUT" | grep -niP "验收.*($SUBJECTIVE_WORDS)|($SUBJECTIVE_WORDS).*验收|acceptance.*($SUBJECTIVE_WORDS)|($SUBJECTIVE_WORDS).*acceptance" || true
  FAIL=1
else
  echo "✅ No subjective words in acceptance criteria"
fi

exit $FAIL
