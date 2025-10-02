# Flow Framework - Advanced Patterns

> **Version**: 1.0.11
> **Last Updated**: 2025-10-02
> **Purpose**: Advanced usage patterns discovered through real-world Flow projects

---

## Table of Contents

1. [Multi-Version Planning (V1/V2/V3 Splits)](#1-multi-version-planning-v1v2v3-splits)
2. [Large-Scale Refactoring](#2-large-scale-refactoring)
3. [Complex Subject Trees](#3-complex-subject-trees)
4. [Pre-Implementation Task Pattern](#4-pre-implementation-task-pattern)
5. [Progress Dashboard for Large Files](#5-progress-dashboard-for-large-files)
6. [Mid-Development Adoption](#6-mid-development-adoption)

---

## 1. Multi-Version Planning (V1/V2/V3 Splits)

### Overview

Split complex features into versions to deliver value incrementally while deferring complexity.

### When to Use

- Feature scope is too large for single release
- Some requirements are "nice-to-have" vs "must-have"
- You want to ship quickly and iterate based on feedback
- Complexity can be deferred without breaking core functionality

### Pattern

**V1**: Minimum viable implementation (simple, functional, testable)
**V2**: Enhanced implementation (optimizations, edge cases, polish)
**V3**: Advanced features (rarely needed, can wait)

### Example from This PLAN.md

```markdown
## V1 Remaining Work (Linear progression):
1. Complete Task 3: Documentation & Examples (3 iterations) ← CURRENT
2. Complete Task 4: Developer Experience (2 iterations)
3. Complete Task 5: Command Flow Redesign (7 iterations)

## V2 Deferred Items (Phase 4):
1. Visual diagram generation (`/flow-visualize`)
2. Export to PDF/HTML (`/flow-export`)
3. Drift detection (`/flow-compare`)
4. Template system (`/flow-template`)
5. Multi-plan support
6. Team collaboration features
```

### Before/After

**Before (Scope Creep)**:
```markdown
Task 1: Payment Gateway Integration
- Stripe API integration
- Webhook handling
- Retry logic
- Failed payment recovery
- Subscription management ← Too much!
- Invoice generation ← Too much!
- Tax calculation ← Too much!
- Multi-currency support ← Too much!
```

**After (V1/V2 Split)**:
```markdown
## V1 (Ship This Month)
Task 1: Payment Gateway Integration
- Stripe API integration
- Webhook handling
- Retry logic (3 attempts, exponential backoff)

## V2 (Next Quarter)
Task 2: Advanced Payment Features
- Subscription management
- Invoice generation
- Failed payment recovery

## V3 (Future)
Task 3: International Support
- Multi-currency
- Tax calculation (by region)
```

### Benefits

- ✅ Ship V1 faster (weeks vs months)
- ✅ Get user feedback early
- ✅ Defer complexity until proven needed
- ✅ Clear scope boundaries prevent feature creep

### Anti-Pattern

❌ **Don't** split versions mid-iteration:
```markdown
Iteration 1: User Auth (V1 + V2 mixed) ← BAD
- Basic login (V1)
- OAuth integration (V2) ← Should be separate iteration
```

✅ **Do** complete V1 iterations, then plan V2:
```markdown
Iteration 1: User Auth - Basic Login (V1) ✅
Iteration 2: User Auth - OAuth (V2) ⏳
```

---

## 2. Large-Scale Refactoring

### Overview

Plan and execute major refactorings using Flow's brainstorming → pre-implementation → iteration pattern.

### When to Use

- Refactoring affects 10+ files
- Architecture needs restructuring
- Breaking changes required
- Need to maintain working code during refactor

### Pattern

1. **Brainstorm the refactoring approach**
2. **Identify pre-implementation tasks** (Type A resolutions)
3. **Break refactoring into safe iterations**
4. **Verify after each iteration**

### Example: Refactoring Skill Generation System

```markdown
### Brainstorming Session - Refactor Skill Gen System

**Subjects to Discuss**:
1. ✅ **Current Issues** - What's wrong with current implementation?
2. ✅ **Target Architecture** - What should it look like?
3. ✅ **Migration Strategy** - How to migrate without breaking?
4. ✅ **Rollback Plan** - How to undo if it fails?

### Subject 3 Resolution (Type A: Pre-Implementation Task)

**Decision**: Refactor requires creating new interfaces before touching implementations

**Pre-Implementation Tasks**:
- Task 1: Create new ISkillGenerator interface
- Task 2: Add deprecation warnings to old code
- Task 3: Create adapter layer for backward compat
- Task 4: Write migration script for data

### Implementation (After Pre-Tasks Complete)

Iteration 1: Migrate Blue Service ✅
Iteration 2: Migrate Green Service ✅
Iteration 3: Migrate Red Service ✅
Iteration 4: Remove deprecated code ✅
```

### Refactoring Checklist

**Before starting**:
- [ ] Document current architecture
- [ ] Identify all files affected
- [ ] Create rollback plan
- [ ] Add comprehensive tests (if missing)

**During refactoring**:
- [ ] Complete pre-implementation tasks first
- [ ] Refactor one module/service per iteration
- [ ] Run tests after each iteration
- [ ] Keep old code working until migration complete

**After completion**:
- [ ] Remove deprecated code
- [ ] Update documentation
- [ ] Run full test suite
- [ ] Document lessons learned

---

## 3. Complex Subject Trees

### Overview

Manage brainstorming sessions with many subjects, some of which depend on others or auto-resolve.

### When to Use

- Feature has 10+ design decisions
- Some decisions depend on others
- Subjects emerge during brainstorming
- Need to track decision cascade effects

### Pattern: Subject Dependencies

```markdown
**Subjects to Discuss**:
1. 🚧 **Core Architecture Decision** - CURRENT
2. ⏳ **Naming Convention** (depends on Subject 1)
3. ⏳ **Validation Strategy** (depends on Subject 1)
4. ⏳ **Error Handling** (independent)
5. ⏳ **Performance Optimization** (defer to V2)

### Subject 1: Core Architecture ✅
**Decision**: Use event-driven architecture with pub/sub

### Subject 2: Auto-Resolved ✅
**Resolution**: Auto-resolved by Subject 1's decision
**Rationale**: Event-driven architecture dictates naming (EventBus, Publisher, Subscriber)

### Subject 3: Auto-Resolved ✅
**Resolution**: Auto-resolved by Subject 1's decision
**Rationale**: Pub/sub pattern includes built-in validation via schema
```

### Dynamic Subject Addition

**During brainstorming**, add subjects as insights emerge:

```markdown
**Subjects to Discuss**:
1. ✅ **API Design** - RESOLVED
2. 🚧 **Data Structure** - CURRENT (discussing now)
3. ⏳ **Error Handling** - PENDING
4. ⏳ **Type Conversion** - NEW (just added during Subject 2!)
5. ⏳ **Validation Strategy** - NEW (discovered dependency)
```

**How to add mid-brainstorm**:
1. Update "Subjects to Discuss" list immediately
2. Mark new subject with ⏳ and note why it was added
3. Finish current subject before jumping to new one

### Example: 15-Subject Brainstorming Session

From RED project (skill generation system):

```markdown
**Subjects to Discuss**:
1. ✅ Foundational Element Property (architecture decision)
2. ✅ Element Type Semantics (auto-resolved by #1)
3. ✅ Conversion Placeholder Validation (auto-resolved by #1)
4. ✅ Prevention Placeholder Logic (auto-resolved by #1)
5. ✅ Enhancement Placeholder Behavior (auto-resolved by #1)
6. 🚧 Naming Convention (emerged during #1)
7. ⏳ Parser Architecture (independent)
8. ⏳ Tier Generation Formula (independent)
9. ⏳ Slot Validation Strategy (depends on #7)
10. ⏳ Error Metadata Structure (independent)
11. ⏳ Performance Optimization (defer to V2)
12. ⏳ Internationalization (defer to V3)
13. ⏳ Bug Fix: Conversion Placeholder (Pre-Implementation Task)
14. ⏳ Bug Fix: Prevention Logic (Pre-Implementation Task)
15. ⏳ Testing Strategy (independent)
```

**Result**:
- 5 subjects auto-resolved by architecture decision
- 2 subjects became pre-implementation tasks
- 3 subjects deferred to V2/V3
- 5 subjects resolved independently

---

## 4. Pre-Implementation Task Pattern

### Overview

Document and complete preparatory work BEFORE starting main iteration implementation.

### When to Use

- Refactoring needed before feature can be built
- System-wide changes required (e.g., enum → const conversion)
- Bug fixes discovered during brainstorming
- Dependencies must be updated first
- Test infrastructure needs setup

### Pattern Structure

```markdown
### **Pre-Implementation Tasks:**

#### ⏳ Task 1: [Name] (PENDING)

**Objective**: [What this accomplishes]

**Root Cause** (if bug): [Why this is needed]

**Solution**: [How to fix/implement]

**Action Items**:
- [ ] Specific step 1
- [ ] Specific step 2

**Files to Modify**:
- path/to/file.ts (what to change)

---

#### ✅ Task 2: [Name] (COMPLETE)

**Changes Made**:
- Change 1
- Change 2

**Verification**: [How verified]
```

### Example: Bug Fixes from Brainstorming

```markdown
### **Brainstorming Session - Skill Placeholder System**

**Subjects to Discuss**:
1. ✅ Placeholder Syntax Design
2. ✅ Parser Architecture
3. ✅ Bug: Conversion Placeholder Requirement (Type A!)

### Subject 3 Resolution (Type A: Pre-Implementation Task)

**Decision**: Conversion placeholder requires 2+ elements (current code allows 1)

**Pre-Implementation Tasks Created**:

#### ⏳ Task 1: Fix Conversion Placeholder Validation (PENDING)

**Objective**: Prevent single-element conversion placeholders

**Root Cause**: Current validation allows `{conversion:fire}` (1 element) which breaks conversion logic

**Solution**: Update validation to require minimum 2 elements

**Action Items**:
- [ ] Update Blue.validatePlaceholder() to check element count
- [ ] Add error: "Conversion requires 2+ elements (from → to)"
- [ ] Update tests to verify 2-element minimum
- [ ] Test edge cases (empty, 1 element, 2+ elements)

**Files to Modify**:
- `src/services/Blue.ts` (validation logic)
- `scripts/blue.scripts.ts` (add test cases)
```

### Completion Rule

**CRITICAL**: Mark brainstorming complete ONLY after all pre-tasks done:

```markdown
### Brainstorming Session ✅
**Status**: COMPLETE

### Pre-Implementation Tasks:
- ✅ Task 1: Fix Conversion Validation (COMPLETE)
- ✅ Task 2: Refactor Parser (COMPLETE)
- ✅ Task 3: Update Test Infrastructure (COMPLETE)

→ NOW ready for /flow-brainstorm_complete
→ THEN /flow-implement_start
```

---

## 5. Progress Dashboard for Large Files

### Overview

Add mission control dashboard for PLAN.md files exceeding 1000 lines.

### When to Use

- PLAN.md exceeds 1000 lines
- 10+ iterations across multiple phases
- V1/V2/V3 version planning with deferrals
- Multiple developers or AI sessions
- Need quick navigation to current work

### Pattern

Insert Progress Dashboard after Overview, before Architecture:

```markdown
# [Feature] - Development Plan

## Overview
[Purpose, goals, scope]

---

## 📋 Progress Dashboard    ← INSERT HERE

**Last Updated**: 2025-10-02

**Current Work**:
- **Phase**: Phase 2 - Enhancement & Polish → [Jump](#phase-2-enhancement--polish-)
- **Task**: Task 3 - Documentation → [Jump](#task-3-documentation--examples-)
- **Iteration**: Iteration 1 - Testing Guide → [Jump](#iteration-1-comprehensive-testing-guide-)

**Completion Status**:
- Phase 1: ✅ 100% | Phase 2: 🚧 75% | Phase 3: ⏳ 0%

**Progress Overview**:
- ✅ **Iteration 1-5**: [Grouped completed] (verified & frozen)
- 🚧 **Iteration 6**: Current work ← **YOU ARE HERE**
- ⏳ **Iteration 7-9**: Pending work

**V1 Remaining Work**:
1. Complete Iteration 6
2. Implement Iteration 7
3. Implement Iteration 9

**V2 Deferred Items**:
1. Iteration 10: Advanced Feature (complexity)
2. Task 12: Optional Enhancement (out of scope)

---

## Architecture
[Design details...]
```

### Key Elements

1. **Jump Links** - Navigate 2000+ line files instantly
   ```markdown
   → [Jump](#phase-2-enhancement--polish-)
   ```

2. **YOU ARE HERE** - Crystal clear current position
   ```markdown
   🚧 **Iteration 6**: Circuit Breaker ← **YOU ARE HERE**
   ```

3. **Grouped Completed Items** - Token-efficient (skip re-verification)
   ```markdown
   ✅ **Iteration 1-5**: Setup, integration, API, webhooks, tests (verified & frozen)
   ```

4. **Deferred/Cancelled Tracking** - Explicit scope decisions with reasons
   ```markdown
   🔮 **Iteration 10**: Name Gen (DEFERRED to V2 - 124 components, complexity)
   ```

### Smart Verification

Commands verify only **active work** (skip completed ✅ items):

```
🔍 Verification:
✅ Phase 2 marker: 🚧 IN PROGRESS ✓
✅ Task 5 marker: 🚧 IN PROGRESS ✓
✅ Iteration 6 marker: 🚧 IN PROGRESS ✓

⏭️  Skipped: 15 completed items (verified & frozen)
```

**Benefits**:
- Saves tokens (don't re-verify completed work)
- Faster status checks
- Focuses on what matters (current work)

---

## 6. Mid-Development Adoption

### Overview

Adopt Flow methodology mid-project without starting over.

### When to Use

- Project already in progress (weeks/months of work)
- Have existing docs (PRD.md, TODO.md, specs)
- Team wants structure without restarting
- Need to preserve existing decisions/context

### Pattern: Migration Strategy

**Step 1: Assess Current State**
```bash
# Identify existing documentation
ls -la {PRD,PLAN,TODO,SPEC,DESIGN}*.md

# Common patterns:
# - PRD.md (Product Requirements)
# - TODO.md (Task list)
# - DESIGN.md (Architecture)
# - CHANGELOG.md (History)
```

**Step 2: Use `/flow-migrate` Command**
```bash
# Migrate existing docs to Flow format
/flow-migrate PRD.md

# Creates:
# - .flow/PLAN.md (Flow-managed)
# - PRD.md.backup-[timestamp] (safety)
```

**Step 3: Restructure to Flow Hierarchy**

**Before (Flat TODO)**:
```markdown
# TODO.md
- [ ] Build payment API
- [ ] Add webhooks
- [ ] Implement retry logic
- [ ] Add tests
- [ ] Deploy to staging
```

**After (Flow Structure)**:
```markdown
# .flow/PLAN.md

## Phase 1: Core Implementation ⏳

### Task 1: Payment Integration ⏳
- Iteration 1: Stripe API Setup ⏳
- Iteration 2: Webhook Handling ⏳
- Iteration 3: Retry Logic ⏳

### Task 2: Testing & Deployment ⏳
- Iteration 1: Test Suite ⏳
- Iteration 2: Staging Deploy ⏳
```

**Step 4: Add Missing Flow Patterns**

Enhance migrated plan with:
- [ ] Testing Strategy section
- [ ] Status markers (✅ ⏳ 🚧 🎨)
- [ ] Brainstorming sessions for complex iterations
- [ ] Pre-implementation tasks (if refactoring needed)

### Example: RED Project Mid-Development

**Situation**: 3 months into game engine development, realized needed structure

**Before**:
- Scattered notes in comments
- No central plan file
- Hard to onboard new AI sessions
- Lost context between sessions

**Migration Process**:
1. Created `.flow/PLAN.md` manually (no existing docs)
2. Documented completed work as Phase 1 (✅ COMPLETE)
3. Planned remaining work as Phase 2-4
4. Used `/flow-brainstorm_start` for first new feature

**After**:
- 3747-line PLAN.md with complete context
- 10 versions released using Flow
- Command Flow Redesign (Task 5) emerged from dogfooding
- Framework improvements fed back into Flow itself

### Migration Checklist

**Before migrating**:
- [ ] Backup all existing docs
- [ ] Identify what to preserve (decisions, context, history)
- [ ] Decide on Testing Strategy

**During migration**:
- [ ] Use `/flow-migrate` or manual conversion
- [ ] Mark completed work ✅ (don't lose progress)
- [ ] Add status markers at all levels
- [ ] Create Testing Strategy section

**After migration**:
- [ ] Verify `.flow/PLAN.md` has complete context
- [ ] Test with `/flow-status` command
- [ ] Use Flow for all new work
- [ ] Update team/AI on new workflow

---

## Pattern Selection Guide

**Use Multi-Version Planning when**:
- ✅ Feature scope is large (months of work)
- ✅ Need to ship value incrementally
- ✅ Some requirements are optional

**Use Large-Scale Refactoring when**:
- ✅ Touching 10+ files
- ✅ Breaking changes required
- ✅ Need to maintain working code during refactor

**Use Complex Subject Trees when**:
- ✅ 10+ design decisions
- ✅ Decisions depend on each other
- ✅ Subjects emerge during brainstorming

**Use Pre-Implementation Tasks when**:
- ✅ Discovered bugs during brainstorming
- ✅ System-wide changes needed first
- ✅ Refactoring required before feature

**Use Progress Dashboard when**:
- ✅ PLAN.md exceeds 1000 lines
- ✅ Multiple phases/tasks/iterations
- ✅ Need quick navigation

**Use Mid-Development Adoption when**:
- ✅ Project already in progress
- ✅ Have existing documentation
- ✅ Want structure without restarting

---

## Real-World Success Stories

### Flow Framework Development (This Project)

**Pattern Used**: All 6 patterns!

- **Multi-Version**: V1 (core), V2 (advanced features) clearly split
- **Refactoring**: Task 5 (Command Flow Redesign) with 7 iterations
- **Complex Subjects**: 15-subject brainstorming sessions
- **Pre-Tasks**: Bug fixes discovered during design
- **Progress Dashboard**: Essential for 900+ line PLAN.md
- **Mid-Development**: Applied Flow to Flow itself after v1.0

**Result**: 10+ versions released, framework continuously improving

### RED Game Engine (Skill Generation)

**Pattern Used**: Large-Scale Refactoring + Pre-Tasks

- Refactored entire skill generation system
- 15 pre-implementation tasks (bug fixes, validation)
- 20+ iterations planned and executed
- Zero regressions (pre-tasks caught everything)

**Result**: Clean architecture, extensible system, production-ready

---

## Contributing Your Patterns

Discovered a new pattern? Share it!

1. Document pattern in this format
2. Include real-world example
3. Add "When to Use" guidance
4. Submit PR to Flow repo

**Pattern Template**:
```markdown
## N. [Pattern Name]

### Overview
[Brief description]

### When to Use
- Situation 1
- Situation 2

### Pattern
[Step-by-step approach]

### Example
[Real-world usage]

### Benefits
- Benefit 1
- Benefit 2
```

---

**Maintainer**: Flow Framework Team
**Feedback**: [GitHub Issues](https://github.com/khgs2411/flow/issues)
**More Patterns**: See [DEVELOPMENT_FRAMEWORK.md](framework/DEVELOPMENT_FRAMEWORK.md)
