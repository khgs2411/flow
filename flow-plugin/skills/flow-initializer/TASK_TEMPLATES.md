# Task File Templates

Templates for task files with different structures: standalone tasks, tasks with iterations, and tasks with brainstorming.

## Task Template (Standalone Task)

Use this template for simple tasks without iterations (rare in Flow - most tasks should have iterations).

```markdown
# Task [N]: [TASK_NAME]

**Status**: [STATUS_EMOJI] [STATUS]

---

## Task Overview

**Purpose**: [WHY_THIS_TASK_EXISTS]

**Dependencies**: [DEPENDENCY_LIST_OR_NONE]

---

## Action Items

- [ ] [ACTION_ITEM_1]
- [ ] [ACTION_ITEM_2]
- [ ] [ACTION_ITEM_3]
- [ ] [ACTION_ITEM_4]

---

## Verification

**Success Criteria**:
- [ ] [VERIFICATION_POINT_1]
- [ ] [VERIFICATION_POINT_2]

**Test Plan**:
- [HOW_TO_TEST_THIS_TASK]

---

## Notes

[ADDITIONAL_CONTEXT_DESIGN_DECISIONS_OR_DISCOVERIES]
```

## Task Template (Task with Iterations)

Use this template for most tasks - iterations allow breaking work into manageable chunks.

```markdown
# Task [N]: [TASK_NAME]

**Status**: [STATUS_EMOJI] [STATUS]

---

## Task Overview

**Purpose**: [WHY_THIS_TASK_EXISTS]

**Dependencies**: [DEPENDENCY_LIST_OR_NONE]

**Design Notes**: [KEY_ARCHITECTURAL_CONSIDERATIONS]

---

## Iterations

### [STATUS_EMOJI] Iteration 1: [ITERATION_NAME]

**Goal**: [WHAT_THIS_ITERATION_ACHIEVES]

**Status**: [STATUS_EMOJI] [STATUS] ([DATE_IF_COMPLETE])

#### Action Items
- [ ] [ACTION_ITEM_1]
- [ ] [ACTION_ITEM_2]
- [ ] [ACTION_ITEM_3]

#### Implementation
[IMPLEMENTATION_NOTES_OR_BLANK_IF_NOT_STARTED]

#### Verification
- [ ] [VERIFICATION_POINT_1]
- [ ] [VERIFICATION_POINT_2]

---

### [STATUS_EMOJI] Iteration 2: [ITERATION_NAME]

**Goal**: [WHAT_THIS_ITERATION_ACHIEVES]

**Status**: [STATUS_EMOJI] [STATUS]

#### Action Items
- [ ] [ACTION_ITEM_1]
- [ ] [ACTION_ITEM_2]
- [ ] [ACTION_ITEM_3]

#### Verification
- [ ] [VERIFICATION_POINT_1]
- [ ] [VERIFICATION_POINT_2]

---

### [STATUS_EMOJI] Iteration 3: [ITERATION_NAME]

**Goal**: [WHAT_THIS_ITERATION_ACHIEVES]

**Status**: [STATUS_EMOJI] [STATUS]

#### Action Items
- [ ] [ACTION_ITEM_1]
- [ ] [ACTION_ITEM_2]
- [ ] [ACTION_ITEM_3]

#### Verification
- [ ] [VERIFICATION_POINT_1]
- [ ] [VERIFICATION_POINT_2]

---

## Notes

[ADDITIONAL_CONTEXT_DISCOVERIES_OR_CHANGES]
```

## Task Template (Task with Brainstorming)

Use this template for complex tasks requiring design decisions before implementation.

```markdown
# Task [N]: [TASK_NAME]

**Status**: [STATUS_EMOJI] [STATUS]

---

## Task Overview

**Purpose**: [WHY_THIS_TASK_EXISTS]

**Dependencies**: [DEPENDENCY_LIST_OR_NONE]

---

## Iterations

### [STATUS_EMOJI] Iteration 1: [ITERATION_NAME]

**Goal**: [WHAT_THIS_ITERATION_ACHIEVES]

**Status**: [STATUS_EMOJI] [STATUS]

---

#### Brainstorming

**Status**: [STATUS_EMOJI] [STATUS] ([DATE_IF_COMPLETE])

**Subjects to Discuss**:
1. [STATUS_EMOJI] [SUBJECT_NAME] - [QUESTION_OR_DECISION_NEEDED]
2. [STATUS_EMOJI] [SUBJECT_NAME] - [QUESTION_OR_DECISION_NEEDED]
3. [STATUS_EMOJI] [SUBJECT_NAME] - [QUESTION_OR_DECISION_NEEDED]

---

##### Subject 1: [SUBJECT_NAME]

**Status**: [STATUS_EMOJI] [STATUS] ([DATE_IF_RESOLVED])

**Question**: [WHAT_NEEDS_TO_BE_DECIDED]

**Options**:
- **Option A**: [DESCRIPTION] - Pros: [PROS], Cons: [CONS]
- **Option B**: [DESCRIPTION] - Pros: [PROS], Cons: [CONS]

**Decision**: [CHOSEN_OPTION_AND_REASONING]

**Resolution Type**: [A/B/C/D]

**Action Items** (if Type A or D):
- [ ] [ACTION_ITEM_1]
- [ ] [ACTION_ITEM_2]

---

##### Subject 2: [SUBJECT_NAME]

**Status**: [STATUS_EMOJI] [STATUS]

**Question**: [WHAT_NEEDS_TO_BE_DECIDED]

[REPEAT_STRUCTURE_AS_SUBJECT_1]

---

#### Pre-Implementation Tasks

**Status**: [STATUS_EMOJI] [STATUS]

These must be completed BEFORE starting main implementation:

- [ ] [PRE_TASK_1_FROM_BRAINSTORMING_TYPE_A]
- [ ] [PRE_TASK_2_FROM_BRAINSTORMING_TYPE_A]

---

#### Implementation

**Status**: [STATUS_EMOJI] [STATUS]

**Files Modified**:
- [FILE_PATH_1]
- [FILE_PATH_2]

**Changes Made**:
[DESCRIPTION_OF_IMPLEMENTATION]

#### Action Items
- [ ] [ACTION_ITEM_1_FROM_BRAINSTORMING_TYPE_D]
- [ ] [ACTION_ITEM_2_FROM_BRAINSTORMING_TYPE_D]
- [ ] [ACTION_ITEM_3_FROM_BRAINSTORMING_TYPE_D]

#### Verification
- [ ] [VERIFICATION_POINT_1]
- [ ] [VERIFICATION_POINT_2]

---

## Notes

[ADDITIONAL_CONTEXT]
```

## Usage Guidelines

### When to Use Each Template

**Standalone Task** (rare):
- Simple, atomic tasks with no natural breakdown
- One-step operations (e.g., "Deploy to production", "Create Git repository")
- Administrative tasks

**Task with Iterations** (most common):
- Complex work that can be broken into steps
- Feature implementation with multiple phases
- Tasks requiring incremental progress

**Task with Brainstorming** (for complex/uncertain work):
- New features requiring design decisions
- Tasks with multiple implementation approaches
- Work involving architectural choices
- Cases where requirements need clarification

### Status Marker Reference

| Status | Emoji | When to Use |
|--------|-------|-------------|
| COMPLETE | ✅ | Work finished and verified |
| IN PROGRESS | 🚧 | Currently working on this |
| PENDING | ⏳ | Not started yet |
| READY | 🎨 | Ready to implement (brainstorming complete) |
| CANCELLED | ❌ | Work abandoned |
| DEFERRED | 🔮 | Moved to future version |

### Template Selection Logic

```
IF task is simple AND atomic:
  → Use Standalone Task template

ELSE IF task is well-defined AND can be broken into steps:
  → Use Task with Iterations template

ELSE IF task needs design decisions OR has uncertainties:
  → Use Task with Brainstorming template
```

## Example: Choosing the Right Template

**Scenario 1**: "Set up CI/CD pipeline"
- **Complexity**: Medium
- **Breakdown**: Multiple steps (configure, test, deploy)
- **Design needed**: No (well-understood process)
- **→ Use**: Task with Iterations (3 iterations: configure, test, deploy)

**Scenario 2**: "Add real-time chat feature"
- **Complexity**: High
- **Breakdown**: Multiple components
- **Design needed**: Yes (WebSocket vs polling, state management, etc.)
- **→ Use**: Task with Brainstorming (design decisions first, then iterations)

**Scenario 3**: "Create Git repository"
- **Complexity**: Low
- **Breakdown**: Single atomic step
- **Design needed**: No
- **→ Use**: Standalone Task (just create repo, no iterations)
