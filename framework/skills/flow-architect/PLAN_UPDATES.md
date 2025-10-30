# PLAN.md Update Patterns

This document provides best practices and patterns for updating PLAN.md during brainstorming sessions in Flow framework projects. Use this as a reference when documenting architectural decisions, DO/DON'T guidelines, technology choices, and scope boundaries.

> **Note**: This is a Level 3 resource for the flow-architect Skill. See [SKILL.md](SKILL.md) for core architectural guidance.

## Table of Contents

1. [When to Update PLAN.md](#when-to-update-planmd)
2. [Architecture vs Scope](#architecture-vs-scope)
3. [DO/DON'T Guideline Examples](#dodont-guideline-examples)
4. [Technology Choice Documentation](#technology-choice-documentation)
5. [Keeping PLAN.md Focused](#keeping-planmd-focused)

## When to Update PLAN.md

### During Brainstorming (Type B Subjects)

**Type B subjects** are resolved by updating PLAN.md documentation:
- Architectural decisions finalized
- Design patterns chosen
- Technology/library selection complete
- Scope boundaries clarified
- DO/DON'T pattern discovered

**Workflow**:
1. Discuss options during brainstorming
2. User makes final decision
3. Update PLAN.md with decision + rationale
4. Mark brainstorming subject as ✅ RESOLVED (Type B)

**Example Subject**:
```markdown
### Subject 3: Choose Error Mapping Strategy

**Status**: ✅ RESOLVED (Type B - Documentation)

**Question**: How should we map Stripe errors to domain errors?

**Decision**: Use dedicated ErrorMapper class with error code lookup table

**Rationale**:
- Centralizes error mapping logic
- Easy to extend with new error codes
- Testable in isolation
- Keeps StripeClient focused

**PLAN.md Updated**:
- Added ErrorMapper to Architecture section (Component list)
- Added "DO: Use ErrorMapper for all Stripe errors" guideline
```

### Not During Implementation

**DON'T update PLAN.md during implementation** for:
- Bug fixes (document in iteration notes)
- Implementation details (document in code comments)
- Completed work (document in task files)
- Discovered issues (document in implementation notes)

**Exception**: If implementation reveals a pattern that should be followed consistently, note it for future brainstorming session to add to DO/DON'T guidelines.

## Architecture vs Scope

### Architecture Section: HOW the system works

**Use Architecture section for**:
- System structure (components, modules, layers)
- Component responsibilities and boundaries
- Data flow between components
- Integration points (external services, APIs)
- Design patterns being used
- Key technical constraints

**Example - Architecture Section**:
```markdown
## Architecture

### Component Structure

**Core Modules**:
- **PaymentProcessor** (Orchestrator)
  - Coordinates payment workflow
  - Handles transaction lifecycle
  - Delegates to specialized components

- **StripeClient** (Integration Adapter)
  - Wraps Stripe SDK
  - Applies retry policy to all API calls
  - Maps Stripe responses to domain models

- **ErrorMapper** (Error Translation)
  - Classifies errors (transient vs permanent)
  - Maps Stripe error codes to domain errors
  - Provides user-friendly error messages

- **RetryPolicy** (Resilience)
  - Configurable exponential backoff
  - Jitter to prevent thundering herd
  - Different policies for different error types

### Data Flow

```
User Request
  ↓
PaymentProcessor.process()
  ↓
StripeClient.createCharge() → [RetryPolicy wraps call]
  ↓
Stripe API
  ↓ (success)
Return Charge ID
  ↓ (failure - transient)
RetryPolicy → exponential backoff → retry
  ↓ (failure - permanent)
ErrorMapper → domain error → return to user
```

### Integration Points

**External Services**:
- Stripe API v2024-10 (payment processing)
  - Rate limit: 100 req/sec
  - Retry-after header respected
  - Webhook for async updates

**Database**:
- Transaction log (PostgreSQL)
  - Payment attempts (for audit)
  - Retry history (for analytics)
```

### Scope Section: WHAT is included

**Use Scope section for**:
- Features included in V1
- Features deferred to V2/V3
- Explicit exclusions
- Business constraints
- Performance requirements
- Platform limitations

**Example - Scope Section**:
```markdown
## Scope

### V1 - MVP (Current Release)

**In Scope**:
- Credit card payments (Visa, Mastercard, Amex)
- Basic retry for transient failures
- Error classification (permanent vs transient)
- Transaction logging for audit
- Synchronous payment flow

**Out of Scope** (defer to V2):
- Refund processing: Not needed for launch
- Subscription billing: Future business model
- Multi-currency support: US market only for V1
- Webhook processing: Will add with async flow
- Saved payment methods: V2 feature

**Constraints**:
- Stripe API v2024-10 required
- TypeScript 5.x (project standard)
- Response time < 3 seconds (includes retries)
- Must handle 100 payments/sec

**Platform Limitations**:
- Stripe test mode: 100 req/hour (not a production issue)
- No 3D Secure in V1 (adds complexity, defer to V2)
```

### Quick Decision Tree

```
Need to document decision
    ↓
Does it explain HOW the system is structured?
    ↓
YES → Architecture section
  - Components
  - Data flow
  - Patterns
  - Integration points
    ↓
NO → Does it define WHAT is included/excluded?
    ↓
YES → Scope section
  - V1 features
  - V2 deferred
  - Constraints
  - Limitations
```

## DO/DON'T Guideline Examples

### Example 1: API Integration Pattern

```markdown
### DO: Use RetryPolicy for all external API calls

**Rationale**: External APIs have transient failures (network issues, rate limits, temporary unavailability). Retry logic with exponential backoff provides resilience without user-facing errors.

**Pattern**:
```typescript
// Good: Wrapped with retry policy
const result = await retryPolicy.execute(async () => {
  return await externalApi.call(params);
});
```

**Anti-pattern**:
```typescript
// Bad: Direct call without retry
const result = await externalApi.call(params); // Fails on transient errors
```

**When to Apply**:
- All calls to Stripe API
- All calls to third-party services
- Any network request that can fail transiently

**Exceptions**:
- Internal service calls (use different error handling)
- Database queries (use transaction retry instead)
```

### Example 2: Error Handling Constraint

```markdown
### DON'T: Retry permanent failures

**Rationale**: Permanent failures (invalid input, insufficient funds, authorization denied) will never succeed no matter how many times you retry. Retrying wastes resources and delays error feedback to users.

**Impact**:
- User waits longer for error message
- Unnecessary load on payment provider
- Risk of hitting rate limits
- Wasted compute resources

**How to Identify Permanent Failures**:
```typescript
// Use ErrorMapper to classify
const error = errorMapper.map(stripeError);

if (error.type === 'permanent') {
  // Don't retry - return error immediately
  throw error;
}

if (error.type === 'transient') {
  // Safe to retry
  await retryPolicy.execute(() => operation());
}
```

**Permanent Error Codes** (Stripe):
- `card_declined` - Card issuer rejected
- `insufficient_funds` - Not enough money
- `invalid_card` - Card details invalid
- `expired_card` - Card past expiration
```

### Example 3: Configuration Management

```markdown
### DO: Make retry policies configurable per environment

**Rationale**: Different environments have different performance characteristics and requirements. Test environments need faster retries for quick feedback. Production needs conservative retries to handle real failures.

**Configuration**:
```typescript
// config/retry.ts
export const retryConfig = {
  development: {
    maxRetries: 2,
    baseDelay: 100, // 100ms
    maxDelay: 1000, // 1 second
  },
  test: {
    maxRetries: 1,
    baseDelay: 10, // 10ms (fast tests)
    maxDelay: 100,
  },
  production: {
    maxRetries: 5,
    baseDelay: 1000, // 1 second
    maxDelay: 32000, // 32 seconds
  },
};
```

**Usage**:
```typescript
const policy = new RetryPolicy(retryConfig[process.env.NODE_ENV]);
```
```

### Example 4: Testing Pattern

```markdown
### DO: Test error scenarios with mocks

**Rationale**: External API failures are hard to reproduce in tests. Use mocks to simulate transient failures, permanent failures, and edge cases consistently.

**Pattern**:
```typescript
describe('PaymentProcessor with retries', () => {
  it('should retry on transient failure', async () => {
    // Mock: fail twice, then succeed
    const mockStripe = jest.fn()
      .mockRejectedValueOnce(new TransientError('rate_limit'))
      .mockRejectedValueOnce(new TransientError('network_error'))
      .mockResolvedValueOnce({ id: 'ch_123', status: 'succeeded' });

    const result = await processor.process(payment);

    expect(mockStripe).toHaveBeenCalledTimes(3); // 2 retries + success
    expect(result.status).toBe('succeeded');
  });

  it('should not retry on permanent failure', async () => {
    const mockStripe = jest.fn()
      .mockRejectedValueOnce(new PermanentError('card_declined'));

    await expect(processor.process(payment)).rejects.toThrow('card_declined');

    expect(mockStripe).toHaveBeenCalledTimes(1); // No retries
  });
});
```
```

## Technology Choice Documentation

### Template

```markdown
### [Component/Feature]: [Technology/Pattern]

**Decision**: Using [specific technology] for [purpose]

**Rationale**:
- [Reason 1: primary benefit]
- [Reason 2: fits project needs]
- [Reason 3: team familiarity / community support]

**Alternatives Considered**:
- [Alternative 1]: [Why not chosen - specific reason]
- [Alternative 2]: [Why not chosen - specific reason]

**Trade-offs**:
- ✅ Pros:
  - [Advantage 1]
  - [Advantage 2]
- ❌ Cons:
  - [Disadvantage 1]
  - [Disadvantage 2]
- ⚖️ Acceptable for V1: [Why trade-offs are acceptable]

**Migration Path** (if relevant):
- V1: [Current approach]
- V2: [Future improvement if needed]
```

### Example 1: Library Selection

```markdown
### Retry Logic: Custom Implementation

**Decision**: Building custom RetryPolicy class instead of using generic retry library

**Rationale**:
- Need Stripe-specific error classification (transient vs permanent)
- Stripe SDK v12 doesn't expose retry configuration
- Want exponential backoff with jitter (not all libraries support this)
- Need different policies for different error types

**Alternatives Considered**:
- **async-retry**: Generic library, but doesn't understand Stripe errors
  - Would need wrapper anyway for error classification
  - Adds dependency for limited benefit
- **Stripe SDK built-in**: Not customizable in v12
  - No access to retry timing
  - Can't distinguish transient from permanent
  - Would need to wait for v13 (6+ months)

**Trade-offs**:
- ✅ Pros:
  - Full control over retry behavior
  - Stripe-aware error handling
  - Testable in isolation
  - Zero external dependencies
- ❌ Cons:
  - More code to maintain (~75 lines)
  - Need to implement backoff algorithm ourselves
  - Testing async timing can be tricky
- ⚖️ Acceptable for V1:
  - Retry logic is isolated in single class
  - Well-tested with mocks (time-injection pattern)
  - Can swap for library later if needed (interface stays same)

**Migration Path**:
- V1: Custom RetryPolicy class
- V2: Monitor if Stripe SDK v13+ adds customizable retry
- V3: Consider migrating to SDK if it meets needs
```

### Example 2: Design Pattern

```markdown
### Error Handling: Strategy Pattern

**Decision**: Using Strategy pattern for error classification

**Rationale**:
- Different error types need different handling strategies
- Easy to add new error types without modifying existing code
- Testable strategies in isolation
- Clear separation of concerns

**Implementation**:
```typescript
interface ErrorStrategy {
  canHandle(error: StripeError): boolean;
  handle(error: StripeError): DomainError;
}

class TransientErrorStrategy implements ErrorStrategy {
  canHandle(error: StripeError): boolean {
    return ['rate_limit', 'network_error'].includes(error.code);
  }
  handle(error: StripeError): DomainError {
    return new TransientError(error.message, { retryable: true });
  }
}

class PermanentErrorStrategy implements ErrorStrategy {
  canHandle(error: StripeError): boolean {
    return ['card_declined', 'insufficient_funds'].includes(error.code);
  }
  handle(error: StripeError): DomainError {
    return new PermanentError(error.message, { retryable: false });
  }
}
```

**Alternatives Considered**:
- **Simple if/else chain**: Harder to test, grows complex with more error types
- **Error code mapping table**: Less flexible, can't handle complex logic

**Trade-offs**:
- ✅ Pros: Extensible, testable, clean
- ❌ Cons: More classes (4 strategies + manager)
- ⚖️ Acceptable: Error handling is core feature, worth the structure
```

## Keeping PLAN.md Focused

### What TO Include

**Architecture Section**:
- ✅ High-level component structure
- ✅ Data flow diagrams (text-based)
- ✅ Integration points with external systems
- ✅ Key design patterns being used
- ✅ Technical constraints affecting design

**DO/DON'T Guidelines**:
- ✅ Patterns discovered from real experience
- ✅ Anti-patterns that caused problems
- ✅ Platform-specific constraints
- ✅ Examples with code snippets

**Technology Choices**:
- ✅ Major library/framework selections
- ✅ Design pattern choices
- ✅ Rationale and trade-offs

**Scope**:
- ✅ V1 feature list
- ✅ Explicitly deferred features (V2/V3)
- ✅ Performance requirements
- ✅ Platform constraints

### What NOT to Include

**Avoid in Architecture**:
- ❌ Implementation details (specific line numbers)
- ❌ Completed work (belongs in task files)
- ❌ Bug fixes (belongs in iteration notes)
- ❌ Todos and action items (belongs in task files)
- ❌ Speculation about V2 features (keep focused on V1)

**Avoid in DO/DON'T**:
- ❌ Obvious best practices ("write tests", "use version control")
- ❌ One-off decisions that aren't patterns
- ❌ Personal preferences without rationale
- ❌ Guidelines without examples

**Avoid in Scope**:
- ❌ Detailed implementation plans (belongs in tasks)
- ❌ Tentative "maybe" features (defer or commit)
- ❌ Features without user value justification

### Red Flags (PLAN.md Getting Too Large)

**Warning signs**:
- PLAN.md over 300 lines (probably too detailed)
- Architecture section listing every file
- DO/DON'T with 20+ guidelines (too many patterns)
- Scope including V2/V3/V4 features

**How to slim down**:
1. Move implementation details to code comments
2. Move completed work to task files or ARCHIVE.md
3. Consolidate similar guidelines
4. Focus scope on V1 only, defer V2/V3 discussion

### Example: Too Detailed vs Just Right

**❌ Too Detailed** (avoid):
```markdown
## Architecture

### File Structure
- src/
  - payment/
    - PaymentProcessor.ts (145 lines)
      - process() method (lines 23-67)
      - validate() method (lines 69-89)
      - log() method (lines 91-103)
    - StripeClient.ts (213 lines)
      - createCharge() (lines 45-98)
      ...
```

**✅ Just Right**:
```markdown
## Architecture

### Component Structure

**PaymentProcessor** (Orchestrator):
- Validates payment requests
- Coordinates Stripe API calls
- Logs transactions

**StripeClient** (Integration):
- Wraps Stripe SDK
- Applies retry policy
- Maps errors to domain model
```

## Summary

**Key Principles**:
1. Update PLAN.md during brainstorming (Type B subjects)
2. Distinguish Architecture (HOW) from Scope (WHAT)
3. DO/DON'T guidelines need rationale + examples
4. Document technology choices with trade-offs
5. Keep PLAN.md focused on V1, high-level decisions

**When in doubt**:
- Ask: "Is this a pattern others should follow?" → DO/DON'T
- Ask: "Does this explain system structure?" → Architecture
- Ask: "Does this define what's included?" → Scope
- Ask: "Is this implementation detail?" → Code comments / task file
