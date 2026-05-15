#!/usr/bin/env bash
set -euo pipefail
id=${1:?id}
input=$(cat)

require_terms() {
  for term in "$@"; do
    printf '%s\n' "$input" | grep -qiE "$term" || { echo "missing $term"; exit 1; }
  done
}

scenario_file="evals/scenarios/${id}.json"
coverage_required="false"
if [ -f "$scenario_file" ]; then
  coverage_required=$(python3 -c "import json; print(str(json.load(open('$scenario_file')).get('coverageBaseline', False)).lower())")
fi

if [ "$coverage_required" != "true" ]; then
  echo "coverage baseline not required for this scenario"
  exit 0
fi

case "$id" in
  coverage-baseline)
    require_terms 五态覆盖 正常态 等待态 空态 错误态 边界态 边界品类 显示边界 数据边界 状态边界 权限边界 兼容边界 异步 等待态 不可逆 确认机制 '错误.*下一步'
    ;;
  *)
    require_terms 五态覆盖 正常态 等待态 空态 错误态 边界态 边界品类 显示边界 数据边界 状态边界 权限边界 兼容边界 异步等待态 不可逆确认机制 错误响应可执行下一步
    ;;
esac
