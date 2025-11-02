---
name: flow-reviewer
description: Review and verify Flow framework plan consistency. Use when user says "review", "review the plan", "review this", "verify", "verify this", "check", "check the plan", "validate", "is this complete", "are we done", or wants to inspect plan status. Validates status markers match reality, checks for phantom tasks, ensures brainstorming complete before implementation, verifies task structure follows rules. Read-only inspection using Grep, Read, Glob tools only - never modifies files.
---

# Flow Reviewer

Help users verify plan consistency, validate status markers, and review implementation completeness using Flow framework projects. This Skill performs read-only inspections to ensure the plan matches reality.

## When to Use This Skill

Activate when the user wants verification:
- "Review the plan"
- "Verify the status"
- "Check if we're done"
- "Is the implementation complete?"
- "Validate the structure"
- "Are there any issues?"
- "Check for inconsistencies"
- "Verify all tasks are tracked"

## Review Philosophy

**Read-Only Inspection**: This Skill observes and reports, never modifies.

**What We Check**:
- Status markers match actual state
- No phantom tasks (DASHBOARD promises what doesn't exist)
- Brainstorming complete before implementation starts
- Task structure follows Flow rules
- Action items are all checked off when complete
- File references are valid

**Tools Available**: `Read`, `Grep`, `Glob` (read-only tools only)

## Review Checklist

### 1. Status Marker Consistency

**Check**: Do status markers reflect actual state?

**How to verify**:
```bash
# Find all IN PROGRESS items
grep -r "🚧 IN PROGRESS" .flow/

# Find all COMPLETE items
grep -r "✅ COMPLETE" .flow/

# Find all PENDING items
grep -r "⏳ PENDING" .flow/
```

**Common issues**:
- Task marked 🚧 IN PROGRESS but all iterations are ✅ COMPLETE
- Iteration marked ⏳ PENDING but has implementation section
- Multiple items marked 🚧 IN PROGRESS (should only be one active)

**Example problem**:
```markdown
### 🚧 Iteration 2: Error Handling

**Status**: ✅ COMPLETE (2025-10-30)  ← MISMATCH!
```

**Report**:
```
❌ Status Marker Mismatch
- Iteration 2 header shows 🚧 IN PROGRESS
- Implementation section shows ✅ COMPLETE
- Action: Update header to match implementation status
```

### 2. Phantom Task Detection

**Check**: Does every task listed in DASHBOARD.md have a corresponding file?

**How to verify**:
```bash
# List all tasks mentioned in DASHBOARD
grep "Task [0-9]" .flow/DASHBOARD.md

# Check if task files exist
ls .flow/phase-*/task-*.md
```

**Common issues**:
- DASHBOARD lists "Task 5" but `.flow/phase-2/task-5.md` doesn't exist
- Task file references non-existent iterations

**Example problem**:
```markdown
DASHBOARD.md:
- 🚧 **Task 3**: API Integration (2/4 iterations)

But: .flow/phase-2/task-3.md doesn't exist
```

**Report**:
```
❌ Phantom Task Detected
- DASHBOARD.md references Task 3: API Integration
- File .flow/phase-2/task-3.md does not exist
- Action: Create task file or remove from DASHBOARD
```

### 3. Implementation Gate Verification

**Check**: Is implementation starting before brainstorming is complete?

**How to verify**:
```bash
# Check if iteration has brainstorming
grep -A 20 "## Brainstorming" task-file.md

# Check brainstorming status
grep "Brainstorming.*Status.*COMPLETE" task-file.md

# Check if implementation started
grep "## Implementation" task-file.md
```

**Gate Rule**: If iteration has brainstorming, it must be ✅ COMPLETE before implementation starts.

**Example problem**:
```markdown
## Brainstorming
**Status**: 🚧 IN PROGRESS

## Implementation
**Status**: 🚧 IN PROGRESS  ← GATE VIOLATION!
```

**Report**:
```
❌ Implementation Gate Violation
- Iteration 2 has brainstorming IN PROGRESS
- Implementation section already started
- Action: Complete brainstorming before implementing
```

### 4. Task Structure Validation

**Check**: Does task follow the Golden Rule (Standalone XOR Iterations)?

**Golden Rule**: Tasks have EITHER:
- Direct action items (standalone task)
- OR iterations with action items in each iteration
- NEVER both

**How to verify**:
```bash
# Check if task has direct action items
grep -A 5 "## Action Items" task-file.md

# Check if task has iterations
grep "### " task-file.md | grep "Iteration"
```

**Example problem**:
```markdown
# Task 3: API Integration

## Action Items
- [ ] Create StripeClient
- [ ] Add error handling

## Iterations

### Iteration 1: Setup
...
```

**Report**:
```
❌ Task Structure Violation (Golden Rule)
- Task 3 has both direct action items AND iterations
- Golden Rule: Tasks must be EITHER standalone OR have iterations, never both
- Action: Move action items into iterations or remove iterations
```

### 5. Action Item Completion Check

**Check**: Are all action items checked off when iteration is marked complete?

**How to verify**:
```bash
# Find iteration marked COMPLETE
grep -B 2 "Status.*COMPLETE" task-file.md

# Check for unchecked action items in that iteration
grep -A 30 "### ✅ Iteration" task-file.md | grep "\[ \]"
```

**Example problem**:
```markdown
### ✅ Iteration 2: Error Handling
**Status**: ✅ COMPLETE

#### Action Items
- [x] Create ErrorMapper
- [ ] Add tests  ← UNCHECKED!
- [x] Integrate with client
```

**Report**:
```
❌ Incomplete Action Items
- Iteration 2 marked ✅ COMPLETE
- But action item "Add tests" is unchecked
- Action: Either complete the item or mark iteration as IN PROGRESS
```

### 6. File Reference Validation

**Check**: Do all file references point to existing files?

**How to verify**:
```bash
# Find file references in task files
grep -r "\`.*\.ts\`" .flow/ | grep -v "example"

# Check if referenced files exist
ls path/to/file.ts
```

**Example problem**:
```markdown
**Files Modified**:
- src/payment/StripeClient.ts
- src/payment/DoesNotExist.ts  ← FILE DOESN'T EXIST!
```

**Report**:
```
⚠️ Invalid File Reference
- Iteration 2 references src/payment/DoesNotExist.ts
- File does not exist in repository
- Action: Verify file path or remove invalid reference
```

## Status Markers Reference

### Valid Status Markers

**Task/Iteration Status**:
- ✅ `COMPLETE` - Work finished and verified
- 🚧 `IN PROGRESS` - Currently working on this
- ⏳ `PENDING` - Not started yet
- 🎨 `READY` - Ready to implement (brainstorming complete)
- ❌ `CANCELLED` - Work abandoned
- 🔮 `DEFERRED` - Moved to future version

**Phase Status**:
- ✅ `COMPLETE` - All tasks in phase done
- 🚧 `IN PROGRESS` - Currently working in this phase
- ⏳ `PENDING` - Phase not started

### Status Marker Lifecycle

**Iteration Lifecycle**:
```
⏳ PENDING
  ↓ (brainstorming started)
🚧 IN PROGRESS (brainstorming)
  ↓ (brainstorming complete, ready to implement)
🎨 READY
  ↓ (/flow-implement-start)
🚧 IN PROGRESS (implementing)
  ↓ (/flow-implement-complete)
✅ COMPLETE
```

**Common Mistakes**:
- ❌ Skipping 🎨 READY (going from brainstorming to implementation without marking ready)
- ❌ Multiple items marked 🚧 IN PROGRESS (should only be one active)
- ❌ Marking ✅ COMPLETE with unchecked action items
- ❌ Using ⏳ PENDING after implementation started

## Common Review Patterns

### Pattern 1: Full Plan Review

**When**: User asks "review the entire plan"

**Steps**:
1. Read DASHBOARD.md to understand structure
2. For each phase:
   - Verify phase status matches task statuses
   - Check all tasks listed have files
3. For each task:
   - Verify task status matches iteration statuses
   - Check structure (standalone XOR iterations)
4. For each iteration:
   - Verify status marker consistency
   - Check action items if marked complete
5. Report all findings

**Output format**:
```markdown
## Plan Review Results

**Summary**: 15 items checked, 2 issues found

### ✅ Passing Checks (13)
- All phase statuses consistent
- No phantom tasks detected
- Task structure valid
- ...

### ❌ Issues Found (2)

#### Issue 1: Status Marker Mismatch
- **Location**: Phase 2, Task 3, Iteration 2
- **Problem**: Header shows 🚧 but implementation shows ✅
- **Action**: Update header to ✅ COMPLETE

#### Issue 2: Unchecked Action Items
- **Location**: Phase 2, Task 4, Iteration 1
- **Problem**: Iteration marked complete but 1 action item unchecked
- **Action**: Complete action item or mark iteration IN PROGRESS
```

### Pattern 2: Task-Specific Review

**When**: User asks "review Task 3"

**Steps**:
1. Read task file
2. Check task status consistency
3. Verify structure (standalone XOR iterations)
4. For each iteration:
   - Status marker consistency
   - Action item completion
   - Implementation gate (brainstorming before implementation)
5. Report findings

### Pattern 3: Status Audit

**When**: User asks "check all status markers"

**Steps**:
1. Grep for all status markers
2. For each marker:
   - Verify it's in valid lifecycle position
   - Check consistency with surrounding content
3. Check for multiple IN PROGRESS items (should be max 1)
4. Report findings

## Review Commands

### Check for Phantom Tasks

```bash
# List tasks from DASHBOARD
grep -E "Task [0-9]" .flow/DASHBOARD.md

# List actual task files
ls .flow/phase-*/task-*.md

# Compare (manual check)
```

### Find Incomplete Work

```bash
# Find all IN PROGRESS items
grep -r "🚧 IN PROGRESS" .flow/

# Find unchecked action items
grep -r "\[ \]" .flow/phase-*/*.md
```

### Verify Implementation Gates

```bash
# Find iterations with brainstorming
grep -r "## Brainstorming" .flow/phase-*/

# Check if brainstorming is complete
grep -A 2 "## Brainstorming" .flow/phase-*/*.md | grep "Status"
```

### Validate Task Structure

```bash
# Check for direct action items in tasks
grep -A 5 "## Action Items" .flow/phase-*/task-*.md

# Check for iterations
grep "### " .flow/phase-*/task-*.md | grep -i iteration
```

## Interaction with Other Flow Skills

**Planning Stage** (flow-planner Skill):
- Planner creates structure
- Reviewer validates structure

**Implementation Stage** (flow-implementer Skill):
- Implementer executes work
- Reviewer verifies completion

**Architecture Stage** (flow-architect Skill):
- Architect documents decisions
- Reviewer checks references are valid

**Review Stage** (This Skill):
- Inspect plan consistency ← YOU ARE HERE
- Report findings, don't fix ← YOU ARE HERE

## Reporting Guidelines

### Report Format

**Use this structure for review findings**:

```markdown
## Review Results

**Scope**: [What was reviewed]
**Date**: [Review date]
**Status**: [✅ All Clear | ⚠️ Issues Found]

### Summary
- X checks performed
- Y issues found
- Z warnings

### ✅ Passing Checks
- [List what's working correctly]

### ❌ Issues Found
- [List problems discovered]

### ⚠️ Warnings
- [List potential concerns]

### 📋 Recommendations
- [Suggested actions to fix issues]
```

### Severity Levels

**❌ Critical**: Must fix before proceeding
- Phantom tasks (DASHBOARD promises don't exist)
- Implementation started before brainstorming complete
- Task structure violates Golden Rule

**⚠️ Warning**: Should fix soon
- Status marker inconsistency (cosmetic)
- Unchecked action items with work complete
- Minor file reference issues

**ℹ️ Info**: Nice to fix
- Formatting inconsistencies
- Missing optional documentation

## References

- **Status Markers**: DEVELOPMENT_FRAMEWORK.md lines 1872-1968
- **Task Structure Rules**: DEVELOPMENT_FRAMEWORK.md lines 238-566
- **Implementation Gates**: DEVELOPMENT_FRAMEWORK.md lines 1798-1836
- **Slash Command**: `/flow-verify-plan` (automated verification)

## Key Reminders

**Before reviewing**:
- [ ] Understand what user wants reviewed (full plan, specific task, status audit)
- [ ] Use read-only tools (Grep, Read, Glob)
- [ ] Never modify files during review

**During review**:
- [ ] Check status marker consistency
- [ ] Verify no phantom tasks
- [ ] Validate implementation gates
- [ ] Check task structure (Golden Rule)
- [ ] Verify action item completion

**After review**:
- [ ] Report findings in structured format
- [ ] Prioritize issues by severity
- [ ] Suggest specific actions to fix
- [ ] Don't modify files - let user or other Skills handle fixes
