# Implementation Verification Guide

This document provides detailed verification patterns, completion criteria, and decision-making guidance for implementation work in Flow framework. Reference this guide when you need detailed examples and templates for verifying your work.

> **Note**: This is a Level 3 resource for the flow-implementer Skill. See [SKILL.md](SKILL.md) for core implementation workflow.

## Table of Contents

1. [Testing Patterns](#testing-patterns)
2. [What "Done" Looks Like](#what-done-looks-like)
3. [When to Document Bugs and Issues](#when-to-document-bugs-and-issues)
4. [Deciding: ❌ BLOCKED vs Continue](#deciding--blocked-vs-continue)

---

## Testing Patterns

### Unit Testing Pattern

**When**: Testing individual functions/methods in isolation

**Example Structure**:
```typescript
describe('RetryPolicy', () => {
  describe('calculateDelay', () => {
    it('should return base delay for first retry', () => {
      const policy = new RetryPolicy({ baseDelay: 1000, maxRetries: 3 });
      expect(policy.calculateDelay(1)).toBe(1000);
    });

    it('should apply exponential backoff', () => {
      const policy = new RetryPolicy({ baseDelay: 1000, maxRetries: 3 });
      expect(policy.calculateDelay(2)).toBe(2000);
      expect(policy.calculateDelay(3)).toBe(4000);
    });

    it('should cap at max delay', () => {
      const policy = new RetryPolicy({ baseDelay: 1000, maxDelay: 5000 });
      expect(policy.calculateDelay(10)).toBe(5000);
    });
  });
});
```

**What to Test**:
- Happy path (expected inputs → expected outputs)
- Edge cases (empty, null, undefined, boundary values)
- Error cases (invalid inputs → proper errors)
- State changes (method calls affect object state correctly)

### Integration Testing Pattern

**When**: Testing multiple components working together

**Example Structure**:
```typescript
describe('Payment Integration', () => {
  it('should process payment with retry on transient failure', async () => {
    // Setup: Create real instances (or test doubles)
    const stripe = new StripeClient(testApiKey);
    const processor = new PaymentProcessor(stripe);

    // Mock Stripe to fail once, then succeed
    jest.spyOn(stripe, 'createCharge')
      .mockRejectedValueOnce(new TransientError('rate_limit'))
      .mockResolvedValueOnce({ id: 'ch_123', status: 'succeeded' });

    // Execute: Run the full flow
    const result = await processor.process({
      amount: 1000,
      currency: 'usd',
      retryPolicy: { maxRetries: 3 }
    });

    // Verify: Check end-to-end behavior
    expect(result.status).toBe('succeeded');
    expect(stripe.createCharge).toHaveBeenCalledTimes(2); // Failed once, succeeded second time
  });
});
```

**What to Test**:
- Component interactions (A calls B correctly)
- Data flow (data transforms correctly through layers)
- Error propagation (errors bubble up properly)
- Side effects (database writes, API calls, file I/O)

### Manual Testing Checklist

**When**: No automated tests exist or testing UI/UX

**Checklist Template**:
```markdown
**Manual Testing - [Feature Name]**

**Setup**:
- [ ] Environment: [development/staging]
- [ ] Test data: [describe test data used]
- [ ] Prerequisites: [any setup needed]

**Test Cases**:
1. Happy Path:
   - [ ] Action: [what you did]
   - [ ] Expected: [what should happen]
   - [ ] Actual: [what actually happened]
   - [ ] Result: ✅ PASS / ❌ FAIL

2. Edge Case:
   - [ ] Action: [what you did]
   - [ ] Expected: [what should happen]
   - [ ] Actual: [what actually happened]
   - [ ] Result: ✅ PASS / ❌ FAIL

**Issues Found**:
- [Bug 1 description + severity]
- [Bug 2 description + severity]

**Verified**: [Date] by [Name]
```

### Test-Driven Development (TDD) Pattern

**When**: Complex logic where tests help design

**Flow**:
```
1. RED: Write failing test
   ↓
2. GREEN: Write minimal code to pass
   ↓
3. REFACTOR: Improve code while keeping tests green
   ↓
Repeat
```

**Example Iteration**:
```typescript
// Step 1: RED - Write failing test
test('should calculate exponential backoff', () => {
  const delay = calculateBackoff(2, 1000);
  expect(delay).toBe(2000);
});
// Run test → FAILS (function doesn't exist)

// Step 2: GREEN - Minimal implementation
function calculateBackoff(attempt: number, baseDelay: number): number {
  return attempt * baseDelay;
}
// Run test → PASSES

// Step 3: REFACTOR - Improve implementation
function calculateBackoff(attempt: number, baseDelay: number): number {
  return Math.pow(2, attempt - 1) * baseDelay;
}
// Run test → STILL PASSES (for attempt=2: 2^1 * 1000 = 2000)

// Step 4: Add more tests to drive better design
test('should handle attempt=1', () => {
  expect(calculateBackoff(1, 1000)).toBe(1000); // 2^0 * 1000
});
```

---

## What "Done" Looks Like

### Iteration Completion Criteria

An iteration is **truly done** when ALL of the following are true:

#### 1. All Action Items Completed

```markdown
✅ Correct:
- [x] Create RetryPolicy class
- [x] Implement backoff algorithm
- [x] Add configuration
- [x] Integrate with client
- [x] Add tests

❌ Incorrect:
- [x] Create RetryPolicy class
- [x] Implement backoff algorithm
- [ ] Add configuration          ← NOT DONE
- [x] Integrate with client
- [x] Add tests
```

#### 2. Code Works Correctly

**Verification Methods** (choose based on project):
- Unit tests passing (all green)
- Integration tests passing
- Manual testing completed with checklist
- Code review approved
- No compiler/linter errors

**Example**:
```bash
✅ All tests passing:
  PASS  src/payment/RetryPolicy.test.ts
  PASS  src/payment/StripeClient.test.ts
  PASS  integration/payment.integration.test.ts

  Test Suites: 3 passed, 3 total
  Tests:       24 passed, 24 total
```

#### 3. No Unresolved Blockers

**Resolved Blocker Example**:
```markdown
**Implementation Notes**:
- Created RetryPolicy class
- **Blocker Encountered**: Stripe SDK v12 doesn't support custom retry
  - **Resolution**: Implemented wrapper pattern around SDK calls
  - **Impact**: Added StripeClientWrapper.ts (86 lines)
- Integrated wrapper with payment processor
```

**Unresolved Blocker Example** (iteration NOT done):
```markdown
**Implementation Notes**:
- Created RetryPolicy class
- **Blocker Encountered**: Stripe SDK v12 doesn't support custom retry
  - **Status**: ❌ WAITING FOR USER DECISION
  - **Options Presented**: Downgrade to v11, wait for v13, or implement wrapper
  - **Action**: Cannot proceed until user chooses approach
```

#### 4. Implementation Notes Updated

**Complete Notes Example**:
```markdown
**Implementation Notes**:

Created comprehensive retry logic for payment processing:

**What Was Built**:
- RetryPolicy class with configurable backoff (src/payment/RetryPolicy.ts, 124 lines)
- Exponential backoff algorithm (base: 1s, max: 32s, jitter: 20%)
- Error classification (transient vs permanent errors)
- Integration with StripeClient via wrapper pattern

**Design Decisions**:
- Chose exponential backoff over linear (better for API rate limiting)
- Added jitter to prevent thundering herd problem
- Made policy injectable for easy testing

**Challenges & Solutions**:
- Challenge: Stripe SDK v12 doesn't support custom retry
  - Solution: Implemented StripeClientWrapper to intercept API calls
- Challenge: Difficult to test retry timing
  - Solution: Made clock injectable via dependency injection

**Deviations from Plan**:
- Originally planned to use Stripe's built-in retry, but discovered it's not customizable
- Added StripeClientWrapper.ts (not in original action items, but necessary)

**Bugs Fixed**:
- Fixed off-by-one error in backoff calculation (was 2^attempt, now 2^(attempt-1))
```

#### 5. Files Modified Documented

**Complete Documentation Example**:
```markdown
**Files Modified**:
- src/payment/RetryPolicy.ts (created, 124 lines)
- src/payment/StripeClientWrapper.ts (created, 86 lines)
- src/payment/StripeClient.ts (modified, +24 lines, -8 lines)
- src/types/payment.ts (modified, +12 lines for retry types)
- tests/payment/RetryPolicy.test.ts (created, 98 lines)
- tests/payment/StripeClientWrapper.test.ts (created, 64 lines)
- integration/payment.integration.test.ts (modified, +42 lines)
```

#### 6. Ready for Next Work

**Verification Questions**:
- Can the next iteration start immediately? YES / NO
- Are there any dependencies that need resolving? YES / NO
- Does anything need user decision before continuing? YES / NO

**Example - Ready**:
```markdown
✅ READY FOR NEXT ITERATION

Current Status:
- Iteration 2 (Retry Logic) complete and verified
- All tests passing
- No blockers for Iteration 3 (Error Logging)
- Can proceed immediately with /flow-implement-complete
```

**Example - NOT Ready**:
```markdown
❌ NOT READY - NEEDS USER DECISION

Current Status:
- Iteration 2 (Retry Logic) functionally complete
- All tests passing
- **Blocker for Iteration 3**: User needs to decide on logging library
  - Options: Winston, Pino, or custom logger
  - Cannot start Iteration 3 until decision made
- Mark Iteration 2 complete, but address blocker before starting Iteration 3
```

---

## When to Document Bugs and Issues

### Bug Discovery During Implementation

**When you discover bugs in EXISTING code** (not your changes):

#### Document in Implementation Notes

```markdown
**Implementation Notes**:

Created payment retry logic.

**Bugs Discovered in Existing Code**:

##### Bug 1: Race Condition in PaymentService

**Location**: `src/services/PaymentService.ts:145-152`

**Problem**:
```typescript
// Current buggy code
async processPayment(amount: number) {
  const status = await this.checkStatus();
  // Race condition: status can change between check and update
  await this.updatePayment(status);
}
```

**Impact**: Could cause duplicate charges in concurrent requests

**Action Taken**: Documented here, created separate task for fix (not in scope of current iteration)

**Recommendation**: High priority fix for next sprint
```

#### When to Fix Immediately vs Defer

**Fix Immediately** (document in Implementation Notes):
- Blocking bug in file you're currently modifying
- Syntax error preventing compilation
- Trivial fix (< 5 minutes)
- Part of your current action items

**Defer** (document and create task):
- Bug in unrelated code
- Requires significant refactoring
- Needs design discussion
- Out of scope for current iteration

### Issue Severity Levels

**Critical** (Fix immediately or BLOCK iteration):
- Causes data loss
- Security vulnerability
- System crash/unavailability
- Blocking current work

**High** (Document and create follow-up task):
- Incorrect functionality
- Performance degradation
- Race condition/concurrency issue
- Affects multiple users

**Medium** (Document for backlog):
- Edge case handling missing
- Poor error messages
- Minor performance issue
- Affects few users

**Low** (Document for future):
- Code quality issue
- Missing tests
- Documentation gap
- Nice-to-have improvement

---

## Deciding: ❌ BLOCKED vs Continue

### When to Mark ❌ BLOCKED

Mark iteration **❌ BLOCKED** when you **CANNOT PROCEED** without external help:

**Valid Blocking Scenarios**:

1. **External Dependency Unavailable**:
   ```markdown
   ❌ BLOCKED: Stripe API test environment down
   - Cannot run integration tests
   - Need API to be back up before proceeding
   - Estimated wait: 2-4 hours (according to status page)
   ```

2. **Need User Decision**:
   ```markdown
   ❌ BLOCKED: Need architecture decision
   - Two viable approaches for retry logic:
     A) Client-side retry (simpler, less reliable)
     B) Server-side retry queue (complex, more reliable)
   - Cannot proceed without user choosing approach
   - Next action: Present options to user, await decision
   ```

3. **Technical Limitation Discovered**:
   ```markdown
   ❌ BLOCKED: Library doesn't support required feature
   - Stripe SDK v12 doesn't expose retry hooks
   - Options: downgrade to v11, wait for v13, or implement wrapper
   - Estimated resolution time: > 2 hours (needs investigation)
   ```

4. **Missing Information**:
   ```markdown
   ❌ BLOCKED: Missing API credentials
   - Need production Stripe API key to test
   - Cannot verify integration without real credentials
   - User must provide credentials
   ```

### When to CONTINUE (Not Block)

**DO NOT mark blocked** if you can work around or continue:

**Continue Scenarios**:

1. **Minor Issue with Workaround**:
   ```markdown
   ✅ CONTINUING: Test flakiness found
   - Integration test occasionally fails (timing issue)
   - **Workaround**: Added retry logic to test itself
   - Can proceed with implementation
   - **Note**: Will fix flakiness in separate cleanup task
   ```

2. **Discover Out-of-Scope Work**:
   ```markdown
   ✅ CONTINUING: Found refactoring opportunity
   - Noticed ErrorHandler could be refactored for better reuse
   - **Decision**: Out of scope for this iteration
   - **Action**: Documented for future refactoring task
   - Proceeding with current implementation using existing ErrorHandler
   ```

3. **Can Complete Action Items Without Resolution**:
   ```markdown
   ✅ CONTINUING: Documentation incomplete
   - Found outdated API documentation
   - **Action**: Using source code as reference instead
   - Can complete implementation despite docs being stale
   - **Note**: Will update docs in separate task
   ```

4. **Temporary Solution Acceptable**:
   ```markdown
   ✅ CONTINUING: Performance not optimal
   - Current retry logic takes 30s worst case (goal was 20s)
   - **Decision**: Acceptable for V1, will optimize in V2
   - Can mark iteration complete with known limitation
   - **Note**: Documented in Implementation Notes for V2 improvement
   ```

### Decision Flowchart

```
Encounter Issue
    ↓
Can I complete action items without resolving this?
    ↓
YES → CONTINUE
  ↓
  Document issue in Implementation Notes
  Create follow-up task if needed
  Proceed with implementation
    ↓
NO → Assess Impact
  ↓
  Is this a minor issue (< 30 min to resolve)?
    ↓
    YES → FIX NOW
      ↓
      Resolve issue
      Document in Implementation Notes
      Continue implementation
    ↓
    NO → BLOCKED
      ↓
      Mark iteration ❌ BLOCKED
      Document blocker clearly
      Present options to user
      Wait for decision/resolution
```

### Example: Blocked vs Continue

**Scenario**: Discovered Stripe API rate limiting during testing

**Option 1: Mark BLOCKED** (if cannot proceed):
```markdown
❌ BLOCKED: Hit Stripe API rate limit

**Issue**: Integration tests hitting Stripe API rate limit (100 requests/hour in test mode)

**Impact**: Cannot run integration tests to verify implementation

**Cannot Proceed Because**:
- Tests are mandatory for completion
- No way to verify retry logic works without testing against real API
- Mock tests insufficient (need real API behavior)

**Options**:
A) Request higher rate limit from Stripe support (ETA: 1-2 days)
B) Space out test runs (run tests every hour, very slow)
C) Use more sophisticated mocking to reduce API calls

**Waiting for**: User decision on approach
```

**Option 2: CONTINUE** (if can work around):
```markdown
✅ CONTINUING: Stripe API rate limit hit

**Issue**: Integration tests hitting Stripe API rate limit (100 requests/hour in test mode)

**Workaround**: Implemented smart test mocking
- Created realistic mock responses based on Stripe API documentation
- Validated mock responses against real API (used 10 of 100 requests)
- Remaining integration tests use mocks
- Will run full integration test suite during deployment (production has higher limits)

**Impact**: Can proceed with confidence
- Core logic tested with mocks
- Sample verification with real API successful
- Documented limitation for deployment testing

**Next Steps**: Continue with implementation
```
