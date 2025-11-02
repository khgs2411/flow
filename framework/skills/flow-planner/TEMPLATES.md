# Flow Planning Templates

Ready-to-use templates for creating phases, tasks, and iterations using Flow framework. Copy and customize these structures for your planning needs.

## Template 1: Standalone Task

Use when: Simple, focused work that doesn't need breaking down

```markdown
# Task [N]: [Task Name]

**Status**: ⏳ PENDING
**Phase**: [Phase [N] - [Phase Name]](../DASHBOARD.md#phase-[n]-[phase-name])
**Purpose**: [Brief description of what this task accomplishes]

## Overview

[1-2 paragraphs explaining the task's context, why it's needed, and how it fits into the larger project]

## Action Items

- [ ] [Concrete action step 1]
- [ ] [Concrete action step 2]
- [ ] [Concrete action step 3]
- [ ] [Concrete action step 4]
- [ ] [Concrete action step 5]

## Notes

**Key Considerations**:
- [Important point to remember]
- [Trade-off or constraint]
- [Dependency or prerequisite]

**References**:
- [Link to related documentation]
- [Link to relevant framework section]
```

### Example: Standalone Task

```markdown
# Task 3: Add Request Logging

**Status**: ⏳ PENDING
**Phase**: [Phase 2 - Core Features](../DASHBOARD.md#phase-2-core-features)
**Purpose**: Add structured logging for all HTTP requests to aid debugging

## Overview

Currently, the application doesn't log HTTP requests, making it difficult to debug issues in production. This task adds middleware to log all incoming requests with relevant metadata (method, path, duration, status code).

## Action Items

- [ ] Create logging middleware function
- [ ] Add request ID generation
- [ ] Log request start (method, path, headers)
- [ ] Log request completion (status, duration)
- [ ] Add middleware to express app
- [ ] Test logging output format
- [ ] Update documentation

## Notes

**Key Considerations**:
- Use structured logging (JSON format)
- Don't log sensitive data (passwords, tokens)
- Include correlation IDs for request tracing

**References**:
- Express middleware docs
- Winston logging library
```

---

## Template 2: Task with Iterations

Use when: Complex, multi-step work that needs progressive refinement

```markdown
# Task [N]: [Task Name]

**Status**: ⏳ PENDING
**Phase**: [Phase [N] - [Phase Name]](../DASHBOARD.md#phase-[n]-[phase-name])
**Purpose**: [Brief description of what this task accomplishes]

## Overview

[1-2 paragraphs explaining the task's context, complexity, and why it's broken into iterations]

## Iterations

### ⏳ Iteration 1: [Skeleton] - [Minimal version]
**Goal**: [What minimal functionality this iteration delivers]
**Status**: ⏳ PENDING

#### Action Items
- [ ] [Core action 1]
- [ ] [Core action 2]
- [ ] [Core action 3]

### ⏳ Iteration 2: [Veins] - [Core functionality]
**Goal**: [What essential features this iteration adds]
**Status**: ⏳ PENDING

#### Action Items
- [ ] [Essential feature 1]
- [ ] [Essential feature 2]
- [ ] [Essential feature 3]

### ⏳ Iteration 3: [Flesh] - [Polish and edge cases]
**Goal**: [What production-ready features this iteration completes]
**Status**: ⏳ PENDING

#### Action Items
- [ ] [Polish item 1]
- [ ] [Edge case handling 1]
- [ ] [Final touches 1]

## Notes

**Task Structure**:
- This task follows Flow's iterative pattern: Skeleton → Veins → Flesh
- Each iteration is independently testable and adds value
- No direct action items in task - only in iterations

**Dependencies**:
- [Prerequisite work that must be complete]
- [Related tasks that affect this one]

**References**:
- [Link to related documentation]
- [Link to framework patterns]
```

### Example: Task with Iterations

```markdown
# Task 2: User Authentication System

**Status**: ⏳ PENDING
**Phase**: [Phase 1 - Foundation](../DASHBOARD.md#phase-1-foundation)
**Purpose**: Implement secure user authentication with JWT tokens

## Overview

The application needs a complete authentication system supporting user registration, login, logout, and token-based session management. This is complex enough to warrant iterative development, building from basic login to full production-ready auth.

## Iterations

### ⏳ Iteration 1: Skeleton - Basic Login/Logout
**Goal**: Minimal working login/logout with password hashing
**Status**: ⏳ PENDING

#### Action Items
- [ ] Create User model with password field
- [ ] Implement password hashing (bcrypt)
- [ ] Create POST /login endpoint
- [ ] Create POST /logout endpoint
- [ ] Add basic session storage
- [ ] Test login/logout flow

### ⏳ Iteration 2: Veins - JWT Tokens & Auth Middleware
**Goal**: Secure token-based authentication for protected routes
**Status**: ⏳ PENDING

#### Action Items
- [ ] Generate JWT tokens on login
- [ ] Create auth middleware to verify tokens
- [ ] Add token to response headers
- [ ] Implement token refresh logic
- [ ] Add protected route examples
- [ ] Test token validation

### ⏳ Iteration 3: Flesh - Registration & Password Reset
**Goal**: Complete auth system with all user flows
**Status**: ⏳ PENDING

#### Action Items
- [ ] Create POST /register endpoint
- [ ] Add email verification flow
- [ ] Implement forgot-password endpoint
- [ ] Create password reset token system
- [ ] Add rate limiting to auth endpoints
- [ ] Test complete user lifecycle

## Notes

**Task Structure**:
- Skeleton: Get basic auth working
- Veins: Add security and token management
- Flesh: Polish with registration and recovery flows

**Dependencies**:
- Database schema must be set up
- Email service configured (for Iteration 3)

**References**:
- JWT library: jsonwebtoken
- DEVELOPMENT_FRAMEWORK.md lines 567-613
```

---

## Template 3: Individual Iteration

Use when: Adding a new iteration to an existing task

```markdown
### ⏳ Iteration [N]: [Iteration Name]
**Goal**: [Clear, specific goal this iteration achieves]
**Status**: ⏳ PENDING

#### Action Items
- [ ] [Action step 1]
- [ ] [Action step 2]
- [ ] [Action step 3]
- [ ] [Action step 4]
- [ ] [Action step 5]

#### Design Notes
**Approach**: [Brief explanation of the implementation approach]

**Key Decisions**:
- [Important decision 1 and rationale]
- [Important decision 2 and rationale]

**Testing**: [How to verify this iteration works]
```

### Example: Individual Iteration

```markdown
### ⏳ Iteration 4: Add Redis Caching
**Goal**: Reduce database load by caching frequently accessed data
**Status**: ⏳ PENDING

#### Action Items
- [ ] Set up Redis client connection
- [ ] Identify cacheable queries (user profiles, product listings)
- [ ] Implement cache-aside pattern
- [ ] Add cache invalidation on updates
- [ ] Set appropriate TTLs for different data types
- [ ] Add cache hit/miss metrics
- [ ] Test cache behavior under load

#### Design Notes
**Approach**: Use cache-aside pattern where application checks cache first, then falls back to database. Invalidate cache entries on write operations.

**Key Decisions**:
- TTL: 5 minutes for user profiles, 1 hour for product listings
- Cache key format: `{resource}:{id}` (e.g., `user:123`)
- Invalidation: Delete on update, let expire on delete

**Testing**:
- Verify cache hits reduce DB queries
- Confirm stale data doesn't persist after updates
- Load test with Redis enabled vs disabled
```

---

## Template 4: Task with Brainstorming

Use when: Complex decisions need discussion before implementation

```markdown
# Task [N]: [Task Name]

**Status**: ⏳ PENDING
**Phase**: [Phase [N] - [Phase Name]](../DASHBOARD.md#phase-[n]-[phase-name])
**Purpose**: [Brief description]

## Overview

[Explanation of task and why it needs design discussion]

## Iterations

### ⏳ Iteration 1: Design [Core System]
**Goal**: Make key architectural decisions
**Status**: ⏳ PENDING

#### Brainstorming Session

**Subjects to Discuss**:
1. ⏳ **[Subject 1]** - [Key question to decide]
2. ⏳ **[Subject 2]** - [Trade-off to evaluate]
3. ⏳ **[Subject 3]** - [Approach to determine]

**Resolved Subjects**:
[Will be filled during `/flow-brainstorm-start`]

### ⏳ Iteration 2: Implement [Core]
**Goal**: Build based on design decisions
**Status**: ⏳ PENDING

#### Action Items
- [ ] [Implementation step 1]
- [ ] [Implementation step 2]
- [ ] [Implementation step 3]

### ⏳ Iteration 3: [Additional Features]
**Goal**: [Next increment]
**Status**: ⏳ PENDING

## Notes

**Why Brainstorming First**:
- [Reason brainstorming is valuable]
- [What decisions need discussion]
```

### Example: Task with Brainstorming

```markdown
# Task 1: Database Schema Design

**Status**: ⏳ PENDING
**Phase**: [Phase 1 - Foundation](../DASHBOARD.md#phase-1-foundation)
**Purpose**: Design normalized database schema supporting all product requirements

## Overview

The database schema is foundational - poor choices here create technical debt. We need to discuss relationships, indexing strategy, and migration approach before implementation.

## Iterations

### ⏳ Iteration 1: Design Schema Structure
**Goal**: Finalize table structure, relationships, and indexing
**Status**: ⏳ PENDING

#### Brainstorming Session

**Subjects to Discuss**:
1. ⏳ **User-Product Relationship** - One-to-many or many-to-many with junction table?
2. ⏳ **Indexing Strategy** - Which columns to index? Composite indexes needed?
3. ⏳ **Soft Deletes** - Use soft deletes (deleted_at) or hard deletes?
4. ⏳ **Timestamps** - What audit fields (created_at, updated_at, created_by)?
5. ⏳ **Migration Approach** - How to handle schema changes in production?

**Resolved Subjects**:
[Will be filled during brainstorming]

### ⏳ Iteration 2: Create Initial Migration
**Goal**: Implement decided schema in SQL migration
**Status**: ⏳ PENDING

#### Action Items
- [ ] Write SQL migration file
- [ ] Create database models (ORM)
- [ ] Add indexes per brainstorming decisions
- [ ] Test migration up/down
- [ ] Seed test data

### ⏳ Iteration 3: Add Constraints and Triggers
**Goal**: Production-ready schema with validation
**Status**: ⏳ PENDING

#### Action Items
- [ ] Add foreign key constraints
- [ ] Create database triggers for audit fields
- [ ] Add check constraints for data validation
- [ ] Test constraint enforcement
- [ ] Document schema design

## Notes

**Why Brainstorming First**:
- Schema changes are expensive once production data exists
- Trade-offs between normalization and performance need discussion
- Team alignment on conventions (soft deletes, audit fields) needed upfront
```

---

## Template 5: Phase Structure

Use when: Adding a new phase to the project

```markdown
# Phase [N]: [Phase Name]

**Goal**: [High-level goal this phase accomplishes]
**Status**: ⏳ PENDING
**Complexity**: [Simple / Medium / Complex]

## Overview

[2-3 paragraphs explaining:
- What this phase delivers
- Why it's a distinct phase
- How it relates to previous/next phases]

## Tasks

1. **Task 1**: [Task Name] - [Brief description]
2. **Task 2**: [Task Name] - [Brief description]
3. **Task 3**: [Task Name] - [Brief description]

## Success Criteria

This phase is complete when:
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]

## Dependencies

**Requires** (must be done first):
- [Prerequisite phase or work]

**Blocks** (waiting on this):
- [Dependent phases or work]

## Notes

**Estimated Duration**: [Time estimate]
**Risk Level**: [Low / Medium / High]
**Key Challenges**: [Anticipated difficulties]
```

---

## Usage Guidelines

### When to Use Each Template

**Standalone Task**:
- Bug fixes
- Simple feature additions
- Documentation updates
- Configuration changes
- Estimated < 2 hours

**Task with Iterations**:
- Complex features
- System integrations
- Architecture changes
- New modules/services
- Estimated > 2 hours

**Task with Brainstorming**:
- Architectural decisions
- Multiple valid approaches
- Performance-critical features
- External integrations
- Trade-offs need discussion

### Customization Tips

1. **Adjust iteration count** - Use 2-5 iterations based on complexity
2. **Add sections as needed** - Testing Strategy, Performance Notes, Security Considerations
3. **Reference framework docs** - Link to relevant DEVELOPMENT_FRAMEWORK.md sections
4. **Include examples** - Add code snippets or diagrams when helpful
5. **Keep action items atomic** - Each checkbox is a clear, completable step

### Common Mistakes to Avoid

❌ **DON'T**: Mix standalone and iteration patterns in same task
✅ **DO**: Choose one structure and stick with it

❌ **DON'T**: Create task with only 1 iteration
✅ **DO**: Make it standalone if there's only one phase

❌ **DON'T**: Have action items both in task AND in iterations
✅ **DO**: Action items only in iterations (for task-with-iterations pattern)

❌ **DON'T**: Make iterations too small (< 30 min) or too large (> 1 day)
✅ **DO**: Size iterations to 1-3 hours of focused work

## References

- **Task Structure Rules**: DEVELOPMENT_FRAMEWORK.md lines 238-566
- **Brainstorming Patterns**: DEVELOPMENT_FRAMEWORK.md lines 1167-1797
- **Complete Workflow**: DEVELOPMENT_FRAMEWORK.md lines 614-940
- **Status Markers Guide**: DEVELOPMENT_FRAMEWORK.md lines 1872-1968
