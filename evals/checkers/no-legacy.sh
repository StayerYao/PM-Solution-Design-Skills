#!/usr/bin/env bash
set -euo pipefail
input=$(cat)
if printf '%s\n' "$input" | grep -qiE '规则编排|gate-1-problem-clarity|gate-2-solution-closure|detail-overview|1\.x|兼容层'; then
  echo "legacy reference found"
  exit 1
fi
