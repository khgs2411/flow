# Task 3: API Integration

**Status**: 🚧 IN PROGRESS
**Phase**: [Phase 2 - Core Implementation](../DASHBOARD.md#phase-2-core-implementation)
**Purpose**: Integrate with Stripe REST API for payment processing

---

## Task Overview

Build a robust Stripe API client with error handling, retry logic for transient failures, and comprehensive integration tests. This is the core integration layer that all payment operations depend on.

**Why This Task**: Payment processing requires reliable communication with Stripe API. Without proper error handling and retry logic, transient network issues or API hiccups would cause payment failures and poor user experience.

**Dependencies**:
- **Requires**: Task 1 (Database Layer) - need PaymentRepository for state persistence
- **Requires**: Task 2 (Business Logic) - need PaymentService interface definitions
- **Blocks**: Task 4 (Webhook Handler) - webhook processing depends on API client
- **Blocks**: Task 5 (Authentication) - auth tokens stored via API calls

**Estimated Complexity**: High (4 iterations expected)

**Risk Level**: High - Core payment functionality depends on this

---

## Iterations

### ✅ Iteration 1: REST Client Setup

**Goal**: Create Stripe API client wrapper with authentication and configuration

**Status**: ✅ COMPLETE (2025-01-12)

---

#### Brainstorming Session - REST Client Architecture

**Focus**: Design API client abstraction layer and authentication flow

**Subjects to Discuss**:
(All subjects resolved)

**Resolved Subjects**:

---

##### ✅ Subject 1: Client Architecture Pattern

**Decision**: Use singleton pattern with lazy initialization

**Resolution Type**: D (Iteration Action Items)

**Rationale**:
- Stripe SDK maintains connection pool internally
- Multiple client instances would create redundant connections and waste resources
- Lazy initialization delays credential validation until first use (fast app startup)
- Singleton ensures consistent configuration across the application

**Action Items**:
- [x] Create `StripeClient` singleton class in src/integrations/stripe/
- [x] Implement lazy initialization in constructor (init on first API call)
- [x] Add credential validation on first API call (fail fast if misconfigured)
- [x] Export singleton instance for import across codebase

---

##### ✅ Subject 2: Authentication Flow

**Decision**: Use API key from environment variable with startup validation

**Resolution Type**: D (Iteration Action Items)

**Rationale**:
- Stripe best practices recommend environment-based configuration
- Supports different keys per environment (dev/staging/prod)
- Validation at startup prevents runtime errors from missing/invalid keys
- Fails fast with clear error message if key is missing or malformed

**Action Items**:
- [x] Load `STRIPE_API_KEY` from environment variables
- [x] Validate key format at startup (must start with `sk_test_` or `sk_live_`)
- [x] Throw descriptive error if key is missing or invalid
- [x] Log masked key on startup for debugging (sk_***...last4chars)

---

##### ✅ Subject 3: API Timeout Configuration

**Decision**: Set 30-second timeout for API calls, configurable via environment

**Resolution Type**: D (Iteration Action Items)

**Rationale**:
- Stripe recommends 30s timeout for payment operations
- Prevents indefinite hanging on network issues
- Configurable via environment for different deployment scenarios
- Balance between reliability (long enough for legit slow requests) and responsiveness (not too long)

**Action Items**:
- [x] Configure default timeout of 30 seconds
- [x] Make timeout configurable via `STRIPE_API_TIMEOUT_MS` env var
- [x] Add timeout handling in API call wrapper
- [x] Log timeout events for monitoring

---

#### Implementation - Iteration 1: REST Client Setup

**Status**: ✅ COMPLETE (2025-01-12)

**Action Items**: See resolved subjects above (all completed)

**Implementation Notes**:
- Created `src/integrations/stripe/StripeClient.ts` with singleton pattern
- Implemented lazy initialization - Stripe SDK initialized on first `getInstance()` call
- Added comprehensive key validation (format check + test API call)
- Discovered: Stripe SDK v12 changed API - using `paymentIntents` instead of deprecated `charges`
- Added utility method `maskApiKey()` for safe logging
- Performance: Singleton initialization takes ~50ms (acceptable for lazy init)

**Files Modified**:
- `src/integrations/stripe/StripeClient.ts` - Created new file (187 lines)
- `src/config/env.ts` - Added STRIPE_API_KEY and STRIPE_API_TIMEOUT_MS validation
- `src/integrations/stripe/index.ts` - Barrel export for clean imports
- `scripts/stripe-client.scripts.ts` - Created test file with connection verification

**Verification**:
- ✅ All tests passing in stripe-client.scripts.ts
- ✅ API key validation working correctly (rejects invalid keys)
- ✅ Singleton pattern verified (same instance returned on multiple calls)
- ✅ Timeout configuration working (tested with slow network simulation)
- ✅ Connection to Stripe test API successful
- ✅ Code review completed by team

**Bugs Discovered**:
None in current scope, but found issue in existing ErrorHandler (see Pre-Implementation Tasks in Iteration 2)

---

### 🚧 Iteration 2: Error Handling

**Goal**: Implement comprehensive error handling and error taxonomy mapping

**Status**: 🚧 IN PROGRESS (Implementing)

---

#### Pre-Implementation Tasks

These tasks MUST be completed BEFORE starting main implementation of this iteration.

---

##### ✅ Pre-Task 1: Refactor Legacy ErrorHandler

**Completed**: 2025-01-14

**Why Blocking**: Current ErrorHandler class doesn't support async retry logic needed for Stripe API calls

**Scope** (< 30 min):
- Update ErrorHandler.ts to support async error handlers
- Add `retryAsync()` method
- Update 3 existing call sites to use new async pattern

**Files**:
- `src/utils/ErrorHandler.ts` - Add async support
- `src/services/BillingService.ts` - Update to use retryAsync()
- `src/services/PaymentService.ts` - Update to use retryAsync()
- `tests/utils/ErrorHandler.test.ts` - Add async tests

**Test**: Run existing test suite to ensure no regressions

**Changes Made**:
- Added `retryAsync<T>(fn: () => Promise<T>, options)` method to ErrorHandler
- Updated ErrorHandler to handle Promise-based operations
- Migrated BillingService and PaymentService to use retryAsync()
- All existing tests pass + 5 new async tests added
- No breaking changes to existing sync error handling

---

#### Brainstorming Session - Error Handling Strategy

**Focus**: Design error taxonomy, retry logic, and error recovery patterns

**Subjects to Discuss**:
(All subjects resolved)

**Resolved Subjects**:

---

##### ✅ Subject 1: Error Taxonomy

**Decision**: Map Stripe errors to domain-specific error types using ErrorMapper class

**Resolution Type**: D (Iteration Action Items)

**Rationale**:
- Decouples domain logic from Stripe SDK (enables future provider switching)
- Provides consistent error handling across application
- Enables easier testing with mocked errors
- Business logic doesn't need to know about Stripe-specific error codes

**Error Categories**:
- `PaymentDeclinedError` - Card declined (insufficient funds, incorrect details, etc.)
- `PaymentAuthenticationError` - 3D Secure or authentication required
- `PaymentProcessingError` - Stripe API or network error (retryable)
- `PaymentConfigurationError` - API key or configuration issue (not retryable)
- `PaymentValidationError` - Invalid request parameters (not retryable)

**Action Items**:
- [x] Create `ErrorMapper` class in src/integrations/stripe/
- [x] Define domain error types in src/errors/
- [x] Map all Stripe error codes to domain errors
- [x] Add tests for error mapping (all Stripe error codes covered)

---

##### ✅ Subject 2: Retry Strategy

**Decision**: Implement exponential backoff with 3 retries for transient errors only

**Resolution Type**: D (Iteration Action Items)

**Rationale**:
- Exponential backoff prevents overwhelming Stripe API during issues
- 3 retries balances reliability (handle transient failures) with user experience (don't wait too long)
- Retry delays: 1s, 2s, 4s (total 7s max additional wait)
- Only retry transient errors (network issues, 5xx responses), not permanent errors (4xx client errors)

**Retry Decision Logic**:
- Retry: Network timeout, Stripe 500/502/503/504, rate limit (429)
- Don't retry: Card declined (402), invalid request (400), authentication errors (401)

**Action Items**:
- [x] Create `RetryPolicy` class with exponential backoff algorithm
- [x] Implement retry logic in StripeClient wrapper
- [x] Add configuration for max retries (default 3, configurable via env)
- [x] Add configuration for base delay (default 1000ms, configurable via env)
- [x] Log retry attempts with attempt number and delay
- [x] Add tests for retry scenarios (success after N retries, exhausted retries)

---

##### ✅ Subject 3: Error Logging

**Decision**: Log all errors with structured logging including request context and retry attempts

**Resolution Type**: D (Iteration Action Items)

**Rationale**:
- Structured logs enable better monitoring and debugging
- Request context (payment ID, user ID, amount) helps trace issues
- Retry attempt numbers help understand system behavior under failures
- Sensitive data (API keys, card numbers) must be redacted

**Log Format**:
```typescript
{
  level: 'error',
  message: 'Stripe API call failed',
  paymentId: 'pay_123',
  userId: 'user_456',
  stripeErrorCode: 'card_declined',
  retryAttempt: 2,
  timestamp: '2025-01-15T14:30:00Z'
}
```

**Action Items**:
- [x] Add structured logging to StripeClient
- [x] Log all API errors with full context
- [x] Redact sensitive data before logging
- [x] Add retry attempt number to logs
- [x] Integrate with existing logging infrastructure

---

##### ✅ Subject 4: Circuit Breaker Pattern

**Decision**: Skip circuit breaker for V1, defer to V2

**Resolution Type**: B (Documentation)

**Rationale**:
- Circuit breaker adds complexity (state management, monitoring, configuration)
- Stripe API has robust rate limiting and rarely has prolonged outages
- Our expected V1 volume (<100 requests/min) is low risk for cascade failures
- Retry logic with exponential backoff provides sufficient resilience for V1
- Can add circuit breaker in V2 when we have production metrics to tune thresholds

**Documentation Update**:
Added circuit breaker to PLAN.md V2 scope with reasoning and implementation notes

---

#### Implementation - Iteration 2: Error Handling

**Status**: 🚧 IN PROGRESS (2025-01-15)

**Action Items**: See resolved subjects above

**Implementation Notes**:
- Created `src/integrations/stripe/ErrorMapper.ts` (98 lines)
  - Comprehensive mapping of all Stripe error codes
  - Includes error code reference documentation
- Created `src/integrations/stripe/RetryPolicy.ts` (76 lines)
  - Exponential backoff algorithm implementation
  - Configurable via STRIPE_MAX_RETRIES and STRIPE_RETRY_BASE_DELAY_MS env vars
- Updated `src/integrations/stripe/StripeClient.ts` to use ErrorMapper and RetryPolicy
  - All API calls wrapped with retry logic
  - Errors mapped before thrown to service layer
- Created `src/errors/payment/` directory with domain error classes
  - PaymentDeclinedError
  - PaymentProcessingError
  - PaymentConfigurationError
  - PaymentValidationError
  - PaymentAuthenticationError
- Added structured logging to all error paths
  - Using existing logger with additional context fields
  - Sensitive data redaction working correctly
- Discovered: Stripe SDK throws different error types for network vs API errors, needed special handling

**Files Modified**:
- `src/integrations/stripe/StripeClient.ts` - Added error handling and retry (220 lines now, +33)
- `src/integrations/stripe/ErrorMapper.ts` - Created (98 lines)
- `src/integrations/stripe/RetryPolicy.ts` - Created (76 lines)
- `src/errors/payment/PaymentDeclinedError.ts` - Created (18 lines)
- `src/errors/payment/PaymentProcessingError.ts` - Created (18 lines)
- `src/errors/payment/PaymentConfigurationError.ts` - Created (18 lines)
- `src/errors/payment/PaymentValidationError.ts` - Created (18 lines)
- `src/errors/payment/PaymentAuthenticationError.ts` - Created (18 lines)
- `src/errors/payment/index.ts` - Barrel export (8 lines)
- `scripts/error-handling.scripts.ts` - Created test file (156 lines)
  - Tests all error mapping scenarios
  - Tests retry logic with simulated failures
  - Tests exhausted retry scenarios

**Verification** (In Progress):
- ✅ Error mapping tests passing (all Stripe error codes covered)
- ✅ Retry logic tests passing (success after retries, exhausted retries)
- ✅ Exponential backoff working correctly (measured actual delays)
- ✅ Structured logging working (verified log format)
- ✅ Sensitive data redaction working
- [ ] Integration test with real Stripe test API (in progress)
- [ ] Team code review (scheduled for 2025-01-16)

**Next Steps**:
1. Complete integration test with Stripe test API
2. Get code review approval
3. Mark iteration complete
4. Move to Iteration 3

---

### ⏳ Iteration 3: Advanced Retry Logic

**Goal**: Add jitter to exponential backoff and implement retry budget pattern

**Status**: ⏳ PENDING

**Note**: This iteration will be planned after Iteration 2 is complete. Initial thoughts:
- Add jitter to prevent thundering herd problem
- Implement retry budget to prevent excessive retries across all requests
- May defer some advanced features to V2 based on Iteration 2 outcomes

---

### ⏳ Iteration 4: Integration Tests

**Goal**: Comprehensive test coverage with Stripe API simulation

**Status**: ⏳ PENDING

**Note**: This iteration focuses on end-to-end integration testing:
- Simulate all Stripe API responses (success, errors, timeouts)
- Test retry logic with controlled network conditions
- Verify error mapping for all error codes
- Performance testing (measure API call latency with retries)

---

## Task Notes

**Discoveries**:
- Stripe SDK already implements connection pooling internally (no need for custom pool)
- Stripe SDK v12 uses `paymentIntents` API instead of deprecated `charges` API
- Error codes changed in Stripe API v2023-10-16 (updated error taxonomy accordingly)
- Stripe webhooks can deliver out of order (must handle idempotently in Task 4)
- Network timeouts throw different error type than API errors (needed special handling)

**Decisions**:
- Using Stripe Node SDK v12.18.0 (latest stable)
- NOT implementing custom connection pool (Stripe SDK handles it better)
- NOT implementing circuit breaker for V1 (defer to V2)
- Using exponential backoff over fixed delay (more efficient)
- Retry 3 times max (balance between reliability and user experience)

**Performance**:
- Stripe API calls average 200-300ms response time
- With 3 retries and exponential backoff, worst case is ~7s additional wait
- Total max time for payment call: 30s timeout + 7s retry delay = 37s (acceptable)
- Singleton initialization overhead: ~50ms (one-time cost)

**References**:
- Stripe API Docs: https://stripe.com/docs/api
- Stripe Error Codes: https://stripe.com/docs/error-codes
- Stripe Best Practices: https://stripe.com/docs/api/errors/handling
- Existing PayPal integration: `src/legacy/billing.ts` (learned webhook validation pattern)
- Similar retry logic: `src/utils/HttpClient.ts` (reused exponential backoff algorithm)

**Team Feedback**:
- Code review from @alice (2025-01-12): Suggested adding timeout configuration - added ✅
- Code review from @bob (2025-01-14): Requested more comprehensive error tests - added ✅
- Architecture review (2025-01-13): Approved singleton pattern and retry strategy ✅
