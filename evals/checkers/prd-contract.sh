#!/usr/bin/env bash
set -euo pipefail
id=${1:?id}
input=$(cat)
case "$id" in
  complex-rules|ui-interaction)
    for term in 状态流转 用户故事 界面交互 异常流程 场景泛化 业务规则设计 五态覆盖 正常态 等待态 空态 错误态 边界态 边界品类 显示边界 数据边界 状态边界 权限边界 兼容边界 异步等待态 不可逆确认机制 错误响应可执行下一步; do
      printf '%s\n' "$input" | grep -q "$term" || { echo "missing $term"; exit 1; }
    done
    ;;
  simple-light)
    if printf '%s\n' "$input" | grep -qiE 'Mermaid|完整状态机|规则引擎'; then echo "over-modeled simple request"; exit 1; fi
    ;;
  *)
    printf '%s\n' "$input" | grep -qiE '验收标准|成功指标|做 / 不做|做/不做' || { echo "missing contract basics"; exit 1; }
    ;;
esac
