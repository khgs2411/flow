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

<!-- ESSENTIAL: Always keep this updated with current phase/task/iteration -->
**Current Work**:

- **Phase**: [Phase 1 - Foundation](#phase-1-foundation-)
- **Task**: [Task 1 - Setup & API Integration](#task-1-setup--api-integration-)
- **Iteration**: [Iteration 2 - Basic Payment Flow](#iteration-2-basic-payment-flow-) 🚧 IN PROGRESS

**Completion Status**:

- Phase 1: 🚧 50% | Phase 2: ⏳ 0% | Phase 3: ⏳ 0%

**Progress Overview**:

- 🚧 **Phase 1**: Foundation ← **YOU ARE HERE**
  - ✅ Task 1: Setup & API Integration (2/3 iterations complete)
    - ✅ Iteration 1: Project Setup & SDK Integration
    - 🚧 Iteration 2: Basic Payment Flow ← **CURRENT**
    - ⏳ Iteration 3: Error Handling & Validation
  - ⏳ Task 2: Webhook Integration (0/3 iterations)
- ⏳ **Phase 2**: Core Implementation
  - ⏳ Task 1: Transaction Logging & Audit Trail
  - ⏳ Task 2: Payment Retry Logic
- ⏳ **Phase 3**: Testing & Validation
  - ⏳ Task 1: Integration Tests
  - ⏳ Task 2: Load Testing
- 🔮 **Phase 4**: Enhancement & Polish (DEFERRED TO V2)
  - 🔮 Task 1: Multiple Payment Providers
  - 🔮 Task 2: Saved Payment Methods
  - 🔮 Task 3: Subscription Billing (V3)

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

**Action Items**: See resolved subjects above (Subjects 1, 2, 3 - all Type B/D items completed)

**Implementation Notes**:
- Discovered MockPay SDK sandbox mode - added `MOCKPAY_SANDBOX=true` for dev
- Added health check endpoint `/api/payment/health` for connectivity testing

**Files Modified**:
- `src/adapters/MockPayAdapter.ts` - Adapter implementation (127 lines)
- `src/config/mockpay.ts` - Config loader with validation
- `tests/unit/MockPayAdapter.test.ts` - 8 test cases
- Environment setup: .env.example, README.md, CONTRIBUTING.md

**Verification**: All 8 unit tests passing. Connected to MockPay sandbox successfully.

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

**Rationale**: Explicit state transitions prevent invalid states, easier debugging, foundation for V2 refunds

**States**: `PENDING → PROCESSING → COMPLETED | FAILED | CANCELLED` (+ REFUNDING/REFUNDED in V2)

**Action Items**:
- [x] Create PaymentStatus enum with state transition validation
- [x] Add timestamps (created_at, updated_at, status_changed_at)
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

**Objective**: Refactor config module to support nested configuration for payment settings

**Changes**: Migrated to hierarchical structure, updated 23 test files, added TypeScript interfaces

**Verification**: All 187 tests passing

---

#### ⏳ Task 2: Add Request ID Middleware (PENDING)

**Objective**: Add request ID tracking for debugging payment flows

**Action Items**: Install express-request-id, add middleware, update logger

---

### **Implementation - Iteration 2**

**Status**: 🚧 IN PROGRESS

**Action Items**: See resolved subjects above (Subjects 1, 2 - Type D items; Subject 3 in progress)

**Implementation Notes**:
- Created basic payment creation flow (happy path working)
- Error handling strategy still being resolved (Subject 3 in progress)

**🚨 Scope Boundary Example**: Discovered bug in `UserAuth.validateToken()` (doesn't check expiration). Instead of fixing immediately:
1. STOPPED implementation
2. NOTIFIED user - not part of Iteration 2 scope
3. User decided: Create pre-implementation task for Iteration 3
4. Documented bug, stayed focused on payment flow

**Why this matters**: Prevents scope creep, keeps iterations focused, tracks all changes intentionally.

**Files Modified**:
- `src/services/PaymentService.ts` - Core logic (143 lines, partial)
- `src/routes/payment.routes.ts` - API routes (78 lines)
- Database migration, API spec

**Verification**: Manual testing successful. Automated tests pending error handling completion.

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

---

## Future Enhancements (V2+)

**Deferred to V2/V3**:
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

**2025-10-01**:
- ✅ Iteration 1: MockPay SDK integration, adapter pattern, 8 unit tests
- 🚧 Iteration 2: Payment flow design, state machine, basic endpoint (in progress)
