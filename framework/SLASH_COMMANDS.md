# Flow Framework - Slash Commands

This file contains all slash command definitions for the Flow framework. Copy these to `.claude/commands/` when ready to use.

---

## Command Guidelines

**IMPORTANT**: Every command must:

1. **Read the framework guide** at the start to understand patterns and structure
2. **Find and parse .flow/PLAN.md** to understand current state
3. **Follow framework patterns exactly** (status markers, section structure, etc.)
4. **Update .flow/PLAN.md** according to framework conventions
5. **Provide clear next steps** to the user

**File Locations**:
- **Plan File**: `.flow/PLAN.md` (Flow manages the plan from this directory)
- **Framework Guide**: Search in order:
  1. `.flow/DEVELOPMENT_FRAMEWORK.md`
  2. `.claude/DEVELOPMENT_FRAMEWORK.md`
  3. `./DEVELOPMENT_FRAMEWORK.md` (project root)
  4. `~/.claude/flow/DEVELOPMENT_FRAMEWORK.md` (global)

**Finding PLAN.md** (all commands except `/flow-blueprint` and `/flow-migrate`):
- Primary location: `.flow/PLAN.md`
- If not found, search project root and traverse up
- If still not found: Suggest `/flow-blueprint` (new project) or `/flow-migrate` (existing docs)

**Status Markers** (use consistently):
- ✅ Complete
- ⏳ Pending
- 🚧 In Progress
- 🎨 Ready for Implementation
- ❌ Cancelled
- 🔮 Deferred

---

## /flow-blueprint

**File**: `flow-blueprint.md`

```markdown
---
description: Create new .flow/PLAN.md for a feature/project from scratch
---

You are executing the `/flow-blueprint` command from the Flow framework.

**Purpose**: Create a brand new PLAN.md file from scratch for a new feature/project/bug/issue.

**IMPORTANT**: This command ALWAYS creates a fresh `.flow/PLAN.md`, overwriting any existing plan file. Use `/flow-migrate` if you want to convert existing documentation.

**Instructions**:

1. **Read the framework guide**:
   - Search for DEVELOPMENT_FRAMEWORK.md in these locations (in order):
     - `.flow/DEVELOPMENT_FRAMEWORK.md`
     - `.claude/DEVELOPMENT_FRAMEWORK.md`
     - `./DEVELOPMENT_FRAMEWORK.md` (project root)
     - `~/.claude/flow/DEVELOPMENT_FRAMEWORK.md` (global)
   - Read the first found location
   - Understand the hierarchy: PHASE → TASK → ITERATION → BRAINSTORM → IMPLEMENTATION
   - Study the plan file template section
   - Note the status markers and section structure

2. **Analyze the feature request**: `$ARGUMENTS`

3. **Check for reference implementation**:
   - If user mentioned a reference path in arguments, use it
   - Otherwise, ask: "Do you have a reference implementation I should analyze? (Provide path or say 'no')"
   - If reference provided, read and analyze it to inform the planning

4. **Gather testing methodology** (CRITICAL - if not in $ARGUMENTS):
   - Ask: "How do you prefer to verify implementations? Choose or describe:
     - **Simulation-based (per-service)**: Each service has its own test file (e.g., `{service}.scripts.ts`)
     - **Simulation-based (single file)**: All tests in one orchestration file (e.g., `run.scripts.ts`)
     - **Unit tests**: Test individual functions/classes after implementation (Jest/Vitest/etc.)
     - **TDD**: Write tests before implementation, then make them pass
     - **Integration/E2E**: Focus on end-to-end workflows, minimal unit tests
     - **Manual QA**: No automated tests, manual verification only
     - **Custom**: Describe your approach"
   - **CRITICAL follow-up questions**:
     - "What's your test file naming convention?" (e.g., `{service}.scripts.ts`, `{feature}.test.ts`, `{feature}.spec.ts`)
     - "Where do test files live?" (e.g., `scripts/`, `__tests__/`, `tests/`, `e2e/`)
     - "When should I create NEW test files vs. add to existing?" (e.g., "Create `{service}.scripts.ts` for new services, add to existing for enhancements")
   - **IMPORTANT**: These answers determine how AI creates/modifies test files in every iteration

5. **Gather any other project-specific patterns** (if not clear from $ARGUMENTS):
   - File naming conventions (if mentioned or user specifies)
   - Directory structure preferences (if relevant)
   - Code style preferences (if mentioned)
   - Skip if not applicable to project type

6. **Generate .flow/PLAN.md** following the framework template (ALWAYS overwrites if exists):
   - Note: .flow/ directory already exists (created by flow.sh installation)
   - **Framework reference**: Link to DEVELOPMENT_FRAMEWORK.md at top
   - **Overview section**: Purpose, goals, scope
   - **Architecture section**: High-level design, key components
   - **Testing Strategy section** (NEW - REQUIRED):
     - Document the testing methodology from step 4
     - **Must include**: Methodology, Location, Naming Convention, When to create, When to add, Tooling
     - Include file structure example showing test file organization
     - Add IMPORTANT section with ✅ DO and ❌ DO NOT examples
     - Example for per-service simulation:
       ```markdown
       ## Testing Strategy
       **Methodology**: Simulation-based orchestration per service
       **Naming Convention**: `{service}.scripts.ts`
       **Location**: `scripts/` directory
       **When to create**: If `scripts/{service}.scripts.ts` doesn't exist for new service
       **When to add**: If file exists, add test cases to existing file
       **IMPORTANT**:
       - ✅ Create `scripts/gold.scripts.ts` for new "gold" service
       - ✅ Add to `scripts/blue.scripts.ts` for blue enhancements
       - ❌ Do NOT create `test.*.ts` files (wrong naming pattern)
       ```
     - Example for unit tests: "Unit tests created after implementation in __tests__/ using Jest. Create `{feature}.test.ts` for new features, add to existing for enhancements."
   - **Progress Dashboard**: For complex projects (optional, can add later)
   - **Development Plan**:
     - Estimate 2-4 phases (Foundation, Core Implementation, Testing, Enhancement/Polish)
     - For each phase: 1-5 tasks
     - For each task: 2-10 iterations (high-level names only)
     - Mark everything as ⏳ PENDING
     - Add placeholder brainstorming sessions (empty subject lists)

7. **Depth**: Medium detail
   - Phase names and strategies
   - Task names and purposes
   - Iteration names only (no brainstorming subjects yet)

8. **Confirm to user**:
   - "✨ Created .flow/PLAN.md with [X] phases, [Y] tasks, [Z] iterations"
   - "📂 Flow is now managing this project from .flow/ directory"
   - "Use `/flow-status` to see current state"
   - "Use `/flow-brainstorm_start [topic]` to begin first iteration"

**Output**: Create `.flow/PLAN.md` file and confirm creation to user.
```

---

## /flow-migrate

**File**: `flow-migrate.md`

```markdown
---
description: Migrate existing PRD/PLAN/TODO to Flow's .flow/PLAN.md format
---

You are executing the `/flow-migrate` command from the Flow framework.

**Purpose**: Migrate existing project documentation (PLAN.md, TODO.md, etc.) to Flow-compliant `.flow/PLAN.md` format.

**IMPORTANT**: This command ALWAYS creates a fresh `.flow/PLAN.md`, overwriting any existing plan file. It reads your current documentation and converts it to Flow format.

**Instructions**:

1. **Read the framework guide**:
   - Search for DEVELOPMENT_FRAMEWORK.md in these locations (in order):
     - `.flow/DEVELOPMENT_FRAMEWORK.md`
     - `.claude/DEVELOPMENT_FRAMEWORK.md`
     - `./DEVELOPMENT_FRAMEWORK.md` (project root)
     - `~/.claude/flow/DEVELOPMENT_FRAMEWORK.md` (global)
   - Understand Flow's hierarchy: PHASE → TASK → ITERATION → BRAINSTORM → IMPLEMENTATION
   - Study the Progress Dashboard template
   - Note all status markers (✅ ⏳ 🚧 🎨 ❌ 🔮)

2. **Discover existing documentation**:
   - Check if user provided path in `$ARGUMENTS`
   - Otherwise, search project root for common files (in order):
     - `PRD.md` (common in TaskMaster AI, Spec-Kit)
     - `PLAN.md`
     - `TODO.md`
     - `DEVELOPMENT.md`
     - `ROADMAP.md`
     - `TASKS.md`
   - If multiple found, list them and ask: "Found [X] files. Which should I migrate? (number or path)"
   - If none found, ask: "No plan files found. Provide path to file you want to migrate, or use `/flow-blueprint` to start fresh."

3. **Read and analyze source file**:
   - Read entire source file
   - Detect structure type:
     - **STRUCTURED** (Path A): Has phases/tasks/iterations or similar hierarchy
     - **FLAT_LIST** (Path B): Simple todo list or numbered items
     - **UNSTRUCTURED** (Path C): Free-form notes, ideas, design docs
   - Extract key information:
     - Project context/purpose
     - Existing work completed
     - Current status/position
     - Remaining work
     - Architecture/design notes
     - V1/V2 splits (if mentioned)
     - Deferred items
     - Cancelled items

4. **Create backup**:
   - Copy source file: `[original].pre-flow-backup-$(date +%Y-%m-%d-%H%M%S)`
   - Confirm: "✅ Backed up [original] to [backup]"

5. **Generate .flow/PLAN.md** based on detected structure (ALWAYS overwrites if exists):
   - Note: .flow/ directory already exists (created by flow.sh installation)

   **Path A - STRUCTURED** (already has phases/tasks):
   - Keep existing hierarchy
   - Add framework reference at top
   - Add/enhance Progress Dashboard section (after Overview, before Architecture)
   - **Remove duplicate progress sections** (search for patterns like "Current Phase:", "Implementation Tasks", old progress trackers)
   - **Update status pointers** (change "Search for 'Current Phase' below" to jump link to Progress Dashboard)
   - **Identify redundant framework docs** (ask user if sections like "Brainstorming Framework" should be removed since Flow provides this)
   - Standardize status markers (✅ ⏳ 🚧 🎨 ❌ 🔮)
   - Add jump links to Progress Dashboard
   - Preserve all content, decisions, and context
   - Reformat sections to match Flow template
   - Report: "Enhanced existing structure (preserved [X] phases, [Y] tasks, [Z] iterations, removed [N] duplicate sections)"

   **Path B - FLAT_LIST** (todos/bullets):
   - Ask: "Group items into phases? (Y/n)"
   - If yes, intelligently group related items
   - If no, create single phase with items as iterations
   - Add framework reference
   - Add Progress Dashboard
   - Convert items to Flow iteration format
   - Add placeholder brainstorming sessions
   - Mark completed items as ✅, pending as ⏳
   - Report: "Converted flat list to Flow structure ([X] phases, [Y] tasks, [Z] iterations)"

   **Path C - UNSTRUCTURED** (notes):
   - Extract key concepts and features mentioned
   - Create Framework reference
   - Create Overview section from notes
   - Create Architecture section if design mentioned
   - Create Progress Dashboard (minimal - project just starting)
   - Create initial brainstorming session with subjects from notes
   - Mark everything as ⏳ PENDING
   - Report: "Created Flow plan from notes (extracted [X] key concepts as brainstorming subjects)"

7. **Add standard Flow sections** (all paths):
   - Framework reference: `> **📖 Framework Guide**: See DEVELOPMENT_FRAMEWORK.md`
   - Progress Dashboard (with proper format)
   - Development Plan with proper hierarchy
   - Status markers at every level

8. **Smart content preservation**:
   - NEVER discard user's original content
   - Preserve all decisions, rationale, context
   - Preserve code examples, file paths, references
   - Preserve completion status and dates
   - Enhance with Flow formatting, don't replace

9. **Confirm to user**:
   ```
   ✨ Migration complete!

   📂 Source: [original file path]
   💾 Backup: [backup file path]
   🎯 Output: .flow/PLAN.md

   Migration type: [STRUCTURED/FLAT_LIST/UNSTRUCTURED]
   Changes:
     + Added Progress Dashboard with jump links
     + Enhanced [X] status markers
     + Preserved [Y] completed items
     + Preserved [Z] pending items
     + [other changes specific to migration type]

   Next steps:
     1. Review: diff [backup] .flow/PLAN.md
     2. Verify: /flow-status
     3. Start using Flow: /flow-brainstorm_start [topic]

   📂 Flow is now managing this project from .flow/ directory
   ```

10. **Handle edge cases**:
    - If source file is empty: Suggest `/flow-blueprint` instead
    - If source file is already Flow-compliant: Mention it's already compatible, migrate anyway
    - If can't determine structure: Default to Path C (unstructured)
    - If migration fails: Keep backup safe, report error, suggest manual approach

**Output**: Create `.flow/PLAN.md` from existing documentation, create backup, confirm migration to user.
```

---

## /flow-update-plan-version

**File**: `flow-update-plan-version.md`

```markdown
---
description: Update existing plan to match latest Flow framework structure
---

You are executing the `/flow-update-plan-version` command from the Flow framework.

**Purpose**: Update an existing `.flow/PLAN.md` to match the latest Flow framework structure and patterns.

**IMPORTANT**: This command updates your current plan file to match framework changes (e.g., Progress Dashboard moved, new status markers, structural improvements).

**Instructions**:

1. **Read the framework guide**:
   - Search for DEVELOPMENT_FRAMEWORK.md in these locations (in order):
     - `.flow/DEVELOPMENT_FRAMEWORK.md`
     - `.claude/DEVELOPMENT_FRAMEWORK.md`
     - `./DEVELOPMENT_FRAMEWORK.md` (project root)
     - `~/.claude/flow/DEVELOPMENT_FRAMEWORK.md` (global)
   - Understand current framework structure and patterns
   - Study the Progress Dashboard template and its location
   - Note all status markers and section structure requirements

2. **Read the example plan**:
   - Search for EXAMPLE_PLAN.md in these locations (in order):
     - `.flow/EXAMPLE_PLAN.md`
     - `.claude/EXAMPLE_PLAN.md`
     - `~/.claude/flow/EXAMPLE_PLAN.md` (global)
   - Study the section order and formatting
   - Note how Progress Dashboard is positioned
   - Understand the complete structure template

3. **Read current plan**:
   - Read `.flow/PLAN.md` (your project's current plan)
   - Analyze its current structure
   - Identify what needs updating to match framework

4. **Create backup**:
   - Copy current plan: `.flow/PLAN.md.version-update-backup-$(date +%Y-%m-%d-%H%M%S)`
   - Confirm: "✅ Backed up .flow/PLAN.md to [backup]"

5. **Update plan structure** (preserve ALL content):
   - **NEVER discard any user content** - only reformat and enhance
   - Update section order to match framework:
     1. Title + Framework Reference
     2. Overview (Purpose, Goals, Scope)
     3. **Progress Dashboard** (if complex project, OR create if missing)
     4. Architecture
     5. Development Plan (Phases → Tasks → Iterations)
   - Move Progress Dashboard if in wrong location (should be after Overview, before Architecture)
   - **Remove duplicate progress sections** (search for old "Implementation Tasks", "Current Phase" headers, redundant trackers)
   - **Update status pointers** (change old references like "Search for 'Current Phase' below" to jump link: `[Progress Dashboard](#-progress-dashboard)`)
   - **Clean up redundant framework documentation** (if user has custom brainstorming/workflow docs that duplicate Flow, ask if they want to remove)
   - Add Progress Dashboard if missing and project is complex (10+ iterations)
   - Ensure all status markers are standardized (✅ ⏳ 🚧 🎨 ❌ 🔮)
   - Add jump links to Progress Dashboard if missing
   - Update any deprecated patterns to new format
   - Preserve all:
     - Decisions and rationale
     - Brainstorming subjects and resolutions
     - Implementation notes
     - Completion dates
     - Bug discoveries
     - Code examples

6. **Verify consistency**:
   - Check Progress Dashboard matches status markers
   - Verify all sections follow framework structure
   - Ensure no content was lost

7. **Confirm to user**:
   ```
   ✨ Plan structure updated to match latest Flow framework!

   💾 Backup: .flow/PLAN.md.version-update-backup-[timestamp]
   🎯 Updated: .flow/PLAN.md

   Changes made:
     + Moved Progress Dashboard to correct location (after Overview, before Architecture)
     + Removed [N] duplicate progress sections (old trackers)
     + Updated status pointers to use jump links
     + Added [X] jump links to Progress Dashboard
     + Standardized [Y] status markers
     + Cleaned up [Z] redundant framework documentation
     + [other changes specific to this update]

   Next steps:
     1. Review changes: diff [backup] .flow/PLAN.md
     2. Verify: /flow-status
     3. Continue work: /flow-next

   All your content preserved - only structure enhanced.
   ```

8. **Handle edge cases**:
   - If `.flow/PLAN.md` doesn't exist: Suggest `/flow-blueprint` or `/flow-migrate`
   - If plan already matches latest structure: Report "Already up to date!"
   - If can't determine what to update: Ask user what framework version they're coming from

**Output**: Update `.flow/PLAN.md` to latest framework structure, create backup, confirm changes to user.
```

---

## /flow-phase

**File**: `flow-phase.md`

```markdown
---
description: Add a new phase to the development plan
---

You are executing the `/flow-phase` command from the Flow framework.

**Purpose**: Add a new phase to the current PLAN.md file.

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this phase that are NOT part of the current work:
1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Verify framework understanding**: Know that phases are top-level milestones (e.g., "Foundation", "Core Implementation", "Testing")

2. **Parse arguments**: `$ARGUMENTS` = phase description

3. **Add new phase section**:
   ```markdown
   ### Phase [N]: [$ARGUMENTS] ⏳

   **Strategy**: [Ask user or infer from description]

   **Goal**: [What this phase achieves]

   ---
   ```

4. **Update .flow/PLAN.md**: Append new phase to Development Plan section

5. **Confirm to user**: "Added Phase [N]: [$ARGUMENTS] to PLAN.md"

**Output**: Update .flow/PLAN.md with new phase.
```

---

## /flow-task

**File**: `flow-task.md`

```markdown
---
description: Add a new task under the current phase
---

You are executing the `/flow-task` command from the Flow framework.

**Purpose**: Add a new task to the current phase in PLAN.md.

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this task that are NOT part of the current work:
1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Parse arguments**: `$ARGUMENTS` = task description

3. **Find current phase**: Look for last phase marked ⏳ or 🚧

4. **Add new task section**:
   ```markdown
   #### Task [N]: [$ARGUMENTS] ⏳

   **Status**: PENDING
   **Purpose**: [What this task accomplishes]

   ---
   ```

5. **Update .flow/PLAN.md**: Append task under current phase

6. **Confirm to user**: "Added Task [N]: [$ARGUMENTS] to current phase"

**Output**: Update .flow/PLAN.md with new task.
```

---

## /flow-iteration

**File**: `flow-iteration.md`

```markdown
---
description: Add a new iteration under the current task
---

You are executing the `/flow-iteration` command from the Flow framework.

**Purpose**: Add a new iteration to the current task in PLAN.md.

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this iteration that are NOT part of the current work:
1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Parse arguments**: `$ARGUMENTS` = iteration description

3. **Find current task**: Look for last task marked ⏳ or 🚧

4. **Add new iteration section**:
   ```markdown
   ##### Iteration [N]: [$ARGUMENTS] ⏳

   **Status**: PENDING
   **Goal**: [What this iteration builds]

   ---
   ```

5. **Update .flow/PLAN.md**: Append iteration under current task

6. **Confirm to user**: "Added Iteration [N]: [$ARGUMENTS] to current task. Use `/flow-brainstorm_start [topic]` to begin."

**Output**: Update .flow/PLAN.md with new iteration.
```

---

## /flow-brainstorm_start

**File**: `flow-brainstorm_start.md`

```markdown
---
description: Start brainstorming session for current iteration
---

You are executing the `/flow-brainstorm_start` command from the Flow framework.

**Purpose**: Begin a brainstorming session for the current iteration.

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Framework Pattern**: See "Brainstorming Session Pattern" section in framework guide

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues during brainstorming that are NOT part of the current iteration:
1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Parse arguments**: `$ARGUMENTS` = brainstorming topic

3. **Find current iteration**: Look for last iteration marked ⏳ or 🚧

4. **Update iteration status**: Change to 🚧 IN PROGRESS

5. **Add brainstorming section**:
   ```markdown
   ### **Brainstorming Session - [$ARGUMENTS]**

   **Subjects to Discuss** (tackle one at a time):

   1. ⏳ [Suggest first subject based on iteration goal]

   **Resolved Subjects**:

   ---
   ```

6. **Suggest first subject**: Based on iteration name/goal, suggest an initial subject to discuss

7. **Confirm to user**: "Started brainstorming session: [$ARGUMENTS]. First subject: [subject name]. Use `/flow-brainstorm_subject [name]` to add more subjects."

**Output**: Update .flow/PLAN.md with brainstorming section and status change.
```

---

## /flow-brainstorm_subject

**File**: `flow-brainstorm_subject.md`

```markdown
---
description: Add a subject to discuss in brainstorming
---

You are executing the `/flow-brainstorm_subject` command from the Flow framework.

**Purpose**: Add a new subject to the current brainstorming session.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Parse arguments**: `$ARGUMENTS` = subject name and optional brief description

3. **Find current brainstorming session**: Look for "Subjects to Discuss" section

4. **Add subject to list**:
   - Count existing subjects
   - Append: `[N]. ⏳ **[$ARGUMENTS]** - [Brief description if provided]`

5. **Update .flow/PLAN.md**: Add subject to "Subjects to Discuss" list

6. **Confirm to user**: "Added Subject [N]: [$ARGUMENTS] to brainstorming session."

**Output**: Update .flow/PLAN.md with new subject.
```

---

## /flow-brainstorm_resolve

**File**: `flow-brainstorm_resolve.md`

```markdown
---
description: Resolve current subject with decision
---

You are executing the `/flow-brainstorm_resolve` command from the Flow framework.

**Purpose**: Mark a brainstorming subject as resolved with a decision.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Parse arguments**: `$ARGUMENTS` = subject name/number

3. **Find subject**:
   - If number provided, find subject [N]
   - If name provided, find matching subject
   - Default: Find first ⏳ subject (not yet resolved)

4. **Update subject status**: Change ⏳ to ✅ in "Subjects to Discuss" list

5. **Prompt user for details**:
   - "What decision did you make for this subject?"
   - "What's the rationale? (comma-separated reasons)"

6. **Determine resolution type** (IMPORTANT - choose ONE):

   **Type A: Pre-Implementation Task** (code changes needed before implementing iteration)
   - Ask: "Does this decision require code changes before implementing this iteration? (refactoring, bug fixes, system changes)"
   - If YES:
     - Create new pre-implementation task in "### **Pre-Implementation Tasks:**" section
     - Include: Objective, Root Cause (if bug), Solution, Action Items, Files to Modify
     - Mark subject resolution as: "**Action Items**: Pre-Implementation Task [N] created"
     - Example: "Task 3: Fix Conversion Placeholder Requirement"

   **Type B: Immediate Documentation** (architectural decision, no code changes yet)
   - If NO code changes needed:
     - Document decision in appropriate section (Architecture, Design Decisions, etc.)
     - List conceptual action items (if any)
     - Example: "Added `foundational: boolean` property to architecture docs"

   **Type C: Auto-Resolved** (answered by another subject's decision)
   - If subject was resolved by cascade effect:
     - Mark as: "**Resolution**: Auto-resolved by Subject [X]'s decision"
     - Briefly explain why it's answered
     - No separate action items needed

7. **Add resolution section** under "Resolved Subjects":
   ```markdown
   ### ✅ **Subject [N]: [Name]**

   **Decision**: [User's decision]

   **Rationale**:
   - [Reason 1]
   - [Reason 2]

   **Action Items**:
   - [ ] Pre-Implementation Task [N] created (Type A)
     OR
   - [ ] Updated Architecture section with [decision] (Type B)
     OR
   - Auto-resolved by Subject [X] (Type C)

   ---
   ```

8. **Update .flow/PLAN.md**: Update subject status, add resolution section, create pre-implementation task if Type A

9. **Suggest next action**:
   - Type A: "Created Pre-Implementation Task [N]. Continue with next subject or use `/flow-brainstorm_complete` when all subjects resolved."
   - Type B: "Documented decision. Continue with next subject or use `/flow-brainstorm_complete` when all subjects resolved."
   - Type C: "Auto-resolved. Continue with next subject or use `/flow-brainstorm_complete` when all subjects resolved."

10. **Confirm to user**: "Resolved Subject [N]: [Name] ([Resolution Type]). Use `/flow-brainstorm_subject` to add more, or `/flow-brainstorm_complete` when done."

**Output**: Update .flow/PLAN.md with resolved subject.
```

---

## /flow-brainstorm_complete

**File**: `flow-brainstorm_complete.md`

```markdown
---
description: Complete brainstorming and generate action items
---

You are executing the `/flow-brainstorm_complete` command from the Flow framework.

**Purpose**: Close the current brainstorming session (only after pre-implementation tasks are done).

**IMPORTANT**: Pre-implementation tasks should be documented IN PLAN.md during brainstorming, then completed BEFORE running this command.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Verify all subjects resolved**: Check "Subjects to Discuss" - all should be ✅

3. **Check for pre-implementation tasks**:
   - Look for "### **Pre-Implementation Tasks:**" section in PLAN.md
   - If found:
     - Check if all pre-tasks are marked ✅ COMPLETE
     - If any are ⏳ PENDING or 🚧 IN PROGRESS:
       "Pre-implementation tasks exist but are not complete. Complete them first, then run this command again."
     - If all are ✅ COMPLETE: Proceed to step 4
   - If not found:
     - Ask user: "Are there any pre-implementation tasks that need to be completed before starting the main implementation? (Refactoring, system-wide changes, bug fixes discovered during brainstorming, etc.)"
     - If yes: "Please document pre-implementation tasks in PLAN.md first (see framework guide), complete them, then run this command again."
     - If no: Proceed to step 4

4. **Update iteration status**: Change from 🚧 to 🎨 READY FOR IMPLEMENTATION

5. **Add note**: "**Status**: All brainstorming complete, pre-implementation tasks done, ready for implementation"

6. **Confirm to user**: "Brainstorming session complete. Iteration is now 🎨 READY FOR IMPLEMENTATION. Use `/flow-implement_start` to begin."

**Output**: Update .flow/PLAN.md with brainstorming completion status.
```

---

## /flow-implement_start

**File**: `flow-implement_start.md`

```markdown
---
description: Begin implementation of current iteration
---

You are executing the `/flow-implement_start` command from the Flow framework.

**Purpose**: Begin implementation phase for the current iteration.

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Framework Pattern**: See "Implementation Pattern" section in framework guide
- **Prerequisite**: Brainstorming must be ✅ COMPLETE and all pre-implementation tasks done

**🚨 SCOPE BOUNDARY RULE (CRITICAL)**:
If you discover NEW issues during implementation that are NOT part of the current iteration's action items:
1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval
**Exception**: Syntax errors or blocking issues in files you must modify (document what you fixed)

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current iteration**: Look for iteration marked 🎨 READY FOR IMPLEMENTATION

3. **Read Testing Strategy section** (CRITICAL):
   - Locate "## Testing Strategy" section in PLAN.md
   - Understand the verification methodology (simulation, unit tests, TDD, manual QA, etc.)
   - Note file locations, naming conventions, and when verification happens
   - **IMPORTANT**: Follow Testing Strategy exactly - do NOT create test files that violate conventions

4. **Verify readiness**:
   - Brainstorming should be marked ✅ COMPLETE
   - All pre-implementation tasks should be ✅ COMPLETE
   - If not ready: Warn user and ask to complete brainstorming first

5. **Update iteration status**: Change from 🎨 to 🚧 IN PROGRESS

6. **Create implementation section**:
   ```markdown
   ### **Implementation - Iteration [N]: [Name]**

   **Status**: 🚧 IN PROGRESS

   **Action Items** (from brainstorming):

   [Copy all unchecked action items from resolved subjects]

   **Implementation Notes**:

   [Leave blank for user to fill during implementation]

   **Files Modified**:

   [Leave blank - will be filled as work progresses]

   **Verification**: [Leave blank - how work will be verified]

   ---
   ```

6. **Confirm to user**: "Implementation started for Iteration [N]. Work through action items and check them off as you complete them. Use `/flow-implement_complete` when done."

**Output**: Update .flow/PLAN.md with implementation section and status change.
```

---

## /flow-implement_complete

**File**: `flow-implement_complete.md`

```markdown
---
description: Mark current iteration as complete
---

You are executing the `/flow-implement_complete` command from the Flow framework.

**Purpose**: Mark the current iteration as complete.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current iteration**: Look for iteration marked 🚧 IN PROGRESS

3. **Verify completion**:
   - Check all action items are ✅ checked
   - If unchecked items remain: Ask user "There are unchecked action items. Are you sure you want to mark complete? (yes/no)"

4. **Prompt for verification notes**:
   - "How did you verify this iteration works? (tests, manual checks, etc.)"

5. **Update iteration status**: Change from 🚧 to ✅ COMPLETE

6. **Update implementation section**:
   - Add verification notes
   - Add timestamp

7. **Add completion summary**:
   ```markdown
   **Implementation Results**:
   - [Summarize what was built]
   - [List key accomplishments]

   **Verification**: [User's verification method]

   **Completed**: [Date]
   ```

8. **Check if task/phase complete**:
   - If all iterations in task complete → Mark task ✅
   - If all tasks in phase complete → Mark phase ✅

9. **Confirm to user**: "Iteration [N] marked complete! Use `/flow-iteration [description]` to start next iteration, or `/flow-status` to see current state."

**Output**: Update .flow/PLAN.md with completion status and summary.
```

---

## /flow-status

**File**: `flow-status.md`

```markdown
---
description: Show current position and verify plan consistency
---

You are executing the `/flow-status` command from the Flow framework.

**Purpose**: Show current position in the plan.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Parse Progress Dashboard** (if exists):
   - Look for "## 📋 Progress Dashboard" section
   - Extract claimed current phase/task/iteration
   - Extract completion percentages
   - Note: Dashboard is manual, may need verification

3. **Parse status markers** (ground truth):
   - Find current phase (last phase with ⏳ 🚧 🎨 ❌ 🔮)
   - Find current task (last task with ⏳ 🚧 🎨 ❌ 🔮)
   - Find current iteration (last iteration with ⏳ 🚧 🎨 ❌ 🔮)
   - Count ✅ COMPLETE items (these are frozen, skip verification)

4. **Smart verification** (active work only):
   - **Skip ✅ COMPLETE items** - Already verified, now frozen
   - **Verify active work** (🚧 ⏳ 🎨):
     - Check if Progress Dashboard claims match markers
     - Check if ❌ CANCELLED items have reasons
     - Check if 🔮 DEFERRED items have reasons + destinations
   - **Report**:
     ```
     🔍 Consistency Check (Active Work Only):

     ✅ Phase 2 marker: 🚧 IN PROGRESS ✓
     ✅ Task 5 marker: 🚧 IN PROGRESS ✓
     ✅ Iteration 6 marker: 🚧 IN PROGRESS ✓

     ⏭️  Skipped: 15 completed items (verified & frozen)

     Status: All active markers aligned with Progress Dashboard ✓
     ```

5. **If inconsistency detected**:
   ```
   ⚠️  INCONSISTENCY (Active Work):

   Progress Dashboard: Iteration 6 🚧 IN PROGRESS
   Actual marker: Iteration 6 ⏳ PENDING

   Action: Update Progress Dashboard to match markers
   (Markers are ground truth)

   ⏭️  Skipped: 15 completed items
   ```

6. **Display hierarchy**:
   ```
   📋 Current Status:

   Phase [N]: [Name] [Status]
     └─ Task [N]: [Name] [Status]
         └─ Iteration [N]: [Name] [Status]

   Next Action: [Suggest next command based on status]
   ```

7. **Suggest next action**:
   - If ⏳ PENDING → "Use `/flow-brainstorm_start [topic]` to begin"
   - If 🚧 IN PROGRESS (brainstorming) → "Continue resolving subjects with `/flow-brainstorm_resolve`"
   - If 🎨 READY → "Use `/flow-implement_start` to begin implementation"
   - If 🚧 IN PROGRESS (implementing) → "Work through action items, use `/flow-implement_complete` when done"
   - If ✅ COMPLETE → "Use `/flow-iteration [description]` to start next iteration"

8. **Show progress summary**:
   - Count completed vs total iterations
   - Count completed vs total tasks
   - Show percentage complete
   - Show deferred count (🔮)
   - Show cancelled count (❌)

**Output**: Display current status, smart verification results, and suggest next action.
```

---

## /flow-summarize

**File**: `flow-summarize.md`

```markdown
---
description: Generate summary of all phases/tasks/iterations
---

You are executing the `/flow-summarize` command from the Flow framework.

**Purpose**: Generate high-level overview of entire project structure and completion state.

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Use case**: "Bird's eye view" of project health, progress across all phases, quick status reports

**Comparison to other commands**:
- `/flow-status` = "Where am I RIGHT NOW?" (micro view - current iteration)
- `/flow-summarize` = "What's the WHOLE PICTURE?" (macro view - all phases/tasks/iterations)
- `/flow-verify-plan` = "Is this accurate?" (validation)
- `/flow-compact` = "Transfer full context" (comprehensive handoff)

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Parse entire PLAN.md structure**:
   - Extract Version (from metadata at top)
   - Extract current Status line (from metadata)
   - Parse ALL phases with their status markers
   - For each phase, parse ALL tasks
   - For each task, parse ALL iterations
   - Track completion percentages at each level

3. **Generate structured summary** (compact, scannable format):

   ```
   📊 Flow Summary

   Version: [V1/V2/V3]
   Status: [Current phase/task/iteration from metadata]

   Phase [N]: [Name] [Status] [%]
   - Task [N]: [Name] [Status]
     - Iter [N-N] [Status]: [Concise description]
     - Iter [N] 🚧 CURRENT: [What you're working on]
     - Iter [N] ⏳: [What's next]

   Phase [N]: [Name] [Status] [%]
   - Task [N-N]: [Grouped if similar] [Status]
   - Task [N]: [Name] [Status]

   Deferred to V2:
   - [Iteration/feature name]
   - [Iteration/feature name]

   ---
   TL;DR: [One punchy sentence about overall state]
   ```

4. **Formatting rules**:
   - **Compact**: Group consecutive completed iterations (e.g., "Iter 1-5 ✅")
   - **Scannable**: Use emojis (✅ ⏳ 🚧 🎨) and percentages prominently
   - **Highlight**: Mark CURRENT work explicitly in bold or with flag
   - **Indent**: Phase (no indent), Task (- prefix), Iteration (-- or nested -)
   - **Defer section**: Show V2/future items at bottom
   - **Skip noise**: Don't list every task name if they're obvious/sequential
   - **Focus on active work**: Emphasize in-progress and next items

5. **Example output** (payment gateway):

   ```
   📊 Flow Summary

   Version: V1
   Status: Phase 2, Task 5, Iteration 2 - In Progress

   Phase 1: Foundation ✅ 100%
   - Task 1-2: Setup, API, Database schema ✅

   Phase 2: Core Implementation 🚧 75%
   - Task 3-4: Payment processing, Webhooks ✅
   - Task 5: Error Handling
     - Iter 1 ✅: Retry logic
     - Iter 2 🚧 CURRENT: Circuit breaker
     - Iter 3 ⏳: Dead letter queue

   Phase 3: Testing & Integration ⏳ 0%
   - Task 6: Integration tests (pending)

   Deferred to V2:
   - Advanced features (monitoring, metrics)
   - Name generation

   ---
   TL;DR: Foundation done, core payment flow working, currently building circuit breaker for error handling.
   ```

   **Example output** (RED project - showing V1/V2 split):

   ```
   📊 Flow Summary - RED Ability Generation

   === V1 - Core System ===

   Phase 1: Foundation ✅ 100%
   - Task 1-4: Constants, enums, types, refactoring ✅

   Phase 2: Core Implementation 🚧 85%
   - Iter 1-5 ✅: Tier gen, slots, filtering, selection, template parsing
   - Iter 6 🚧 NEXT: Green.generate() integration (ties everything together)
   - Iter 7 ⏳: Blue validation (input guards)
   - Iter 9 ⏳ LAST: Red API wrapper (exposes Blue → Green)

   Phase 3: Testing
   - Script-based testing (Blue → Green flow)

   Deferred to V2:
   - Iter 8: Name generation (stub returns "Generated Ability")
   - Database persistence
   - Stats-based damage calculations

   === V2 - Enhanced System (Phase 4) ===

   Enhancements:
   - Potency system (stats × formulas replace fixed damage)
   - Name generation (124 weighted prefix/suffix combos)
   - 12 new placeholders (conditionals, resources, targeting)
   - Damage variance (±10% for crits)
   - Points & Luck systems
   - Database persistence

   ---
   TL;DR:
   V1 = Basic working system with hardcoded damage ranges (85% done, integration next)
   V2 = Dynamic formulas, character stats integration, full feature set
   ```

6. **Add deferred/cancelled sections**:
   ```
   🔮 Deferred Items:
   - Iteration 10: Name Generation (V2 - complexity, needs 124 components)
   - Task 12: Advanced Features (V2 - out of V1 scope)
   - Feature X: Multi-provider support (V3 - abstraction layer)

   ❌ Cancelled Items:
   - Task 8: Custom HTTP Client (rejected - SDK is better)
   - Subject 3: GraphQL API (rejected - REST is sufficient)
   ```

7. **Smart verification** (active work only):
   - Skip ✅ COMPLETE items (verified & frozen)
   - Verify 🚧 ⏳ 🎨 items match Progress Dashboard
   - Check ❌ items have reasons
   - Check 🔮 items have reasons + destinations
   - Report:
     ```
     🔍 Verification (Active Work Only):
     ✅ All active markers (🚧 ⏳) match Progress Dashboard
     ⏭️  Skipped 18 completed items (verified & frozen)
     ```

8. **Handle multiple versions**:
   - If PLAN.md has V2/V3 sections, use `=== V1 Summary ===` separator
   - V1 gets full Phase/Task/Iteration breakdown
   - V2+ get high-level "Enhancements" list (not full iteration tree)
   - Separate TL;DR line for each version

9. **After generating summary**:
   - "Use `/flow-status` to see detailed current position"
   - "Use `/flow-verify-plan` to verify accuracy against actual code"

**Manual alternative**:
- Read entire PLAN.md manually
- Create outline of all phases/tasks/iterations
- Count completions and calculate percentages
- Format into hierarchical view

**Output**: Hierarchical summary of entire project structure with completion tracking.
```

---

## /flow-next-subject

**File**: `flow-next-subject.md`

```markdown
---
description: Move to next brainstorming subject
---

You are executing the `/flow-next-subject` command from the Flow framework.

**Purpose**: Move to the next unresolved subject in the current brainstorming session.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current brainstorming session**: Look for "Subjects to Discuss" section

3. **Find first unresolved subject**: Look for first ⏳ subject in the list

4. **If found**:
   - Display subject name and description
   - Ask: "Ready to resolve this subject? Use `/flow-brainstorm_resolve [subject-name]`"

5. **If all resolved**:
   - Notify: "All subjects resolved! Use `/flow-brainstorm_complete` to finish brainstorming."

6. **Show progress**: "[N] of [Total] subjects resolved"

**Output**: Show next subject to work on.
```

---

## /flow-next-iteration

**File**: `flow-next-iteration.md`

```markdown
---
description: Skip to next iteration (mark current complete)
---

You are executing the `/flow-next-iteration` command from the Flow framework.

**Purpose**: Move to the next iteration in the plan.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current iteration**: Look for last iteration with any active status (⏳ 🚧 🎨 ✅)

3. **Check if current iteration is complete**:
   - If not ✅ COMPLETE: "Current iteration not complete. Finish it first or use `/flow-iteration` to create a new one."
   - If ✅ COMPLETE: Proceed

4. **Look for next iteration in plan**:
   - Check if there's a next iteration already defined (⏳ PENDING)
   - If found: Display iteration name and ask "Ready to start Iteration [N]: [Name]? Use `/flow-brainstorm_start [topic]`"
   - If not found: "No next iteration defined. Use `/flow-iteration [description]` to create one."

5. **Show progress**: "Iteration [N] of [Total] complete"

**Output**: Show next iteration or prompt to create one.
```

---

## /flow-next

**File**: `flow-next.md`

```markdown
---
description: Auto-advance to next pending iteration
---

You are executing the `/flow-next` command from the Flow framework.

**Purpose**: Auto-detect current context and suggest the next logical step.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Determine current context**:
   - Check current iteration status (⏳ 🚧 🎨 ✅)
   - Check if in brainstorming session (look for "Subjects to Discuss")
   - Check if in implementation (look for "Action Items")

3. **Suggest next command based on context**:

   **If in brainstorming (🚧)**:
   - "Use `/flow-next-subject` to see next subject to resolve"
   - OR "Use `/flow-brainstorm_complete` if all subjects done"

   **If ready for implementation (🎨)**:
   - "Use `/flow-implement_start` to begin implementation"

   **If implementing (🚧)**:
   - Show unchecked action items count
   - "Complete action items and use `/flow-implement_complete` when done"

   **If iteration complete (✅)**:
   - "Use `/flow-next-iteration` to move to next iteration"

   **If pending (⏳)**:
   - "Use `/flow-brainstorm_start [topic]` to begin this iteration"

4. **Show current status summary**: Brief summary of where you are

**Output**: Suggest appropriate next command based on context.
```

---

## /flow-rollback

**File**: `flow-rollback.md`

```markdown
---
description: Undo last plan change
---

You are executing the `/flow-rollback` command from the Flow framework.

**Purpose**: Undo the last change made to PLAN.md.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Check if rollback is possible**:
   - Look for "Changelog" section at bottom of PLAN.md
   - If no recent changes logged: "No recent changes to rollback."

3. **Identify last change**:
   - Parse last entry in Changelog
   - Determine what was changed (phase added, task marked complete, etc.)

4. **Ask for confirmation**:
   - "Last change: [Description of change]. Rollback? (yes/no)"

5. **If confirmed, revert change**:
   - Remove last added section, OR
   - Change status marker back to previous state, OR
   - Uncheck last checked checkbox

6. **Update Changelog**: Add rollback entry

7. **Confirm to user**: "Rolled back: [Description of change]"

**Limitation**: Can only rollback one step at a time. For major reverts, manually edit PLAN.md.

**Output**: Revert last change in PLAN.md.
```

---

## /flow-verify-plan

**File**: `flow-verify-plan.md`

```markdown
---
description: Verify plan file matches actual codebase state
---

You are executing the `/flow-verify-plan` command from the Flow framework.

**Purpose**: Verify that PLAN.md is synchronized with the actual project state.

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Use case**: Run before starting new AI session or compacting conversation to ensure context is accurate

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current iteration**: Look for iteration marked 🚧 IN PROGRESS or 🎨 READY FOR IMPLEMENTATION

3. **Read current implementation section**:
   - Find "Implementation - Iteration [N]" section
   - Identify all action items
   - Note which items are marked as ✅ complete

4. **Verify claimed completions against actual project state**:
   - For each ✅ completed action item, check if it actually exists:
     - "Create UserAuth.ts" → Verify file exists
     - "Add login endpoint" → Search for login endpoint in code
     - "Update database schema" → Check schema files
   - List any discrepancies found

5. **Check for unreported work**:
   - Look for modified files that aren't mentioned in PLAN.md
   - Check git status (if available) for uncommitted changes
   - Identify files that were changed but not documented

6. **Report findings**:
   ```
   📋 Plan Verification Results:

   ✅ Verified Complete:
   - [List action items that are correctly marked complete]

   ❌ Discrepancies Found:
   - [List action items marked complete but evidence not found]

   📝 Unreported Work:
   - [List files changed but not mentioned in PLAN.md]

   Status: [SYNCHRONIZED / NEEDS UPDATE]
   ```

7. **If discrepancies found**:
   - Ask user: "PLAN.md is out of sync with project state. Update .flow/PLAN.md now? (yes/no)"
   - If yes: Update .flow/PLAN.md to reflect actual state:
     - Uncheck items that aren't actually done
     - Add notes about files modified
     - Update status markers if needed
   - If no: "Review discrepancies above and update PLAN.md manually."

8. **If synchronized**:
   - "PLAN.md is synchronized with project state. Ready to continue work."

**Manual alternative**:
- Review PLAN.md action items manually
- Check each completed item exists in codebase
- Use `git status` and `git diff` to verify changes
- Update .flow/PLAN.md to match reality

**Output**: Verification report and optional PLAN.md updates.
```

---

## /flow-compact

**File**: `flow-compact.md`

```markdown
You are executing the `/flow-compact` command from the Flow framework.

**Purpose**: Generate comprehensive conversation report for context transfer to new AI instance.

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Use case**: Before compacting conversation or starting new AI session - ensures zero context loss

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Run status verification first**:
   - Execute `/flow-status` command logic to verify current position
   - Check for conflicting status sections (warn if found)
   - Use this verified status as authoritative source for the report

3. **Generate comprehensive report covering**:

   **Current Work Context**:
   - What feature/task are we working on?
   - What phase/task/iteration are we in? (with status)
   - What was the original goal?

   **Conversation History**:
   - What decisions were made during brainstorming? (with rationale)
   - What subjects were discussed and resolved?
   - What pre-implementation tasks were identified and completed?
   - What action items were generated?

   **Implementation Progress**:
   - What has been implemented so far?
   - What files were created/modified?
   - What verification was done?
   - What remains incomplete?

   **Challenges & Solutions**:
   - What blockers were encountered?
   - How were they resolved?
   - What design trade-offs were made?

   **Next Steps**:
   - What is the immediate next action?
   - What are the pending action items?
   - What should the next AI instance focus on?

   **Important Context**:
   - Any quirks or special considerations for this feature
   - Technical constraints or dependencies
   - User preferences or decisions that must be preserved

4. **Report format**:
   ```
   # Context Transfer Report
   ## Generated: [Date/Time]

   ## Current Status
   [Phase/Task/Iteration with status markers]

   ## Feature Overview
   [What we're building and why]

   ## Conversation Summary
   [Chronological summary of discussions and decisions]

   ## Implementation Progress
   [What's done, what's in progress, what's pending]

   ## Key Decisions & Rationale
   [Critical decisions made with reasoning]

   ## Files Modified
   [List with brief description of changes]

   ## Challenges Encountered
   [Problems and how they were solved]

   ## Next Actions
   [Immediate next steps for new AI instance]

   ## Critical Context
   [Must-know information for continuation]
   ```

5. **Important guidelines**:
   - **Do NOT include generic project info** (tech stack, architecture overview, etc.)
   - **Focus ENTIRELY on the feature at hand** and this conversation
   - **Do NOT worry about token output length** - comprehensive is better than brief
   - **Include WHY, not just WHAT** - decisions need context
   - **Be specific** - reference exact file names, function names, line numbers
   - **Preserve user preferences** - if user made specific choices, document them

6. **After generating report**:
   - "Context transfer report generated. Copy this report to a new AI session to continue work with zero context loss."
   - "Use `/flow-verify-plan` before starting new session to ensure PLAN.md is synchronized."

**Manual alternative**:
- Read entire conversation history manually
- Summarize key points, decisions, and progress
- Document in separate notes file
- Reference PLAN.md for structure

**Output**: Comprehensive context transfer report.
```

---

## Installation Instructions

To use these commands:

1. **Copy individual command files** to `.claude/commands/`:
   ```bash
   mkdir -p .claude/commands
   # Copy each command section above into separate .md files
   # Example: flow-blueprint.md, flow-phase.md, etc.
   ```

2. **Or use the copy-paste method**:
   - Copy the content between the code blocks for each command
   - Create corresponding `.md` files in `.claude/commands/`
   - File names should match command names (e.g., `flow-blueprint.md`)

3. **Test with `/help`**: Run `/help` in Claude Code to see your new commands listed

---

## Command Execution Flow

```
/flow-blueprint
    ↓
Creates PLAN.md with skeleton
    ↓
/flow-brainstorm_start
    ↓
/flow-brainstorm_subject (repeat as needed)
    ↓
/flow-brainstorm_resolve (for each subject)
    ↓
Complete pre-implementation tasks (if any)
    ↓
/flow-brainstorm_complete
    ↓
/flow-implement_start
    ↓
Work through action items (check them off)
    ↓
/flow-implement_complete
    ↓
Repeat for next iteration
```

**Helper commands** available at any time:
- `/flow-status` - Check current position
- `/flow-next` - Auto-advance to next step
- `/flow-rollback` - Undo last change
- `/flow-phase`, `/flow-task`, `/flow-iteration` - Add structure as needed

---

**Version**: 1.0.9
**Last Updated**: 2025-10-02
