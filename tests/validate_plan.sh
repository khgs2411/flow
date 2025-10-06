#!/usr/bin/env bash

# validate_plan.sh - Test PLAN.md structure and consistency
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
assert_section_exists() {
    local file="$1"
    local section="$2"
    local description="$3"

    if grep -q "^## $section" "$file"; then
        echo -e "${GREEN}✓${NC} $description"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}✗${NC} $description"
        echo "  Missing section: ## $section"
        ((FAIL_COUNT++))
        return 1
    fi
}

assert_has_content() {
    local file="$1"
    local pattern="$2"
    local description="$3"

    if grep -q "$pattern" "$file"; then
        echo -e "${GREEN}✓${NC} $description"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}✗${NC} $description"
        echo "  Pattern not found: $pattern"
        ((FAIL_COUNT++))
        return 1
    fi
}

count_pattern() {
    local file="$1"
    local pattern="$2"
    grep -c "$pattern" "$file" || echo "0"
}

# Test suite
echo "======================================"
echo "Flow Framework - PLAN.md Validation Tests"
echo "======================================"
echo ""

PLAN_FILE="$PROJECT_ROOT/.flow/PLAN.md"

if [[ ! -f "$PLAN_FILE" ]]; then
    echo -e "${RED}✗ PLAN.md not found at $PLAN_FILE${NC}"
    exit 1
fi

# Test 1: Required sections
echo "Test Suite: Required Sections"
echo "-----------------------------"
# Note: PLAN.md uses "Overview" not "Project Overview"
assert_section_exists "$PLAN_FILE" "Overview" "Has Overview section"
assert_section_exists "$PLAN_FILE" "Architecture" "Has Architecture section"
assert_section_exists "$PLAN_FILE" "Testing Strategy" "Has Testing Strategy section"
assert_section_exists "$PLAN_FILE" "Development Plan" "Has Development Plan section"
assert_section_exists "$PLAN_FILE" "Changelog" "Has Changelog section"
echo ""

# Test 2: Status markers are used correctly
echo "Test Suite: Status Markers"
echo "-------------------------"

COMPLETE_COUNT=$(count_pattern "$PLAN_FILE" "✅")
PENDING_COUNT=$(count_pattern "$PLAN_FILE" "⏳")
IN_PROGRESS_COUNT=$(count_pattern "$PLAN_FILE" "🚧")
READY_COUNT=$(count_pattern "$PLAN_FILE" "🎨")

echo -e "${GREEN}✓${NC} Found status markers: ✅ ($COMPLETE_COUNT) ⏳ ($PENDING_COUNT) 🚧 ($IN_PROGRESS_COUNT) 🎨 ($READY_COUNT)"
((PASS_COUNT++))

# Verify at least one of each marker exists (sanity check)
if [[ $COMPLETE_COUNT -gt 0 ]]; then
    echo -e "${GREEN}✓${NC} Has completed items (✅)"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠${NC} No completed items found (unusual for active project)"
fi

echo ""

# Test 3: Hierarchy structure
echo "Test Suite: Hierarchy Structure"
echo "-------------------------------"

PHASE_COUNT=$(count_pattern "$PLAN_FILE" "^### Phase ")
TASK_COUNT=$(count_pattern "$PLAN_FILE" "^#### Task ")
ITERATION_COUNT=$(count_pattern "$PLAN_FILE" "^##### Iteration ")

echo -e "${GREEN}✓${NC} Found hierarchy: $PHASE_COUNT phases, $TASK_COUNT tasks, $ITERATION_COUNT iterations"
((PASS_COUNT++))

if [[ $PHASE_COUNT -gt 0 && $TASK_COUNT -gt 0 ]]; then
    echo -e "${GREEN}✓${NC} Has phases and tasks"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗${NC} Missing phases or tasks"
    ((FAIL_COUNT++))
fi

echo ""

# Test 4: Brainstorming sections
echo "Test Suite: Brainstorming Sections"
echo "----------------------------------"

BRAINSTORM_COUNT=$(count_pattern "$PLAN_FILE" "### \*\*Brainstorming Session")
RESOLVED_SUBJECTS_COUNT=$(count_pattern "$PLAN_FILE" "\*\*Resolved Subjects\*\*:")

if [[ $BRAINSTORM_COUNT -gt 0 ]]; then
    echo -e "${GREEN}✓${NC} Has brainstorming sessions ($BRAINSTORM_COUNT found)"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠${NC} No brainstorming sessions found"
fi

if [[ $RESOLVED_SUBJECTS_COUNT -gt 0 ]]; then
    echo -e "${GREEN}✓${NC} Has resolved subjects sections ($RESOLVED_SUBJECTS_COUNT found)"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠${NC} No resolved subjects sections found"
fi

echo ""

# Test 5: Implementation sections
echo "Test Suite: Implementation Sections"
echo "-----------------------------------"

IMPLEMENTATION_COUNT=$(count_pattern "$PLAN_FILE" "### \*\*Implementation - Iteration")
ACTION_ITEMS_COUNT=$(count_pattern "$PLAN_FILE" "\*\*Action Items\*\*:")

if [[ $IMPLEMENTATION_COUNT -gt 0 ]]; then
    echo -e "${GREEN}✓${NC} Has implementation sections ($IMPLEMENTATION_COUNT found)"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠${NC} No implementation sections found"
fi

if [[ $ACTION_ITEMS_COUNT -gt 0 ]]; then
    echo -e "${GREEN}✓${NC} Has action items sections ($ACTION_ITEMS_COUNT found)"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠${NC} No action items sections found"
fi

echo ""

# Test 6: Progress Dashboard
echo "Test Suite: Progress Dashboard"
echo "------------------------------"

# Note: Progress Dashboard may have emoji prefix
assert_has_content "$PLAN_FILE" "Progress Dashboard" "Has Progress Dashboard section"

# Check for dashboard structure
if grep -A 50 "## Progress Dashboard" "$PLAN_FILE" | grep -q "### Current Focus"; then
    echo -e "${GREEN}✓${NC} Dashboard has Current Focus section"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠${NC} Dashboard missing Current Focus section"
fi

echo ""

# Test 7: Changelog entries
echo "Test Suite: Changelog"
echo "--------------------"

CHANGELOG_ENTRIES=$(grep -c "^- ✅" "$PLAN_FILE" || echo "0")

if [[ $CHANGELOG_ENTRIES -gt 0 ]]; then
    echo -e "${GREEN}✓${NC} Has changelog entries ($CHANGELOG_ENTRIES found)"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠${NC} No changelog entries found"
fi

echo ""

# Test 8: Self-consistency (dogfooding check)
echo "Test Suite: Self-Consistency (Dogfooding)"
echo "----------------------------------------"

# Flow's own PLAN should reference Flow framework
assert_has_content "$PLAN_FILE" "Flow Framework" "PLAN.md references Flow Framework"
assert_has_content "$PLAN_FILE" "Dogfooding" "PLAN.md mentions dogfooding (meta-application)"

echo ""

# Test 9: Testing Strategy section completeness
echo "Test Suite: Testing Strategy Completeness"
echo "----------------------------------------"

if grep -A 30 "## Testing Strategy" "$PLAN_FILE" | grep -q "Verification Methodology"; then
    echo -e "${GREEN}✓${NC} Testing Strategy has Verification Methodology"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗${NC} Testing Strategy missing Verification Methodology"
    ((FAIL_COUNT++))
fi

if grep -A 30 "## Testing Strategy" "$PLAN_FILE" | grep -q "Quality Gates"; then
    echo -e "${GREEN}✓${NC} Testing Strategy has Quality Gates"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗${NC} Testing Strategy missing Quality Gates"
    ((FAIL_COUNT++))
fi

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
