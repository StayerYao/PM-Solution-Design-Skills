#!/usr/bin/env bash
# PM Solution Design — Eval Runner
# Runs evaluation scenarios against the skill and checks output compliance.
#
# Usage:
#   ./evals/run-eval.sh                    # Run all scenarios
#   ./evals/run-eval.sh B1                 # Run specific scenario
#   ./evals/run-eval.sh --baseline         # Run baseline scenarios only
#   ./evals/run-eval.sh --pressure         # Run pressure scenarios only
#
# Prerequisites:
#   - claude CLI installed and authenticated
#   - pm-solution-design skill installed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCENARIOS_DIR="$SCRIPT_DIR/scenarios"
CHECKERS_DIR="$SCRIPT_DIR/checkers"
RESULTS_DIR="$SCRIPT_DIR/results"

mkdir -p "$RESULTS_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

scenario_slug() {
  basename "$1" .json
}

lowercase() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

run_agent_or_fixture() {
  local scenario_file="$1"
  local scenario_prompt="$2"
  local scenario_type="$3"
  local output_file="$4"

  if [ -n "${PM_EVAL_FIXTURE_DIR:-}" ]; then
    local slug
    slug=$(scenario_slug "$scenario_file")
    local fixture_file="$PM_EVAL_FIXTURE_DIR/$slug.txt"
    if [ ! -f "$fixture_file" ]; then
      echo "  Missing fixture: $fixture_file"
      return 1
    fi
    cp "$fixture_file" "$output_file"
    return 0
  fi

  if [ "$scenario_type" = "baseline" ]; then
    echo "$scenario_prompt" | claude --print 2>/dev/null > "$output_file"
  else
    printf '/pm-solution-design\n%s\n' "$scenario_prompt" | claude --print 2>/dev/null > "$output_file"
  fi
}

run_scenario() {
  local scenario_file="$1"
  local scenario_id
  scenario_id=$(python3 -c "import json; print(json.load(open('$scenario_file'))['id'])")
  local scenario_name
  scenario_name=$(python3 -c "import json; print(json.load(open('$scenario_file'))['name'])")
  local scenario_prompt
  scenario_prompt=$(python3 -c "import json; print(json.load(open('$scenario_file'))['prompt'])")
  local scenario_type
  scenario_type=$(python3 -c "import json; print(json.load(open('$scenario_file'))['type'])")

  echo ""
  echo -e "${YELLOW}═══════════════════════════════════════════════════${NC}"
  echo -e "${YELLOW}  Scenario: $scenario_id — $scenario_name ($scenario_type)${NC}"
  echo -e "${YELLOW}═══════════════════════════════════════════════════${NC}"
  echo "  Prompt: $scenario_prompt"
  echo ""

  # For baseline scenarios: run WITHOUT the skill loaded.
  # For pressure/variant scenarios: run WITH the skill loaded.
  # Fixture mode lets checkers run deterministically without invoking claude.
  local output_file="$RESULTS_DIR/${scenario_id}_output.txt"

  if [ "$scenario_type" = "baseline" ]; then
    echo "  Mode: baseline (no skill)"
  else
    echo "  Mode: with skill"
  fi

  if [ -n "${PM_EVAL_FIXTURE_DIR:-}" ]; then
    echo "  Loading fixture from $PM_EVAL_FIXTURE_DIR"
  else
    echo "  Running claude..."
  fi

  if ! run_agent_or_fixture "$scenario_file" "$scenario_prompt" "$scenario_type" "$output_file"; then
    echo -e "  ${RED}⚠ Failed to produce output${NC}"
    echo "FAIL" > "$RESULTS_DIR/${scenario_id}_result.txt"
    return 1
  fi

  if [ ! -s "$output_file" ]; then
    echo -e "  ${RED}⚠ No output received${NC}"
    echo "FAIL" > "$RESULTS_DIR/${scenario_id}_result.txt"
    return 1
  fi

  echo "  Output saved to $output_file"
  echo ""
  echo "  Running checkers..."

  local total_pass=0
  local total_fail=0

  # Run applicable checkers
  for checker in "$CHECKERS_DIR"/*.sh; do
    checker_name=$(basename "$checker" .sh)
    echo "  → $checker_name"
    if bash "$checker" "$scenario_id" < "$output_file" >> "$RESULTS_DIR/${scenario_id}_checks.txt" 2>&1; then
      total_pass=$((total_pass+1))
    else
      total_fail=$((total_fail+1))
    fi
  done

  echo ""
  if [ "$total_fail" -eq 0 ]; then
    echo -e "  ${GREEN}✅ PASSED ($total_pass checks)${NC}"
    echo "PASS" > "$RESULTS_DIR/${scenario_id}_result.txt"
    return 0
  else
    echo -e "  ${RED}❌ FAILED ($total_pass passed, $total_fail failed)${NC}"
    echo "FAIL" > "$RESULTS_DIR/${scenario_id}_result.txt"
    return 1
  fi
}

# Parse arguments
FILTER=""
SPECIFIC=""

while [ $# -gt 0 ]; do
  case "$1" in
    --baseline)  FILTER="baseline" ;;
    --pressure)  FILTER="pressure" ;;
    --variant)   FILTER="variant" ;;
    *)           SPECIFIC="$1" ;;
  esac
  shift
done

# Find scenarios
SCENARIOS=()

if [ -n "$SPECIFIC" ]; then
  wanted=$(lowercase "$SPECIFIC")
  for f in "$SCENARIOS_DIR"/*.json; do
    slug=$(scenario_slug "$f")
    case "$slug" in
      "$wanted"|"$wanted"-*) SCENARIOS+=("$f") ;;
    esac
  done
else
  for f in "$SCENARIOS_DIR"/*.json; do
    if [ -n "$FILTER" ]; then
      type=$(python3 -c "import json; print(json.load(open('$f'))['type'])")
      if [ "$type" = "$FILTER" ]; then
        SCENARIOS+=("$f")
      fi
    else
      SCENARIOS+=("$f")
    fi
  done
fi

if [ ${#SCENARIOS[@]} -eq 0 ]; then
  echo "No scenarios found matching criteria."
  exit 1
fi

echo -e "${YELLOW}PM Solution Design — Eval Runner${NC}"
echo "Found ${#SCENARIOS[@]} scenario(s) to run"
echo "Results will be saved to $RESULTS_DIR/"
echo ""

# Clean previous results
rm -f "$RESULTS_DIR"/*.txt

PASSED=0
FAILED=0

for scenario in "${SCENARIOS[@]}"; do
  if run_scenario "$scenario"; then
    PASSED=$((PASSED+1))
  else
    FAILED=$((FAILED+1))
  fi
done

echo ""
echo -e "${YELLOW}═══════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}  Summary${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════${NC}"
echo "  Total:  $((PASSED+FAILED))"
echo -e "  ${GREEN}Passed: $PASSED${NC}"
echo -e "  ${RED}Failed: $FAILED${NC}"
echo ""

if [ "$FAILED" -gt 0 ]; then
  echo "Review failed scenarios in $RESULTS_DIR/"
  exit 1
else
  echo "All scenarios passed!"
  exit 0
fi
