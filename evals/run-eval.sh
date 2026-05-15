#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCENARIOS_DIR="$SCRIPT_DIR/scenarios"
CHECKERS_DIR="$SCRIPT_DIR/checkers"
RESULTS_DIR="$SCRIPT_DIR/results"
mkdir -p "$RESULTS_DIR"

scenario_slug() { basename "$1" .json; }
lowercase() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }
json_get() { python3 -c "import json; print(json.load(open('$1'))['$2'])"; }

run_agent_or_fixture() {
  local scenario_file="$1"
  local scenario_prompt="$2"
  local output_file="$3"

  if [ -n "${PM_EVAL_FIXTURE_DIR:-}" ]; then
    local slug
    slug=$(scenario_slug "$scenario_file")
    local fixture_file="$PM_EVAL_FIXTURE_DIR/$slug.txt"
    if [ ! -f "$fixture_file" ]; then
      echo "Missing fixture: $fixture_file"
      return 1
    fi
    cp "$fixture_file" "$output_file"
    return 0
  fi

  printf '/pm-solution-design\n%s\n' "$scenario_prompt" | claude --print 2>/dev/null > "$output_file"
}

run_scenario() {
  local scenario_file="$1"
  local id name prompt output_file checks_file
  id=$(json_get "$scenario_file" id)
  name=$(json_get "$scenario_file" name)
  prompt=$(json_get "$scenario_file" prompt)
  output_file="$RESULTS_DIR/${id}_output.txt"
  checks_file="$RESULTS_DIR/${id}_checks.txt"
  : > "$checks_file"

  echo "Scenario: $id - $name"
  if ! run_agent_or_fixture "$scenario_file" "$prompt" "$output_file"; then
    echo "FAIL: no output"
    return 1
  fi

  local pass=0 fail=0 checker
  for checker in "$CHECKERS_DIR"/*.sh; do
    if bash "$checker" "$id" < "$output_file" >> "$checks_file" 2>&1; then
      pass=$((pass+1))
    else
      fail=$((fail+1))
    fi
  done

  if [ "$fail" -eq 0 ]; then
    echo "PASS ($pass checks)"
    return 0
  fi
  echo "FAIL ($fail failed, $pass passed)"
  return 1
}

FILTER=""
if [ $# -gt 0 ]; then FILTER=$(lowercase "$1"); fi
SCENARIOS=()
for f in "$SCENARIOS_DIR"/*.json; do
  slug=$(scenario_slug "$f")
  if [ -z "$FILTER" ] || [ "$slug" = "$FILTER" ] || [[ "$slug" == "$FILTER"-* ]]; then
    SCENARIOS+=("$f")
  fi
done

if [ ${#SCENARIOS[@]} -eq 0 ]; then
  echo "No scenarios found"
  exit 1
fi

rm -f "$RESULTS_DIR"/*.txt
passed=0
failed=0
for scenario in "${SCENARIOS[@]}"; do
  if run_scenario "$scenario"; then
    passed=$((passed+1))
  else
    failed=$((failed+1))
  fi
done

echo "Total: $((passed+failed)), Passed: $passed, Failed: $failed"
[ "$failed" -eq 0 ]
