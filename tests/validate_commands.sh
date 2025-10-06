#!/usr/bin/env bash

# validate_commands.sh - Test command definition consistency
# Part of Flow Framework test suite (V1.2)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS_COUNT=0
FAIL_COUNT=0

# Test assertion functions
assert_true() {
    local condition="$1"
    local description="$2"

    if eval "$condition"; then
        echo -e "${GREEN}✓${NC} $description"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}✗${NC} $description"
        ((FAIL_COUNT++))
        return 1
    fi
}

# Test suite
echo "======================================"
echo "Flow Framework - Command Validation Tests"
echo "======================================"
echo ""

COMMANDS_FILE="$PROJECT_ROOT/framework/SLASH_COMMANDS.md"

# Test 1: All 28 commands are defined
echo "Test Suite: Command Definitions"
echo "-------------------------------"

EXPECTED_COMMANDS=(
    "flow-blueprint"
    "flow-migrate"
    "flow-plan-update"
    "flow-phase-add"
    "flow-phase-start"
    "flow-phase-complete"
    "flow-task-add"
    "flow-task-start"
    "flow-task-complete"
    "flow-iteration-add"
    "flow-brainstorm-start"
    "flow-brainstorm-subject"
    "flow-brainstorm-review"
    "flow-brainstorm-complete"
    "flow-implement-start"
    "flow-implement-complete"
    "flow-status"
    "flow-summarize"
    "flow-next-subject"
    "flow-next-iteration"
    "flow-next"
    "flow-rollback"
    "flow-verify-plan"
    "flow-compact"
    "flow-plan-split"
    "flow-backlog-add"
    "flow-backlog-view"
    "flow-backlog-pull"
)

for cmd in "${EXPECTED_COMMANDS[@]}"; do
    assert_true "grep -q '^## /$cmd' '$COMMANDS_FILE'" "Command /$cmd is defined"
done
echo ""

# Test 2: Category A commands require Quick Reference
echo "Test Suite: Category A Commands (Framework Reading Required)"
echo "------------------------------------------------------------"

CATEGORY_A_COMMANDS=(
    "flow-blueprint"
    "flow-migrate"
    "flow-plan-update"
    "flow-task-add"
    "flow-iteration-add"
    "flow-brainstorm-start"
    "flow-brainstorm-subject"
    "flow-brainstorm-review"
    "flow-brainstorm-complete"
    "flow-next-subject"
    "flow-verify-plan"
)

for cmd in "${CATEGORY_A_COMMANDS[@]}"; do
    # Extract command section and check for Quick Reference requirement
    # Get line number of command, then check next 200 lines for the requirement
    CMD_LINE=$(grep -n "^## /$cmd$" "$COMMANDS_FILE" | head -1 | cut -d: -f1)
    NEXT_CMD_LINE=$(grep -n "^## /flow-" "$COMMANDS_FILE" | awk -F: -v line=$CMD_LINE '$1 > line {print $1; exit}')

    # If no next command, use end of file
    if [[ -z "$NEXT_CMD_LINE" ]]; then
        NEXT_CMD_LINE=$(wc -l < "$COMMANDS_FILE")
    fi

    # Extract section and check for Quick Reference
    if sed -n "${CMD_LINE},${NEXT_CMD_LINE}p" "$COMMANDS_FILE" | grep -q "Read once per session.*DEVELOPMENT_FRAMEWORK.md lines 1-544"; then
        echo -e "${GREEN}✓${NC} /$cmd requires Quick Reference (lines 1-544)"
        ((PASS_COUNT++))
    else
        echo -e "${RED}✗${NC} /$cmd missing Quick Reference requirement"
        ((FAIL_COUNT++))
    fi
done
echo ""

# Test 3: Category B commands should NOT require framework reading
echo "Test Suite: Category B Commands (No Framework Reading)"
echo "------------------------------------------------------"

CATEGORY_B_COMMANDS=(
    "flow-status"
    "flow-phase-start"
    "flow-phase-complete"
    "flow-task-start"
    "flow-task-complete"
    "flow-implement-start"
    "flow-implement-complete"
    "flow-summarize"
    "flow-next"
    "flow-next-iteration"
    "flow-rollback"
    "flow-compact"
    "flow-plan-split"
    "flow-backlog-add"
    "flow-backlog-view"
    "flow-backlog-pull"
)

for cmd in "${CATEGORY_B_COMMANDS[@]}"; do
    # Extract command section and check for Category B marker
    CMD_LINE=$(grep -n "^## /$cmd$" "$COMMANDS_FILE" | head -1 | cut -d: -f1)
    NEXT_CMD_LINE=$(grep -n "^## /flow-" "$COMMANDS_FILE" | awk -F: -v line=$CMD_LINE '$1 > line {print $1; exit}')

    if [[ -z "$NEXT_CMD_LINE" ]]; then
        NEXT_CMD_LINE=$(wc -l < "$COMMANDS_FILE")
    fi

    if sed -n "${CMD_LINE},${NEXT_CMD_LINE}p" "$COMMANDS_FILE" | grep -q "🟢 NO FRAMEWORK READING REQUIRED"; then
        echo -e "${GREEN}✓${NC} /$cmd correctly marked as Category B"
        ((PASS_COUNT++))
    else
        echo -e "${YELLOW}⚠${NC} /$cmd might be missing Category B marker"
        # Don't fail, just warn
    fi
done
echo ""

# Test 4: Scope Boundary Rule references
echo "Test Suite: Scope Boundary Rule References"
echo "------------------------------------------"

SCOPE_BOUNDARY_COMMANDS=(
    "flow-brainstorm-start"
    "flow-brainstorm-subject"
    "flow-next-subject"
    "flow-implement-start"
)

for cmd in "${SCOPE_BOUNDARY_COMMANDS[@]}"; do
    # Extract command section and check for Scope Boundary Rule reference
    CMD_LINE=$(grep -n "^## /$cmd$" "$COMMANDS_FILE" | head -1 | cut -d: -f1)
    NEXT_CMD_LINE=$(grep -n "^## /flow-" "$COMMANDS_FILE" | awk -F: -v line=$CMD_LINE '$1 > line {print $1; exit}')

    if [[ -z "$NEXT_CMD_LINE" ]]; then
        NEXT_CMD_LINE=$(wc -l < "$COMMANDS_FILE")
    fi

    if sed -n "${CMD_LINE},${NEXT_CMD_LINE}p" "$COMMANDS_FILE" | grep -q "SCOPE BOUNDARY RULE"; then
        echo -e "${GREEN}✓${NC} /$cmd includes Scope Boundary Rule reference"
        ((PASS_COUNT++))
    else
        echo -e "${RED}✗${NC} /$cmd missing Scope Boundary Rule reference"
        ((FAIL_COUNT++))
    fi
done
echo ""

# Test 5: Command structure consistency
echo "Test Suite: Command Structure"
echo "-----------------------------"

# Each command should have Purpose section
COMMANDS_WITH_PURPOSE=$(grep -c "^\*\*Purpose\*\*:" "$COMMANDS_FILE" || true)
assert_true "[[ $COMMANDS_WITH_PURPOSE -ge 28 ]]" "All commands have Purpose section ($COMMANDS_WITH_PURPOSE/28)"

# Each command should have Instructions section
COMMANDS_WITH_INSTRUCTIONS=$(grep -c "^\*\*Instructions\*\*:" "$COMMANDS_FILE" || true)
assert_true "[[ $COMMANDS_WITH_INSTRUCTIONS -ge 28 ]]" "All commands have Instructions section ($COMMANDS_WITH_INSTRUCTIONS/28)"

echo ""

# Test 6: No outdated line references
echo "Test Suite: Line Number References"
echo "----------------------------------"

OLD_QUICK_REF=$(grep -c "lines 1-353" "$COMMANDS_FILE" || true)
assert_true "[[ $OLD_QUICK_REF -eq 0 ]]" "No outdated Quick Reference line numbers (1-353)"

NEW_QUICK_REF=$(grep -c "lines 1-544" "$COMMANDS_FILE" || true)
assert_true "[[ $NEW_QUICK_REF -ge 10 ]]" "Updated Quick Reference line numbers present (1-544, found: $NEW_QUICK_REF)"

echo ""

# Summary
echo "======================================"
echo "Test Results Summary"
echo "======================================"
echo -e "Passed: ${GREEN}$PASS_COUNT${NC}"
echo -e "Failed: ${RED}$FAIL_COUNT${NC}"
echo ""

if [[ $FAIL_COUNT -eq 0 ]]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi
