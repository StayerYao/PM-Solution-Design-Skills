#!/usr/bin/env bash
set -euo pipefail
input=$(cat)
if printf '%s\n' "$input" | grep -qiE '(GET|POST|PUT|DELETE|PATCH)[[:space:]]+/api/|请求体|响应体|字段类型|表结构|主键|外键|索引|伪代码|[0-9]+[[:space:]]*人天'; then
  echo "technical or estimate boundary violation"
  exit 1
fi
