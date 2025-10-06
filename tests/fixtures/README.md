# Test Fixtures

This directory contains sample PLAN.md files for testing Flow framework behavior.

## Files

### minimal_plan.md
A minimal but valid PLAN.md with all required sections.
- Use for: Testing basic validation
- Status: Valid

### malformed_plan.md
An intentionally malformed PLAN.md with various errors.
- Use for: Testing error handling and validation
- Status: Invalid (multiple issues)

## Usage

These fixtures are used by the test suite in `tests/*.sh` scripts to verify:
- Structure validation
- Error detection
- Edge case handling
- Regression prevention
