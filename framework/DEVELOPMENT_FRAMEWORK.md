**Version**: 1.0

# Domain-Driven Design with Agile Iterative Philosophy

**A spec-driven iterative development framework for building complex features with minimal refactoring.**

---

## Philosophy

This framework combines **Domain-Driven Design** principles with an **Agile iterative approach** to software development. The core analogy is building the human body:

1. **Skeleton first** - Create the basic structure and foundational components
2. **Add veins** - Implement core data flow and connections
3. **Add flesh** - Layer on complexity incrementally
4. **Add fibers** - Refine and optimize

By splitting development into minuscule, well-planned iterations, you build a strong foundation and expand complexity over time while keeping refactoring to a minimum.

---

## Core Principles

### 1. Plan File as Single Source of Truth

- Every feature/project/issue has a dedicated `PLAN.md` file
- The plan file survives across sessions and maintains complete context
- All decisions, brainstorming results, and implementation progress are documented
- AI agents and humans can resume work from any point by reading the plan

### 2. Iterative Development Loop

```
PHASE → TASK → ITERATION → BRAINSTORM → IMPLEMENTATION → COMPLETE
                   ↓           ↓              ↓
               (repeat)   (subjects)    (action items)
```

### 3. Progressive Disclosure

- Each iteration focuses ONLY on what's needed NOW
- Future complexity is deferred to V2/V3/etc.
- Prevents scope creep and over-engineering

### 4. State Preservation

- Every step updates the plan file with checkboxes (✅ ⏳ 🚧)
- Timestamps and status markers track progress
- Complete audit trail of all decisions

### 5. Minimal Refactoring

- Brainstorm BEFORE implementing to make correct decisions upfront
- Split complex features into small, testable iterations
- Each iteration is complete and stable before moving to next

---

## Framework Structure

### Hierarchy

```
📋 PLAN.md (Feature/Project Plan File)
├── 📊 PHASE (High-level milestone)
│   ├── 📦 TASK (Feature/component to build)
│   │   ├── 🔄 ITERATION (Incremental buildout)
│   │   │   ├── 💭 BRAINSTORMING SESSION
│   │   │   │   ├── Subject 1 (Design decision)
│   │   │   │   ├── Subject 2 (Design decision)
│   │   │   │   └── Subject N...
│   │   │   │       └── Action Items (checkboxes)
│   │   │   └── 🛠️ IMPLEMENTATION
│   │   │       └── Execute action items
│   │   └── ✅ ITERATION COMPLETE
│   └── 🎯 TASK COMPLETE
└── 🏆 PHASE COMPLETE
```

---

## Development Workflow

### Step 1: Decide What to Work On

Choose the scope:

- **Phase**: Major milestone (e.g., "Core Implementation")
- **Task**: Specific feature/component (e.g., "Implement Green Service")
- **Iteration**: Incremental piece (e.g., "Iteration 1: Tier Generation")

### Step 2: Brainstorm

Break down the iteration into **subjects to discuss**:

- Architecture decisions
- Implementation approach
- Edge cases and constraints
- Data structures
- Algorithm choices

For each subject:

1. Discuss options (Option A, B, C...)
2. Document rationale
3. Make a decision
4. Create **action items** (checkboxes)

### Step 3: Implementation

Work through action items sequentially:

- Check off each item as completed
- Update plan file with results
- Add notes/discoveries during implementation

### Step 4: Mark Complete

- All action items checked → Iteration complete
- All iterations complete → Task complete
- All tasks complete → Phase complete

### Step 5: Repeat

Move to next iteration, applying lessons learned.

---

## Brainstorming Session Pattern

### Structure

```markdown
### **Brainstorming Session - [Topic Name]**

**Subjects to Discuss** (tackle one at a time):

1. ⏳ **Subject Name** - Brief description
2. ⏳ **Subject Name** - Brief description
3. ⏳ **Subject Name** - Brief description
   ...

**Resolved Subjects**:

---

### ✅ **Subject 1: [Name]**

**Decision**: [Your decision here]

**Rationale**:

- Reason 1
- Reason 2
- Reason 3

**Options Considered**:

- **Option A**: Description (✅ CHOSEN / ❌ REJECTED)
- **Option B**: Description (✅ CHOSEN / ❌ REJECTED)

**Action Items**:

- [ ] Action item 1
- [ ] Action item 2
- [ ] Action item 3

---

### ✅ **Subject 2: [Name]**

[Repeat pattern...]
```

### Brainstorming Guidelines

1. **One subject at a time** - Don't overwhelm yourself
2. **Document all options** - Even rejected ones (future reference)
3. **Explain rationale** - Why did you choose this approach?
4. **Create concrete action items** - Turn decisions into work
5. **Mark resolved** - Use ✅ to track progress
6. **Add subjects dynamically** - New topics can emerge during discussion

### Dynamic Subject Addition

**Subjects are NOT fixed upfront** - you can add new subjects as you work through brainstorming:

```markdown
**Subjects to Discuss**:

1. ✅ **API Design** - RESOLVED
2. 🚧 **Data Structure** - CURRENT (discussing now)
3. ⏳ **Error Handling** - PENDING
4. ⏳ **Type Conversion** - NEW (just added!)
5. ⏳ **Validation Strategy** - NEW (discovered during Subject 2)
```

**When to Add Subjects**:

- During discussion of current subject, you realize another topic needs addressing
- While resolving one subject, dependencies on other decisions become clear
- When analyzing code/reference, new questions arise
- After resolving a subject, implications suggest new topics

**How to Add**:

1. **IMMEDIATELY update PLAN.md**: Add new numbered item to "Subjects to Discuss" list with ⏳ status
2. Mark it as "NEW" or add brief context about why it was added
3. Continue with current subject - don't jump to new one immediately

**IMPORTANT**: Always update the "Subjects to Discuss" list in PLAN.md BEFORE continuing the discussion. This ensures you don't lose track of topics.

**Example**:
```markdown
User: "I now dislike the names... let's think about naming convention"

AI: "Great point! Let me add this as a subject to our brainstorming session first."

[AI updates PLAN.md:]

**Subjects to Discuss**:
1. 🚧 **Placeholder Detection Strategy** - CURRENT
2. ⏳ **Naming Convention** - NEW (emerged during Subject 1 discussion)
3. ⏳ **Handler Registration** (Q2 from Subject 1) - DEFERRED

AI: "Added Subject 2: Naming Convention to the list. Now, back to Subject 1..."
```

### Pre-Implementation Tasks During Brainstorming

**IMPORTANT**: When pre-implementation needs are discovered **during brainstorming**, DOCUMENT them immediately but DO NOT implement them yet.

**Workflow**:

1. **During brainstorming** (while discussing subjects)
2. User identifies pre-implementation need (e.g., "we need to create a validation stub in Blue")
3. **AI adds Pre-Implementation Tasks section** to PLAN.md:
   ```markdown
   ### **Pre-Implementation Tasks:**

   #### ⏳ Task 1: [Description] (PENDING)

   **Objective**: [What this task accomplishes]

   **Action Items**:
   - [ ] Item 1
   - [ ] Item 2
   ```
4. **Continue brainstorming** other subjects
5. **After all subjects resolved** → Complete pre-implementation tasks
6. **Mark pre-tasks as ✅ COMPLETE** with verification notes
7. **Then run `/flow-brainstorm_complete`**

**Example During Brainstorming**:

```markdown
User: "Before we continue, create a pre-implementation task to add a validation
      stub in Blue.validateSlotData() that returns true for now."

AI: "Added pre-implementation task. Continuing with Subject 1..."

### **Pre-Implementation Tasks:**

#### ⏳ Task 1: Create Blue Validation Stub (PENDING)

**Objective**: Add Blue.validateSlotData() method that returns true (placeholder
              for future validation logic)

**Action Items**:
- [ ] Add validateSlotData(slotData: I_SlotData): boolean method to Blue.ts
- [ ] Return true (stub implementation)
- [ ] Add TODO comment for future validation logic
- [ ] Create corresponding iteration in PLAN.md for actual implementation

---

[Continue brainstorming subjects...]
```
4. Address new subjects in order after completing current discussion

**Example Flow**:

```
Discussing Subject 2: Parser Architecture
  → Realize we need to decide on placeholder syntax first
  → Add "Subject 4: Placeholder Syntax Design" to list
  → Finish Subject 2 discussion
  → Move to Subject 3
  → Eventually get to Subject 4
```

**Benefits**:

- Captures insights as they emerge
- Prevents forgetting important topics
- Maintains focus on current subject
- Natural, organic planning process

---

## Implementation Pattern

### Structure

```markdown
### **Implementation - Iteration [N]: [Name]**

**Status**: 🚧 IN PROGRESS / ✅ COMPLETE

**Action Items** (from brainstorming):

- [x] Completed action item
- [x] Completed action item
- [ ] Pending action item

**Implementation Notes**:

[Document discoveries, challenges, solutions during implementation]

**Files Modified**:

- `path/to/file.ts` - Description of changes
- `path/to/file.ts` - Description of changes

**Verification**: [How you verified it works - tests, manual checks, etc.]

---
```

### Implementation Guidelines

1. **Follow action items** - Don't deviate from brainstorming decisions
2. **Check boxes as you go** - Maintain accurate state
3. **Document surprises** - Note anything unexpected
4. **Verify before completing** - Test/validate your work
5. **Update file list** - Track what changed

---

## Version Management

Features can be split into versions:

- **V1**: Minimum viable implementation (simple, functional)
- **V2**: Enhanced implementation (optimizations, edge cases)
- **V3**: Advanced features (rarely needed)

### When to Version

**Use V1 for:**

- Core functionality that must work
- Simple, testable implementations
- Proving the concept

**Defer to V2:**

- Performance optimizations
- Advanced edge cases
- Complex algorithms
- Nice-to-have features

**Mark in Plan:**

```markdown
**V1 Implementation**: [Description]
**V2 Enhancements** (Deferred to Phase 4):

- [ ] Optimization 1
- [ ] Feature 2
```

---

## Status Markers

**CRITICAL**: Status markers are **MANDATORY** at every level (Phase, Task, Iteration, Brainstorm, Subject). They are the ground truth for your project state.

### Marker Reference

| Marker | Meaning          | Usage                                           | Documentation Required       | Verification         |
| ------ | ---------------- | ----------------------------------------------- | ---------------------------- | -------------------- |
| ✅     | Complete         | Finished and verified (frozen, no re-verify)    | Completion date              | Skipped (frozen)     |
| ⏳     | Pending          | Not started yet                                 | None                         | Verified             |
| 🚧     | In Progress      | Currently working on this                       | None                         | Verified             |
| 🎨     | Ready            | Brainstorming done, ready to implement          | None                         | Verified             |
| ❌     | Cancelled        | Decided against (task/iteration/subject)        | **WHY** (mandatory!)         | Verified             |
| 🔮     | Deferred         | Moved to V2/V3/later phase                      | **WHY + WHERE** (mandatory!) | Verified             |

### Required Documentation

**For ❌ CANCELLED items:**

Must include reason for cancellation:

```markdown
##### Iteration 8: Custom Retry Logic ❌

**Status**: CANCELLED
**Reason**: SDK already handles retry logic with exponential backoff. Reimplementing would be redundant and error-prone.
**Cancelled on**: 2025-09-30
```

**For 🔮 DEFERRED items:**

Must include reason AND destination:

```markdown
##### Iteration 10: Name Generation 🔮

**Status**: DEFERRED to Phase 4 (V2)
**Reason**: Requires 124 name components with weighted selection system. Core generation must be proven first.
**Deferred to**: Phase 4, Task 11
**Deferred on**: 2025-10-01
```

### Mandatory Markers

**Every level MUST have a status marker:**

```markdown
### Phase 1: Foundation ✅

**Status**: COMPLETE
**Completed**: 2025-09-30

#### Task 1: Setup & Integration ✅

**Status**: COMPLETE
**Completed**: 2025-09-28

##### Iteration 1: Project Setup ✅

**Status**: COMPLETE
**Completed**: 2025-09-28

### **Brainstorming Session - API Setup** ✅

**Status**: COMPLETE

**Subjects to Discuss**:
1. ✅ **Credential Management** - RESOLVED
2. ❌ **Custom HTTP Client** - REJECTED (SDK is better)
3. 🔮 **Advanced Retry** - DEFERRED to V2
```

### Smart Verification

**Token-efficient validation:**

Commands verify only **active work** (🚧 ⏳ 🎨 ❌ 🔮) and skip completed items (✅):

- ✅ **COMPLETE** items = Verified when completed, now frozen (skipped)
- 🚧 **IN PROGRESS** items = Verify markers match Progress Dashboard
- ⏳ **PENDING** items = Verify markers exist
- ❌ **CANCELLED** items = Verify reason is documented
- 🔮 **DEFERRED** items = Verify reason and destination documented

**Example:**

```
🔍 Verification:
✅ Phase 2 marker: 🚧 IN PROGRESS ✓
✅ Task 5 marker: 🚧 IN PROGRESS ✓
✅ Iteration 6 marker: 🚧 IN PROGRESS ✓

⏭️  Skipped: 15 completed items (verified & frozen)
```

---

## Status Management Best Practices

### Single Source of Truth for Status

**CRITICAL**: Your PLAN.md should have **EXACTLY ONE** authoritative status indicator.

**Where to put status:**
- At the top of the file, in the metadata section
- Format: `**Status**: [Current phase/iteration]`
- Example: `**Status**: Phase 2, Task 5, Iteration 7 - In Progress`

**What NOT to do:**
- ❌ Creating multiple "Progress Tracking" or "Current Status" sections
- ❌ Adding status summaries at the bottom of the file
- ❌ Leaving old status sections when updating to new status

### Maintaining Status in Long-Running Projects

As your project grows (1000+ lines), status management becomes critical:

1. **Update status in-place** - Don't create new status sections, update the existing one at the top
2. **Use status markers** - Let ✅ ⏳ 🚧 markers indicate completion, don't duplicate this info
3. **Archive old summaries** - If you create progress summaries, move them to a "Status History" appendix
4. **Use slash commands** - `/flow-status` dynamically reads your PLAN.md and reports TRUE current state

### Status Section Template

```markdown
**Created**: 2025-10-01
**Status**: Phase 2, Task 5, Iteration 7 - In Progress
**Version**: V1
**Last Updated**: 2025-10-02
```

Update `**Status**` and `**Last Updated**` as you progress. **NEVER** add a second status section.

### Verification

Before starting a new AI session or after a long break:

1. Run `/flow-status` - See computed current state from PLAN.md
2. Run `/flow-verify-plan` - Verify PLAN.md matches actual project files
3. Update the `**Status**` line at top if needed

---

## Progress Dashboard (Required for Complex Projects)

### When to Use

**Required for:**
- ✅ Projects with 10+ iterations across multiple phases
- ✅ V1/V2/V3 version planning with deferred features
- ✅ Long-running development (weeks/months)
- ✅ Large PLAN.md files (2000+ lines)

**Optional for:** Simple 2-3 iteration features (single status line may suffice)

### Purpose

The Progress Dashboard is **your mission control** - a single section at the top of PLAN.md that shows the big picture and points to current work. It works with status markers to create a rigorous progress tracking system:

- **Progress Dashboard** = Always visible pointer + overview (manual)
- **Status Markers** = Ground truth at every level (mandatory)
- **`/flow-status`** = Current position verification (computed, active work only)
- **`/flow-summarize`** = Full structure overview (computed, includes deferred/cancelled)

### Template

Insert this section **after Architecture, before Development Plan**:

```markdown
## 📋 Progress Dashboard

**Last Updated**: [Date]

**Current Work**:
- **Phase**: Phase 2 - Core Implementation → [Jump](#phase-2-core-implementation)
- **Task**: Task 5 - Error Handling → [Jump](#task-5-error-handling)
- **Iteration**: Iteration 6 - Circuit Breaker → [Jump](#iteration-6-circuit-breaker)

**Completion Status**:
- Phase 1: ✅ 100% | Phase 2: 🚧 75% | Phase 3: ⏳ 0%

**Progress Overview**:
- ✅ **Iteration 1-5**: [Grouped completed items] (verified & frozen)
- 🚧 **Iteration 6**: Circuit Breaker ← **YOU ARE HERE**
- ⏳ **Iteration 7**: Blue Validation
- ⏳ **Iteration 8-9**: [Pending work]
- 🔮 **Iteration 10**: Name Generation (DEFERRED to V2 - complexity)

**V1 Remaining Work**:
1. Complete Iteration 6
2. Implement Iteration 7
3. Implement Iteration 9

**V2 Deferred Items**:
1. Iteration 10: Name Generation (moved - complexity)
2. Task 12: Advanced Features (out of V1 scope)

**Cancelled Items**:
1. Task 8: Custom HTTP Client (REJECTED - SDK is better)

---
```

### Key Elements

1. **Jump links** - Navigate to current work in large files (`[Jump](#phase-2-core-implementation)`)
2. **YOU ARE HERE** - Crystal clear current position
3. **Completion %** - Quick progress view per phase
4. **Grouped completed items** - Token-efficient (marked "verified & frozen")
5. **Deferred/Cancelled tracking** - Explicit scope decisions with reasons

### Positioning in PLAN.md

```markdown
# [Feature] - Development Plan

**Created**: [Date]
**Version**: V1

---

## Overview
[Purpose, Goals, Scope]

---

## Architecture
[High-level design, components]

---

## 📋 Progress Dashboard    ← INSERT HERE

[Dashboard content]

---

## Development Plan         ← STATUS MARKERS AT EVERY LEVEL

### Phase 1: Foundation ✅

**Status**: COMPLETE
**Completed**: 2025-09-30

#### Task 1: Setup ✅

**Status**: COMPLETE
...
```

### Maintaining the Dashboard

**Update triggers:**
- ✅ Completing an iteration
- ✅ Starting new iteration
- ✅ Deferring items to V2 (🔮)
- ✅ Cancelling items (❌)

**Maintenance steps:**
1. **Last Updated** - Change date when modifying
2. **← YOU ARE HERE** - Move to current iteration
3. **Completion %** - Recalculate per phase
4. **Jump links** - Update to current work
5. **Deferred/Cancelled sections** - Add items with reasons

### Verification (Smart & Token-Efficient)

**Hierarchy of truth:**
1. **Status markers** (✅ ⏳ 🚧 🎨 ❌ 🔮) = Ground truth
2. **Progress Dashboard** = Derived from markers (pointer)
3. **Commands** = Verify dashboard matches markers

**Smart verification (skips completed items):**

Commands verify only **active work**:
- 🚧 IN PROGRESS - Verify markers match dashboard
- ⏳ PENDING - Verify markers exist
- ❌ CANCELLED - Verify reason documented
- 🔮 DEFERRED - Verify reason + destination documented
- ✅ **COMPLETE - SKIPPED** (verified when completed, now frozen)

**When conflict:**
- Trust status markers (ground truth)
- Update dashboard to match
- Commands warn about mismatch

### Benefits

1. **Always visible** - No command execution, immediately scannable
2. **Token-efficient** - Completed items marked "verified & frozen" (skip re-verification)
3. **Single location** - Lives in PLAN.md (single source of truth)
4. **Navigate large files** - Jump links to current work (critical for 2000+ line files)
5. **Scope clarity** - Deferred/Cancelled sections show evolution
6. **Session continuity** - New AI sessions see full context
7. **Stakeholder friendly** - Copy/paste for reports

### Real-World Example

From a 3747-line game engine PLAN.md:

```markdown
## 📋 Progress Dashboard

**Last Updated**: 2025-10-02

**Current Work**:
- **Phase**: Phase 2 - Core Implementation → [Jump](#phase-2-core-implementation)
- **Task**: Task 5 - Green Service → [Jump](#task-5-green-service)
- **Iteration**: Iteration 7 - Blue Validation → [Jump](#iteration-7-blue-validation)

**Completion Status**:
- Phase 1: ✅ 100% | Phase 2: 🚧 95% | Phase 3: ⏳ 0%

**Progress Overview**:
- ✅ **Iteration 1-6**: Tier gen, slots, filtering, selection, parsing, integration (verified & frozen)
- 🚧 **Iteration 7**: Blue Validation (input guards) ← **YOU ARE HERE**
- ⏳ **Iteration 9**: Red API Layer (wraps Blue → Green)

**V1 Remaining Work**:
1. Complete Iteration 7 (Blue validation)
2. Implement Iteration 9 (Red wrapper)
3. Phase 3: Testing & iteration

**V2 Deferred Items** (Phase 4):
1. Iteration 8: Name Generation (124 components - complexity)
2. Task 12: 12 new placeholders (conditionals, resources)
3. Task 13: Potency system (stats-based formulas)
4. Task 14: Points & Luck (budget modifiers)
5. Task 15: Database persistence
6. Task 16: Damage variance (±10%)
7. Task 17: Game integration

**Cancelled Items**:
None

---
```

**Why this works:**
- Immediately see 95% done, 1 iteration active
- Jump link goes straight to Iteration 7 (in 3747-line file!)
- Completed items marked "verified & frozen" (commands skip them)
- 7 V2 items explicitly deferred with reasons
- Clear "YOU ARE HERE" + next steps

---

## Common Pitfalls

### Pitfall 1: Multiple Status Sections

**Problem**: In long projects (weeks/months), developers often add "Progress Tracking" sections at the bottom of PLAN.md. Over time, these become stale while the top status is updated, creating conflicting information.

**Example**:
```markdown
# Top of file (line 10):
**Status**: Phase 2, Task 5, Iteration 7 - In Progress

# Bottom of file (line 3600):
## Progress Tracking
Current Phase: Phase 1 - Foundation Setup (COMPLETE ✅)
Next Task: Task 5 - Implement Blue (Validator)
```

**Result**: New AI sessions read the stale bottom section and think you're at Iteration 1 when you're actually at Iteration 7.

**Solution**:
- Maintain single status line at top
- Use `/flow-status` to verify current state
- Archive old progress notes to "Status History (Archive)" section if needed

### Pitfall 2: Confusing Tasks vs Iterations

**Problem**: High-level "Tasks" (e.g., Task 7: Implement Green) don't map 1:1 to "Iterations" (Iteration 7: Red Orchestration). This naming overlap confuses status tracking.

**Example**:
- Task 7 is "Implement Green Service"
- Iteration 7 is "Red Orchestration" (different component!)

**Solution**:
- Use `/flow-status` to see the hierarchy clearly
- Status line should show both: `**Status**: Task 7 (Green Service), Iteration 5 (Template Parsing) - Complete`
- Don't rely on numbers alone; include names for clarity

### Pitfall 3: Not Verifying Status at Session Start

**Problem**: When starting a new AI session or compacting conversation, AI may scan PLAN.md and misinterpret current state (especially in 2000+ line files).

**Solution**:
- **ALWAYS** run `/flow-status` at the start of new AI sessions
- Run `/flow-verify-plan` to ensure PLAN.md matches actual code
- Explicitly state to AI: "We're on Iteration X, here's the context"

---

## Plan File Template

**Complete Example**: See `.flow/EXAMPLE_PLAN.md` for a full working example of a payment gateway integration project showing multiple completed iterations, brainstorming sessions, bug discoveries, and improvements.

### Basic Template Structure

```markdown
# [Feature/Project Name] - Development Plan

**Created**: [Date]
**Status**: [Current phase/iteration]
**Version**: V1

---

## Overview

**Purpose**: [What does this feature/project do?]

**Goals**:

- Goal 1
- Goal 2
- Goal 3

**Scope**: [What's included, what's excluded]

---

## Architecture

**High-Level Design**:
[Brief description of architecture, patterns, key components]

**Key Components**:

1. Component A - Description
2. Component B - Description
3. Component C - Description

**Dependencies**:

- Dependency 1
- Dependency 2

---

## Development Plan

### Phase 1: [Phase Name] ⏳

**Strategy**: [Overall approach for this phase]

**Goal**: [What this phase achieves]

---

#### Task 1: [Task Name] ⏳

**Status**: PENDING
**Purpose**: [What this task accomplishes]

---

##### Iteration 1: [Iteration Name] ⏳

**Status**: PENDING
**Goal**: [What this iteration builds]

---

### **Brainstorming Session - [Topic]**

**Subjects to Discuss**:

1. ⏳ **Subject Name** - Description
2. ⏳ **Subject Name** - Description
3. ⏳ **Subject Name** - Description

**Resolved Subjects**:

---

### ✅ **Subject 1: [Name]**

**Decision**: [Decision here]

**Rationale**:

- Reason 1
- Reason 2

**Action Items**:

- [ ] Action item 1
- [ ] Action item 2
- [ ] Action item 3

---

### **Implementation - Iteration 1**

**Status**: 🚧 IN PROGRESS

**Action Items**:

- [ ] Action item 1
- [ ] Action item 2
- [ ] Action item 3

**Files Modified**:

- `path/to/file.ts` - Changes

**Verification**: [How verified]

---

##### Iteration 2: [Iteration Name] ⏳

[Repeat pattern...]

---

#### Task 2: [Task Name] ⏳

[Repeat pattern...]

---

### Phase 2: [Phase Name] ⏳

[Repeat pattern...]

---

## Testing Strategy

**V1 Testing**:

- [ ] Test case 1
- [ ] Test case 2

**V2 Testing** (Deferred):

- [ ] Advanced test 1
- [ ] Advanced test 2

---

## Future Enhancements (V2+)

**Phase 4: Enhancement & Polish** (FUTURE)

**Deferred Features**:

- [ ] Feature 1
- [ ] Optimization 2
- [ ] Advanced capability 3

---

## Notes & Learnings

**Design Decisions**:

- Decision 1 and why
- Decision 2 and why

**Challenges Encountered**:

- Challenge 1 and solution
- Challenge 2 and solution

**Improvements Over Original** (if refactoring):

- Improvement 1
- Improvement 2

---

## Changelog

**[Date]** - Phase 1, Task 1, Iteration 1 complete

- Implemented X
- Added Y
- Fixed Z

**[Date]** - Brainstorming session for Iteration 2

- Resolved 5 subjects
- Created 12 action items

---
```

---

## Pre-Implementation Pattern

Before starting iteration implementation, identify if preparatory work is needed.

### When to Use Pre-Implementation Tasks

Pre-implementation tasks are preparatory work that must be completed BEFORE the main iteration implementation can begin:

- **Refactoring required** - System needs restructuring before new code
- **System-wide changes** - Updates affecting multiple files (e.g., enum → const conversion)
- **Data structure updates** - Interface/type changes needed across codebase
- **Bug fixes discovered during brainstorming** - Issues found during design that must be fixed first
- **Dependency changes** - Library updates or new dependencies to add
- **Test infrastructure** - Test setup needed before TDD implementation

### How to Document

Add pre-implementation tasks AFTER brainstorming session, BEFORE implementation:

```markdown
### **Pre-Implementation Tasks:**

#### ✅ Task 1: [Description] (COMPLETED)

**Objective**: [What this task accomplishes]

**Changes Made**:

- Change 1
- Change 2

**Verification**: [How verified]

---

#### ⏳ Task 2: [Description] (PENDING)

**Objective**: [What this task accomplishes]

**Action Items**:

- [ ] Action item 1
- [ ] Action item 2

---
```

### Completion Rule

**IMPORTANT**: Mark brainstorming session as complete ONLY after all pre-implementation tasks are done.

**Flow**:

1. Complete brainstorming session → Create pre-tasks (if needed)
2. Complete all pre-tasks → Mark brainstorming ✅ COMPLETE
3. Brainstorming complete → Ready for main iteration implementation

---

## Bugs Discovered Pattern

When analyzing reference implementations or during brainstorming, you may discover bugs in existing code. Document these clearly as part of your iteration planning.

### When to Document Bugs

- **During brainstorming** when analyzing reference code
- **When planning refactoring** work
- **As part of pre-implementation tasks**
- **When the bug discovery changes your design decisions**

### How to Document

Add bugs discovered section during brainstorming, typically BEFORE pre-implementation tasks:

````markdown
### 🐛 **Bugs Discovered in Original Implementation**

#### Bug 1: [Short Description] (Critical/Major/Minor)

**Location**: `path/to/file.ts:line_number`

**Problem**:

```typescript
// ❌ Original code (WRONG):
const result = array[Math.random() * (array.length - 1)];
// Off-by-one error: last element never selected!
```
````

**Fix**:

```typescript
// ✅ Corrected code:
const result = array[Math.random() * array.length];
// Now all elements have equal probability
```

**Impact**: Subtle bias in random selection affecting game balance

**Action**: Add to pre-implementation tasks

---

#### Bug 2: [Short Description]

[Repeat pattern...]

````

### Improvements Over Original Pattern

When rewriting/refactoring existing code, document what you improved:

```markdown
### ✅ **Improvements Over Original**

1. **Bug Fixes**:
   - Fixed random selection off-by-one error
   - Corrected prevention logic (.every → .some)

2. **Performance**:
   - Single-pass filtering (original used 3 loops)
   - O(1) Set lookups instead of O(n) array searches

3. **Code Quality**:
   - Added comprehensive JSDoc comments
   - Removed dead code (unused parameters)
   - Strict TypeScript types (no 'any')

4. **Developer Experience**:
   - Rich error metadata instead of throwing
   - Extensive logging for debugging
   - Public methods for testing

5. **Safety**:
   - Infinite loop protection (max iterations)
   - Weight budget validation
   - Bidirectional constraint checking
````

### Benefits

**Bug Discovery Documentation**:

- Creates audit trail of improvements
- Helps team understand why changes were made
- Prevents reintroducing the same bugs
- Demonstrates thorough analysis

**Improvements Tracking**:

- Shows value of refactoring effort
- Guides future improvements
- Celebrates wins and learnings
- Provides reference for similar work

---

## Best Practices

### 1. Keep Iterations Small

- Target 1-3 days of work per iteration
- Each iteration should be independently testable
- Prefer many small iterations over few large ones

### 2. Brainstorm Before Coding

- ALWAYS brainstorm before implementation
- Document all options, even rejected ones
- Create concrete action items from decisions

### 3. Update the Plan Continuously

- Check boxes as you complete work
- Add notes during implementation
- Document surprises and learnings

### 4. Use Clear Status Markers

- Make it obvious what's done, what's pending, what's in progress
- Use emoji markers consistently (✅ ⏳ 🚧 🎨)

### 5. Defer Complexity

- V1 should be simple and functional
- Mark complex features as V2/V3
- Don't over-engineer early iterations

### 6. Validate Before Completing

- Every iteration should be verified (tests, manual checks, etc.)
- Document verification method
- Don't mark complete until proven working

### 7. Learn and Adapt

- Document challenges and solutions
- Track improvements over original implementations
- Apply learnings to future iterations

### 8. Proactively Update PLAN.md

- When using slash commands, PLAN.md updates happen automatically
- When working manually (without slash commands), AI agents should:
  - **Automatically update PLAN.md** after completing significant milestones (iterations, phases, tasks)
  - **Suggest updates** when test results or implementation details should be documented
  - **Check for staleness** - if implementation diverges from plan, update the plan
- The plan file is the source of truth and must stay synchronized with actual progress

---

## Example: Iteration Lifecycle

### Starting State

```markdown
##### Iteration 4: Affix Selection 🚧 IN PROGRESS

**Brainstorming Session**:
**Subjects to Discuss**:

1. ⏳ Constraint solver algorithm
2. ⏳ Prevention rule validation
3. ⏳ Weight budget handling
```

### During Brainstorming

```markdown
**Subjects to Discuss**:

1. ✅ Constraint solver algorithm
2. 🚧 Prevention rule validation (CURRENT)
3. ⏳ Weight budget handling

**Resolved Subjects**:

### ✅ Subject 1: Constraint solver algorithm

**Decision**: Use greedy selection with backtracking
**Action Items**:

- [ ] Implement main selection loop
- [ ] Add infinite loop protection
- [ ] Create rich metadata for failures
```

### During Implementation

```markdown
**Implementation - Iteration 4**:

**Action Items**:

- [x] Implement main selection loop
- [x] Add infinite loop protection (MAX_ITERATIONS = 1000)
- [ ] Create rich metadata for failures

**Files Modified**:

- `src/services/Green.ts` - Added generateAffixes() method
```

### Completion

```markdown
##### Iteration 4: Affix Selection ✅ COMPLETE

**Implementation Results**:

- 3 methods implemented (196 lines)
- 8 test cases passing
- Weight budget constraint solver working correctly

**Verification**: All 8 tests passed, partial successes expected (constraint solver limiting overpowered combos)
```

---

## Integration with Slash Commands

This framework is designed to work with slash commands that automate plan file updates.

**Prefix**: All commands use `flow-` prefix to prevent conflicts with other frameworks.

### Initial Planning

- `/flow-blueprint [feature-description]` - **START HERE**: Generate initial PLAN.md with skeleton structure (phases/tasks/iterations). AI will ask for reference implementation if not provided.

### Structure Commands

- `/flow-phase [description]` - Start new phase
- `/flow-task [description]` - Start new task within current phase
- `/flow-iteration [description]` - Start new iteration within current task

### Brainstorming Workflow

- `/flow-brainstorm_start [topic]` - Begin brainstorming session for current iteration
- `/flow-brainstorm_subject [name]` - Add new subject to discuss
- `/flow-brainstorm_resolve [subject-name]` - Mark subject as resolved with decision
- `/flow-brainstorm_complete` - Close brainstorming (only after pre-tasks done)

### Implementation Workflow

- `/flow-implement_start` - Begin implementation phase
- `/flow-implement_complete` - Mark current iteration complete

### Navigation & State

- `/flow-status` - Show current position in plan (phase → task → iteration → status)
- `/flow-next` - Auto-detect context and suggest next command (smart helper)
- `/flow-next-subject` - Move to next unresolved brainstorming subject
- `/flow-next-iteration` - Move to next iteration in plan
- `/flow-rollback` - Undo last change to plan file

See `.claude/commands/` for slash command implementations.

---

## Summary

This framework provides:

✅ **Structure** - Clear hierarchy from phases to action items
✅ **Context** - Plan file preserves all decisions and progress
✅ **Flexibility** - Iterations can be any size, versions defer complexity
✅ **Traceability** - Complete audit trail of what/why/how
✅ **Resumability** - Anyone (human or AI) can pick up where you left off
✅ **Quality** - Brainstorming before coding reduces refactoring
✅ **Simplicity** - Simple loop: brainstorm → implement → complete → repeat

By following this framework, you build complex features incrementally with minimal refactoring, complete documentation, and clear progress tracking.

---

**Version**: 1.0
**Last Updated**: 2025-10-01
