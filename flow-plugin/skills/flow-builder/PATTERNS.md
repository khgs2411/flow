# Implementation Patterns

This document provides detailed patterns for handling pre-implementation tasks and executing action items using Flow framework.

## Table of Contents

1. [Pre-Implementation Tasks Pattern](#pre-implementation-tasks-pattern)
2. [Action Item Execution Best Practices](#action-item-execution-best-practices)
3. [Sequential vs Parallel Execution](#sequential-vs-parallel-execution)
4. [Breaking Down Large Action Items](#breaking-down-large-action-items)
5. [Common Implementation Scenarios](#common-implementation-scenarios)

---

## Pre-Implementation Tasks Pattern

### What Are Pre-Implementation Tasks?

**Pre-implementation tasks** are small, blocking pieces of work (< 30 min) that must be completed BEFORE starting the main iteration implementation.

**Key Characteristics**:
- **Small scope**: Can be completed in < 30 minutes
- **Blocking**: Main iteration cannot start without them
- **Independent**: Can be done separately from main work
- **Discovered during brainstorming**: Identified when resolving Type A subjects

### When to Create Pre-Implementation Tasks

Create pre-implementation tasks when you discover during brainstorming:

**Code Structure Issues**:
- Interface signature doesn't support new pattern
- Enum missing required values
- Type definitions need updates
- File naming doesn't match conventions

**Legacy Code Issues**:
- Old code doesn't support async operations
- Error handling pattern incompatible
- Deprecated API being used
- Missing error states

**Refactoring Needs**:
- Duplicate code needs extraction
- Hard-coded values need configuration
- Tight coupling needs decoupling
- Missing abstraction layer

**Bug Fixes**:
- Race condition in existing code
- Memory leak in utility function
- Off-by-one error in loop
- Missing null checks

### Pre-Implementation Task Structure

#### Template

```markdown
#### Pre-Implementation Tasks

These tasks MUST be completed BEFORE starting main implementation of this iteration.

##### ⏳ Pre-Task 1: [Name]

**Why Blocking**: [Explanation of why this blocks implementation]

**Scope** (< 30 min):
- [Specific change 1]
- [Specific change 2]
- [Specific change 3]

**Files**:
- [File path 1]
- [File path 2]

**Test**: [How to verify it's done]

---

##### ✅ Pre-Task 1: [Name]

**Completed**: [Date]

**Changes Made**:
- [What was actually done]
- [Any deviations from plan]

**Files Modified**:
- [File path 1] ([+/-] X lines)
- [File path 2] ([+/-] Y lines)

**Verification**:
- [How it was tested]
```

### Example 1: Interface Update

**Before (Planning)**:

```markdown
##### ⏳ Pre-Task 1: Update PaymentProcessor interface

**Why Blocking**: Current interface doesn't support async retry logic needed for main implementation

**Scope** (< 30 min):
- Add `retryPolicy?: RetryPolicy` parameter to ProcessPaymentOptions
- Update 3 implementations (StripeProcessor, PayPalProcessor, MockProcessor)
- Update type definitions file

**Files**:
- src/types/payment.ts
- src/processors/StripeProcessor.ts
- src/processors/PayPalProcessor.ts
- src/processors/MockProcessor.ts

**Test**: TypeScript compiles without errors, all processors accept new parameter
```

**After (Completed)**:

```markdown
##### ✅ Pre-Task 1: Update PaymentProcessor interface

**Completed**: 2025-10-30

**Changes Made**:
- Added `retryPolicy?: RetryPolicy` to ProcessPaymentOptions interface
- Updated all 3 processor implementations with optional parameter
- Added JSDoc comments explaining retry policy usage
- Discovered MockProcessor was missing error handling - fixed that too

**Files Modified**:
- src/types/payment.ts (+8 lines)
- src/processors/StripeProcessor.ts (+12 lines)
- src/processors/PayPalProcessor.ts (+10 lines)
- src/processors/MockProcessor.ts (+15 lines, +8 for error handling fix)

**Verification**:
- TypeScript compiles cleanly
- All unit tests passing
- Mock tests verify optional parameter behavior
```

### Example 2: Enum Update

**Before (Planning)**:

```markdown
##### ⏳ Pre-Task 2: Add missing payment states to enum

**Why Blocking**: Retry logic needs "pending_retry" and "failed_permanent" states

**Scope** (< 15 min):
- Add two new states to PaymentStatus enum
- Update 4 switch statements to handle new states
- Update state transition documentation

**Files**:
- src/types/payment.ts
- src/services/PaymentService.ts
- src/services/RetryService.ts
- docs/payment-states.md

**Test**: No switch statement exhaustiveness errors, docs updated
```

**After (Completed)**:

```markdown
##### ✅ Pre-Task 2: Add missing payment states to enum

**Completed**: 2025-10-30

**Changes Made**:
- Added `PENDING_RETRY` and `FAILED_PERMANENT` to PaymentStatus enum
- Updated 4 switch statements with proper handling
- Added state transition diagram to docs
- Also added `CANCELLED_BY_USER` state (discovered during implementation)

**Files Modified**:
- src/types/payment.ts (+3 states)
- src/services/PaymentService.ts (+8 lines)
- src/services/RetryService.ts (+6 lines)
- docs/payment-states.md (+state diagram)

**Verification**:
- TypeScript exhaustiveness checks pass
- All switch statements handle new states
- State diagram reviewed and accurate
```

### Example 3: Legacy Code Refactor

**Before (Planning)**:

```markdown
##### ⏳ Pre-Task 3: Update ErrorHandler to support async operations

**Why Blocking**: Current ErrorHandler is synchronous, retry logic requires async

**Scope** (< 30 min):
- Add `handleAsync()` method to ErrorHandler class
- Implement async error recovery pattern
- Update 3 existing call sites to use async version
- Keep sync version for backwards compatibility

**Files**:
- src/utils/ErrorHandler.ts
- src/services/BillingService.ts
- src/services/PaymentService.ts
- src/services/OrderService.ts

**Test**: All services use async handler, no regressions in error handling
```

**After (Completed)**:

```markdown
##### ✅ Pre-Task 3: Update ErrorHandler to support async operations

**Completed**: 2025-10-30

**Changes Made**:
- Added `handleAsync()` method with Promise-based error recovery
- Implemented exponential backoff helper function
- Updated all 3 call sites to async pattern
- Kept sync `handle()` method for backwards compatibility
- Added comprehensive unit tests for async error handling

**Files Modified**:
- src/utils/ErrorHandler.ts (+65 lines)
- tests/utils/ErrorHandler.test.ts (+42 lines)
- src/services/BillingService.ts (+8 lines)
- src/services/PaymentService.ts (+12 lines)
- src/services/OrderService.ts (+6 lines)

**Verification**:
- All unit tests passing (12 new tests)
- Integration tests with services passing
- No regressions in existing error handling
- Async pattern verified with multiple retry scenarios
```

### Pre-Implementation Task Workflow

```
1. During brainstorming, identify Type A subjects
   ↓
2. /flow-brainstorm-review creates Pre-Implementation Tasks section
   ↓
3. Complete each pre-task sequentially
   ↓
4. Mark each ✅ COMPLETE with date and details
   ↓
5. Verify all pre-tasks done
   ↓
6. ONLY THEN run /flow-implement-start for main iteration
```

---

## Action Item Execution Best Practices

### General Principles

**1. Read Before Execute**
- Read ALL action items before starting
- Understand dependencies between items
- Identify which can be parallel vs sequential

**2. Check Off Immediately**
- Mark item `[x]` as soon as completed
- Don't batch multiple completions
- Provides clear progress tracking

**3. Document as You Go**
- Update Implementation Notes with discoveries
- Note any deviations from plan
- Document workarounds or alternative approaches

**4. Verify Incrementally**
- Test after each action item (if possible)
- Don't wait until end to verify everything
- Catch issues early while context is fresh

### Action Item Checklist Format

**Good Action Items** (specific, measurable):
```markdown
- [ ] Create `src/payment/RetryPolicy.ts` class
- [ ] Implement exponential backoff algorithm (base: 1s, max: 32s)
- [ ] Add configuration for max retries (default: 3)
- [ ] Integrate RetryPolicy with StripeClient.processPayment()
- [ ] Add unit tests for retry scenarios (success, failure, timeout)
```

**Poor Action Items** (vague, unmeasurable):
```markdown
- [ ] Handle retries
- [ ] Make it work
- [ ] Add tests
- [ ] Fix issues
```

### Execution Order Strategies

#### Strategy 1: Dependency Order

Execute items based on what depends on what.

**Example**:
```markdown
1. [x] Create RetryPolicy class (nothing depends on this yet)
2. [x] Implement backoff algorithm (depends on class existing)
3. [x] Add configuration (depends on algorithm structure)
4. [x] Integrate with client (depends on all above)
5. [x] Add tests (depends on everything working)
```

#### Strategy 2: Risk Order

Do risky/uncertain items first to catch blockers early.

**Example**:
```markdown
1. [x] Research Stripe API rate limits (uncertain, might change approach)
2. [x] Implement retry logic (core feature, most risk)
3. [x] Add configuration (low risk, straightforward)
4. [x] Add logging (low risk, enhancement)
5. [x] Add tests (low risk, verification)
```

#### Strategy 3: Value Order

Deliver most valuable functionality first.

**Example**:
```markdown
1. [x] Implement basic payment processing (core value)
2. [x] Add error handling (high value, prevents crashes)
3. [x] Integrate with database (high value, persistence)
4. [x] Add logging (medium value, debugging)
5. [x] Add rate limiting (low value, optimization)
```

### Handling Blockers

**When you encounter a blocker**:

1. **Document the blocker immediately**:
   ```markdown
   **Implementation Notes**:
   - Created RetryPolicy class
   - Implemented backoff algorithm
   - **BLOCKER**: Stripe SDK v12 doesn't support custom retry hooks
     - Cannot complete action item 4 (integrate with client)
     - Options: downgrade to v11, wait for v13, implement wrapper
     - Needs user decision
   ```

2. **Notify user with options**:
   ```
   ⚠️ BLOCKER ENCOUNTERED

   Action Item: "Integrate RetryPolicy with StripeClient"

   Issue: Stripe SDK v12 doesn't expose retry hooks for custom logic

   Options:
   A) Downgrade to Stripe SDK v11 (supports custom retry, but older)
   B) Wait for SDK v13 release (has retry hooks, ETA 2 weeks)
   C) Implement wrapper around SDK calls (adds complexity)
   D) Mark iteration ❌ BLOCKED and move to different work

   Which approach should we take?
   ```

3. **Wait for user decision** before proceeding

### Parallel Action Items

**Safe for parallel execution**:
- Independent files
- Different modules
- No shared state
- Can verify independently

**Example**:
```markdown
Action Items (can do in parallel):
- [ ] Create `logger.ts` utility
- [ ] Create `validator.ts` utility
- [ ] Create `formatter.ts` utility
- [ ] Create `parser.ts` utility

All four can be created simultaneously.
```

**NOT safe for parallel**:
- One depends on another
- Shared file/state
- Must be tested together

**Example**:
```markdown
Action Items (MUST be sequential):
- [ ] Create database schema
- [ ] Create data access layer (needs schema)
- [ ] Create service layer (needs DAL)
- [ ] Create API endpoints (needs service)

These have dependencies - do in order.
```

---

## Sequential vs Parallel Execution

### Sequential Execution Pattern

**When to use**: Action items have dependencies

**Pattern**:
```
Item 1 → Item 2 → Item 3 → Item 4
```

**Example: Building API Endpoint**

```markdown
#### Action Items (Sequential)

- [x] Define API request/response types
  ↓ (next item needs types)
- [x] Implement validation logic
  ↓ (next item needs validation)
- [x] Create service method
  ↓ (next item needs service)
- [x] Create API endpoint handler
  ↓ (next item needs endpoint)
- [x] Add integration tests

**Why Sequential**: Each item builds on the previous one.
```

**Execution Strategy**:
1. Complete item 1 fully
2. Verify item 1 works
3. Move to item 2
4. Repeat until all done

### Parallel Execution Pattern

**When to use**: Action items are independent

**Pattern**:
```
    ┌─ Item 1
    ├─ Item 2
    ├─ Item 3
    └─ Item 4
```

**Example: Creating Utility Functions**

```markdown
#### Action Items (Parallel)

- [x] Create logger utility
- [x] Create validator utility
- [x] Create formatter utility
- [x] Create error handler utility

**Why Parallel**: None depend on each other, all are standalone utilities.
```

**Execution Strategy**:
1. Create all files at once
2. Implement all functions
3. Verify each independently
4. Check off all items

### Hybrid Execution Pattern

**When to use**: Mix of dependent and independent items

**Pattern**:
```
Item 1 →  ┌─ Item 2a
          ├─ Item 2b  → Item 3
          └─ Item 2c
```

**Example: Feature with Multiple Components**

```markdown
#### Action Items (Hybrid)

- [x] Create base authentication interface
  ↓
  ┌─ [x] Implement JWT auth provider (uses interface)
  ├─ [x] Implement OAuth provider (uses interface)
  └─ [x] Implement API key provider (uses interface)
  ↓
- [x] Create auth middleware (uses all providers)
- [x] Add tests for all auth methods

**Why Hybrid**: Interface must exist first, then providers can be built in parallel, then middleware needs all providers.
```

**Execution Strategy**:
1. Complete item 1 (interface)
2. Complete items 2a, 2b, 2c in parallel
3. Complete item 3 (middleware)
4. Complete item 4 (tests)

### Decision Tree: Sequential or Parallel?

```
Does Item B need Item A's output?
    ↓
YES → Sequential (A → B)
    ↓
NO → Check for shared resources
    ↓
    Same file/state?
        ↓
    YES → Sequential (safer)
        ↓
    NO → Parallel (A + B)
```

---

## Breaking Down Large Action Items

### When to Break Down

**Signs an action item is too large**:
- Estimated > 2 hours
- Involves multiple files
- Multiple sub-steps needed
- Unclear how to complete
- High risk of failure

**Example of Too-Large Item**:
```markdown
- [ ] Implement payment system
```

This is too vague and large. Break it down!

### Breakdown Strategies

#### Strategy 1: By Component

Break into logical components/modules.

**Before**:
```markdown
- [ ] Implement payment system
```

**After**:
```markdown
- [ ] Create PaymentProcessor interface
- [ ] Implement StripeProcessor class
- [ ] Implement PayPalProcessor class
- [ ] Create PaymentService to coordinate processors
- [ ] Add payment validation logic
- [ ] Add error handling and retry
- [ ] Add tests for all processors
```

#### Strategy 2: By Layer

Break into architectural layers.

**Before**:
```markdown
- [ ] Add user authentication
```

**After**:
```markdown
- [ ] Database: Create users table with auth fields
- [ ] Data Layer: Create UserRepository with auth methods
- [ ] Service Layer: Create AuthService with login/logout
- [ ] API Layer: Create /login and /logout endpoints
- [ ] Middleware: Add authentication middleware
- [ ] Tests: Add auth integration tests
```

#### Strategy 3: By Phase

Break into implementation phases (skeleton → veins → flesh).

**Before**:
```markdown
- [ ] Build search feature
```

**After**:
```markdown
Skeleton (basic functionality):
- [ ] Create search API endpoint that returns hardcoded results
- [ ] Add search input in UI
- [ ] Wire UI to API

Veins (core functionality):
- [ ] Implement database search query
- [ ] Add pagination to results
- [ ] Add sorting options

Flesh (polish):
- [ ] Add search filters (date, type, status)
- [ ] Add search highlighting
- [ ] Add search suggestions
- [ ] Optimize query performance
```

#### Strategy 4: By File

Break into file-level changes.

**Before**:
```markdown
- [ ] Refactor error handling
```

**After**:
```markdown
- [ ] Update ErrorHandler.ts with new error types
- [ ] Update PaymentService.ts error handling
- [ ] Update OrderService.ts error handling
- [ ] Update BillingService.ts error handling
- [ ] Update error handling tests
- [ ] Update error documentation
```

### Breakdown Examples

#### Example 1: API Integration

**Too Large**:
```markdown
- [ ] Integrate with Stripe API
```

**Properly Broken Down**:
```markdown
- [ ] Create StripeClient class with API key configuration
- [ ] Implement createPayment() method
- [ ] Implement getPayment() method
- [ ] Implement refundPayment() method
- [ ] Add error mapping (Stripe errors → our errors)
- [ ] Add retry logic for transient failures
- [ ] Add webhook signature validation
- [ ] Add unit tests with mocked Stripe API
- [ ] Add integration tests with Stripe test mode
```

#### Example 2: Database Schema

**Too Large**:
```markdown
- [ ] Design and implement database schema
```

**Properly Broken Down**:
```markdown
- [ ] Create users table with fields and constraints
- [ ] Create payments table with foreign keys
- [ ] Create orders table with relationships
- [ ] Add indexes on frequently queried fields
- [ ] Create migration script for schema
- [ ] Add seed data for development
- [ ] Test schema with sample queries
- [ ] Document schema in ER diagram
```

#### Example 3: Refactoring

**Too Large**:
```markdown
- [ ] Refactor legacy payment code
```

**Properly Broken Down**:
```markdown
- [ ] Extract payment processing into separate class
- [ ] Replace hard-coded values with configuration
- [ ] Convert callbacks to async/await
- [ ] Add proper error handling
- [ ] Replace any types with proper interfaces
- [ ] Update tests to match new structure
- [ ] Verify no regressions with integration tests
- [ ] Update documentation
```

---

## Common Implementation Scenarios

### Scenario 1: Creating New Feature

**Context**: Building a new feature from scratch

**Recommended Pattern**: Sequential with verification

```markdown
#### Action Items

- [x] Design and document API contract
  → Verification: API spec reviewed and approved

- [x] Create database schema and migration
  → Verification: Migration runs cleanly, schema correct

- [x] Implement data access layer
  → Verification: Unit tests for DAL passing

- [x] Implement service layer
  → Verification: Service tests passing

- [x] Create API endpoints
  → Verification: Integration tests passing

- [x] Add error handling
  → Verification: Error cases tested and working

- [x] Add logging and monitoring
  → Verification: Logs visible, metrics tracked

- [x] Write documentation
  → Verification: Docs accurate and complete
```

### Scenario 2: Bug Fix

**Context**: Fixing a specific bug

**Recommended Pattern**: Diagnose → Fix → Verify

```markdown
#### Action Items

- [x] Reproduce bug with test case
  → Verification: Test fails, reproducing bug

- [x] Debug and identify root cause
  → Verification: Root cause documented

- [x] Implement fix
  → Verification: Test now passes

- [x] Add regression test
  → Verification: New test prevents bug from returning

- [x] Verify fix doesn't break anything else
  → Verification: All tests still passing
```

### Scenario 3: Refactoring

**Context**: Improving existing code structure

**Recommended Pattern**: Incremental with safety checks

```markdown
#### Action Items

- [x] Add comprehensive tests for current behavior
  → Verification: Tests passing, covering all cases

- [x] Extract method/class/module
  → Verification: Tests still passing

- [x] Update call sites to use new code
  → Verification: Tests still passing

- [x] Remove old code
  → Verification: Tests still passing

- [x] Clean up and optimize
  → Verification: Tests still passing, code cleaner
```

### Scenario 4: Integration

**Context**: Integrating with external system

**Recommended Pattern**: Mock → Real → Error handling

```markdown
#### Action Items

- [x] Create client interface and types
  → Verification: Interface matches external API

- [x] Implement client with mock responses
  → Verification: Mock client works, tests passing

- [x] Replace mock with real API calls
  → Verification: Integration test with real API succeeds

- [x] Add error handling and retry logic
  → Verification: Error cases handled gracefully

- [x] Add rate limiting and timeouts
  → Verification: Rate limits respected, timeouts working
```

### Scenario 5: Performance Optimization

**Context**: Improving performance of existing feature

**Recommended Pattern**: Measure → Optimize → Verify

```markdown
#### Action Items

- [x] Add performance benchmarks
  → Verification: Baseline performance measured

- [x] Profile and identify bottlenecks
  → Verification: Bottlenecks documented

- [x] Implement optimization (e.g., caching)
  → Verification: Benchmarks show improvement

- [x] Verify functionality unchanged
  → Verification: All tests still passing

- [x] Document performance characteristics
  → Verification: Docs updated with new benchmarks
```

---

## Best Practices Summary

**Pre-Implementation Tasks**:
- ✅ Keep scope < 30 minutes
- ✅ Complete ALL before starting main work
- ✅ Document why each is blocking
- ✅ Mark completed with date and details

**Action Items**:
- ✅ Make items specific and measurable
- ✅ Check off immediately after completion
- ✅ Execute in logical order (dependencies first)
- ✅ Verify incrementally, not just at end
- ✅ Document blockers and deviations

**Breaking Down Large Items**:
- ✅ If > 2 hours, break it down
- ✅ Use component, layer, phase, or file breakdown
- ✅ Ensure sub-items are still specific
- ✅ Maintain logical grouping

**Sequential vs Parallel**:
- ✅ Sequential when items depend on each other
- ✅ Parallel when items are independent
- ✅ Hybrid when mix of both
- ✅ When in doubt, go sequential (safer)

**Common Scenarios**:
- ✅ New feature: Sequential with verification
- ✅ Bug fix: Diagnose → Fix → Verify
- ✅ Refactoring: Incremental with safety checks
- ✅ Integration: Mock → Real → Error handling
- ✅ Optimization: Measure → Optimize → Verify
