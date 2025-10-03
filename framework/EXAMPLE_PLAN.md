# Payment Gateway Integration - Development Plan

> **📖 Framework Guide**: See DEVELOPMENT_FRAMEWORK.md for complete methodology and patterns used in this plan
>
> **🎯 Purpose**: This is a reference example showing the Flow framework in action - demonstrating brainstorming sessions, iterations, pre-implementation tasks, bug discoveries, and state tracking

**Created**: 2025-10-01
**Version**: V1
**Plan Location**: `.flow/PLAN.md` (managed by Flow)

---

## Overview

**Purpose**: Integrate a third-party payment gateway (MockPay) into our e-commerce platform to enable secure online transactions.

**Goals**:
- Enable credit card payments through MockPay API
- Implement webhook handling for payment status updates
- Add payment retry logic for failed transactions
- Ensure PCI compliance for sensitive data handling

**Scope**:
- **Included**: MockPay integration, basic error handling, webhook system, transaction logging
- **Excluded**: Multiple payment providers (V2), saved payment methods (V2), subscription billing (V3)

---

## 📋 Progress Dashboard

**Last Updated**: 2025-10-01

**Current Work**:
- **Phase**: Phase 1 - Foundation → [Jump](#phase-1-foundation-)
- **Task**: Task 1 - Setup & API Integration → [Jump](#task-1-setup--api-integration-)
- **Iteration**: Iteration 2 - Basic Payment Flow → [Jump](#iteration-2-basic-payment-flow-)

**Completion Status**:
- Phase 1: 🚧 50% | Phase 2: ⏳ 0% | Phase 3: ⏳ 0%

**Progress Overview**:
- ✅ **Iteration 1**: Project Setup & SDK Integration (verified & frozen)
- 🚧 **Iteration 2**: Basic Payment Flow ← **YOU ARE HERE**
- ⏳ **Iteration 3-5**: Webhook system, error handling, testing

**V1 Remaining Work**:
1. Complete Iteration 2 (basic payment flow)
2. Implement Iteration 3 (webhook system)
3. Implement Iteration 4 (error handling)
4. Phase 2: Advanced features
5. Phase 3: Testing & polish

**V2 Deferred Items**:
1. Task 6: Multiple Payment Providers (complexity - abstraction layer needed)
2. Task 7: Saved Payment Methods (out of V1 scope - security considerations)
3. Task 8: Subscription Billing (V3 - recurring payments infrastructure)

**Cancelled Items**:
None

---

## Architecture

**High-Level Design**:
- Service-oriented architecture with dedicated `PaymentService`
- Webhook processor as separate background job
- Transaction state machine for payment lifecycle management
- Event-driven notifications for payment status changes

**Key Components**:
1. **PaymentService** - Core payment processing logic
2. **MockPayAdapter** - Third-party API integration layer
3. **WebhookProcessor** - Handles async payment notifications
4. **TransactionRepository** - Persists payment records
5. **PaymentEventEmitter** - Publishes payment events to message bus

**Dependencies**:
- MockPay Node.js SDK (v3.2.1)
- Express.js for webhook endpoints
- Redis for webhook deduplication
- PostgreSQL for transaction storage

---

## Testing Strategy

**Methodology**: Integration tests + Manual QA

**Approach**:
- **Integration Tests**: Created after each iteration using Jest
- **Location**: `tests/integration/payment/` directory
- **Naming Convention**: `{feature}.integration.test.ts` (e.g., `payment-creation.integration.test.ts`)
- **When to create**: After iteration implementation complete and working, if test file doesn't exist
- **When to add**: If test file already exists for the feature, add new test cases to existing file
- **Coverage**: Focus on happy path + critical error cases (insufficient funds, network errors, webhook failures)
- **Manual QA**: Final end-to-end verification in staging environment before deployment

**Test Execution**:
```bash
npm run test:integration                 # Run all integration tests
npm run test:integration:payment         # Payment tests only
```

**File Structure**:
```
tests/integration/payment/
├── payment-creation.integration.test.ts       # Payment creation tests
├── webhook-handling.integration.test.ts       # Webhook tests
└── payment-retry.integration.test.ts          # Retry logic tests (create if new feature)
```

**Verification Per Iteration**:
Each iteration's "Verification" section will include:
1. Integration test file created (if new feature) or updated (if enhancement)
2. Test cases passing (list specific scenarios)
3. Manual QA checklist (if applicable)

**IMPORTANT**:
- ✅ Create `tests/integration/payment/new-feature.integration.test.ts` for new features
- ✅ Add test cases to existing files for enhancements to existing features
- ❌ Do NOT create tests before implementation (we write tests after code works)
- ❌ Do NOT create unit tests (focus on integration tests only)

**Why This Approach**:
- Integration tests catch real API interaction issues
- Writing tests after implementation allows for faster prototyping
- Manual QA ensures user experience quality before production

---

## Development Plan

### Phase 1: Foundation 🚧

**Status**: IN PROGRESS
**Started**: 2025-10-01
**Completed**: (in progress)

**Strategy**: Set up core infrastructure and basic payment flow

**Goal**: Enable simple payment processing without advanced features

---

#### Task 1: Setup & API Integration ✅

**Status**: COMPLETE
**Completed**: 2025-10-01
**Purpose**: Establish connection to MockPay and implement basic payment creation

---

##### Iteration 1: Project Setup & SDK Integration ✅

**Status**: COMPLETE
**Completed**: 2025-10-01
**Goal**: Install dependencies and configure MockPay credentials

---

### **Brainstorming Session - API Setup** ✅

**Status**: COMPLETE

**Subjects to Discuss**:

1. ✅ **Credential Management** - RESOLVED
2. ✅ **SDK vs Raw HTTP** - RESOLVED
3. ✅ **Environment Configuration** - RESOLVED
4. ❌ **Custom HTTP Client** - REJECTED (SDK is sufficient)

**Resolved Subjects**:

---

### ✅ **Subject 1: Credential Management**

**Decision**: Use environment variables with .env file + secret manager in production

**Resolution Type**: B (Immediate Documentation)

**Rationale**:
- Industry standard approach (12-factor app)
- Easy to rotate credentials without code changes
- Prevents accidental commits of secrets to git
- Integrates well with deployment pipelines

**Options Considered**:
- **Option A**: Hardcoded in config files ❌ REJECTED (security risk)
- **Option B**: Environment variables ✅ CHOSEN
- **Option C**: Database configuration ❌ REJECTED (chicken-egg problem for DB credentials)

**Action Items**:
- [x] Add `MOCKPAY_API_KEY` and `MOCKPAY_SECRET` to .env.example
- [x] Create .env file and add to .gitignore
- [x] Document credential setup in README.md
- [x] Add validation on startup to ensure credentials are present

---

### ✅ **Subject 2: SDK vs Raw HTTP**

**Decision**: Use official MockPay SDK for V1, abstract behind adapter pattern

**Resolution Type**: D (Iteration Action Items)

**Rationale**:
- SDK handles authentication, retries, and rate limiting automatically
- Reduces development time for V1
- Adapter pattern allows swapping to custom HTTP client later if needed
- SDK is well-maintained (last updated 2 weeks ago)

**Options Considered**:
- **Option A**: Raw HTTP with axios ❌ REJECTED (reinventing the wheel)
- **Option B**: Official SDK with adapter pattern ✅ CHOSEN
- **Option C**: Third-party wrapper library ❌ REJECTED (adds extra dependency)

**Action Items**:
- [x] Install `@mockpay/node-sdk@3.2.1`
- [x] Create `MockPayAdapter` class implementing `PaymentGatewayInterface`
- [x] Add TypeScript types for adapter methods
- [x] Write unit tests for adapter initialization

---

### ✅ **Subject 3: Environment Configuration**

**Decision**: Use NODE_ENV with separate .env files per environment

**Resolution Type**: B (Immediate Documentation)

**Rationale**:
- Clear separation of concerns
- Standard Node.js convention
- Easy to understand for new developers
- Works well with CI/CD pipelines

**Action Items**:
- [x] Create .env.development, .env.staging, .env.production templates
- [x] Add dotenv-flow package for automatic env file loading
- [x] Document environment setup in CONTRIBUTING.md

---

### ❌ **Subject 4: Custom HTTP Client**

**Status**: REJECTED

**Reason**: Building custom HTTP client would duplicate functionality already provided by MockPay SDK. SDK handles authentication, retry logic with exponential backoff, rate limiting, and request signing automatically. Reimplementing these features would be time-consuming and error-prone.

**Decision**: Use MockPay SDK (Subject 2) instead. If custom HTTP implementation is needed later (e.g., for performance optimization or multi-provider abstraction), it can be added in V2 behind the existing adapter interface.

**Rejected on**: 2025-10-01

---

### **Implementation - Iteration 1** ✅

**Status**: COMPLETE
**Completed**: 2025-10-01

**Action Items**:
- [x] Add MOCKPAY_API_KEY and MOCKPAY_SECRET to .env.example
- [x] Create .env file and add to .gitignore
- [x] Document credential setup in README.md
- [x] Add validation on startup to ensure credentials are present
- [x] Install @mockpay/node-sdk@3.2.1
- [x] Create MockPayAdapter class implementing PaymentGatewayInterface
- [x] Add TypeScript types for adapter methods
- [x] Write unit tests for adapter initialization
- [x] Create .env.development, .env.staging, .env.production templates
- [x] Add dotenv-flow package for automatic env file loading
- [x] Document environment setup in CONTRIBUTING.md

**Implementation Notes**:

Discovered that MockPay SDK has a sandbox mode that can be enabled via flag, added `MOCKPAY_SANDBOX=true` to development environment. This will prevent accidental charges during testing.

Also added a health check endpoint `/api/payment/health` that verifies API connectivity without making actual requests.

**Files Modified**:
- `package.json` - Added mockpay SDK and dotenv-flow dependencies
- `src/config/mockpay.ts` - Created configuration loader with validation
- `src/adapters/MockPayAdapter.ts` - Implemented adapter class (127 lines)
- `src/types/PaymentGateway.ts` - Defined interface for payment gateways
- `tests/unit/MockPayAdapter.test.ts` - Added 8 test cases
- `.env.example` - Documented required environment variables
- `.gitignore` - Added .env* to ignore list
- `README.md` - Added setup instructions
- `CONTRIBUTING.md` - Documented environment configuration

**Verification**: All 8 unit tests passing. Successfully connected to MockPay sandbox environment and retrieved account details.

**Completed**: 2025-10-01

---

##### Iteration 2: Payment Creation Flow 🚧 IN PROGRESS

**Status**: IN PROGRESS
**Goal**: Implement API endpoints and service methods to create payment intents

---

### **Brainstorming Session - Payment Flow Design**

**Subjects to Discuss**:

1. ✅ **API Endpoint Structure** - RESTful design for payment operations
2. ✅ **Payment State Machine** - Lifecycle management (pending → processing → complete)
3. 🚧 **Error Handling Strategy** - How to handle API failures gracefully (CURRENT)
4. ⏳ **Idempotency Keys** - Preventing duplicate charges

**Resolved Subjects**:

---

### ✅ **Subject 1: API Endpoint Structure**

**Decision**: Use REST with POST /api/payments to create payment intents

**Resolution Type**: B (Immediate Documentation)

**Rationale**:
- Standard RESTful convention (POST = create resource)
- Returns payment intent ID that frontend can use with SDK
- Separation of concerns: backend creates intent, frontend confirms
- Aligns with MockPay's recommended integration pattern

**Options Considered**:
- **Option A**: Single endpoint `/api/pay` that does everything ❌ REJECTED (too much coupling)
- **Option B**: POST `/api/payments` to create intent, PUT `/api/payments/:id/confirm` to complete ✅ CHOSEN
- **Option C**: GraphQL mutation ❌ REJECTED (overkill for V1)

**Action Items**:
- [x] Define OpenAPI spec for POST /api/payments
- [x] Create Express router for payment endpoints
- [x] Add request validation middleware (amount, currency, metadata)
- [x] Implement PaymentService.createPaymentIntent() method

---

### ✅ **Subject 2: Payment State Machine**

**Decision**: Use enum-based state machine with explicit transitions

**Resolution Type**: D (Iteration Action Items)

**Rationale**:
- Makes valid state transitions explicit and enforceable
- Easier to debug payment issues by examining state history
- Prevents invalid state transitions (e.g., pending → refunded without complete)
- Foundation for future workflow features (partial refunds, disputes)

**States**: `PENDING → PROCESSING → COMPLETED | FAILED | CANCELLED`

**Transitions**:
```
PENDING → PROCESSING (payment initiated)
PROCESSING → COMPLETED (payment succeeded)
PROCESSING → FAILED (payment declined)
PENDING → CANCELLED (user cancelled)
COMPLETED → REFUNDING → REFUNDED (future V2)
```

**Action Items**:
- [x] Create PaymentStatus enum with all states
- [x] Define state transition validation function
- [x] Add created_at, updated_at, status_changed_at timestamps
- [x] Create database migration for payment_transactions table

---

### 🚧 **Subject 3: Error Handling Strategy** (CURRENT)

**Decision**: [To be resolved]

**Discussion in progress...**

Options being considered:
- **Option A**: Return generic errors to frontend, log details server-side
- **Option B**: Return detailed error codes that frontend can map to user messages
- **Option C**: Return both error code + safe message

Need to decide:
- How much detail to expose to frontend?
- What error codes do we need? (INSUFFICIENT_FUNDS, CARD_DECLINED, NETWORK_ERROR, etc.)
- Should we retry automatically or let user retry?

---

### **Pre-Implementation Tasks:**

#### ✅ Task 1: Refactor Config Module (COMPLETED)

**Objective**: Current config module doesn't support nested configuration objects. Need to refactor before adding payment config.

**Changes Made**:
- Migrated from flat key-value config to hierarchical structure
- Updated all existing services to use new config.get() API
- Added TypeScript interfaces for type-safe config access
- Updated 23 test files to use new config structure

**Verification**: All existing tests passing (187/187). No breaking changes in other services.

---

#### ⏳ Task 2: Add Request ID Middleware (PENDING)

**Objective**: Need request ID tracking for debugging payment flows across services

**Action Items**:
- [ ] Install express-request-id package
- [ ] Add middleware to Express app
- [ ] Update logger to include request ID in all log entries
- [ ] Update existing payment logging to use request ID

---

### **Implementation - Iteration 2**

**Status**: 🚧 IN PROGRESS

**Action Items**:
- [x] Define OpenAPI spec for POST /api/payments
- [x] Create Express router for payment endpoints
- [x] Add request validation middleware
- [x] Implement PaymentService.createPaymentIntent() method
- [x] Create PaymentStatus enum
- [x] Define state transition validation function
- [x] Add timestamps to transaction model
- [x] Create database migration
- [ ] Resolve error handling strategy
- [ ] Implement error handling in service layer
- [ ] Add integration tests for payment creation
- [ ] Update API documentation

**Implementation Notes**:

Created basic payment creation flow. Currently works for happy path (successful payment creation). Need to finalize error handling strategy before implementing failure cases.

**🚨 Scope Boundary Example** (Discovery during implementation):

While implementing payment validation middleware, I discovered that the existing `UserAuth.validateToken()` function has a bug - it doesn't check token expiration correctly.

**What I did**:
1. **STOPPED** implementation immediately
2. **NOTIFIED** user: "Found bug in UserAuth.validateToken() - doesn't check expiration. This is NOT part of Iteration 2 (payment flow). Should I: (A) Add as new brainstorming subject for next iteration, (B) Create pre-implementation task, (C) Fix now?"
3. **WAITED** for user decision
4. User chose: "Create pre-implementation task - we need it fixed before webhooks (Iteration 3)"
5. **CREATED** Pre-Implementation Task 3: "Fix UserAuth Token Expiration Bug"

**Why this matters**: If I had "helpfully" fixed the auth bug immediately, it would have:
- Added untracked changes to this iteration
- Made code review confusing ("why are auth changes in payment PR?")
- Potentially broken authentication for other services
- Violated Flow's principle of intentional, scoped changes

**Result**: Bug documented, will be fixed in proper scope, Iteration 2 stays focused on payment flow.

**Files Modified**:
- `src/routes/payment.routes.ts` - Payment API routes (78 lines)
- `src/services/PaymentService.ts` - Core service logic (143 lines, partial)
- `src/types/PaymentStatus.ts` - State machine enum and validation
- `migrations/002_create_payment_transactions.sql` - Database schema
- `docs/api/openapi.yaml` - API specification

**Verification**: Manual testing in Postman shows successful payment creation. Automated tests pending error handling decisions.

---

##### Iteration 3: Error Handling & Validation ⏳

**Status**: PENDING
**Goal**: Implement comprehensive error handling for payment failures

---

#### Task 2: Webhook Integration ⏳

**Status**: PENDING
**Purpose**: Handle asynchronous payment status updates from MockPay

---

##### Iteration 1: Webhook Endpoint & Signature Verification ⏳

**Status**: PENDING
**Goal**: Create secure webhook receiver endpoint

---

##### Iteration 2: Webhook Processing & Event Emission ⏳

**Status**: PENDING
**Goal**: Process webhook payloads and emit internal events

---

##### Iteration 3: Webhook Retry & Deduplication ⏳

**Status**: PENDING
**Goal**: Handle webhook delivery guarantees and prevent duplicate processing

---

### Phase 2: Core Implementation ⏳

**Strategy**: Build out remaining payment features and edge cases

**Goal**: Production-ready payment system with monitoring and logging

---

#### Task 1: Transaction Logging & Audit Trail ⏳

**Status**: PENDING
**Purpose**: Complete audit trail of all payment operations for compliance

---

#### Task 2: Payment Retry Logic ⏳

**Status**: PENDING
**Purpose**: Automatic retry for transient failures

---

### Phase 3: Testing & Validation ⏳

**Strategy**: Comprehensive testing across all scenarios

**Goal**: Confidence in production deployment

---

#### Task 1: Integration Tests ⏳

**Status**: PENDING
**Purpose**: End-to-end tests with MockPay sandbox

---

#### Task 2: Load Testing ⏳

**Status**: PENDING
**Purpose**: Verify system handles production traffic volumes

---

### Phase 4: Enhancement & Polish 🔮 FUTURE

**Strategy**: V2 features and optimizations

**Goal**: Advanced payment features for better UX

**Deferred Tasks**:
- Multiple payment provider support (Stripe, PayPal)
- Saved payment methods / tokenization
- Recurring billing / subscriptions
- Partial refunds
- Payment disputes handling
- Advanced fraud detection

---

## Testing Strategy

**V1 Testing**:
- [x] Unit tests for adapter layer (8 tests)
- [x] Unit tests for state machine (5 tests)
- [ ] Integration tests for payment creation flow
- [ ] Integration tests for webhook processing
- [ ] Manual testing with MockPay test cards
- [ ] Security audit of credential handling

**V2 Testing** (Deferred):
- [ ] Load tests (1000 concurrent payments)
- [ ] Chaos engineering tests (simulate API downtime)
- [ ] PCI compliance validation

---

## Future Enhancements (V2+)

**Phase 4: Enhancement & Polish** (FUTURE)

**Deferred Features**:
- [ ] Multi-provider support (Stripe, PayPal, etc.)
- [ ] Saved payment methods with tokenization
- [ ] Subscription billing engine
- [ ] Partial and split refunds
- [ ] Payment dispute management
- [ ] ML-based fraud detection
- [ ] Apple Pay / Google Pay integration
- [ ] International payment methods (Alipay, WeChat Pay)

---

## Notes & Learnings

**Design Decisions**:
- **Adapter pattern for gateway**: Allows swapping payment providers in V2 without rewriting business logic
- **State machine for payments**: Explicit transitions prevent invalid states and make debugging easier
- **Sandbox mode by default**: Discovered during implementation, prevents accidental charges in dev

**Challenges Encountered**:
- **Config refactoring needed**: Had to refactor config module before adding payment config (added as pre-implementation task)
- **MockPay SDK quirks**: SDK requires explicit sandbox flag, not documented clearly in their main guide

**Improvements Over Original** (if refactoring):
- N/A - This is a new feature implementation

---

## Changelog

**2025-10-01** - Phase 1, Task 1, Iteration 1 complete
- Implemented MockPay SDK integration
- Created adapter pattern for payment gateway
- Set up environment configuration
- Added 8 unit tests for adapter layer
- Discovered sandbox mode feature

**2025-10-01** - Phase 1, Task 1, Iteration 2 in progress
- Started brainstorming session for payment flow
- Resolved API endpoint structure (RESTful)
- Resolved payment state machine design
- Created database schema migration
- Completed pre-implementation task: config refactoring
- Currently resolving error handling strategy
- Implemented basic payment creation endpoint (happy path only)

---

**Next Steps**:
- Complete brainstorming for error handling strategy
- Finish Iteration 2 implementation
- Move to Iteration 3: Error handling & validation
