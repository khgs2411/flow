# Subject Resolution Types

Deep dive on the four types of brainstorming subject resolutions (A/B/C/D).

## Overview

When brainstorming, each subject must be resolved with one of four types. The type determines what happens next with the decision.

| Type | Name | Outcome | Timing |
|------|------|---------|--------|
| A | Pre-Implementation Task | Small blocking work BEFORE iteration | Done before main implementation |
| B | Immediate Documentation | Update PLAN.md NOW | Done during brainstorming |
| C | Auto-Resolved | No action (answered by another subject) | Already resolved |
| D | Iteration Action Items | Main feature work | Done during implementation |

## Type A: Pre-Implementation Task

### Definition

Small blocking code changes that must be done BEFORE the iteration's main implementation can start.

### Criteria (All 3 must be true)

✅ **Required for iteration** (blocking)
- Cannot start main work without this
- Main implementation depends on this being done

✅ **Small scope** (< 30 min)
- Quick change, not a full feature
- Typically affects 1-3 files

✅ **Can be done independently**
- Self-contained change
- Doesn't require the full iteration context

### Examples

**Example 1: Type Definition Update**
```markdown
Subject: Payment Status Enum

**Question**: Need to add new payment states for retry logic?

**Decision**: Add PENDING_RETRY and FAILED_PERMANENT to PaymentStatus enum

**Resolution Type**: A (Pre-Implementation Task)

**Why Type A**:
- ✅ Blocking: Retry logic needs these states to function
- ✅ Small: 5-minute change (update enum, 4 switch statements)
- ✅ Independent: Can update enum without retry implementation

**Action Items**:
- [ ] Update PaymentStatus enum in types.ts
- [ ] Add PENDING_RETRY and FAILED_PERMANENT
- [ ] Update 4 switch statements to handle new states
- [ ] Add tests for new states
```

**Example 2: Interface Fix**
```markdown
Subject: API Client Interface

**Question**: Current APIClient doesn't support async retry callbacks?

**Decision**: Add async callback support to APIClient interface

**Resolution Type**: A (Pre-Implementation Task)

**Why Type A**:
- ✅ Blocking: Retry logic requires async callback support
- ✅ Small: 15-minute change (update interface, 2 implementations)
- ✅ Independent: Interface change doesn't require retry implementation

**Action Items**:
- [ ] Update APIClient interface with async callback support
- [ ] Update HttpClient implementation
- [ ] Update MockClient implementation for tests
```

### What Goes into Pre-Implementation Tasks Section

```markdown
#### Pre-Implementation Tasks

**Status**: ⏳ PENDING

These must be completed BEFORE starting main implementation:

- [ ] Update PaymentStatus enum (Subject 2)
- [ ] Add async callback support to APIClient (Subject 4)
- [ ] Rename ErrorHandler to AsyncErrorHandler (Subject 7)

**Estimated Time**: 30-45 minutes total
```

### Workflow

1. During brainstorming, identify Type A subjects
2. When brainstorming completes, collect all Type A action items
3. Create "Pre-Implementation Tasks" section
4. Mark iteration status: ⏳ PENDING
5. Complete ALL pre-tasks
6. Mark pre-tasks section: ✅ COMPLETE
7. Update iteration status: 🎨 READY
8. THEN start main implementation

## Type B: Immediate Documentation

### Definition

Architectural decisions that shape the system design. These get documented in PLAN.md IMMEDIATELY during brainstorming, not during implementation.

### Criteria (Any 2 or more)

✅ **System-wide impact**
- Affects multiple features or components
- Sets precedent for future work

✅ **Technology choice**
- Picking libraries, frameworks, tools
- Choosing between approaches (REST vs GraphQL)

✅ **Design pattern adoption**
- Architectural pattern (MVC, Event-Driven, etc.)
- Code organization approach

✅ **High-level abstraction**
- API contracts, interfaces
- Data models, database schema
- System boundaries

### Examples

**Example 1: Technology Choice**
```markdown
Subject: Retry Library vs Custom Implementation

**Question**: Use existing retry library or build custom?

**Decision**: Build custom RetryPolicy class

**Rationale**:
- Existing libraries (retry, async-retry) too generic
- Need tight integration with error classification
- Want exponential backoff with custom jitter
- Library overhead not justified for our simple needs

**Resolution Type**: B (Immediate Documentation)

**PLAN.md Update** (done NOW):
```markdown
### Retry Mechanism

**Decision**: Custom RetryPolicy class (not external library)

**Rationale**:
- Tight integration with error classification system
- Custom exponential backoff with jitter
- Simpler than adding library dependency for basic needs

**Trade-offs**:
- **Chosen**: Custom implementation
  - Pros: Full control, simple, no dependencies
  - Cons: We maintain the code
- **Not chosen**: retry library
  - Pros: Battle-tested, feature-rich
  - Cons: Generic (not tailored to our needs), overhead

**DO**:
- Use exponential backoff for transient errors
- Add jitter to prevent thundering herd
- Make retry config injectable for testing

**DON'T**:
- Retry on permanent failures (4xx errors except 429)
- Retry infinitely (max 3 attempts)
- Block other requests while retrying
```
```

**Example 2: Data Model Decision**
```markdown
Subject: User Session Storage

**Question**: Store sessions in memory, Redis, or database?

**Decision**: Redis for session storage

**Rationale**:
- Need fast session lookups (< 10ms)
- Sessions expire (TTL built into Redis)
- Horizontal scaling requires shared state
- Database too slow for every request

**Resolution Type**: B (Immediate Documentation)

**PLAN.md Update** (done NOW):
```markdown
### Session Management

**Decision**: Redis for session storage with 7-day TTL

**Rationale**:
- Sub-10ms lookups required for performance
- Built-in TTL matches session expiry needs
- Shared state enables horizontal scaling
- Database (500ms avg) too slow for per-request lookups

**Trade-offs**:
- **Chosen**: Redis
  - Pros: Fast, TTL support, scalable
  - Cons: Additional infrastructure, volatile
- **Not chosen**: Database
  - Pros: Durable, existing infrastructure
  - Cons: Too slow (500ms vs 5ms)
- **Not chosen**: In-memory
  - Pros: Fastest, simple
  - Cons: Can't scale horizontally, lost on restart

**DO**:
- Set 7-day TTL on sessions
- Use Redis cluster for high availability
- Implement session refresh on activity

**DON'T**:
- Store sensitive data (only session tokens)
- Use for permanent data (use database)
- Assume sessions persist forever
```
```

### What to Update in PLAN.md

See [PLAN_UPDATES.md](PLAN_UPDATES.md) for detailed templates. Key sections:

1. **Architecture Section** - Add decision with rationale
2. **DO/DON'T Guidelines** - Add patterns learned
3. **Technology Choices** - Document why chosen/not chosen
4. **Testing Strategy** - If testing approach decided

### Workflow

1. During brainstorming, user makes architectural decision
2. Identify as Type B (architectural impact)
3. **Immediately** read PLAN.md
4. Update appropriate section with decision + rationale
5. Mark subject ✅ RESOLVED (with PLAN.md reference)
6. Continue with next subject

**Key**: Type B happens DURING brainstorming, not later!

## Type C: Auto-Resolved

### Definition

Subjects that are answered by another subject's decision. No independent decision needed - the answer is implied.

### Criteria

✅ **No independent decision**
- Answer determined by previous subject
- Consequence of another choice

✅ **Cascade relationship**
- "If we chose X, then Y must be Z"
- Implementation detail flowing from architecture choice

### Examples

**Example 1: Implementation Detail**
```markdown
Subject 1: Retry Strategy (Type D)
**Decision**: Exponential backoff starting at 1 second

---

Subject 5: Retry Delay Calculation (Type C)

**Question**: How to calculate delay between retries?

**Decision**: Use exponential formula from Subject 1

**Resolution Type**: C (Auto-Resolved by Subject 1)

**Explanation**:
Subject 1 decided exponential backoff with base 1s.
Formula: `delay = 1s * (2 ^ attempt_number)`
Max delay: 32s (after 5 attempts: 1s, 2s, 4s, 8s, 16s, 32s)

No additional decision needed - implementation covered by Subject 1.
```

**Example 2: Consequential Choice**
```markdown
Subject 2: Session Storage = Redis (Type B)
**Decision**: Use Redis for session storage

---

Subject 8: Session Serialization Format (Type C)

**Question**: How to serialize session data?

**Decision**: JSON (standard for Redis)

**Resolution Type**: C (Auto-Resolved by Subject 2)

**Explanation**:
Subject 2 chose Redis for sessions.
Redis stores strings, JSON is standard practice.
No decision needed - follow Redis conventions.
```

### What Happens

```markdown
##### Subject 5: Retry Delay Calculation

**Status**: ✅ RESOLVED (Auto-Resolved by Subject 1)

**Decision**: Exponential backoff formula from Subject 1

**Resolution Type**: C

**No Action Items** (implementation covered by Subject 1)
```

### Workflow

1. User asks about something that was already decided
2. AI recognizes cascade from previous subject
3. Mark as Type C and reference which subject resolved it
4. No action items needed
5. Move to next subject

## Type D: Iteration Action Items

### Definition

The main feature work - substantial implementation that IS the iteration's purpose. This is the "meat" of what you're building.

### Criteria (Any 2 or more)

✅ **Substantial scope** (> 30 min, typically hours)
- Core feature implementation
- Multiple components affected

✅ **Main iteration goal**
- This IS what the iteration is about
- Central to the feature being built

✅ **Implementation-focused**
- Actual coding work
- Building the feature

### Examples

**Example 1: Core Feature**
```markdown
Subject: Retry Logic Implementation

**Question**: How to implement the retry mechanism?

**Decision**: Create RetryPolicy class with exponential backoff and error classification

**Resolution Type**: D (Iteration Action Items)

**Why Type D**:
- ✅ Substantial: 3-4 hours of implementation
- ✅ Main goal: This IS what "Add Retry Logic" iteration is about
- ✅ Implementation: Core coding work

**Action Items**:
- [ ] Create RetryPolicy class with config (max attempts, base delay)
- [ ] Implement exponential backoff algorithm with jitter
- [ ] Integrate with ErrorClassifier to determine retryable errors
- [ ] Add retry() method that wraps async operations
- [ ] Implement circuit breaker pattern for repeated failures
- [ ] Add RetryMetrics for monitoring (attempts, successes, failures)
- [ ] Write unit tests for retry scenarios (success after N attempts, max retries exceeded)
- [ ] Write integration tests with real API calls
- [ ] Add logging for retry attempts and outcomes
- [ ] Update API client to use RetryPolicy
```

**Example 2: Feature Implementation**
```markdown
Subject: Webhook Delivery System

**Question**: How to implement reliable webhook delivery?

**Decision**: Queue-based delivery with retry and dead-letter queue

**Resolution Type**: D (Iteration Action Items)

**Why Type D**:
- ✅ Substantial: Full feature, 6-8 hours
- ✅ Main goal: Iteration is "Webhook Delivery"
- ✅ Implementation: Complete system to build

**Action Items**:
- [ ] Create WebhookQueue class using BullMQ
- [ ] Implement WebhookDelivery service with HTTP client
- [ ] Add retry logic (3 attempts with exponential backoff)
- [ ] Create dead-letter queue for failed deliveries
- [ ] Add webhook signature generation (HMAC-SHA256)
- [ ] Implement webhook event types (user.created, payment.succeeded, etc.)
- [ ] Add webhook delivery status tracking (pending, delivered, failed)
- [ ] Create admin API to view delivery status and retry manually
- [ ] Write tests for delivery, retries, and failures
- [ ] Add monitoring and alerts for delivery rate
```

### What Goes into Iteration Action Items Section

```markdown
#### Action Items

- [ ] Create RetryPolicy class with config (Subject 1)
- [ ] Implement exponential backoff algorithm (Subject 1)
- [ ] Integrate with ErrorClassifier (Subject 1, Subject 3)
- [ ] Add retry() method wrapping async operations (Subject 1)
- [ ] Add RetryMetrics for monitoring (Subject 6)
- [ ] Write unit tests for retry scenarios (Subject 1)
- [ ] Write integration tests with real API (Subject 1)
- [ ] Update API client to use RetryPolicy (Subject 1)
```

### Workflow

1. During brainstorming, identify main feature work as Type D
2. When brainstorming completes, collect all Type D action items
3. Add to iteration's "Action Items" section
4. These become the implementation checklist
5. Execute during `/flow-implement-start`
6. Check off as completed
7. Verify all done before `/flow-implement-complete`

## Decision Flow chart

```
Is this a small blocking change needed first?
    ↓ YES → Type A (Pre-Implementation Task)
    ↓ NO
    ↓
Is this an architectural decision affecting system design?
    ↓ YES → Type B (Immediate Documentation)
    ↓ NO
    ↓
Is this already answered by another subject?
    ↓ YES → Type C (Auto-Resolved)
    ↓ NO
    ↓
Is this substantial implementation work (main goal)?
    ↓ YES → Type D (Iteration Action Items)
```

## Common Mistakes

### ❌ Mistake 1: Confusing A and D

**Wrong**: Marking "Update ErrorHandler" as Type D because it involves coding
**Right**: It's Type A (small, blocking, independent prerequisite)

**How to tell**: Ask "Is this blocking main work?" + "Can I do this in < 30 min?"

### ❌ Mistake 2: Not Using Type B

**Wrong**: Keeping architectural decisions only in brainstorming notes
**Right**: Document in PLAN.md immediately (Type B)

**How to tell**: Ask "Will future developers need to know this?" + "Does it affect system design?"

### ❌ Mistake 3: Everything as Type D

**Wrong**: Making every subject Type D with action items
**Right**: Use A/B/C when appropriate

**How to tell**: Not everything is main implementation work. Look for prerequisites (A), architecture (B), and cascades (C).

## Summary Table

| Type | When | Outcome | Example |
|------|------|---------|---------|
| **A** | Small blocking prerequisite | Pre-Implementation Tasks section | Update enum before using it |
| **B** | Architectural decision | PLAN.md updated immediately | Choose Redis for sessions |
| **C** | Answered by another subject | No action (reference other subject) | Formula determined by strategy choice |
| **D** | Main feature work | Iteration Action Items section | Build retry policy class |

## Examples in Context

See SKILL.md Examples section for complete brainstorming sessions showing all four types in action.
