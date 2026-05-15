#!/usr/bin/env bash
set -euo pipefail
id=${1:?id}
input=$(cat)
if [ "$id" = "platform-entry" ]; then
  for term in Claude Codex Cursor Gemini; do
    printf '%s\n' "$input" | grep -q "$term" || { echo "missing platform $term"; exit 1; }
  done
  printf '%s\n' "$input" | grep -q 'flow.md' || { echo "missing flow reference"; exit 1; }
else
  echo "not platform scenario"
fi
