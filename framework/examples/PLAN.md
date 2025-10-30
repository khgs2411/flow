# Payment Gateway Integration - Development Plan

> **📖 Framework Guide**: See [DEVELOPMENT_FRAMEWORK.md](DEVELOPMENT_FRAMEWORK.md) for complete Flow methodology
> **📍 Current Progress**: See [DASHBOARD.md](DASHBOARD.md) for real-time status tracking
> **🎯 Purpose**: Integrate Stripe payment processing with credit card support and webhook handling

**Created**: 2025-01-08
**Version**: V1
**Plan Location**: `.flow/` (managed by Flow framework)

---

## Overview

### Purpose

Build a production-ready payment gateway integration that allows our platform to accept credit card payments through Stripe. The system must handle synchronous payment processing, asynchronous webhook notifications for payment events, and provide robust error handling with retry logic for transient failures.

This integration is critical for monetization and must meet PCI compliance requirements while maintaining <2s response time for payment operations.

### Goals

**Primary Goals**:
- [ ] Process credit card payments via Stripe API with <2s response time
- [ ] Handle webhook events for async payment state notifications (payment succeeded, failed, refunded)
- [ ] Implement automatic retry logic for transient API failures (3 attempts, exponential backoff)
- [ ] Maintain 99.9% payment processing success rate (excluding card declines)
- [ ] Ensure PCI compliance through proper token handling (no raw card data stored)

**Success Criteria**:
- Payment processing works end-to-end in production
- All webhook events handled correctly with idempotency
- Error rate < 0.1% (excluding legitimate declines)
- Test coverage > 85% for payment critical paths
- Security audit passed for PCI compliance

### Scope

**V1 Scope** (Current - MVP for Launch):
- Credit card payment processing (charges API)
- Basic subscription support (create, cancel)
- Webhook handler for critical events:
  - `payment_intent.succeeded`
  - `payment_intent.failed`
  - `charge.refunded`
- Retry logic: 3 attempts with exponential backoff (1s, 2s, 4s)
- Error handling: Map Stripe errors to domain errors
- Basic authentication with API keys
- USD currency only
- Payment history storage in PostgreSQL

**V2 Scope** (Post-Launch Enhancements):
- Advanced subscription management:
  - Plan upgrades/downgrades with proration
  - Dunning logic for failed renewals
  - Grace periods for payment failures
- Circuit breaker pattern for API resilience
- Multi-currency support (EUR, GBP, CAD)
- ACH/bank transfer support
- Saved payment methods (tokenized cards)
- Advanced webhook events (subscription lifecycle, disputes)
- Real-time payment notifications via WebSocket

**V3+ Scope** (Long-term Vision):
- Multiple payment providers (PayPal, Apple Pay, Google Pay)
- Payment analytics dashboard
- Fraud detection integration
- Installment payments
- Invoice generation and management

**Explicitly Out of Scope**:
- Cryptocurrency payments (no current business need)
- Buy-now-pay-later (BNPL) integrations (V3+)
- International tax calculation (separate service)
- Manual payment reconciliation (accounting team handles)

---

## Architecture

### System Design

The payment gateway integration follows a layered architecture with clear separation of concerns:

**Layer 1: API Layer** (`src/api/payment/`)
- REST endpoints for payment operations
- Request validation and sanitization
- Authentication and rate limiting
- Response formatting

**Layer 2: Service Layer** (`src/services/payment/`)
- Business logic orchestration
- State management (pending → processing → succeeded/failed)
- Validation rules (amount limits, currency checks)
- Audit logging

**Layer 3: Integration Layer** (`src/integrations/stripe/`)
- Stripe API client wrapper
- Error mapping (Stripe errors → domain errors)
- Retry logic implementation
- Webhook signature verification

**Layer 4: Data Layer** (`src/repositories/payment/`)
- Payment persistence
- Transaction management
- Query optimization
- Database migrations

### Components

**Core Components**:

- **PaymentService** (`src/services/payment/PaymentService.ts`)
  - Responsibility: Orchestrate payment processing flow
  - Key methods: `createPayment()`, `processPayment()`, `refundPayment()`
  - Dependencies: StripeClient, PaymentRepository
  - State management: Handles payment lifecycle states

- **StripeClient** (`src/integrations/stripe/StripeClient.ts`)
  - Responsibility: Stripe API wrapper with resilience patterns
  - Key methods: `createCharge()`, `createSubscription()`, `handleWebhook()`
  - Patterns: Singleton, retry with exponential backoff
  - Configuration: API key from environment, timeout settings

- **WebhookHandler** (`src/integrations/stripe/WebhookHandler.ts`)
  - Responsibility: Process incoming Stripe webhook events
  - Key methods: `verifySignature()`, `processEvent()`, `handleIdempotency()`
  - Security: HMAC signature validation
  - Idempotency: Event deduplication using event IDs

- **PaymentRepository** (`src/repositories/payment/PaymentRepository.ts`)
  - Responsibility: Payment data persistence
  - Key methods: `save()`, `findById()`, `updateStatus()`
  - Transactions: ACID guarantees for payment state changes
  - Indexes: Optimized for payment ID and user ID lookups

- **ErrorMapper** (`src/integrations/stripe/ErrorMapper.ts`)
  - Responsibility: Translate Stripe errors to domain errors
  - Decouples business logic from Stripe SDK
  - Enables consistent error handling across the application

### Interactions & Data Flow

**Payment Processing Flow**:
```
1. User Request → API Endpoint (/api/payment/create)
   ↓
2. PaymentController validates request
   ↓
3. PaymentService.createPayment()
   - Validate amount, currency, user
   - Create payment record (status: pending)
   ↓
4. StripeClient.createCharge()
   - Call Stripe API
   - Retry on transient failures (3x with exponential backoff)
   ↓
5. Handle Response:
   - Success: Update payment (status: succeeded)
   - Failure: Update payment (status: failed), log error
   ↓
6. PaymentRepository.save()
   - Persist state in database (transaction)
   ↓
7. Return response to user
```

**Webhook Event Flow**:
```
1. Stripe webhook → /api/webhooks/stripe
   ↓
2. WebhookHandler.verifySignature()
   - Validate HMAC signature
   - Reject if invalid (403)
   ↓
3. WebhookHandler.checkIdempotency()
   - Check if event already processed
   - Return 200 if duplicate
   ↓
4. WebhookHandler.processEvent()
   - Parse event type
   - Route to appropriate handler
   ↓
5. Update payment state asynchronously
   - PaymentService.handleWebhookEvent()
   - PaymentRepository.updateStatus()
   ↓
6. Return 200 OK to Stripe
```

### Key Dependencies

**Internal Dependencies**:
- **Existing Auth Service** (`src/services/auth/`): User authentication and authorization
  - What we need: User ID validation, API key generation
  - Integration point: Middleware for protected endpoints

- **Existing Billing Service** (`src/services/billing/`): Subscription and invoice management
  - What we need: Subscription data model, billing cycles
  - Integration point: PaymentService calls BillingService after successful payment

- **Database Service** (`src/database/`): PostgreSQL connection and migrations
  - What we need: Transaction support, migration framework
  - Integration point: PaymentRepository uses existing connection pool

**External Dependencies**:
- **Stripe Node SDK** (v12.18.0): Official Stripe API client
  - Why: Industry-standard, well-maintained, includes TypeScript types
  - License: MIT
  - Alternatives considered: Axios + manual API calls (rejected - reinventing wheel)

- **Express.js** (v4.18.2): HTTP framework (existing dependency)
  - Why: Already in use, webhook middleware support

- **PostgreSQL** (v14+): Database (existing dependency)
  - Why: ACID transactions critical for payment operations

**Reference Implementations**:
- **Existing PayPal Integration** (`src/legacy/billing.ts`):
  - Learn from: Webhook signature validation pattern
  - Avoid: Tight coupling to payment provider SDK (abstract behind interface)

- **Shipment Webhook Handler** (`src/webhooks/shipment.ts`):
  - Reuse: Idempotency pattern using event IDs
  - Reuse: Event processing queue structure

### Data Model

**Core Entities**:

**Payment** (`src/entities/Payment.ts`):
```typescript
{
  id: UUID
  userId: UUID
  stripePaymentIntentId: string
  amount: number (cents)
  currency: string (ISO 4217)
  status: PaymentStatus (pending | processing | succeeded | failed | refunded)
  failureReason?: string
  metadata: JSON
  createdAt: timestamp
  updatedAt: timestamp
}
```

**PaymentStatus Enum**:
- `pending`: Payment created, not yet submitted to Stripe
- `processing`: Submitted to Stripe, awaiting response
- `succeeded`: Payment completed successfully
- `failed`: Payment failed (card declined, API error, etc.)
- `refunded`: Payment was refunded

**WebhookEvent** (`src/entities/WebhookEvent.ts`):
```typescript
{
  id: UUID
  stripeEventId: string (unique - for idempotency)
  eventType: string (payment_intent.succeeded, etc.)
  payload: JSON
  processedAt: timestamp
  createdAt: timestamp
}
```

**Relationships**:
- User (1) → (N) Payment: One user has many payments
- Payment (1) → (N) WebhookEvent: One payment can have multiple related events
- Payment (1) → (1) Subscription (optional): Some payments are subscription-related

---

## Testing Strategy

**Methodology**: Simulation-based testing with mocked Stripe API responses

**Approach**: Each service has dedicated test file in `scripts/` directory that simulates real-world scenarios without hitting live Stripe API. This allows fast iteration during development and comprehensive coverage of edge cases.

**Test Location**: `scripts/`

**Naming Convention**: `{service}.scripts.ts`
- Examples: `payment.scripts.ts`, `stripe.scripts.ts`, `webhook.scripts.ts`

**Coverage Goals**:
- Unit tests: 85% minimum
- Integration tests: All critical payment paths (happy path + key error scenarios)
- E2E tests: Smoke tests for deployment validation

**Test Scenarios**:

**Happy Path** (Must Cover):
- [ ] Successful credit card charge
- [ ] Successful subscription creation
- [ ] Webhook event processing (payment succeeded)
- [ ] Webhook event idempotency (duplicate events)
- [ ] Successful refund

**Edge Cases** (Must Cover):
- [ ] Partial payment (amount limits)
- [ ] Currency validation
- [ ] Concurrent payment requests for same user
- [ ] Webhook signature validation failure
- [ ] Stripe API rate limiting (429 responses)

**Error Conditions** (Must Cover):
- [ ] Card declined (insufficient funds)
- [ ] Card declined (incorrect CVC)
- [ ] Stripe API timeout
- [ ] Stripe API 5xx errors (retry logic)
- [ ] Network failures (transient)
- [ ] Database transaction rollback
- [ ] Invalid webhook signature (reject)

**✅ DO**:
- Create `payment.scripts.ts` for PaymentService tests
- Create `stripe.scripts.ts` for StripeClient retry logic tests
- Create `webhook.scripts.ts` for WebhookHandler tests
- Simulate Stripe API responses (success, errors, timeouts)
- Test retry logic with controlled delays
- Verify webhook signature validation with test secrets
- Test idempotency with duplicate event IDs

**❌ DO NOT**:
- Test against live Stripe API in development (use Stripe test mode API keys for integration tests only)
- Skip testing retry logic (critical for resilience)
- Skip testing webhook signature validation (critical for security)
- Mix tests from different services in one file

---

## Development Phases

**Note**: Detailed tasks and iterations are in phase directories. This section provides high-level phase summaries.

### Phase 1: Foundation ✅ COMPLETE

**Strategy**: Establish solid foundation before building payment features

**Goal**: Set up project structure, core data models, and development environment to enable smooth Phase 2 implementation

**Duration**: 1 week (completed)

**Key Deliverables**:
- Repository structure with feature-based organization
- Core entity models (Payment, WebhookEvent)
- Database migrations and schema
- Development environment setup (Stripe test keys, local DB)
- Testing framework and simulation scripts structure

**Tasks**: See [phase-1/](phase-1/) directory for detailed task files
- Task 1: Project Setup (3 iterations)
- Task 2: Core Models (2 iterations)

**Learnings**:
- Chose singleton pattern for StripeClient (connection pooling)
- Decided on repository pattern for data access (ACID guarantees)
- Set up TypeScript strict mode (catch type errors early)

---

### Phase 2: Core Implementation 🚧 IN PROGRESS

**Strategy**: Build payment processing and webhook handling with robust error handling

**Goal**: Complete end-to-end payment flow from API request to database persistence, including webhook event processing

**Duration**: 3 weeks (2 weeks remaining)

**Key Deliverables**:
- Payment processing API endpoint
- Stripe API integration with retry logic
- Webhook handler with signature verification
- Error handling and error mapping
- Authentication and authorization

**Tasks**: See [phase-2/](phase-2/) directory for detailed task files
- Task 1: Database Layer ✅ COMPLETE (2 iterations)
- Task 2: Business Logic ✅ COMPLETE (3 iterations)
- Task 3: API Integration 🚧 IN PROGRESS (4 iterations)
- Task 4: Webhook Handler ⏳ PENDING (3 iterations)
- Task 5: Authentication ⏳ PENDING (3 iterations)

**Current Focus**: Task 3, Iteration 2 - Error Handling

**Decisions Made**:
- Using exponential backoff for retry (1s, 2s, 4s)
- Mapping Stripe errors to domain errors (decoupling)
- Deferring circuit breaker to V2 (complexity vs value)

---

### Phase 3: Testing & Hardening ⏳ PENDING

**Strategy**: Comprehensive testing and production readiness validation

**Goal**: Achieve 85%+ test coverage, validate all error scenarios, and ensure production readiness with performance testing and security audit

**Duration**: 2 weeks (starts after Phase 2)

**Key Deliverables**:
- Complete test suite (unit, integration, E2E)
- Error scenario coverage (card declines, API failures, etc.)
- Performance testing (load testing, response time validation)
- Security audit for PCI compliance
- Deployment runbook and monitoring setup
- User documentation

**Tasks**: See [phase-3/](phase-3/) directory for detailed task files (to be created)
- Task 1: Test Suite (comprehensive coverage)
- Task 2: Error Scenarios (all edge cases)
- Task 3: Performance Testing (load, response time)
- Task 4: Documentation (API docs, runbooks)

---

## Notes & Learnings

**Design Decisions**:

- **2025-01-08**: Chose Stripe over other payment providers
  - Rationale: Best-in-class documentation, well-supported SDK, lower fees for our volume
  - Considered: PayPal (higher fees), Braintree (more complex), Square (less flexible)

- **2025-01-09**: Singleton pattern for StripeClient
  - Rationale: Stripe SDK manages connection pooling internally, multiple instances wasteful
  - Alternative considered: Factory pattern (rejected - unnecessary complexity)

- **2025-01-10**: Repository pattern for data access
  - Rationale: Abstracts database operations, enables easy testing, maintains ACID guarantees
  - Alternative considered: Direct Prisma calls (rejected - tight coupling)

- **2025-01-13**: Exponential backoff for retry logic
  - Rationale: Balances reliability (retries transient failures) with user experience (fails fast for permanent errors)
  - Configuration: 3 attempts max, delays 1s/2s/4s
  - Alternative considered: Fixed delay (rejected - less efficient)

- **2025-01-13**: Circuit breaker deferred to V2
  - Rationale: Adds complexity, Stripe API has good rate limiting, low risk of cascade failures for V1 scale
  - Revisit: When request volume > 1000/min or observing cascade failures

**Technical Discoveries**:

- Stripe SDK v12 changed from `charges` API to `paymentIntents` API (better 3DS support)
- Stripe webhooks can arrive out of order (must handle idempotently)
- Stripe test mode API keys start with `sk_test_`, production with `sk_live_`
- Webhook signature verification is critical (HMAC SHA-256)

**Performance Insights**:

- Stripe API calls average 200-300ms response time
- Database writes average 20-30ms
- End-to-end payment processing target: <2s (achievable)
- Webhook processing should be async (don't block Stripe's webhook delivery)

**Security Considerations**:

- Never log full API keys (mask with `sk_***...last4chars`)
- Validate webhook signatures before processing (prevent spoofing)
- Use HTTPS for all webhook endpoints (Stripe requirement)
- Store payment metadata, not raw card data (PCI compliance)

**References**:

- Stripe API Docs: https://stripe.com/docs/api
- Stripe Webhooks Guide: https://stripe.com/docs/webhooks
- Stripe Error Codes: https://stripe.com/docs/error-codes
- PCI Compliance: https://stripe.com/docs/security/guide
- Existing PayPal integration: `src/legacy/billing.ts`
- Similar webhook handler: `src/webhooks/shipment.ts`

---

## Future Enhancements (V2+)

**V2 Features** (Next 3-6 months):

1. **Multi-Currency Support**
   - **Description**: Support EUR, GBP, CAD in addition to USD
   - **Why deferred**: V1 focuses on US market only, multi-currency adds 2-3 weeks
   - **Dependencies**: Exchange rate API integration, currency conversion logic
   - **Estimated effort**: 3 weeks
   - **Priority**: High (international expansion planned Q2)

2. **Advanced Subscription Management**
   - **Description**: Plan upgrades/downgrades with proration, dunning logic
   - **Why deferred**: Basic subscriptions sufficient for V1, advanced features add complexity
   - **Dependencies**: Billing service integration
   - **Estimated effort**: 2 weeks
   - **Priority**: High (recurring revenue focus)

3. **Circuit Breaker Pattern**
   - **Description**: Stop retrying when Stripe API is consistently failing (prevent cascade)
   - **Why deferred**: Low volume in V1, not critical, adds state management complexity
   - **Dependencies**: Monitoring and alerting integration
   - **Estimated effort**: 1 week
   - **Priority**: Medium (implement when volume > 1000 req/min)

4. **Saved Payment Methods**
   - **Description**: Securely store tokenized cards for one-click payments
   - **Why deferred**: V1 focuses on one-time payments, saved cards add security complexity
   - **Dependencies**: Security audit, card management UI
   - **Estimated effort**: 2 weeks
   - **Priority**: Medium (user experience enhancement)

5. **ACH/Bank Transfer Support**
   - **Description**: Alternative payment method for large transactions
   - **Why deferred**: Lower priority than credit cards, ACH has longer settlement times
   - **Dependencies**: Different Stripe API integration (ACH vs cards)
   - **Estimated effort**: 2 weeks
   - **Priority**: Low (niche use case)

**V3 Features** (6-12 months):

1. **Multiple Payment Providers**
   - **Description**: Support PayPal, Apple Pay, Google Pay in addition to Stripe
   - **Why deferred**: Stripe sufficient for V1/V2, multiple providers increase maintenance
   - **Dependencies**: Payment provider abstraction layer
   - **Estimated effort**: 4-6 weeks
   - **Priority**: Medium (diversification)

2. **Payment Analytics Dashboard**
   - **Description**: Real-time analytics on payment volume, success rates, revenue
   - **Why deferred**: Focus on core functionality first, analytics are nice-to-have
   - **Dependencies**: Analytics infrastructure, data warehouse
   - **Estimated effort**: 3 weeks
   - **Priority**: Low (operational nice-to-have)

**Technical Debt**:

1. **Refactor PaymentService** (V3)
   - Some code duplication between charge and subscription flows
   - Wait until V2 when all use cases understood
   - Estimated: 3-4 days

2. **Optimize Database Indexes** (V2)
   - Add composite indexes for common query patterns
   - Wait until production usage patterns identified
   - Estimated: 1-2 days

See [BACKLOG.md](BACKLOG.md) for complete backlog details.
