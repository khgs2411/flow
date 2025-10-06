#!/usr/bin/env bash

# run_all_tests.sh - Test runner for Flow Framework test suite
# Part of Flow Framework test suite (V1.2)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track test results
TOTAL_SUITES=0
PASSED_SUITES=0
FAILED_SUITES=0

echo ""
echo "======================================"
echo "Flow Framework - Test Suite Runner"
echo "======================================"
echo ""

# Function to run a test suite
run_test_suite() {
    local test_script="$1"
    local suite_name="$2"

    echo -e "${BLUE}Running: $suite_name${NC}"
    echo "--------------------------------------"

    ((TOTAL_SUITES++))

    if "$SCRIPT_DIR/$test_script"; then
        echo -e "${GREEN}✓ $suite_name PASSED${NC}"
        ((PASSED_SUITES++))
        echo ""
        return 0
    else
        echo -e "${RED}✗ $suite_name FAILED${NC}"
        ((FAILED_SUITES++))
        echo ""
        return 1
    fi
}

# Run all test suites
echo "Starting test suites..."
echo ""

run_test_suite "validate_build.sh" "Build Validation" || true
run_test_suite "validate_commands.sh" "Command Validation" || true
run_test_suite "validate_plan.sh" "PLAN.md Validation" || true

# Final summary
echo "======================================"
echo "Final Test Results"
echo "======================================"
echo ""
echo "Total Suites:  $TOTAL_SUITES"
echo -e "Passed Suites: ${GREEN}$PASSED_SUITES${NC}"
echo -e "Failed Suites: ${RED}$FAILED_SUITES${NC}"
echo ""

if [[ $FAILED_SUITES -eq 0 ]]; then
    echo -e "${GREEN}✓✓✓ ALL TEST SUITES PASSED! ✓✓✓${NC}"
    echo ""
    echo "Flow Framework V1.2 test suite complete."
    echo "All quality gates passed - ready for release!"
    exit 0
else
    echo -e "${RED}✗✗✗ SOME TEST SUITES FAILED ✗✗✗${NC}"
    echo ""
    echo "Please fix failing tests before release."
    exit 1
fi
