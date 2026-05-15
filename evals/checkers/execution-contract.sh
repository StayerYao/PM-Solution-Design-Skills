#!/usr/bin/env bash
set -euo pipefail
input=$(cat)
printf '%s\n' "$input" | grep -qiE '验收标准|关键测试场景|P0|P1' || { echo "missing execution contract"; exit 1; }
if printf '%s\n' "$input" | awk '/验收标准/{flag=1} /^#/{if(flag&&$0 !~ /验收标准/) flag=0} flag{print}' | grep -qiE '体验好|快速|方便|高效|流畅|友好'; then
  echo "subjective acceptance"
  exit 1
fi
