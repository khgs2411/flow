#!/usr/bin/env bash

# validate_build.sh - Test build integrity and output validation
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
assert_file_exists() {
    local file="$1"
    local description="$2"

    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} $description"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}✗${NC} $description"
        echo "  Expected file: $file"
        ((FAIL_COUNT++))
        return 1
    fi
}

assert_contains() {
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
        echo "  In file: $file"
        ((FAIL_COUNT++))
        return 1
    fi
}

assert_line_count() {
    local file="$1"
    local min_lines="$2"
    local description="$3"

    local actual_lines=$(wc -l < "$file" | tr -d ' ')

    if [[ $actual_lines -ge $min_lines ]]; then
        echo -e "${GREEN}✓${NC} $description (actual: $actual_lines lines)"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}✗${NC} $description"
        echo "  Expected >= $min_lines lines, got: $actual_lines"
        ((FAIL_COUNT++))
        return 1
    fi
}

assert_command_count() {
    local file="$1"
    local expected_count="$2"
    local description="$3"

    local actual_count=$(grep -c "^## /flow-" "$file" || true)

    if [[ $actual_count -eq $expected_count ]]; then
        echo -e "${GREEN}✓${NC} $description (found: $actual_count commands)"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}✗${NC} $description"
        echo "  Expected: $expected_count commands, got: $actual_count"
        ((FAIL_COUNT++))
        return 1
    fi
}

# Test suite
echo "======================================"
echo "Flow Framework - Build Validation Tests"
echo "======================================"
echo ""

# Test 1: Source files exist
echo "Test Suite: Source Files"
echo "------------------------"
assert_file_exists "$PROJECT_ROOT/framework/DEVELOPMENT_FRAMEWORK.md" "DEVELOPMENT_FRAMEWORK.md exists"
assert_file_exists "$PROJECT_ROOT/framework/EXAMPLE_PLAN.md" "EXAMPLE_PLAN.md exists"
assert_file_exists "$PROJECT_ROOT/framework/SLASH_COMMANDS.md" "SLASH_COMMANDS.md exists"
assert_file_exists "$PROJECT_ROOT/build-standalone.sh" "build-standalone.sh exists"
echo ""

# Test 2: flow.sh exists and has correct structure
echo "Test Suite: Generated flow.sh"
echo "-----------------------------"
assert_file_exists "$PROJECT_ROOT/flow.sh" "flow.sh exists"
assert_line_count "$PROJECT_ROOT/flow.sh" 9000 "flow.sh has >= 9000 lines"
assert_contains "$PROJECT_ROOT/flow.sh" "COMMANDS_DATA_EOF" "flow.sh contains COMMANDS_DATA_EOF heredoc marker"
assert_contains "$PROJECT_ROOT/flow.sh" "FRAMEWORK_DATA_EOF" "flow.sh contains FRAMEWORK_DATA_EOF heredoc marker"
assert_contains "$PROJECT_ROOT/flow.sh" "EXAMPLE_DATA_EOF" "flow.sh contains EXAMPLE_DATA_EOF heredoc marker"
echo ""

# Test 3: Command definitions
echo "Test Suite: Command Definitions"
echo "-------------------------------"
assert_command_count "$PROJECT_ROOT/framework/SLASH_COMMANDS.md" 28 "SLASH_COMMANDS.md has 28 commands"
echo ""

# Test 4: Heredoc extraction (verify content embeds correctly)
echo "Test Suite: Heredoc Extraction"
echo "------------------------------"

# Simpler approach: check that flow.sh contains the actual content (means heredoc worked)
if grep -q "^## /flow-blueprint" "$PROJECT_ROOT/flow.sh"; then
    echo -e "${GREEN}✓${NC} Commands heredoc contains command definitions"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗${NC} Commands heredoc missing command definitions"
    ((FAIL_COUNT++))
fi

if grep -q "# Quick Reference for AI" "$PROJECT_ROOT/flow.sh"; then
    echo -e "${GREEN}✓${NC} Framework heredoc contains framework content"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗${NC} Framework heredoc missing framework content"
    ((FAIL_COUNT++))
fi

echo ""

# Test 5: Framework line number references
echo "Test Suite: Framework References"
echo "--------------------------------"

# Check for updated Quick Reference line numbers (should be 1-544, not 1-353)
OLD_REFERENCE_COUNT=$(grep -c "lines 1-353" "$PROJECT_ROOT/framework/SLASH_COMMANDS.md" || true)
NEW_REFERENCE_COUNT=$(grep -c "lines 1-544" "$PROJECT_ROOT/framework/SLASH_COMMANDS.md" || true)

if [[ $OLD_REFERENCE_COUNT -eq 0 ]]; then
    echo -e "${GREEN}✓${NC} No outdated Quick Reference line numbers (1-353) found"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗${NC} Found $OLD_REFERENCE_COUNT outdated Quick Reference line numbers"
    ((FAIL_COUNT++))
fi

if [[ $NEW_REFERENCE_COUNT -ge 10 ]]; then
    echo -e "${GREEN}✓${NC} Found $NEW_REFERENCE_COUNT updated Quick Reference line numbers (1-544)"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠${NC} Only found $NEW_REFERENCE_COUNT updated Quick Reference line numbers (expected >= 10)"
    ((FAIL_COUNT++))
fi
echo ""

# Test 6: Build script validation output
echo "Test Suite: Build Script Validation"
echo "-----------------------------------"

# Run build script and capture output
BUILD_OUTPUT=$(cd "$PROJECT_ROOT" && ./build-standalone.sh 2>&1)

if echo "$BUILD_OUTPUT" | grep -q "All 28 commands have valid framework references"; then
    echo -e "${GREEN}✓${NC} Build script validates all 28 commands"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗${NC} Build script validation check missing or failed"
    ((FAIL_COUNT++))
fi

if echo "$BUILD_OUTPUT" | grep -q "✨ The standalone script is ready to distribute"; then
    echo -e "${GREEN}✓${NC} Build script completes successfully"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗${NC} Build script did not complete successfully"
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
