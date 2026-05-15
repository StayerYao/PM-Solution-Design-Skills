#!/usr/bin/env bash
set -euo pipefail
input=$(cat)
if printf '%s\n' "$input" | grep -qiE 'pm-solution-design|使用.*skill|Skill.*pm'; then
  echo "skill trigger ok"
else
  echo "missing skill declaration"
  exit 1
fi
if printf '%s\n' "$input" | grep -qiE '复杂度|简单|中等|复杂'; then
  echo "complexity ok"
else
  echo "missing complexity"
  exit 1
fi
