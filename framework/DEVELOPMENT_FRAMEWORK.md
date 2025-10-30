<!-- AI_SCAN:QUICK_REFERENCE:1-600 -->
# Quick Reference for AI (Read This First!!)

> **Purpose**: This section provides essential Flow framework knowledge in ~600 lines instead of reading the entire file. Read this first, then use the Section Index to jump to specific sections only when needed.

> **NEW in Multi-File Architecture**: Flow now uses separate files (`DASHBOARD.md`, `PLAN.md`, `phase-N/task-N.md`) instead of a single monolithic `PLAN.md`. All commands follow a **dashboard-first** navigation pattern.

---

<!-- AI_SCAN:MULTI_FILE_STRUCTURE:12-85 -->
## Multi-File Structure Overview

Flow uses a **multi-file architecture** where work is split across focused files:

```
.flow/
├── DASHBOARD.md              # ⭐ USER'S MAIN WORKSPACE (single source of truth for progress)
├── PLAN.md                   # 📖 Static context (overview, architecture, scope)
├── BACKLOG.md                # 📦 Deferred/future tasks
├── ARCHIVE.md                # 🗄️ Completed work (created by /flow-plan-split)
├── phase-1/                  # 👤 USER'S WORK FILES
│   ├── task-1.md            # 📝 Task with iterations, brainstorming, implementation
│   ├── task-2.md
│   └── task-3.md
├── phase-2/                  # 👤 USER'S WORK FILES
│   ├── task-1.md
│   └── task-2.md
└── framework/                # 🤖 AI REFERENCE FILES (read-only for user)
    ├── DEVELOPMENT_FRAMEWORK.md  # 🎓 Complete methodology guide
    └── examples/             # 📚 Example files for AI to learn from
        ├── DASHBOARD.md
        ├── PLAN.md
        ├── phase-1/
        │   └── task-1.md
        └── phase-2/
            └── task-3.md
```

### File Purposes

**👤 USER'S FILES** (What you work in):

**DASHBOARD.md** (⭐ Most Important - Single Source of Truth):
- User spends most time here
- Shows current work pointer (Phase/Task/Iteration)
- Displays progress overview with ALL phases/tasks/iterations
- Key decisions needing user input
- **This is the ONLY place progress is tracked** - no duplication

**PLAN.md** (Static Context - Rarely Changes):
- Like CLAUDE.md but for this specific feature/project
- Purpose, Goals (text only, no checklists), Scope (V1 only)
- Architecture overview
- DO/DON'T guidelines
- Minimal and focused - no assumptions about future work

**phase-N/task-N.md** (Work Files - All Tasks Have Iterations):
- Contains task overview and dependencies
- **All tasks have iterations** (no standalone tasks)
- Each iteration has: Pre-tasks (optional) → Brainstorming (optional) → Action Items
- One Action Items section per iteration
- Brainstorming subjects produce "Resolution Items" → consolidated into Action Items

**BACKLOG.md** (Future Work):
- Tasks moved out of active plan
- Deferred features
- V2/V3 items (if user explicitly wants to track them)

**ARCHIVE.md** (Completed Work):
- Created by `/flow-plan-split`
- Archives all completed tasks
- Task files become references: "See ARCHIVE.md"

**🤖 AI REFERENCE FILES** (Read-only, for AI agents):

**framework/DEVELOPMENT_FRAMEWORK.md** (This File):
- Complete Flow methodology
- Templates, patterns, best practices
- AI reads this to understand how Flow works

**framework/examples/** (Example Project):
- Real example of Flow in use (payment gateway project)
- AI learns patterns from these examples
- Shows DASHBOARD.md, PLAN.md, and task file formats

---

<!-- AI_SCAN:CORE_HIERARCHY:88-110 -->
## Core Hierarchy

```
PHASE → TASK → ITERATION → BRAINSTORM → IMPLEMENTATION → COMPLETE
```

**Structure**:
- **PHASE**: High-level milestone (e.g., "Core Implementation", "Testing")
  - Lives in: DASHBOARD.md (overview) + `phase-N/` directory
- **TASK**: Feature/component to build (e.g., "Database Schema", "API Endpoints")
  - Lives in: `phase-N/task-N.md` file
- **ITERATION**: Incremental buildout (e.g., "V1: Basic validation", "V2: Advanced rules")
  - Lives in: Inside task file (`phase-N/task-N.md`)
- **BRAINSTORM**: Design before code (subjects → decisions → action items)
  - Lives in: Inside iteration section of task file
- **IMPLEMENTATION**: Execute action items from brainstorming
  - Lives in: Inside iteration section of task file

**Golden Rule**: Brainstorm → Pre-Tasks → Implementation (never skip brainstorming for complex work)

---

<!-- AI_SCAN:DASHBOARD_FIRST_PATTERN:113-165 -->
## Dashboard-First Navigation Pattern

**ALL commands follow this pattern**:

```
1. Read DASHBOARD.md (source of truth)
2. Extract current context:
   - Phase: Phase N
   - Task: Task M (in phase-N/ directory)
   - Iteration: Iteration K
3. Navigate to task file: phase-N/task-M.md
4. Perform operation (read/edit task file)
5. Update DASHBOARD.md with new state
```

**Example: `/flow-implement-start`**:
```
1. Read DASHBOARD.md
   → Current: Phase 2, Task 3, Iteration 2
2. Construct path: phase-2/task-3.md
3. Read phase-2/task-3.md
   → Find Iteration 2 section
4. Add Implementation subsection
5. Update DASHBOARD.md:
   - Change Iteration 2 status: ⏳ → 🚧
   - Update "Current Work" pointer
```

**Why Dashboard-First?**
- Single source of truth for project state
- User always knows where they are
- Commands don't need to search multiple files
- Consistent navigation across all commands

**Key Insight**: DASHBOARD.md is like an index - it tells you WHERE to find detailed work (which task file, which iteration).

---

<!-- AI_SCAN:STATUS_MARKERS:168-195 -->
## Status Markers

| Marker | Meaning | When to Use |
|--------|---------|-------------|
| ✅ | COMPLETE | Finished and verified (frozen, skip re-verification) |
| ⏳ | PENDING | Not started yet |
| 🚧 | IN PROGRESS | Currently working on this |
| 🎨 | READY | Brainstorming done, ready to implement |
| ❌ | CANCELLED | Decided against (must document WHY) |
| 🔮 | DEFERRED | Moved to V2/V3/later (must document WHY + WHERE - usually moved to BACKLOG.md) |
| 🎯 | ACTIVE | Current focus (optional, used in DASHBOARD.md) |

**Rules**:
- Every Phase/Task/Iteration/Subject MUST have a status marker
- ✅ COMPLETE items are verified & frozen (skip re-verification)
- ❌ CANCELLED and 🔮 DEFERRED must document reason
- Status appears in BOTH:
  - DASHBOARD.md (for overview)
  - Task file header (phase-N/task-M.md)

**Status Lifecycle**:
```
⏳ PENDING → 🚧 IN PROGRESS → ✅ COMPLETE
                ↓
              🎨 READY (for iterations with brainstorming)
```

---

<!-- AI_SCAN:TASK_STRUCTURE_QUICK:198-270 -->
## Task Structure Rules

**The Golden Rule**: **ALL tasks have iterations** - this provides consistent structure and enables iterative development.

### Task with Iterations (The Only Pattern)

**File**: `phase-N/task-N.md`
```markdown
# Task 3: Implement Payment Gateway

**Status**: 🚧 IN PROGRESS
**Phase**: [Phase 2 - Core Implementation](../DASHBOARD.md#phase-2-core-implementation)
**Purpose**: Integrate Stripe API for payment processing

---

## Task Overview

Build production-ready payment gateway integration.

**Why This Task**: Current system has no payment processing capability.

**Dependencies**:
- Requires: Task 1 (Database Layer)
- Blocks: Task 4 (Subscription System)

---

## Iterations

### ✅ Iteration 1: API Setup

**Goal**: Configure Stripe SDK and credentials
**Status**: ✅ COMPLETE

[Brainstorming → Action Items → Implementation sections below]

---

### 🚧 Iteration 2: Payment Processing

**Goal**: Implement charge creation and webhooks
**Status**: 🚧 IN PROGRESS

[Currently brainstorming...]
```

**Why iterations-only**:
- Consistent structure across all tasks
- Enables human-in-loop iteration (plan → brainstorm → implement → complete)
- Clear progress tracking (iteration status)
- Simple tasks just have 1-2 iterations with action items
- Complex tasks have multiple iterations with brainstorming

**Structure per iteration**:
1. **Pre-Implementation Tasks** (optional) - Quick fixes before starting
2. **Brainstorming Session** (optional) - Design decisions → Resolution Items
3. **Action Items** (required) - ONE list per iteration, consolidated from brainstorming or direct
4. **Implementation** - Track work, files modified, discoveries

---

<!-- AI_SCAN:SUBJECT_RESOLUTION:273-300 -->
## Subject Resolution Types

When brainstorming (inside task file), every resolved subject falls into ONE of these types:

| Type | Name | When | Action | Example |
|------|------|------|--------|---------|
| **A** | Pre-Implementation Task | Small code changes needed BEFORE iteration | Create pre-task (< 30 min work) | Fix interface, rename file, update enum |
| **B** | Immediate Documentation | Architectural decision, no code yet | Update PLAN.md Architecture section NOW | Design pattern choice, API contract |
| **C** | Auto-Resolved | Answered by another subject's decision | Mark as resolved by Subject N | Cascade decisions |
| **D** | Iteration Action Items | Substantial feature work that IS the iteration | Create "Resolution Items" list in subject | Build API endpoint, implement validator |

**Decision Flow**:
1. Does subject require code changes?
   - **NO** → Type B (Documentation) or Type C (Auto-resolved)
   - **YES** → Continue to #2
2. Is it small quick task (< 30 min)?
   - **YES** → Type A (Pre-task)
   - **NO** → Type D (Resolution Items → Action Items)

**Where They Live**:
- Type B decisions → Update `PLAN.md` Architecture section immediately
- Type A pre-tasks → Pre-Implementation Tasks section (before brainstorming complete)
- Type D Resolution Items → Listed in subject, then `/flow-brainstorm-review` consolidates them into iteration's Action Items section

**Key Insight**: Brainstorming creates "Resolution Items" per subject. The `/flow-brainstorm-review` command consolidates all Resolution Items → single Action Items list per iteration.

---

<!-- AI_SCAN:COMMON_PATTERNS:303-410 -->
## Common Patterns Quick Reference

### Creating a New Project

```bash
# Option 1: From scratch
/flow-blueprint

# Option 2: Convert existing docs
/flow-migrate

# Option 3: Convert old single-file PLAN.md
/flow-plan-update
```

**Result**: Creates DASHBOARD.md, PLAN.md, phase-1/ directory with initial task files

---

### Starting Work on a Phase

```bash
/flow-phase-add "Phase 2: Core Implementation"
/flow-phase-start
```

**Files Created/Updated**:
- `phase-2/` directory created
- DASHBOARD.md updated with new phase section

---

### Adding a Task

```bash
/flow-task-add "API Integration"
```

**Files Created/Updated**:
- `phase-N/task-M.md` created (N = current phase, M = next task number)
- DASHBOARD.md updated with new task entry

---

### Working on an Iteration

```bash
# 1. Add iteration to current task
/flow-iteration-add "Error Handling"

# 2. Start brainstorming
/flow-brainstorm-start

# 3. Resolve subjects one by one
/flow-next-subject
# [Discuss subject, choose Type A/B/C/D, document decision]

# 4. After all subjects resolved, review
/flow-brainstorm-review
# [AI suggests iterations/pre-tasks based on decisions]

# 5. Complete any pre-tasks, then close brainstorming
/flow-brainstorm-complete

# 6. Start implementation
/flow-implement-start

# 7. Do the work...

# 8. Complete implementation
/flow-implement-complete
```

**Files Updated**:
- Current `phase-N/task-M.md` (brainstorming, implementation sections added)
- DASHBOARD.md (status updates throughout)
- Possibly PLAN.md (if Type B decisions made)

---

### Checking Status

```bash
/flow-status
```

**Result**: Reads DASHBOARD.md, shows formatted current state
- Current work pointer
- Progress overview

**This is the REFERENCE MODEL command** - simple dashboard read, no complex logic needed.

---

### Finding Next Work

```bash
/flow-next
```

**Logic**:
1. Read DASHBOARD.md
2. Check current iteration status
3. Suggest appropriate next command based on state

---

<!-- AI_SCAN:BRAINSTORMING_WORKFLOW:413-480 -->
## Brainstorming Workflow Pattern

**Context**: Happens inside `phase-N/task-M.md` file, within an iteration section.

### Structure in Task File

```markdown
### 🚧 Iteration 2: Error Handling

**Goal**: Implement comprehensive error handling

**Status**: 🚧 IN PROGRESS (Brainstorming)

---

#### Brainstorming Session - Error Handling Strategy

**Focus**: Design retry logic, error recovery patterns

**Subjects to Discuss**:
1. ⏳ Retry Strategy
2. ⏳ Circuit Breaker Pattern
3. ⏳ Error Logging

**Resolved Subjects**:

---

##### ✅ Subject 1: Retry Strategy

**Decision**: Use exponential backoff with 3 retries

**Resolution Type**: D (Iteration Action Items)

**Rationale**: Balances reliability with user experience

**Action Items**:
- [ ] Implement RetryPolicy class
- [ ] Add exponential backoff logic
- [ ] Configure max retry count

---

##### ✅ Subject 2: Circuit Breaker Pattern

**Decision**: Skip circuit breaker for V1, defer to V2

**Resolution Type**: B (Documentation)

**Rationale**: V1 scope is tight, circuit breaker adds complexity

**Documentation Update**: Added to PLAN.md V2 scope
```

### Workflow Commands

1. **Start**: `/flow-brainstorm-start`
   - Adds brainstorming section to current iteration
   - Creates "Subjects to Discuss" list

2. **Resolve**: `/flow-next-subject`
   - Picks next ⏳ subject
   - Discuss with user
   - Document decision + choose Type A/B/C/D
   - Add action items if needed

3. **Review**: `/flow-brainstorm-review` (CRITICAL STEP!)
   - After all subjects resolved
   - AI analyzes all decisions
   - Suggests if more iterations needed
   - Identifies pre-implementation tasks
   - **Always suggest this BEFORE /flow-brainstorm-complete**

4. **Complete**: `/flow-brainstorm-complete`
   - Marks brainstorming ✅ COMPLETE
   - Changes iteration status to 🎨 READY
   - Only call AFTER completing pre-tasks

---

<!-- AI_SCAN:PRE_IMPLEMENTATION_PATTERN:483-540 -->
## Pre-Implementation Tasks Pattern

**Context**: Discovered during brainstorming (Type A subjects). Must be completed BEFORE starting iteration implementation.

### Structure in Task File

```markdown
### 🚧 Iteration 2: Error Handling

[... Brainstorming section above ...]

---

#### Pre-Implementation Tasks

These tasks MUST be completed BEFORE starting main implementation of this iteration.

##### ⏳ Pre-Task 1: Refactor Legacy Error Handler

**Why Blocking**: Current ErrorHandler doesn't support async retry logic

**Scope** (< 30 min):
- Update ErrorHandler.ts to support async
- Add retryAsync() method
- Update 3 existing call sites

**Files**:
- src/utils/ErrorHandler.ts
- src/services/BillingService.ts
- tests/utils/ErrorHandler.test.ts

**Test**: Run existing tests to ensure no regressions

---

##### ✅ Pre-Task 2: Update Type Definitions

**Completed**: 2025-01-15

**Changes Made**:
- Added ErrorType enum
- Updated function signatures
- All tests passing
```

### Workflow

1. During brainstorming, identify Type A subjects (small < 30 min tasks)
2. `/flow-brainstorm-review` creates pre-implementation tasks section
3. Complete all pre-tasks (mark each ✅ with completion date)
4. Only then call `/flow-brainstorm-complete`
5. Then call `/flow-implement-start`

**Why This Matters**: Pre-tasks unblock the main implementation. Doing them early prevents getting stuck mid-iteration.

---

<!-- AI_SCAN:SECTION_INDEX:543-600 -->
## Section Index (Use Read Tool with Offset/Limit)

**How to Use**: When you need deep details, use `Read(file_path, offset=X, limit=Y)` to read ONLY the specific section.

### Quick Reference Sections (You Just Read These!)
- Lines 1-600: This Quick Reference (current section)

### Core Framework Sections
- Lines 601-850: **Framework Philosophy & Principles**
  - Domain-Driven Design approach
  - Agile iterative philosophy
  - When to use Flow

- Lines 851-1100: **Multi-File Architecture Deep Dive**
  - File responsibilities in detail
  - Cross-file references
  - Directory structure rules
  - File naming conventions

- Lines 1101-1400: **Task Structure Rules (Complete Guide)**
  - Iterations-only architecture
  - When to split tasks
  - Task size guidelines
  - Nested iteration patterns

- Lines 1401-1700: **Brainstorming Pattern (Complete Guide)**
  - Full brainstorming workflow
  - Subject resolution types deep dive
  - Pre-implementation task patterns
  - Bugs discovered pattern

- Lines 1701-1900: **Implementation Pattern (Complete Guide)**
  - Implementation structure
  - Notes and discoveries
  - Verification checklist
  - When to mark complete

- Lines 1901-2100: **Status Management**
  - Status marker lifecycle
  - State transitions
  - Common pitfalls
  - Recovery from incorrect states

- Lines 2101-2600: **File Templates**
  - DASHBOARD.md template (complete)
  - PLAN.md template (complete)
  - task-N.md template (complete)
  - Copy-paste ready templates

- Lines 2601-2900: **Command Patterns**
  - Dashboard-first navigation (detailed)
  - Structure creation pattern
  - Full traversal pattern
  - Cross-file search pattern

- Lines 2901-3200: **Complete Workflow Examples**
  - Full feature implementation walkthrough
  - File updates at each step
  - Real-world example with payment gateway

- Lines 3201-3500: **Backlog Management**
  - BACKLOG.md structure
  - Moving tasks to backlog
  - Pulling tasks back
  - Archiving with /flow-plan-split

- Lines 3501-3800: **Best Practices & Pitfalls**
  - Common mistakes
  - How to recover
  - Performance tips
  - Multi-developer workflows

---

**End of Quick Reference** - Continue reading below for complete framework documentation →


<!-- AI_SCAN:FRAMEWORK_PHILOSOPHY:620-850 -->
# Framework Philosophy & Principles

## What is Flow?

Flow is a **specification-driven iterative development methodology** that combines:
- **Domain-Driven Design** principles (understand before building)
- **Agile philosophy** (iterative shipping, adapt to feedback)
- **Progressive disclosure** (V1 → V2 → V3, defer complexity)

### Core Metaphor: Building a Human Body

**Skeleton** (Phase 1) → **Veins** (Phase 2) → **Flesh** (Phase 3) → **Fibers** (Phase 4)

- **Skeleton**: Basic structure and foundation
  - Minimal working version
  - Core data models
  - Basic happy path

- **Veins**: Core data flow and connections
  - Main feature workflows
  - Critical integration points
  - Error handling basics

- **Flesh**: Incremental complexity
  - Additional features
  - Edge cases
  - Performance optimization

- **Fibers**: Refinement and optimization
  - Polish and UX improvements
  - Advanced edge cases
  - Production hardening

### Multi-File Architecture Philosophy

**Problem**: Monolithic `PLAN.md` files grow to 500-5000+ lines, becoming:
- Hard to navigate
- Slow to load/edit
- Git merge nightmares
- Context overload for AI

**Solution**: Split into focused files:
- **DASHBOARD.md**: User's active workspace (what's happening NOW)
- **PLAN.md**: Static context (WHY we're building this, HOW it fits together)
- **phase-N/task-N.md**: Detailed work files (what's IN each task)
- **BACKLOG.md**: Future work (what's DEFERRED)

**Benefits**:
- Smaller files = faster to read/edit
- Each file has single responsibility
- Git conflicts are localized
- AI can focus on relevant file only
- User knows where to look for information

### When to Use Flow

**✅ Use Flow For**:
- Complex features requiring design decisions
- Multi-phase projects (> 2 weeks)
- Features with unclear requirements (need exploration)
- Team projects (shared context needed)
- Features requiring iterative refinement

**❌ Don't Use Flow For**:
- Simple bug fixes (< 1 hour)
- Trivial features (< 5 steps)
- Well-defined copy-paste implementations
- One-off scripts

### Key Principles

#### 1. Plan-Before-Code

**Never start coding without understanding the problem domain.**

- Brainstorming is NOT optional for complex work
- Document decisions and rationale
- Identify pre-implementation tasks early
- Update architecture documentation (PLAN.md) for major decisions

#### 2. Context Preservation

**The plan files ARE the memory of the project.**

- DASHBOARD.md: Current state (always up-to-date)
- PLAN.md: Static context (reference docs)
- Task files: Complete work history per task
- CHANGELOG.md: Historical decisions
- Everything is documented, nothing is forgotten

#### 3. Iterative Refinement

**Ship V1, then V2, then V3 - don't try to build perfect V1.**

- V1: Minimum viable (skeleton + veins)
- V2: Enhancements (flesh)
- V3: Optimization (fibers)
- Defer complexity to later versions

#### 4. Progressive Disclosure

**Focus only on what's needed NOW.**

- Each iteration is focused and shippable
- Don't design V3 during V1 brainstorming
- Document V2/V3 ideas in PLAN.md or BACKLOG.md
- Revisit deferred decisions when actually needed

#### 5. State Preservation

**Status markers track progress across sessions.**

- ✅ COMPLETE: Frozen, verified, skip re-verification
- 🚧 IN PROGRESS: Currently active work
- ⏳ PENDING: Not started yet
- 🎨 READY: Brainstorming done, ready to code
- Status in both DASHBOARD.md (overview) and task files (details)

#### 6. Dashboard-First Navigation

**DASHBOARD.md is the single source of truth for "where are we?"**

- All commands read DASHBOARD.md first
- Dashboard points to current task file
- Task file contains detailed work
- Consistent navigation pattern across all commands

---

<!-- AI_SCAN:MULTI_FILE_ARCHITECTURE:852-1100 -->
# Multi-File Architecture Deep Dive

## File Responsibilities

### DASHBOARD.md (Progress Tracking)

**Purpose**: User's main workspace - shows current work and overall progress

**Sections**:
1. **Current Work** - Pointer to active Phase/Task/Iteration
2. **Progress Overview** - All phases with task completion status
3. **Key Decisions** - Outstanding decisions needing user input
4. **Success Criteria** - Definition of done for phases
5. **Related Resources** - Links to docs, examples

**Update Frequency**: Every command that changes state

**User Interaction**: User reads this constantly to understand where they are

**Example Structure**:
```markdown
# Project Dashboard

**Last Updated**: 2025-01-15 14:30

## 📍 Current Work
- **Phase**: [Phase 2 - Core Implementation](phase-2/)
- **Task**: [Task 3 - API Integration](phase-2/task-3.md)
- **Iteration**: [Iteration 2 - Error Handling](phase-2/task-3.md#iteration-2-error-handling) 🚧

## 📊 Progress Overview

### Phase 1: Foundation ✅ COMPLETE
- ✅ Task 1: Project Setup (3/3 iterations)
- ✅ Task 2: Core Models (2/2 iterations)

### Phase 2: Core Implementation 🚧 IN PROGRESS (2/5 tasks)
- ✅ Task 1: Database Layer (2/2 iterations)
- ✅ Task 2: Business Logic (3/3 iterations)
- 🚧 Task 3: API Integration (1/4 iterations) ← CURRENT
- ⏳ Task 4: Authentication
- ⏳ Task 5: Caching Layer


## 💡 Key Decisions

**Decision Needed**: Should Skills be included in flow.sh or distributed separately?
- Option A: Include in flow.sh (150KB → 180KB) - Users get Skills automatically, easier onboarding
- Option B: Separate distribution (skills.zip) - Keeps flow.sh lean, users opt-in to Skills
- **Recommendation**: Option A - Skills are lightweight (~30KB total), automatic deployment enhances AI experience

**Decision Needed**: Which Skills to create first?
- Option A: Start with 3 core Skills (navigator, planner, implementer) - MVP approach, faster testing
- Option B: Create all 6 Skills upfront - Complete experience from day 1, but longer Phase 2
- **Recommendation**: Option A - Iterate on core 3, add remaining 3 based on real usage feedback

**Resolved**:
- **2025-10-30**: Skills Complement Commands - Skills = model-invoked (AI decides when), Commands = user-invoked (human triggers explicitly). This maintains human-in-loop philosophy.
- **2025-10-30**: Human Still Drives - Skills give AI *awareness* of Flow patterns, not *authority* to make architectural decisions. Descriptions emphasize "when user wants..." patterns.

---

## 🎯 Success Criteria

**Phase 1 Complete When**:
- `.claude/skills/` directory structure exists
- Skill templates documented in framework/
- build-standalone.sh embeds Skills in flow.sh
- Skills deploy correctly to test project

**Phase 2 Complete When**:
- 6 Core Skills created with SKILL.md files
- Each Skill has clear description triggering appropriate context
- Skills reference framework patterns correctly
- Skills tested individually

**Phase 3 Complete When**:
- Skills activate based on user requests (not manual invocation)
- Real-world workflow test completed (plan → implement → complete)
- Documentation updated (README, new SKILLS.md guide)
- Example Skills added to framework/examples/

---

## 📚 Related Resources

- **Agent Skills Documentation**: https://docs.claude.com/en/docs/claude-code/skills
- **Flow Framework**: framework/DEVELOPMENT_FRAMEWORK.md
- **Slash Commands**: framework/SLASH_COMMANDS.md
- **Build System**: build-standalone.sh (deployment logic)

```

### PLAN.md (Static Context)

**Purpose**: Like CLAUDE.md but for this specific feature/project

**Sections**:
1. **Overview** - Purpose, Goals, Scope (V1/V2/V3)
2. **Architecture** - System design, components, data flow
3. **Testing Strategy** - How to test this feature
4. **Development Phases** - High-level phase descriptions (NOT detailed tasks)

**Update Frequency**: Rarely (only when architecture changes or Type B brainstorming decisions)

**User Interaction**: User reads at start of project, refers back occasionally

**Key Insight**: This is the "WHY" and "HOW" documentation - it explains the big picture

**Example Structure**:
```markdown
# Payment Gateway Integration - Development Plan

> **📍 Current Progress**: See [DASHBOARD.md](DASHBOARD.md)
> **🎯 Purpose**: Integrate Stripe payment processing

**Created**: 2025-01-10
**Version**: V1

## Overview

### Purpose
Build production-ready payment gateway integration supporting credit cards and subscriptions.

### Goals
- [ ] Process credit card payments via Stripe API
- [ ] Handle webhook events for async notifications
- [ ] Implement retry logic for failed payments

### Scope

**V1 (Included)**:
- Credit card payment processing
- Basic subscription support
- Webhook handler
- Retry logic (3 attempts)

**V2 (Future)**:
- ACH/bank transfer support
- Multi-currency
- Saved payment methods

## Architecture

### System Design

**Components**:
- `PaymentService` - Core payment orchestration
- `StripeClient` - API wrapper with retry logic
- `WebhookHandler` - Event processing
- `PaymentRepository` - Database persistence

### Data Flow
[Diagram or description]

## Testing Strategy

**Methodology**: Simulation-based per-service testing
**Location**: `scripts/` directory
**Naming**: `{service}.scripts.ts`

## Development Phases

### Phase 1: Foundation
Setup project structure and dependencies

### Phase 2: Core Implementation
Build payment processing functionality

### Phase 3: Testing & Hardening
Comprehensive testing and edge cases
```

### phase-N/task-N.md (Work Files)

**Purpose**: Container for all work related to a specific task

**Sections**:
1. **Task Header** - Status, Phase link, Purpose
2. **Task Overview** - Description, dependencies, why this task
3. **Iterations** - All tasks have iterations (1+ iterations per task)
4. **Task Notes** - Discoveries, decisions, references

**Update Frequency**: Constantly during work on this task

**User Interaction**: User works in this file during active development

**Key Insight**: This is the "WHAT" and "HOW SPECIFICALLY" - all the detailed work

**Example Structure** (Task with Iterations):
```markdown
# Task 3: API Integration

**Status**: 🚧 IN PROGRESS
**Phase**: [Phase 2 - Core Implementation](../DASHBOARD.md#phase-2-core-implementation)
**Purpose**: Integrate with Stripe REST API

---

## Task Overview

Build robust Stripe API client with error handling and retry logic.

**Why This Task**: Need payment processing capability

**Dependencies**:
- Requires: Task 1 (Database Layer)
- Blocks: Task 4 (Authentication)

---

## Iterations

### ✅ Iteration 1: REST Client Setup

**Goal**: Create Stripe API client wrapper

**Status**: ✅ COMPLETE

[Brainstorming, Implementation sections below]

---

### 🚧 Iteration 2: Error Handling

**Goal**: Implement error handling

**Status**: 🚧 IN PROGRESS

[Currently working on this iteration]

---

## Task Notes

**Discoveries**:
- Stripe SDK handles connection pooling automatically

**Decisions**:
- Using Stripe Node SDK v12.x

**References**:
- Stripe API Docs: https://stripe.com/docs/api
```

### BACKLOG.md (Future Work)

**Purpose**: Storage for deferred tasks and V2/V3 features

**Sections**:
1. **Backlog Dashboard** - Summary of backlog items
2. **Backlog Items** - Deferred tasks with reasoning

**Update Frequency**: When moving tasks out of active plan or adding future work

**Example Structure**:
```markdown
# Project Backlog

## 📋 Backlog Dashboard

**Total Items**: 8
**V2 Features**: 5
**V3 Features**: 2
**Deferred Bugs**: 1

## Backlog Items

### ⏳ Task: Multi-Currency Support

**Originally Planned**: Phase 2, Task 6
**Deferred To**: V2
**Reasoning**: V1 scope focuses on USD only, multi-currency adds significant complexity
**Estimated Effort**: 2 weeks
**Dependencies**: Core payment processing complete
```

### CHANGELOG.md (History)

**Purpose**: Historical record of completed work

**Example**:
```markdown
# Changelog

## [V1.2.0] - 2025-01-15
### Added
- Retry logic for failed payments
- Webhook signature validation

### Fixed
- Race condition in payment processing

## [V1.1.0] - 2025-01-10
### Added
- Basic payment processing
- Stripe API integration
```

### ARCHIVE.md (Completed Work)

**Purpose**: Created by `/flow-plan-split` - archives completed tasks

**Structure**: Flat list of completed tasks with all iterations

**Effect**: Original task files become references:
```markdown
# Task 1: Project Setup

**Status**: ✅ COMPLETE (Archived)

See [ARCHIVE.md](../ARCHIVE.md#task-1-project-setup) for complete details.
```

## Cross-File References

### Linking Between Files

**Dashboard → Task File**:
```markdown
- **Task**: [Task 3 - API Integration](phase-2/task-3.md)
```

**Task File → Dashboard**:
```markdown
**Phase**: [Phase 2 - Core Implementation](../DASHBOARD.md#phase-2-core-implementation)
```

**Task File → PLAN.md**:
```markdown
See [PLAN.md Architecture section](../PLAN.md#architecture) for system design
```

**PLAN.md → Backlog**:
```markdown
Multi-currency support deferred to V2 (see [BACKLOG.md](BACKLOG.md))
```

### Reference Patterns

**Current Work Pointer** (in DASHBOARD.md):
```markdown
## 📍 Current Work
- **Phase**: Phase 2 - Core Implementation
- **Task**: Task 3 - API Integration
- **Iteration**: Iteration 2 - Error Handling
- **File**: [phase-2/task-3.md](phase-2/task-3.md#iteration-2-error-handling)
```

This pointer is the SOURCE OF TRUTH for "where are we right now?"

## Directory Structure Rules

### Phase Directories

**Naming**: `phase-N/` where N is the phase number (1, 2, 3, ...)
**Created**: When `/flow-phase-add` is run
**Contains**: Task files for that phase

```
phase-1/
├── task-1.md
├── task-2.md
└── task-3.md
```

### Task File Naming

**Format**: `task-N.md` where N is the task number within the phase
**Numbering**: Sequential within each phase (task-1, task-2, task-3, ...)
**Name in Content**: Task file contains descriptive name in header

**Example**:
- File: `phase-2/task-3.md`
- Header: `# Task 3: API Integration`

### File Naming Conventions

**DO**:
- ✅ Use `phase-N/` for phase directories
- ✅ Use `task-N.md` for task files
- ✅ Keep all Flow files in `.flow/` directory
- ✅ Use lowercase for filenames

**DON'T**:
- ❌ Don't put task name in filename (`task-3-api-integration.md`)
- ❌ Don't nest deeper than `phase-N/task-N.md`
- ❌ Don't create subdirectories under phase directories


<!-- AI_SCAN:TASK_STRUCTURE_COMPLETE:1101-1400 -->
# Task Structure Rules (Complete Guide)

## The Golden Rule

**ALL Tasks Have Iterations**

This provides consistent structure and enables human-in-loop iterative development.

## Why Iterations-Only?

- **Consistent structure** - Every task follows same pattern, easier to navigate
- **Human-in-loop** - Enables plan → brainstorm → implement → complete cycle
- **Progress tracking** - Clear iteration status shows where you are
- **Flexibility** - Simple tasks have 1-2 iterations, complex tasks have many
- **No special cases** - One pattern to learn and follow

## Task Pattern (The Only Pattern)

**File**: `phase-N/task-N.md`

### Complete Example

```markdown
# Task 3: API Integration

**Status**: 🚧 IN PROGRESS
**Phase**: [Phase 2 - Core Implementation](../DASHBOARD.md#phase-2-core-implementation)
**Purpose**: Integrate with Stripe REST API for payment processing

---

## Task Overview

Build robust Stripe API client with error handling, retry logic, and webhooks.

**Why This Task**: Core payment functionality depends on reliable API integration.

**Dependencies**:
- **Requires**: Task 1 (Database Layer) - need PaymentRepository
- **Requires**: Task 2 (Business Logic) - need PaymentService interface
- **Blocks**: Task 4 (Authentication) - auth tokens stored via this API

**Estimated Complexity**: High (3-4 iterations expected)

---

## Iterations

### ✅ Iteration 1: REST Client Setup

**Goal**: Create Stripe API client wrapper with authentication

**Status**: ✅ COMPLETE (2025-01-12)

---

#### Brainstorming Session - REST Client Architecture

**Focus**: Design API client abstraction and authentication flow

**Subjects to Discuss**:
(All subjects resolved)

**Resolved Subjects**:

---

##### ✅ Subject 1: Client Architecture Pattern

**Decision**: Use singleton pattern with lazy initialization

**Resolution Type**: D (Iteration Action Items)

**Rationale**:
- Stripe SDK maintains connection pool internally
- Multiple instances would create redundant connections
- Lazy init delays credential validation until first use

**Resolution Items**:
- Create `StripeClient` singleton class
- Implement lazy initialization in constructor
- Add credential validation on first API call

---

##### ✅ Subject 2: Authentication Flow

**Decision**: Use API key from environment variable with validation

**Resolution Type**: D (Iteration Action Items)

**Rationale**:
- Follows Stripe best practices
- Supports different keys per environment
- Fails fast if key missing or invalid

**Resolution Items**:
- Load `STRIPE_API_KEY` from env
- Validate key format at startup
- Throw clear error if key missing

---

#### Action Items

(Consolidated from Resolution Items above by `/flow-brainstorm-review`)

- [x] Create `StripeClient` singleton class
- [x] Implement lazy initialization in constructor
- [x] Add credential validation on first API call
- [x] Load `STRIPE_API_KEY` from env
- [x] Validate key format at startup
- [x] Throw clear error if key missing

---

#### Implementation - Iteration 1: REST Client Setup

**Status**: ✅ COMPLETE (2025-01-12)

**Implementation Notes**:
- Created `src/payment/StripeClient.ts` with singleton pattern
- Implemented environment-based key loading
- Added validation for API key format (starts with `sk_`)
- Discovered bug in existing error handling (see Pre-Implementation Tasks in Iteration 2)

**Files Modified**:
- `src/payment/StripeClient.ts` - Created (142 lines)
- `src/config/env.ts` - Added STRIPE_API_KEY validation
- `scripts/payment.scripts.ts` - Created test file

**Verification**:
- ✅ All tests passing in payment.scripts.ts
- ✅ API key validation working correctly
- ✅ Singleton pattern verified

---

### 🚧 Iteration 2: Error Handling

**Goal**: Implement comprehensive error handling and retry logic

**Status**: 🚧 IN PROGRESS (Brainstorming)

---

#### Pre-Implementation Tasks

##### ⏳ Pre-Task 1: Refactor Legacy Error Handler

**Why Blocking**: Current ErrorHandler doesn't support async retry logic

**Scope** (< 30 min):
- Update ErrorHandler.ts to support async
- Add retryAsync() method
- Update 3 existing call sites

**Files**:
- src/utils/ErrorHandler.ts
- src/services/BillingService.ts
- tests/utils/ErrorHandler.test.ts

---

#### Brainstorming Session - Error Handling Strategy

**Focus**: Design retry logic, error recovery patterns

**Subjects to Discuss**:
1. ⏳ Retry Strategy
2. ⏳ Circuit Breaker Pattern
3. ⏳ Error Logging

**Resolved Subjects**:
(To be filled during brainstorming)

---

### ⏳ Iteration 3: Retry Logic

**Goal**: Add exponential backoff retry for transient failures

**Status**: ⏳ PENDING

---

### ⏳ Iteration 4: Integration Tests

**Goal**: Comprehensive test coverage with Stripe API simulation

**Status**: ⏳ PENDING

---

## Task Notes

**Discoveries**:
- Stripe SDK already implements connection pooling (no need for custom)
- Error codes changed in Stripe API v2023-10-16 (updated error taxonomy)

**Decisions**:
- Using Stripe Node SDK v12.x (latest stable)
- Not implementing custom connection pool (SDK handles it)

**References**:
- Stripe API Docs: https://stripe.com/docs/api
- Existing billing: `src/legacy/billing.ts` (PayPal integration pattern)
- Similar webhook: `src/webhooks/shipment.ts` (signature validation example)
```

### Completion Criteria

Task is ✅ COMPLETE when:
- ALL iterations are ✅ COMPLETE
- Task Notes updated with discoveries
- All dependencies satisfied

## Exception: Pre-Implementation Tasks

**Only exception to "no direct action items" rule**:

Pre-implementation tasks are discovered during brainstorming (Type A subjects) and must be completed BEFORE iteration implementation starts.

**Structure**:
```
Task
├── Iteration N
│   ├── Pre-Implementation Tasks ← EXCEPTION: Action items at iteration level
│   ├── Brainstorming Session
│   └── Implementation
```

**Why Allowed**: These are blocking tasks that unblock the iteration. They're scoped to < 30 min and must be done before `/flow-implement-start`.

## When to Split a Task

### Task Too Large?

**Signals**:
- More than 5 iterations planned
- Iterations span multiple unrelated concerns
- Task takes > 4 weeks
- Task description is vague ("Implement everything...")

**Solution**: Split into multiple tasks

**Example**:
```
Before:
- Task: Payment System (10 iterations)

After:
- Task 1: Payment Processing (4 iterations)
- Task 2: Webhook Handling (3 iterations)
- Task 3: Payment Analytics (3 iterations)
```

### Task Too Small?

**Signals**:
- Only 1 iteration with 2-3 action items
- No brainstorming needed
- Can complete in < 1 hour

**Solution**: Use Single Iteration with Direct Action Items

**Example**:
```
Task: Add Logging
- Iteration 1: Logging Implementation
  - Action Items (no brainstorming):
    - Add logger configuration
    - Update main entry points
    - Add log rotation
```

## Nested Iteration Pattern

**Question**: Can iterations have sub-iterations?

**Answer**: No. Keep structure flat.

**Why**: Two levels (Task → Iteration) is enough. If you need more nesting, split the task.

**If You Feel You Need More Nesting**:
1. You probably need multiple tasks instead
2. Or your brainstorming subjects should become separate iterations

---

<!-- AI_SCAN:BRAINSTORMING_COMPLETE:1402-1700 -->
# Brainstorming Pattern (Complete Guide)

## What is Brainstorming?

**Brainstorming** is the design-before-code phase where you:
1. Identify questions/decisions (subjects)
2. Discuss each subject
3. Document decisions
4. Generate action items
5. Identify pre-implementation work

**Location**: Inside task file, within iteration section

**Mandatory For**: Complex iterations requiring design decisions

## Brainstorming Structure

### Complete Brainstorming Section

```markdown
#### Brainstorming Session - [Topic]

**Focus**: [What we're designing/deciding]

**Subjects to Discuss**:
1. ⏳ [Subject name]
2. ⏳ [Subject name]
3. ⏳ [Subject name]

**Resolved Subjects**:

---

##### ✅ Subject 1: [Name]

**Decision**: [Your decision]

**Resolution Type**: A / B / C / D

**Rationale**: [Why this decision]

**Action Items** (if Type A or D):
- [ ] Item 1
- [ ] Item 2

**Documentation Update** (if Type B):
[What was updated in PLAN.md]

---

##### ✅ Subject 2: [Name]

[... same structure ...]
```

## Subject Resolution Types (Deep Dive)

### Type A: Pre-Implementation Task

**When**: Small code change needed BEFORE iteration starts

**Criteria**:
- Required for iteration (blocking)
- Small scope (< 30 min)
- Can be done independently
- Examples: Fix interface, rename file, update enum, fix bug

**Action**:
1. Document decision
2. Create action items
3. Add to "Pre-Implementation Tasks" section
4. Complete BEFORE `/flow-brainstorm-complete`

**Example**:
```markdown
##### ✅ Subject 3: Type Definition Updates

**Decision**: Need to update PaymentStatus enum to include new states

**Resolution Type**: A (Pre-Implementation Task)

**Rationale**: Current enum missing "pending_retry" and "failed_permanent" states needed for retry logic

**Action Items**:
- [ ] Update PaymentStatus enum in types.ts
- [ ] Update 4 switch statements to handle new states
- [ ] Add tests for new states

**Note**: Must complete before implementing retry logic
```

### Type B: Immediate Documentation

**When**: Architectural decision that affects system design

**Criteria**:
- No code changes yet
- Updates PLAN.md Architecture section
- Examples: Design pattern choice, API contract, data model

**Action**:
1. Document decision
2. Update PLAN.md Architecture section NOW
3. Reference update in subject

**Example**:
```markdown
##### ✅ Subject 1: Error Recovery Strategy

**Decision**: Implement retry with exponential backoff, no circuit breaker for V1

**Resolution Type**: B (Documentation)

**Rationale**:
- Exponential backoff handles transient failures well
- Circuit breaker adds complexity, defer to V2
- Stripe API has good rate limiting, low risk of cascade failures

**Documentation Update**:
Updated PLAN.md Architecture section with retry strategy diagram and V2 scope for circuit breaker
```

### Type C: Auto-Resolved

**When**: Subject answered by another subject's decision

**Criteria**:
- No independent decision needed
- Cascade from another subject
- Examples: Implementation detail determined by architecture choice

**Action**:
1. Note which subject resolved this
2. No additional action items

**Example**:
```markdown
##### ✅ Subject 4: Retry Delay Calculation

**Decision**: Use exponential backoff as decided in Subject 1

**Resolution Type**: C (Auto-Resolved by Subject 1)

**Rationale**: Subject 1 already decided on exponential backoff strategy, this subject is implementation detail
```

### Type D: Iteration Action Items

**When**: Substantial feature work that IS the iteration

**Criteria**:
- Main implementation work
- Takes significant time (> 30 min)
- Examples: Build API endpoint, implement validator, create service

**Action**:
1. Document decision
2. Create action items
3. These become implementation action items

**Example**:
```markdown
##### ✅ Subject 2: Retry Implementation

**Decision**: Implement RetryPolicy class with configurable backoff strategy

**Resolution Type**: D (Iteration Action Items)

**Rationale**:
- Separate class for testability
- Configurable for different API endpoints
- Can swap strategies (exponential, linear, fixed)

**Action Items**:
- [ ] Create RetryPolicy class
- [ ] Implement exponential backoff algorithm
- [ ] Add configuration for max retries, base delay
- [ ] Integrate with StripeClient
- [ ] Add tests for retry scenarios
```

## Brainstorming Workflow Commands

### 1. `/flow-brainstorm-start`

**When**: Starting brainstorming for current iteration

**Effect**:
- Adds brainstorming section to current iteration
- Prompts user for subjects to discuss
- Creates "Subjects to Discuss" list

**Example**:
```
User: /flow-brainstorm-start
AI: Let's start brainstorming for Iteration 2: Error Handling.

What subjects should we discuss? (e.g., "Retry strategy, Error logging, Circuit breaker")

User: Retry strategy, Error taxonomy, Logging format, Integration with existing error handler

AI: Added 4 subjects to brainstorming session in phase-2/task-3.md
```

### 2. `/flow-next-subject`

**When**: Ready to discuss next subject

**Effect**:
- Finds next ⏳ PENDING subject
- Discusses with user
- Documents decision
- User/AI chooses Type A/B/C/D
- Creates action items if needed
- Marks subject ✅ COMPLETE

**Example**:
```
User: /flow-next-subject
AI: Let's discuss Subject 1: Retry Strategy

[Discussion happens...]

AI: Decision: Use exponential backoff with 3 retries

Is this:
A) Pre-implementation task (< 30 min, blocking)
B) Documentation update (update PLAN.md Architecture)
C) Auto-resolved by another subject
D) Main iteration work (implementation action items)

User: D

AI: What are the action items?

User: Create RetryPolicy class, implement backoff algorithm, integrate with client, add tests

AI: Documented. Subject 1 marked complete. 3 subjects remaining.
```

### 3. `/flow-brainstorm-review` (CRITICAL!)

**When**: After ALL subjects resolved, BEFORE `/flow-brainstorm-complete`

**Why Critical**:
- AI reviews all decisions holistically
- Suggests if more iterations needed
- Identifies pre-implementation tasks
- Catches missing subjects

**Effect**:
- AI reads all resolved subjects
- Suggests additional iterations if decisions reveal more work
- Creates "Pre-Implementation Tasks" section if Type A subjects found
- Confirms readiness to close brainstorming

**Example**:
```
User: /flow-brainstorm-review
AI: Reviewing all 4 resolved subjects...

Summary:
- Subject 1: Retry strategy (Type D) → Main iteration work
- Subject 2: Error taxonomy (Type B) → Updated PLAN.md
- Subject 3: Logging format (Type D) → Main iteration work
- Subject 4: Integration with error handler (Type A) → Pre-implementation task

Analysis:
Based on the decisions, I recommend:

1. Pre-Implementation Task Identified:
   - Subject 4 requires updating ErrorHandler.ts before implementing retry logic
   - Estimated: 20 minutes
   - Action: Update ErrorHandler to support async operations

2. Current Iteration Scope Confirmed:
   - Implementing RetryPolicy and logging is appropriate for this iteration
   - Estimated: 3-4 hours of work

3. No Additional Iterations Needed:
   - All error handling concerns addressed
   - Circuit breaker deferred to V2

Next Steps:
1. Complete pre-implementation task (update ErrorHandler.ts)
2. Run /flow-brainstorm-complete
3. Run /flow-implement-start

Ready to proceed?
```

### 4. `/flow-brainstorm-complete`

**When**: After completing ALL pre-implementation tasks

**Effect**:
- Marks brainstorming ✅ COMPLETE
- Changes iteration status to 🎨 READY
- Updates DASHBOARD.md

**Example**:
```
User: /flow-brainstorm-complete
AI: Verifying pre-implementation tasks...
✅ Pre-Task 1: Update ErrorHandler.ts - COMPLETE

Brainstorming complete! Iteration 2 is now 🎨 READY.

Next: /flow-implement-start to begin coding.
```

## Pre-Implementation Tasks Pattern

### Structure

```markdown
#### Pre-Implementation Tasks

These tasks MUST be completed BEFORE starting main implementation of this iteration.

##### ⏳ Pre-Task 1: [Name]

**Why Blocking**: [Explanation of why this blocks implementation]

**Scope** (< 30 min):
- [What needs to be done]
- [Specific changes]

**Files**:
- [List of files to modify]

**Test**: [How to verify it's done]

---

##### ✅ Pre-Task 2: [Name]

**Completed**: [Date]

**Changes Made**:
- [What was actually done]
- [Any deviations from plan]
```

### Workflow

1. During brainstorming, Type A subjects are identified
2. `/flow-brainstorm-review` creates "Pre-Implementation Tasks" section
3. User completes each pre-task (or AI helps)
4. Mark each pre-task ✅ with completion date
5. Only after ALL pre-tasks done → `/flow-brainstorm-complete`

### Why This Pattern Exists

**Problem**: During brainstorming, you discover small blocking issues:
- Interface signature is wrong
- Enum is missing a value
- Legacy code doesn't support new pattern
- Type definitions need update

**Without Pre-Tasks**:
- Start implementation
- Hit blocker
- Stop to fix blocker
- Lose context
- Take longer overall

**With Pre-Tasks**:
- Identify blockers upfront during brainstorming
- Fix them while context is fresh
- Start implementation with clean path
- No interruptions

## Bugs Discovered Pattern

**Use Case**: During brainstorming, you analyze reference implementations and find bugs

**Pattern**:
```markdown
#### Bugs Discovered in Reference Implementation

##### Bug 1: Race Condition in PaymentService

**Location**: `src/services/PaymentService.ts:145`

**Problem**:
```typescript
// Current code (buggy)
async processPayment(amount: number) {
  const status = await this.checkStatus();
  // Race condition: status can change between check and update
  await this.updatePayment(status);
}
```

**Fix**:
```typescript
// Fixed code
async processPayment(amount: number) {
  await this.db.transaction(async (tx) => {
    const status = await this.checkStatus(tx);
    await this.updatePayment(status, tx);
  });
}
```

**Impact**: Could cause duplicate charges in concurrent requests

**Action**: Add to Pre-Implementation Tasks
```

**Why Document This**:
- Shows thorough analysis
- Prevents reintroducing same bugs
- Helps team learn from reference code
- Documents why certain patterns are used


<!-- AI_SCAN:IMPLEMENTATION_PATTERN:1880-1970 -->
# Implementation Pattern (Complete Guide)

## What is Implementation?

**Implementation** is the coding phase where you execute action items from brainstorming.

**Location**: Inside task file, within iteration section, after brainstorming

**Prerequisite**: Brainstorming must be ✅ COMPLETE (status 🎨 READY)

## Implementation Structure

```markdown
#### Implementation - Iteration [N]: [Name]

**Status**: 🚧 IN PROGRESS

**Action Items**: See resolved subjects above

**Implementation Notes**:
[Document discoveries, decisions, challenges during work]

**Files Modified**:
- [file1.ts] - [what changed]
- [file2.ts] - [what changed]

**Verification**:
- ✅ [verification step 1]
- ✅ [verification step 2]
```

## Implementation Workflow

### 1. `/flow-implement-start`

**Prerequisites**:
- Brainstorming ✅ COMPLETE
- All pre-implementation tasks ✅ COMPLETE
- Iteration status is 🎨 READY

**Effect**:
- Adds "Implementation" section to current iteration
- Changes iteration status: 🎨 READY → 🚧 IN PROGRESS
- Updates DASHBOARD.md

### 2. Do the Work

**During Implementation**:
- Work through action items from resolved subjects
- Document discoveries in "Implementation Notes"
- Track files modified
- Note any deviations from plan

**Good Implementation Notes**:
```markdown
**Implementation Notes**:
- Discovered Stripe SDK v12 deprecated `charges.create()`, using `paymentIntents.create()` instead
- Added StripeErrorMapper class to convert SDK errors to domain errors (not in original plan, but needed)
- Performance: API calls taking 200-300ms, added caching layer (will document in Architecture)
- Bug found: Existing PaymentRepository missing transaction support, added in separate commit
```

### 3. `/flow-implement-complete`

**Prerequisites**:
- All action items done
- Code works (tests pass)
- Implementation notes updated

**Effect**:
- Marks iteration ✅ COMPLETE
- Updates DASHBOARD.md
- Moves to next iteration or completes task

## Verification Checklist

Before marking iteration complete, verify:

**Code Quality**:
- [ ] All action items implemented
- [ ] Code follows project style guide
- [ ] No commented-out code or TODOs left behind
- [ ] Error handling in place

**Testing**:
- [ ] Unit tests written and passing
- [ ] Integration tests if needed
- [ ] Manual testing done
- [ ] Edge cases covered

**Documentation**:
- [ ] Implementation notes updated
- [ ] Files modified list complete
- [ ] Any architecture changes documented in PLAN.md
- [ ] Code comments for complex logic

**Integration**:
- [ ] Works with existing code
- [ ] No breaking changes (or documented if intentional)
- [ ] Dependencies satisfied
- [ ] Performance acceptable

## When to Mark Complete

**✅ Mark Complete When**:
- All verification checklist items done
- You would be comfortable shipping this
- Another developer could understand what was done
- No blocking issues remain

**❌ Don't Mark Complete When**:
- Tests are failing
- Code is partially implemented
- "TODO: finish this later" comments exist
- Blocking bugs discovered but not fixed

---

<!-- AI_SCAN:STATUS_MANAGEMENT:1972-2100 -->
# Status Management

## Status Marker Lifecycle

### Phase Lifecycle

```
⏳ PENDING (created)
    ↓
    /flow-phase-start
    ↓
🚧 IN PROGRESS (working on tasks)
    ↓
    /flow-phase-complete (all tasks done)
    ↓
✅ COMPLETE
```

**Alternative Endings**:
- ❌ CANCELLED (decided not to do this phase)
- 🔮 DEFERRED (moved to V2/V3, added to BACKLOG.md)

### Task Lifecycle (with Iterations)

```
⏳ PENDING (created)
    ↓
    /flow-task-start
    ↓
🚧 IN PROGRESS (working on iterations)
    ↓
    /flow-task-complete (all iterations done)
    ↓
✅ COMPLETE
```

### Iteration Lifecycle

```
⏳ PENDING (created)
    ↓
    /flow-brainstorm-start
    ↓
🚧 IN PROGRESS (brainstorming)
    ↓
    /flow-brainstorm-complete (all subjects resolved, pre-tasks done)
    ↓
🎨 READY (ready to implement)
    ↓
    /flow-implement-start
    ↓
🚧 IN PROGRESS (implementing)
    ↓
    /flow-implement-complete (all action items done, verified)
    ↓
✅ COMPLETE
```

**Simplified Path** (no brainstorming):
```
⏳ PENDING
    ↓
    /flow-implement-start (if no brainstorming needed)
    ↓
🚧 IN PROGRESS
    ↓
    /flow-implement-complete
    ↓
✅ COMPLETE
```

## State Transitions

### Valid Transitions

**Phase**:
- ⏳ → 🚧 (start)
- 🚧 → ✅ (complete)
- 🚧 → ❌ (cancel)
- 🚧 → 🔮 (defer)
- ⏳ → ❌ (cancel before starting)
- ⏳ → 🔮 (defer before starting)

**Task**:
- ⏳ → 🚧 (start)
- 🚧 → ✅ (complete)
- 🚧 → ❌ (cancel)
- 🚧 → 🔮 (defer)

**Iteration**:
- ⏳ → 🚧 (start brainstorming or implementing)
- 🚧 → 🎨 (finish brainstorming)
- 🎨 → 🚧 (start implementing)
- 🚧 → ✅ (finish implementing)

### Invalid Transitions

**Never Do This**:
- ❌ ✅ → 🚧 (reopening completed work - create new iteration instead)
- ❌ ⏳ → ✅ (skipping work - mark cancelled or remove if never needed)
- ❌ 🎨 → ⏳ (moving backwards - if brainstorming wrong, add new iteration)

## Common Pitfalls

### Pitfall 1: Marking Complete Too Early

**Problem**:
```markdown
### Iteration 2: Error Handling ✅ COMPLETE

**Implementation Notes**:
- Started implementing retry logic
- TODO: finish exponential backoff
- TODO: add tests
```

**Why Bad**: Work is not done, tests missing, TODOs present

**Fix**: Keep status 🚧 IN PROGRESS until ALL work done

### Pitfall 2: Not Updating DASHBOARD.md

**Problem**: Update task file status but forget DASHBOARD.md

**Effect**: DASHBOARD.md shows wrong current work, user is confused

**Fix**: Commands automatically update both files

### Pitfall 3: Skipping Brainstorming

**Problem**:
```markdown
### Iteration 2: Complex Feature ⏳

[Immediately start implementing without design]
```

**Why Bad**: No decisions documented, will need refactoring later

**Fix**: Always brainstorm for complex work, only skip for trivial iterations

### Pitfall 4: Mixing Status in DASHBOARD and Task File

**Problem**:
- DASHBOARD.md shows Iteration 2 🚧 IN PROGRESS
- Task file shows Iteration 2 ✅ COMPLETE

**Why Bad**: Source of truth is inconsistent

**Fix**: `/flow-verify-plan` detects this, always update both together

## Recovery from Incorrect States

### Reopening Completed Work

**Scenario**: Marked iteration complete, but found bugs/issues

**Wrong Approach**: Change ✅ → 🚧

**Right Approach**:
1. Keep original iteration ✅ COMPLETE
2. Add new iteration: "Iteration N+1: Fix Issues from Iteration N"
3. Document what needs fixing

**Why**: Preserves history, shows work progression

### Abandoned Work

**Scenario**: Started iteration, decided not to finish

**Options**:
1. **Cancel**: Mark ❌ CANCELLED with reason
2. **Defer**: Mark 🔮 DEFERRED, move to BACKLOG.md with reason
3. **Remove**: If truly never started, just delete iteration

**Choose Cancel/Defer**: When some work was done or decision has value

**Choose Remove**: When created by mistake, no work done

### Stuck in Brainstorming

**Scenario**: Brainstorming taking too long, can't resolve subjects

**Solution**:
1. Review resolved subjects
2. Identify if subject should be Type C (auto-resolved)
3. Consider if subject should move to separate iteration
4. If truly stuck, add subject as "Research spike" iteration

---

<!-- AI_SCAN:FILE_TEMPLATES:2102-2600 -->
# File Templates

## DASHBOARD.md Template

```markdown
# [Project Name] - Dashboard

**Last Updated**: [Date & Time]

**Project**: [Brief one-liner]
**Status**: [Overall status]
**Version**: [V1/V2/V3]

---

## 📍 Current Work

- **Phase**: [Phase N - Name](phase-N/)
- **Task**: [Task M - Name](phase-N/task-M.md)
- **Iteration**: [Iteration K - Name](phase-N/task-M.md#iteration-K) [Status Emoji]
- **Focus**: [One sentence describing current work]

---

## 📊 Progress Overview

### Phase 1: [Name] [Status Emoji]

**Goal**: [One sentence phase goal]
**Status**: [Completion summary, e.g., "3/3 tasks complete"]

**Tasks**:
- [Status Emoji] **Task 1**: [Name] ([X/Y iterations])
  - [Status Emoji] Iteration 1: [Name]
  - [Status Emoji] Iteration 2: [Name]
- [Status Emoji] **Task 2**: [Name] ([X/Y iterations])
  - [Status Emoji] Iteration 1: [Name]

### Phase 2: [Name] [Status Emoji]

**Goal**: [One sentence phase goal]
**Status**: [Completion summary]

**Tasks**:
- [Status Emoji] **Task 1**: [Name] ([X/Y iterations])
  - [Status Emoji] Iteration 1: [Name]
  - 🚧 Iteration 2: [Name] ← **CURRENT**
  - ⏳ Iteration 3: [Name]

---

## 💡 Key Decisions

**Decision Needed**: [Question for user]
- Option A: [Choice] - [Rationale]
- Option B: [Choice] - [Rationale]
- **Recommendation**: [If AI has suggestion]

**Resolved**:
- **[Date]**: [Decision made] - [Brief rationale]
```

---

## PLAN.md Template

```markdown
# [Feature/Project Name] - Development Plan

> **📖 Framework Guide**: See [DEVELOPMENT_FRAMEWORK.md](DEVELOPMENT_FRAMEWORK.md) for complete methodology
> **📍 Current Progress**: See [DASHBOARD.md](DASHBOARD.md) for real-time status tracking
> **🎯 Purpose**: [One sentence describing what this feature/project does]

**Created**: [Date]
**Version**: [V1/V2/V3]
**Plan Location**: `.flow/` (managed by Flow framework)

---

## Overview

### Purpose

[2-3 paragraphs explaining WHY this feature exists and WHAT problem it solves]

### Goals

[Describe what success looks like - text format, NOT checklists]

**Primary Goals**:
- [Measurable goal 1]
- [Measurable goal 2]
- [Measurable goal 3]

**Success Criteria**:
- [How we know this is successful]
- [Performance targets, if applicable]
- [User experience goals]

### Scope

**V1 Scope** (Current Session):
- [Feature 1]
- [Feature 2]
- [Feature 3]
- [Constraint/limitation]

**Note**: V2/V3/Out-of-Scope sections only included if user explicitly requests them. Default to V1-only scope for minimal planning overhead.

---

## Architecture

### System Context

[High-level description of how this feature fits into the system - describe WHAT exists, NOT prescriptive current-vs-desired with line numbers]

**Components**:
- **[ComponentName]**: [Responsibility]
- **[ComponentName]**: [Responsibility]

**Key Dependencies**:
- [Internal service/module]: [What we need from it]
- [External library/API]: [Why we need it, version if relevant]

**Reference Implementations** (if relevant):
- [Existing code to learn from]: [File path or description]
- [Similar feature]: [What to reuse/avoid]

---

## DO / DON'T Guidelines

**✅ DO**:
- [Best practice for this project]
- [Quality standard to maintain]
- [Pattern to follow]

**❌ DO NOT**:
- [Anti-pattern to avoid]
- [Common mistake to prevent]
- [Constraint to respect]

---

## Notes & Learnings

**Design Decisions**:
- [Date]: [Decision made and rationale]

**References**:
- [External doc]: [URL]
- [Internal doc]: [Path]
```

---

## task-N.md Template (With Iterations)

```markdown
# Task [N]: [Task Name]

**Status**: ⏳ PENDING
**Phase**: [Phase M - Name](../DASHBOARD.md#phase-M-name)
**Purpose**: [One sentence - what this task accomplishes]

---

## Task Overview

[2-3 paragraphs describing this task in detail]

**Why This Task**: [Explanation of why this task is necessary]

**Dependencies**:
- **Requires**: [Task name/number] - [What we need from it]
- **Blocks**: [Task name/number] - [What depends on this]

**Estimated Complexity**: [Low/Medium/High] ([X iterations expected])

---

## Iterations

### ⏳ Iteration 1: [Name]

**Goal**: [One sentence - what this iteration achieves]

**Status**: ⏳ PENDING

---

#### Brainstorming Session - [Iteration Name]

(Optional - design decisions will be documented here if needed)

**Focus**: [What we're designing - TBD]

**Subjects to Discuss**:
- (Add subjects with /flow-brainstorm-subject)

**Resolved Subjects**:
- (Filled during brainstorming)

---

#### Action Items

- [ ] [TBD - Define during brainstorming or add directly]

---

### ⏳ Iteration 2: [Name]

**Goal**: [One sentence - what this iteration achieves]

**Status**: ⏳ PENDING

---

#### Brainstorming Session - [Iteration Name]

(Optional - design decisions will be documented here if needed)

**Focus**: [What we're designing - TBD]

**Subjects to Discuss**:
- (Add subjects with /flow-brainstorm-subject)

**Resolved Subjects**:
- (Filled during brainstorming)

---

#### Action Items

- [ ] [TBD - Define during brainstorming or add directly]

---

## Task Notes

**Discoveries**:
- [Things learned while working on this task]

**Decisions**:
- [Task-specific decisions made]

**References**:
- [Relevant code]: [Path]
- [Documentation]: [URL]
```

---

## Iteration Section Template (Full)

```markdown
### [Status Emoji] Iteration [N]: [Name]

**Goal**: [One sentence]

**Status**: [Status]

---

#### Pre-Implementation Tasks

(Optional - only if Type A subjects identified during brainstorming)

##### ⏳ Pre-Task 1: [Name]

**Why Blocking**: [Explanation]

**Scope** (< 30 min):
- [What to do]

**Files**:
- [file1]

**Test**: [How to verify]

---

#### Brainstorming Session - [Topic]

(Optional - only for complex iterations requiring design decisions)

**Focus**: [What we're designing]

**Subjects to Discuss**:
1. ⏳ [Subject name]
2. ⏳ [Subject name]

**Resolved Subjects**:

---

##### ✅ Subject 1: [Name]

**Decision**: [The decision made]

**Resolution Type**: [A/B/C/D]

**Rationale**: [Why this decision]

**Resolution Items** (if Type D):
- [Item to do]
- [Item to do]

**Note**: Type A creates Pre-Tasks. Type B updates PLAN.md immediately. Type C references other subjects. Type D creates Resolution Items.

---

#### Action Items

(Required - ONE list per iteration)

**If brainstorming**: `/flow-brainstorm-review` consolidates all Resolution Items into this list
**If no brainstorming**: List action items directly

- [ ] [Action item 1]
- [ ] [Action item 2]
- [ ] [Action item 3]

---

#### Implementation - Iteration [N]: [Name]

(Added by `/flow-implement-start`, updated during work, completed by `/flow-implement-complete`)

**Status**: 🚧 IN PROGRESS

**Implementation Notes**:
- [Discovery during implementation]
- [Change from plan]

**Files Modified**:
- [file1.ts] - [what changed]
- [file2.ts] - [what changed]

**Verification**:
- ✅ [Test passed]
- ✅ [Manual verification done]
```


<!-- AI_SCAN:COMMAND_PATTERNS:2726-2900 -->
# Command Patterns

## Dashboard-First Navigation Pattern (Detailed)

**Used By**: 16 commands (brainstorming, implementation, state management)

### Pattern Steps

```
1. Read DASHBOARD.md
2. Extract current context from "📍 Current Work" section:
   - Phase number (e.g., "Phase 2")
   - Task number (e.g., "Task 3")
   - Iteration number (e.g., "Iteration 2")
3. Construct task file path: phase-{N}/task-{M}.md
4. Read task file
5. Locate relevant section (e.g., Iteration K)
6. Perform operation (read/edit)
7. Update DASHBOARD.md with new state
```

### Example Implementation

**Command**: `/flow-implement-start`

```
Step 1: Read DASHBOARD.md
→ Extract: Phase 2, Task 3, Iteration 2

Step 2: Construct path
→ phase-2/task-3.md

Step 3: Read phase-2/task-3.md
→ Find "### Iteration 2: Error Handling"

Step 4: Check prerequisites
→ Brainstorming status: ✅ COMPLETE
→ Iteration status: 🎨 READY

Step 5: Add Implementation section
→ Insert "#### Implementation - Iteration 2: Error Handling"
→ Add structure (Status, Action Items, Implementation Notes, etc.)

Step 6: Update DASHBOARD.md
→ Change "Iteration 2" status: 🎨 READY → 🚧 IN PROGRESS
→ Update "Last Updated" timestamp
→ Update "Current Work" section if needed

Step 7: Notify user
→ "Started implementation of Iteration 2. See phase-2/task-3.md for details."
```

### Commands Using This Pattern

- `/flow-brainstorm-start`
- `/flow-brainstorm-subject`
- `/flow-next-subject`
- `/flow-brainstorm-review`
- `/flow-brainstorm-complete`
- `/flow-implement-start`
- `/flow-implement-complete`
- `/flow-iteration-add`
- `/flow-task-start`
- `/flow-task-complete`
- `/flow-next`
- `/flow-next-iteration`

---

## Structure Creation Pattern

**Used By**: 4 commands (blueprint, phase-add, task-add, migrate)

### Pattern Steps

```
1. Read DASHBOARD.md (or create if missing for blueprint)
2. Determine what to create:
   - New phase directory?
   - New task file?
   - Initial project structure?
3. Create directory/file with template content
4. Update DASHBOARD.md to include new structure
5. Notify user with file paths created
```

### Example: `/flow-task-add "API Integration"`

```
Step 1: Read DASHBOARD.md
→ Current phase: Phase 2

Step 2: Determine next task number
→ Read phase-2/ directory
→ Find existing files: task-1.md, task-2.md
→ Next task number: 3

Step 3: Create phase-2/task-3.md
→ Use "Task with Iterations" template
→ Fill in: Task name, Phase link, Status ⏳

Step 4: Update DASHBOARD.md
→ Add to Phase 2 section:
  "- ⏳ **Task 3**: API Integration"

Step 5: Notify user
→ "Created phase-2/task-3.md. Use /flow-task-start to begin work."
```

---

## Full Traversal Pattern

**Used By**: 4 commands (status, summarize, verify-plan, plan-split)

### Pattern Steps

```
1. Read DASHBOARD.md
2. Extract all phases from "Progress Overview" section
3. For each phase:
   a. Read phase directory (phase-N/)
   b. List all task files (task-*.md)
   c. Read each task file
   d. Extract relevant information (status, iterations, completion)
4. Aggregate information
5. Generate report or perform validation
6. Return result to user
```

### Example: `/flow-summarize`

```
Step 1: Read DASHBOARD.md
→ Find phases: Phase 1, Phase 2, Phase 3

Step 2: For Phase 1:
→ Read phase-1/ directory
→ Files: task-1.md, task-2.md, task-3.md
→ Read each file, extract:
  - Task name
  - Status
  - Iteration count
  - Key decisions from brainstorming

Step 3: For Phase 2:
→ (repeat same process)

Step 4: For Phase 3:
→ (repeat same process)

Step 5: Generate summary
→ Format output:
  # Project Summary
  
  ## Phase 1: Foundation ✅ COMPLETE
  - Task 1: Project Setup (3 iterations) ✅
    - Key decisions: Singleton pattern, env-based config
  - Task 2: Core Models (2 iterations) ✅
    - Key decisions: Entity validation, repository pattern
  
  ## Phase 2: Core Implementation 🚧 IN PROGRESS
  ...
  
Step 6: Return summary to user
```

---

## Cross-File Search Pattern

**Used By**: 4 commands (backlog-add, backlog-pull, next-iteration, rollback)

### Pattern Steps

```
1. Read DASHBOARD.md (understand scope)
2. Determine search criteria:
   - Looking for next ⏳ iteration?
   - Finding task by number?
   - Searching for specific status?
3. Use Grep or Read to search across multiple task files
4. Collect matches
5. Perform operation (move to backlog, update status, etc.)
6. Update DASHBOARD.md if needed
7. Return result
```

### Example: `/flow-next-iteration`

```
Step 1: Read DASHBOARD.md
→ Current: Phase 2, Task 3, Iteration 2 (in progress)

Step 2: Determine next iteration to work on
→ Check current task file first (phase-2/task-3.md)
→ Look for next ⏳ iteration after current one

Step 3: Read phase-2/task-3.md
→ Find iterations:
  - Iteration 1: ✅ COMPLETE
  - Iteration 2: 🚧 IN PROGRESS (current)
  - Iteration 3: ⏳ PENDING ← FOUND
  - Iteration 4: ⏳ PENDING

Step 4: If found in current task
→ Return "Iteration 3: Retry Logic"
→ Show goal and status

Step 5: If not found in current task
→ Look at next task in current phase
→ Then next phase if needed

Step 6: Return result
→ "Next iteration: Iteration 3 - Retry Logic (phase-2/task-3.md)"
```

---

<!-- AI_SCAN:COMPLETE_WORKFLOW:2902-3200 -->
# Complete Workflow Examples

## Example 1: Payment Gateway Integration (Full Feature)

### Project Setup

```bash
# Create new project
/flow-blueprint

AI: Please provide project details:
- Feature name?
- Purpose?
- High-level phases?

User: Payment Gateway Integration
      Integrate Stripe for credit card payments
      Phases: Foundation, Core Implementation, Testing

AI: Created:
- DASHBOARD.md
- PLAN.md
- phase-1/ (Foundation)
- phase-1/task-1.md (Project Setup)
```

**Files Created**:
- `.flow/DASHBOARD.md` - Progress tracking
- `.flow/PLAN.md` - Overview, architecture, testing strategy
- `.flow/phase-1/` - First phase directory
- `.flow/phase-1/task-1.md` - Initial task

---

### Working Through Phase 1

```bash
# Start first phase
/flow-phase-start

# Add tasks to Phase 1
/flow-task-add "Project Setup"
/flow-task-add "Core Models"

# Start first task
/flow-task-start

# Add iteration to Task 1
/flow-iteration-add "Repository Structure"

# Start brainstorming
/flow-brainstorm-start

AI: What subjects should we discuss for Repository Structure?

User: Directory layout, Configuration setup, Dependency management

AI: Added 3 subjects to brainstorming. Use /flow-next-subject to begin.

# Resolve subjects
/flow-next-subject

AI: Let's discuss Subject 1: Directory Layout
    What structure should we use?

User: Standard src/ structure with feature-based organization

AI: Is this:
    A) Pre-implementation task
    B) Documentation update
    C) Auto-resolved
    D) Main iteration work

User: D

AI: Action items?

User: Create src/payment/ directory, Add index files, Setup barrel exports

AI: Subject 1 resolved. 2 subjects remaining.

/flow-next-subject
[... continue resolving subjects ...]

# After all subjects resolved
/flow-brainstorm-review

AI: Reviewing all 3 subjects...
    - Subject 1: Directory layout (Type D)
    - Subject 2: Config setup (Type D)
    - Subject 3: Dependencies (Type A - Pre-task)
    
    Pre-implementation task identified:
    - Update package.json with Stripe SDK
    
    Ready to proceed?

User: Yes

# Complete pre-task
[Install Stripe SDK]

# Complete brainstorming
/flow-brainstorm-complete

AI: Brainstorming complete. Iteration 1 is now 🎨 READY.
    Use /flow-implement-start to begin coding.

# Start implementation
/flow-implement-start

# Do the work
[Create directory structure, setup config, etc.]

# Complete implementation
/flow-implement-complete

AI: Iteration 1 complete! ✅
    Next: Use /flow-iteration-add for Iteration 2, or /flow-task-complete if task is done.
```

**Files Updated During This Workflow**:
1. **DASHBOARD.md**:
   - Phase 1 status: ⏳ → 🚧
   - Task 1 status: ⏳ → 🚧 → ✅
   - Current work pointer updated throughout
   - Progress percentages updated

2. **phase-1/task-1.md**:
   - Task status: ⏳ → 🚧
   - Iteration 1 added
   - Brainstorming section filled
   - Implementation notes added
   - Status: 🚧 → ✅

---

### Moving to Phase 2

```bash
# Complete Phase 1
/flow-phase-complete

AI: Phase 1 complete! ✅
    Ready to start Phase 2?

# Add Phase 2
/flow-phase-add "Core Implementation"

# Start Phase 2
/flow-phase-start

# Add tasks
/flow-task-add "API Integration"
/flow-task-add "Webhook Handler"
/flow-task-add "Error Handling"

# Work through tasks
[... repeat similar workflow as Phase 1 ...]
```

---

## Example 2: Simple Task with Single Iteration

```bash
# Add simple task
/flow-task-add "Update Documentation"

AI: Created phase-2/task-4.md
    Task created with iterations structure.

    Since this is simple documentation work, you can:
    - Add one iteration with direct action items (skip brainstorming)
    - Start, implement, and complete quickly

# Add single iteration
/flow-iteration-add "Documentation Updates"

AI: Added Iteration 1 to Task 4.
    For simple work, you can skip brainstorming and add action items directly.

User: Add these action items:
      - Update README
      - Fix typos
      - Add examples

AI: Added 3 action items to Iteration 1.
    Use /flow-implement-start to begin.

# Start implementation
/flow-implement-start

# Do the work
[Update docs]

# Complete implementation
/flow-implement-complete

AI: Iteration 1 complete! ✅
    Task 4 has 1/1 iterations complete.
    Use /flow-task-complete to mark task done.

/flow-task-complete

AI: Task 4 complete! ✅
    Moving to next task...
```

**Note**: Simple tasks use one iteration with direct action items - no brainstorming required.

---

## Example 3: Deferring Work to Backlog

```bash
# During Phase 2, decide to defer a task
/flow-backlog-add 5 "Multi-currency support adds too much complexity for V1"

AI: Moved Task 5 to BACKLOG.md with reason.
    Updated DASHBOARD.md to reflect removal.

# Later, pull it back
/flow-backlog-pull 5

AI: Pulled Task 5 from backlog.
    Added to end of Phase 2.
    Updated DASHBOARD.md.
```

---

## Example 4: Archiving Completed Work

```bash
# After completing Phase 1 and Phase 2
/flow-plan-split

AI: Archiving completed work...
    - Phase 1: 3 tasks archived
    - Phase 2: Task 1-2 archived (completed only)
    
    Created ARCHIVE.md with all completed task details.
    
    Updated task files to reference archive:
    - phase-1/task-1.md → "See ARCHIVE.md"
    - phase-1/task-2.md → "See ARCHIVE.md"
    - phase-2/task-1.md → "See ARCHIVE.md"
    - phase-2/task-2.md → "See ARCHIVE.md"
    
    DASHBOARD.md now shows only active work.
```

---

<!-- AI_SCAN:BACKLOG_MANAGEMENT:3202-3500 -->
# Backlog Management

## BACKLOG.md Structure

```markdown
# Project Backlog

**Last Updated**: [Date]

---

## 📋 Backlog Dashboard

**Total Items**: [N]

**By Version**:
- V2 Features: [N]
- V3 Features: [N]
- Technical Debt: [N]
- Deferred Tasks: [N]

**By Priority**:
- High: [N]
- Medium: [N]
- Low: [N]

---

## Backlog Items

### High Priority

#### ⏳ Task: Multi-Currency Support

**Originally Planned**: Phase 2, Task 6
**Deferred To**: V2
**Priority**: High

**Reasoning**:
V1 scope focuses on USD only. Multi-currency requires:
- Exchange rate API integration
- Currency conversion logic
- Multi-currency display in UI
- Testing across currencies

This adds 2-3 weeks and is not critical for V1 launch.

**Estimated Effort**: 2-3 weeks
**Dependencies**: Core payment processing complete (Phase 2, Task 1-3)

**When to Pull Back**:
- After V1 launch
- When international customers become priority
- When we have exchange rate API access

---

#### ⏳ Task: Advanced Retry Logic with Circuit Breaker

**Originally Planned**: Phase 2, Task 3, Iteration 3
**Deferred To**: V2
**Priority**: High

**Reasoning**:
Basic retry logic (3 attempts, exponential backoff) is sufficient for V1.
Circuit breaker pattern adds value but requires:
- State management for circuit status
- Monitoring and alerting integration
- Configuration management
- Additional testing

**Estimated Effort**: 1 week
**Dependencies**: Basic retry logic (Phase 2, Task 3, Iteration 2)

---

### Medium Priority

#### ⏳ Feature: Saved Payment Methods

**Deferred To**: V2
**Priority**: Medium

**Reasoning**:
V1 focuses on one-time payments. Saved payment methods require:
- Secure token storage
- Card management UI
- PCI compliance review
- Additional security testing

**Estimated Effort**: 2 weeks
**Dependencies**: Payment processing complete, Security audit done

---

### Low Priority

#### ⏳ Technical Debt: Refactor PaymentService

**Deferred To**: V3
**Priority**: Low

**Reasoning**:
Current PaymentService works but has some code duplication.
Not urgent, can refactor after V2 when we understand all use cases better.

**Estimated Effort**: 3-4 days
**Dependencies**: None

---

## Removed from Backlog

### Task: ACH Payment Support

**Originally**: V2 Feature
**Removed**: 2025-01-20
**Reason**: Business decision - focus on credit cards only for foreseeable future
```

---

## Backlog Commands

### `/flow-backlog-add [task-number] "[reason]"`

**Purpose**: Move task from active plan to backlog

**Usage**:
```bash
# Move single task
/flow-backlog-add 6 "Multi-currency adds too much complexity for V1, deferring to V2"

# Move range of tasks
/flow-backlog-add 6-8 "These features are V2 scope"
```

**Effect**:
1. Reads DASHBOARD.md, finds Phase/Task info
2. Reads task file (phase-N/task-M.md)
3. Copies task details to BACKLOG.md with reason
4. Marks task as 🔮 DEFERRED in DASHBOARD.md
5. Updates task file status to 🔮 DEFERRED with reference to BACKLOG.md

**Task File After**:
```markdown
# Task 6: Multi-Currency Support

**Status**: 🔮 DEFERRED
**Deferred To**: V2
**Reason**: Too complex for V1 scope

See [BACKLOG.md](../BACKLOG.md#task-multi-currency-support) for details and reasoning.
```

---

### `/flow-backlog-view`

**Purpose**: Show backlog contents

**Usage**:
```bash
/flow-backlog-view
```

**Output**:
```
Backlog Summary:
- Total items: 8
- V2 features: 5
- V3 features: 2
- Technical debt: 1

High Priority (3 items):
1. Multi-Currency Support (V2)
2. Advanced Retry Logic (V2)
3. Saved Payment Methods (V2)

Medium Priority (3 items):
...

See BACKLOG.md for full details.
```

---

### `/flow-backlog-pull [task-number] [position]"`

**Purpose**: Pull task from backlog back into active plan

**Usage**:
```bash
# Pull task, add to end of current phase
/flow-backlog-pull 6

# Pull task, insert after specific task
/flow-backlog-pull 6 "after task 3"

# Pull task, insert at beginning of phase
/flow-backlog-pull 6 "at start"
```

**Effect**:
1. Reads BACKLOG.md, finds task details
2. Determines current phase from DASHBOARD.md
3. Creates new task file in phase directory
4. Assigns next available task number
5. Updates DASHBOARD.md with new task
6. Removes from BACKLOG.md (or marks as pulled)

**Example**:
```bash
/flow-backlog-pull 6

AI: Pulled "Multi-Currency Support" from backlog.
    Created phase-2/task-6.md
    Updated DASHBOARD.md
    
    Task is now ⏳ PENDING in Phase 2.
    Use /flow-task-start when ready to begin.
```

---

## When to Use Backlog

### Use Backlog For:

**V2/V3 Features**:
- Features planned but not in current version scope
- Enhancements discovered during V1 development
- Nice-to-have features that aren't MVP

**Deferred Tasks**:
- Tasks started but decided against mid-development
- Tasks that turned out more complex than expected
- Tasks blocked by external dependencies (waiting for API access, etc.)

**Technical Debt**:
- Refactoring opportunities identified
- Code improvements that aren't urgent
- Performance optimizations that can wait

**Scope Creep Prevention**:
- Features requested during development that expand scope
- "Wouldn't it be cool if..." ideas
- Gold-plating attempts

### Don't Use Backlog For:

**Cancelled Work**:
- Use ❌ CANCELLED status in task file instead
- Document reason directly in task

**Bugs**:
- Bugs should be fixed, not backlogged
- Exception: Non-critical bugs in V2 features can be backlogged with V2

**Core MVP Features**:
- If it's truly needed for V1, keep it in active plan
- Descope properly rather than backlog everything

---

<!-- AI_SCAN:BEST_PRACTICES:3502-3800 -->
# Best Practices & Pitfalls

## Best Practices

### 1. Always Brainstorm for Complex Work

**✅ DO**:
```markdown
### Iteration 2: Error Handling ⏳

[Brainstorming section]
[Pre-implementation tasks]
[Implementation section]
```

**❌ DON'T**:
```markdown
### Iteration 2: Error Handling ⏳

[Start implementing without design]
```

**Why**: Brainstorming surfaces decisions early, prevents refactoring later.

---

### 2. Keep DASHBOARD.md Up-to-Date

**✅ DO**:
- Update DASHBOARD.md every time status changes
- Use commands that automatically update both files
- Run `/flow-status` regularly to verify state

**❌ DON'T**:
- Update task file but forget DASHBOARD.md
- Manually edit both files (error-prone)
- Let DASHBOARD.md get stale

**Why**: DASHBOARD.md is source of truth for current state. Stale dashboard confuses everyone.

---

### 3. Use Descriptive Commit Messages

**✅ DO**:
```bash
git commit -m "Complete Iteration 2: Error Handling

- Implemented RetryPolicy with exponential backoff
- Added error taxonomy mapping
- Fixed legacy ErrorHandler async support
- All tests passing

Updated: phase-2/task-3.md, DASHBOARD.md"
```

**❌ DON'T**:
```bash
git commit -m "updates"
```

**Why**: Commit history tells story of feature development.

---

### 4. Document Discoveries Immediately

**✅ DO**:
```markdown
**Implementation Notes**:
- Discovered Stripe SDK v12 deprecated charges API
- Switched to PaymentIntents API (newer, more flexible)
- Added StripeErrorMapper class (not in original plan)
- Performance: API calls 200-300ms, added caching
```

**❌ DON'T**:
```markdown
**Implementation Notes**:
(empty)
```

**Why**: Discoveries are valuable context for future work and team members.

---

### 5. Break Down Large Tasks

**✅ DO**:
```
Phase 2: Core Implementation
- Task 1: Database Layer (3 iterations)
- Task 2: Business Logic (4 iterations)
- Task 3: API Integration (4 iterations)
```

**❌ DON'T**:
```
Phase 2: Core Implementation
- Task 1: Everything (25 iterations)
```

**Why**: Smaller tasks are easier to reason about, track progress, and complete.

---

### 6. Use Pre-Implementation Tasks

**✅ DO**:
```markdown
#### Pre-Implementation Tasks

##### ⏳ Pre-Task 1: Fix Interface Signature

**Why Blocking**: Current interface doesn't support async
...

[Complete before /flow-brainstorm-complete]
```

**❌ DON'T**:
```markdown
[Start implementation]
[Hit blocker]
[Stop to fix blocker]
[Lose context]
```

**Why**: Unblock early while context is fresh.

---

### 7. Reference PLAN.md for Big Decisions

**✅ DO**:
- Update PLAN.md Architecture section for Type B decisions
- Reference PLAN.md when explaining system design
- Keep PLAN.md as single source of truth for architecture

**❌ DON'T**:
- Scatter architecture decisions across task files
- Forget to document major design choices
- Let PLAN.md get out of sync with reality

---

### 8. Use /flow-verify-plan Regularly

**✅ DO**:
```bash
/flow-verify-plan

# Run this:
- After bulk edits
- When feeling lost
- Before marking phase complete
- After pulling from git
```

**Why**: Catches inconsistencies early before they cause confusion.

---

## Common Pitfalls

### Pitfall 1: Skipping /flow-brainstorm-review

**Problem**:
```bash
/flow-next-subject  # Resolve all subjects
/flow-brainstorm-complete  # Skip review!
```

**Why Bad**: Miss identifying pre-implementation tasks, miss suggesting more iterations.

**Fix**: ALWAYS run `/flow-brainstorm-review` after resolving all subjects, BEFORE `/flow-brainstorm-complete`.

---

### Pitfall 2: Marking Complete Too Early

**Problem**:
```markdown
### Iteration 2: Error Handling ✅ COMPLETE

**Implementation Notes**:
- TODO: Add tests
- TODO: Fix edge case
```

**Why Bad**: Work not actually done, TODOs present.

**Fix**: Only mark ✅ COMPLETE when ALL work done, verified, and no TODOs remain.

---

### Pitfall 3: Not Reading DASHBOARD.md First

**Problem**:
```
[AI tries to edit task file without reading DASHBOARD.md]
[Edits wrong task/iteration]
[Causes confusion]
```

**Why Bad**: Don't know current context, edit wrong places.

**Fix**: ALWAYS read DASHBOARD.md first (dashboard-first pattern).

---

### Pitfall 4: Creating Too Many Small Tasks

**Problem**:
```
Phase 2: Core Implementation
- Task 1: Create class (1 action item)
- Task 2: Add method (1 action item)
- Task 3: Add another method (1 action item)
[... 20 tiny tasks ...]
```

**Why Bad**: Overhead of task management exceeds value.

**Fix**: Combine related small work into one task with multiple action items or iterations.

---

### Pitfall 5: Not Linking Files

**Problem**:
```markdown
# Task 3 in phase-2/task-3.md

**Phase**: Phase 2
```

**Why Bad**: No clickable link back to DASHBOARD.md, hard to navigate.

**Fix**: Always use markdown links:
```markdown
**Phase**: [Phase 2 - Core Implementation](../DASHBOARD.md#phase-2-core-implementation)
```

---

### Pitfall 6: Forgetting to Update Examples

**Problem**: Make changes to framework, forget to update example files.

**Why Bad**: Users learn from outdated examples.

**Fix**: After changing framework docs, update examples/ directory to match.

---

## Performance Tips

### For Large Projects

**Problem**: 100+ tasks across 10 phases = slow to navigate

**Solutions**:

1. **Use /flow-plan-split regularly**:
   - Archives completed work
   - Keeps active plan small
   - Old work still accessible in ARCHIVE.md

2. **Leverage DASHBOARD.md**:
   - Dashboard has jump links
   - Don't read all task files, just current one
   - Use Grep to search across files when needed

3. **Keep task files focused**:
   - One task per file
   - Don't let iterations grow too large
   - Split task if > 7-8 iterations

---

## Multi-Developer Workflows

### Git Merge Conflicts

**Problem**: Multiple developers editing same files

**With Multi-File Architecture**:
- Conflicts localized to specific task files
- DASHBOARD.md conflicts are small and obvious
- Much better than monolithic PLAN.md merge conflicts

**Best Practices**:
1. Each developer works on different tasks (different files)
2. Communicate before editing DASHBOARD.md
3. Pull frequently to stay in sync
4. Use `/flow-verify-plan` after merging

---

### Handoff Between Developers

**Scenario**: Developer A starts task, Developer B finishes it

**Process**:
1. Developer A updates DASHBOARD.md and task file with current state
2. Developer A commits and pushes
3. Developer B pulls, runs `/flow-status` to understand current state
4. Developer B reads current task file (DASHBOARD.md tells them which file)
5. Developer B continues work from current iteration

**Key**: DASHBOARD.md + task files preserve complete context for handoff.

---

## Summary of Key Rules

1. **Dashboard-First**: Always read DASHBOARD.md first
2. **Iterations-Only**: All tasks have iterations (simple tasks use single iteration)
3. **Brainstorm Complex Work**: Don't skip brainstorming for complex iterations
4. **Pre-Tasks Before Implementation**: Complete all pre-tasks before `/flow-brainstorm-complete`
5. **Review Before Complete**: Always `/flow-brainstorm-review` before `/flow-brainstorm-complete`
6. **Document Everything**: Implementation notes, discoveries, decisions
7. **Update Both Files**: Commands update both DASHBOARD.md and task files
8. **Verify Regularly**: Use `/flow-verify-plan` to catch inconsistencies
9. **Archive When Large**: Use `/flow-plan-split` to keep active plan manageable
10. **Use Backlog**: Defer scope creep to BACKLOG.md, don't delete work

---

**End of Complete Framework Documentation**

For quick reference, see lines 1-600 (Quick Reference section).
For specific sections, see Section Index (lines 543-614).

