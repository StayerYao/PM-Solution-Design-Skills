#!/usr/bin/env bash
set -euo pipefail
id=${1:?id}
input=$(cat)
case "$id" in
  scope-no-exceptions)
    printf '%s\n' "$input" | grep -qiE '保留.*异常|异常.*保留|用户可见响应|不能.*完全.*删除|至少.*摘要' || { echo "missing exception retention"; exit 1; }
    ;;
  brief-mode)
    printf '%s\n' "$input" | grep -qiE '方案 Brief|Brief' || { echo "missing brief mode"; exit 1; }
    if printf '%s\n' "$input" | grep -qiE '最终 PRD 已完成|完整 PRD 已完成'; then echo "brief claimed final PRD"; exit 1; fi
    ;;
  *)
    printf '%s\n' "$input" | grep -qiE '输出范围|包含|不包含|不可省略|底线' || { echo "missing output scope"; exit 1; }
    ;;
esac
