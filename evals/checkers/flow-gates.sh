#!/usr/bin/env bash
set -euo pipefail
id=${1:?id}
input=$(cat)
case "$id" in
  fuzzy-g1-stop)
    printf '%s\n' "$input" | grep -qiE 'G1|问题定义|门禁一' || { echo "missing G1"; exit 1; }
    printf '%s\n' "$input" | grep -qiE '停|待确认|需要.*确认|不能.*最终 PRD|不得.*最终 PRD' || { echo "missing stop"; exit 1; }
    if printf '%s\n' "$input" | grep -qiE '^#[[:space:]].*PRD|最终 PRD 已完成|完整 PRD 已完成'; then echo "claimed final PRD"; exit 1; fi
    ;;
  direct-draft)
    printf '%s\n' "$input" | grep -qiE '快速草稿|草稿|未完成.*门禁|不得视为最终 PRD' || { echo "missing draft downgrade"; exit 1; }
    ;;
  *)
    printf '%s\n' "$input" | grep -qiE 'G1|G2|G3|G4|门禁' || { echo "missing gates"; exit 1; }
    ;;
esac
