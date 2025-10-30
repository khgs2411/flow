---
name: flow-planner
description: Plan new features, tasks, and iterations in Flow framework. Use when user says "add task", "plan feature", "create iteration", "break this down", "how should we structure this", or wants to add new work to the plan. Guides task structure decisions (standalone vs iterations), suggests brainstorming for complex features, references planning slash commands.
---

# Flow Planner

Help users plan and structure new work in Flow framework projects. This Skill guides AI in understanding Flow's planning patterns and using appropriate slash commands for adding phases, tasks, and iterations.

## When to Use This Skill

Activate when the user wants to add new work:
- "Add a new task"
- "Plan this feature"
- "Create iterations for..."
- "Break this down into steps"
- "How should we structure this?"
- "Add this to the plan"
- "What's the best way to organize this work?"

## Planning Philosophy

**Flow's Core Principle**: Plan before code. Structure work hierarchically (phases → tasks → iterations) with clear boundaries and iterative refinement.

**Key Decision**: Every task is EITHER:
- **Standalone** - Direct action items, no iterations
- **Task with Iterations** - No direct action items, ONLY iterations

**NEVER mix both** - This is the Golden Rule.

## Task Structure Decision Tree

```
User wants to add work
    ↓
Is it complex/multi-step?
    ↓
YES → Task with Iterations
    ↓
    Break into 3-5 iterations
    Each iteration = milestone
    ↓
NO → Standalone Task
    ↓
    Direct action items
    Complete in one go
```

## Planning Slash Commands

### Core Commands

**`/flow-task-add [name]`**
- Creates new task file in current phase
- Use when: Adding new task to phase
- Prompts for: Standalone vs Iterations decision

**`/flow-iteration-add [name]`**
- Adds iteration to current task
- Use when: Breaking down complex task
- Creates: New iteration with goal, action items

**`/flow-phase-add [name]`**
- Creates new phase directory
- Use when: Major milestone or category of work
- Updates: DASHBOARD.md with new phase

**`/flow-brainstorm-start [topics]`**
- Begins design discussion
- Use when: Complex features need planning
- Helps: Make decisions before implementing

### When to Suggest Brainstorming

Use this decision tree to determine if brainstorming is needed:

```
User wants to add work
    ↓
Does it involve design decisions?
    ↓
YES → Brainstorm first
    ↓
    Multiple valid approaches?
    Trade-offs to discuss?
    Architectural impact?
    Integration complexity?
    ↓
    Use /flow-brainstorm-start
    ↓
NO → Direct implementation
    ↓
    Clear requirements?
    Single obvious approach?
    Isolated change?
    ↓
    Skip brainstorming
```

**Always suggest brainstorming for**:
- Complex features with multiple approaches
- Architectural decisions needed
- Integration with external systems
- Performance-critical features
- Features affecting multiple areas
- Database schema changes
- API contract design
- Error handling strategies
- Security-sensitive features

**Skip brainstorming for**:
- Simple additions (new file, basic function)
- Well-defined tasks (clear requirements)
- Repetitive work (similar to previous tasks)
- Bug fixes with obvious solutions
- Trivial refactoring

## Brainstorming Subject Resolution Types

When users DO need brainstorming, help them understand how subjects get resolved. There are 4 types:

### Type A: Pre-Implementation Task

**When**: Small blocking code change needed BEFORE iteration starts

**Criteria**:
- Required for iteration (blocking)
- Small scope (< 30 min)
- Can be done independently
- Examples: Fix interface, rename file, update enum, fix bug

**Example Subject**:
```markdown
Subject: Type Definition Updates

Decision: Need to update PaymentStatus enum to include new states

Resolution Type: A (Pre-Implementation Task)

Action Items:
- [ ] Update PaymentStatus enum in types.ts
- [ ] Update 4 switch statements to handle new states
- [ ] Add tests for new states
```

**What happens**: These action items go into "Pre-Implementation Tasks" section and must be completed BEFORE main implementation starts.

### Type B: Immediate Documentation

**When**: Architectural decision that affects system design

**Criteria**:
- No code changes yet
- Updates PLAN.md Architecture section NOW
- Examples: Design pattern choice, API contract, data model

**Example Subject**:
```markdown
Subject: Error Recovery Strategy

Decision: Implement retry with exponential backoff, no circuit breaker for V1

Resolution Type: B (Documentation)

Documentation Update:
Updated PLAN.md Architecture section with retry strategy diagram and V2 scope for circuit breaker
```

**What happens**: AI updates PLAN.md immediately during brainstorming, before implementation.

### Type C: Auto-Resolved

**When**: Subject answered by another subject's decision

**Criteria**:
- No independent decision needed
- Cascade from another subject
- Examples: Implementation detail determined by architecture choice

**Example Subject**:
```markdown
Subject: Retry Delay Calculation

Decision: Use exponential backoff as decided in Subject 1

Resolution Type: C (Auto-Resolved by Subject 1)
```

**What happens**: No action items, just note which subject resolved this.

### Type D: Iteration Action Items

**When**: Substantial feature work that IS the iteration

**Criteria**:
- Main implementation work
- Takes significant time (> 30 min)
- Examples: Build API endpoint, implement validator, create service

**Example Subject**:
```markdown
Subject: Retry Implementation

Decision: Implement RetryPolicy class with configurable backoff strategy

Resolution Type: D (Iteration Action Items)

Action Items:
- [ ] Create RetryPolicy class
- [ ] Implement exponential backoff algorithm
- [ ] Add configuration for max retries, base delay
- [ ] Integrate with StripeClient
- [ ] Add tests for retry scenarios
```

**What happens**: These action items become the iteration's implementation action items.

## Complexity Indicators

Help users recognize task complexity:

### Simple Task (No Brainstorming)

**Indicators**:
- Single file change
- Clear requirements from user
- No integration points
- < 1 hour to complete
- Similar to previous work

**Examples**:
- "Add a validation function"
- "Fix typo in error message"
- "Export existing function"
- "Add logging statement"

**Guidance**: "This looks straightforward - I suggest a standalone task with direct action items. No brainstorming needed."

### Complex Task (Needs Brainstorming)

**Indicators**:
- Multiple approaches possible
- Affects system architecture
- Integration with external services
- > 4 hours to complete
- User says "I'm not sure how to..."

**Examples**:
- "Add authentication system"
- "Integrate Stripe payments"
- "Implement caching layer"
- "Design database schema"

**Guidance**: "This is complex - I recommend brainstorming first. Let's use `/flow-brainstorm-start` to discuss: [list 3-5 subjects]."

### Borderline Task (Ask User)

**Indicators**:
- Moderate complexity (2-4 hours)
- Some design decisions needed
- User hasn't expressed preference

**Examples**:
- "Add error handling to API"
- "Refactor data layer"
- "Implement search feature"

**Guidance**: "This could go either way. We could brainstorm the approach first, or jump into iterations if you already have a clear vision. Which would you prefer?"

## Task Structure Patterns

### Pattern 1: Standalone Task

**Use when**: Simple, focused work

```markdown
# Task 3: Add Logging

**Status**: ⏳ PENDING

## Action Items
- [ ] Create logger utility
- [ ] Add log statements to main functions
- [ ] Test logging output
- [ ] Update documentation
```

**Characteristics**:
- Single focus area
- Clear action items
- Can complete in one session
- No need to break down further

### Pattern 2: Task with Iterations (Skeleton → Veins → Flesh)

**Use when**: Complex, multi-phase work

```markdown
# Task 3: API Integration

**Status**: ⏳ PENDING

## Iterations

### ⏳ Iteration 1: Skeleton - Basic API client
**Goal**: Minimal working connection

### ⏳ Iteration 2: Veins - Core endpoints
**Goal**: Essential CRUD operations

### ⏳ Iteration 3: Flesh - Error handling & retry
**Goal**: Production-ready reliability
```

**Characteristics**:
- Multiple milestones
- Each iteration is testable
- Progressive complexity
- Incremental value delivery

**NO direct action items in task** - Only in iterations

### Pattern 3: Task with Brainstorming

**Use when**: Design decisions needed

```markdown
# Task 2: Database Schema

**Status**: 🚧 IN PROGRESS

## Iterations

### 🚧 Iteration 1: Design schema structure
**Status**: 🚧 BRAINSTORMING

#### Brainstorming Session
**Subjects to Discuss**:
1. ⏳ Table relationships - One-to-many or many-to-many?
2. ⏳ Indexing strategy - Which fields to index?
3. ⏳ Migration approach - How to handle schema changes?
```

**When to use**:
- Multiple valid approaches exist
- Trade-offs need discussion
- User needs to make decisions

## Step-by-Step Planning Workflow

### Step 1: Understand the Request

Ask clarifying questions:
- "What's the goal of this feature?"
- "Are there any constraints or requirements?"
- "Does this build on existing work?"

### Step 2: Determine Complexity

**Simple** → Standalone task
**Complex** → Task with iterations
**Uncertain** → Suggest brainstorming first

### Step 3: Propose Structure

Present options to user:
```
I suggest structuring this as:

**Option A: Standalone Task** - "Add Feature X"
- Direct action items
- Single completion
- Estimated: 1-2 hours

**Option B: Task with 3 Iterations**
- Iteration 1: Basic implementation
- Iteration 2: Add advanced features
- Iteration 3: Polish and optimize
- Estimated: 4-6 hours

Which approach fits better?
```

### Step 4: Create the Structure

Use appropriate slash command:
- `/flow-task-add "Task Name"` - Create task
- Follow prompts for standalone vs iterations
- If iterations: `/flow-iteration-add "Iteration Name"` for each

### Step 5: Add Context

Help user fill in:
- **Purpose**: Why this task exists
- **Dependencies**: What it requires/blocks
- **Design Notes**: Key considerations
- **Action Items**: Concrete steps (standalone) or iteration goals (with iterations)

## Common Patterns

### Pattern: Feature Addition

```
User: "Add user authentication"

Response:
This is a complex feature - I suggest a task with 3 iterations:

1. Iteration 1: Basic login/logout (Skeleton)
2. Iteration 2: JWT tokens & session management (Veins)
3. Iteration 3: Password reset & email verification (Flesh)

Should we also brainstorm the auth approach first?
(OAuth, JWT, session-based, etc.)
```

### Pattern: Bug Fix

```
User: "Fix the pagination bug"

Response:
This sounds like a standalone task:

Task: Fix Pagination Bug
- [ ] Reproduce the issue
- [ ] Identify root cause
- [ ] Implement fix
- [ ] Add regression test
- [ ] Verify fix works

Does this structure work?
```

### Pattern: Refactoring

```
User: "Refactor the data layer"

Response:
This is complex - let's break it down:

Task: Refactor Data Layer (4 iterations)
1. Iteration 1: Extract interfaces
2. Iteration 2: Migrate to new pattern
3. Iteration 3: Update tests
4. Iteration 4: Remove old code

We should brainstorm:
- New architecture pattern
- Migration strategy
- Backwards compatibility

Should I start `/flow-brainstorm-start` for this?
```

## Best Practices

1. **Always clarify complexity** - Don't assume, ask user
2. **Suggest iterations for complex work** - Better to break down than have massive tasks
3. **Propose brainstorming when uncertain** - Design first, implement second
4. **Use Flow's metaphor** - Skeleton → Veins → Flesh
5. **Reference slash commands** - Guide user to use Flow's tools
6. **Keep iterations focused** - Each should have clear goal and completion criteria

## Task Structure Golden Rules

**DO**:
- ✅ Standalone task with action items
- ✅ Task with iterations (no direct action items)
- ✅ Each iteration has specific goal
- ✅ Iterations build on each other

**DON'T**:
- ❌ Mix action items and iterations in same task
- ❌ Create task with only 1 iteration (make it standalone)
- ❌ Make iterations too large (break down further)
- ❌ Skip brainstorming for complex features

## Iteration Sizing Guidelines

**Good Iteration Size**:
- Completable in 1-2 hours
- Clear completion criteria
- Testable milestone
- Adds incremental value

**Too Large** (split into multiple iterations):
- "Implement entire feature"
- "Build and test everything"
- No clear milestone

**Too Small** (combine or make standalone):
- "Add one line of code"
- "Rename a variable"
- Trivial changes

## Examples

### Example 1: User Asks to Add Feature

```
User: "I want to add real-time notifications"

AI Response:
Let me help you plan this feature. Real-time notifications is complex - I suggest:

**Task: Real-Time Notifications** (3 iterations)

**Iteration 1: Skeleton - WebSocket Connection**
- Goal: Establish basic WebSocket connection
- Action items:
  - Set up WebSocket server
  - Implement client connection
  - Basic ping/pong keepalive

**Iteration 2: Veins - Notification System**
- Goal: Core notification sending/receiving
- Action items:
  - Design notification message format
  - Implement server-side broadcast
  - Add client-side handlers

**Iteration 3: Flesh - UI & Polish**
- Goal: User-facing notification display
- Action items:
  - Create notification UI component
  - Add notification history
  - Implement dismiss/mark-read

Before we start, should we brainstorm:
- WebSocket library choice (ws, socket.io, native)?
- Notification types and priority system?
- Persistence strategy?

Use `/flow-task-add "Real-Time Notifications"` to create this structure.
```

### Example 2: User Asks to Fix Bug

```
User: "The search filter isn't working correctly"

AI Response:
This looks like a standalone task - focused bug fix:

**Task: Fix Search Filter Bug**

**Action Items**:
- [ ] Reproduce the bug with test case
- [ ] Debug the filter logic
- [ ] Identify root cause (likely query building)
- [ ] Implement fix
- [ ] Add unit test for this scenario
- [ ] Verify fix resolves issue

Estimated: 1-2 hours

Use `/flow-task-add "Fix Search Filter Bug"` to create this task.
```

### Example 3: User Unsure How to Structure

```
User: "I need to integrate with Stripe for payments"

AI Response:
Stripe integration is substantial - let's think through the structure:

**Two approaches**:

**Option A: Task with 4 Iterations** (Recommended)
- Iteration 1: Setup Stripe client & test connection
- Iteration 2: Implement payment processing
- Iteration 3: Add webhook handling
- Iteration 4: Error handling & edge cases

**Option B: Brainstorm First** (For complex decisions)
Run `/flow-brainstorm-start` to discuss:
- Payment flow (one-time vs subscription)
- Error handling strategy
- Webhook security
- Testing approach (Stripe test mode)

Which approach do you prefer? Or should we brainstorm first?
```

### Example 4: Guiding Brainstorming Subject Resolution

```
User: "Let's brainstorm the retry logic for API calls"

AI Response:
Great! Let's start brainstorming. I'll suggest some subjects:

Subjects to Discuss:
1. Retry Strategy - Exponential backoff vs fixed delay vs linear?
2. Error Classification - Which errors should trigger retry vs immediate fail?
3. Max Retry Attempts - How many retries before giving up?
4. Existing Error Handler - Need to update ErrorHandler.ts to support async?
5. Timeout Configuration - Per-request timeout vs total operation timeout?

Use `/flow-brainstorm-start` to begin. I'll help you categorize each decision:
- Type A: Pre-implementation tasks (must do before main work)
- Type B: Architecture docs (update PLAN.md now)
- Type C: Auto-resolved (answered by other decisions)
- Type D: Main implementation work (the actual iteration)

---

[After discussing Subject 4...]

User: "We need to update ErrorHandler.ts to support async operations"

AI Response:
This sounds like Type A (Pre-Implementation Task). Let me confirm:

✅ Is it blocking? YES - Can't implement retry logic without async support
✅ Is it small? YES - Estimated 20-30 minutes
✅ Can it be done independently? YES - Self-contained change

Resolution Type: A (Pre-Implementation Task)

Action Items:
- [ ] Update ErrorHandler.ts to support async operations
- [ ] Add retryAsync() method
- [ ] Update 3 existing call sites to use async version
- [ ] Add tests for async error handling

This will go into "Pre-Implementation Tasks" section and must be completed
BEFORE we run `/flow-implement-start`.

---

[After discussing Subject 1...]

User: "Let's use exponential backoff with base delay of 1 second"

AI Response:
This sounds like Type D (Iteration Action Items). Let me confirm:

✅ Is it substantial work? YES - Core feature implementation
✅ Does it take > 30 min? YES - Estimated 2-3 hours
✅ Is it the main iteration work? YES - This IS what we're building

Resolution Type: D (Iteration Action Items)

Action Items:
- [ ] Create RetryPolicy class
- [ ] Implement exponential backoff algorithm (base: 1s, max: 32s)
- [ ] Add configuration for max retries (default: 3)
- [ ] Integrate with API client
- [ ] Add tests for retry scenarios

These become the iteration's implementation action items.
```

## Interaction with Other Flow Commands

**Planning Stage** (This Skill):
- `/flow-task-add` - Create task
- `/flow-iteration-add` - Add iterations
- `/flow-brainstorm-start` - Design decisions

**Implementation Stage** (flow-implementer Skill):
- `/flow-implement-start` - Begin work
- `/flow-implement-complete` - Finish iteration

**Navigation Stage** (flow-navigator Skill):
- `/flow-status` - Check progress
- `/flow-next` - What to do next

## References

- **Task Structure Rules**: DEVELOPMENT_FRAMEWORK.md lines 238-566
- **Brainstorming Pattern**: DEVELOPMENT_FRAMEWORK.md lines 1167-1797
- **Complete Workflow**: DEVELOPMENT_FRAMEWORK.md lines 614-940
- **Quick Reference**: DEVELOPMENT_FRAMEWORK.md lines 1-353
