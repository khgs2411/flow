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

**💡 TIP FOR USERS**: Provide rich context in $ARGUMENTS! You are the domain expert - the more details you provide upfront, the better the plan.

**Good example**:
```
/flow-blueprint "Payment Gateway Integration

Requirements:
- Integrate with Stripe API for credit card processing
- Support webhooks for async payment notifications
- Handle failed payments with retry logic (3 attempts, exponential backoff)

Constraints:
- Must work with existing Express.js backend
- Maximum 2-second response time

Reference:
- See src/legacy/billing.ts for old PayPal integration
- Similar webhook pattern in src/webhooks/shipment.ts

Testing:
- Simulation-based per service (scripts/{service}.scripts.ts)
"
```

**Minimal example** (AI will ask follow-up questions):
```
/flow-blueprint "payment gateway"
```

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
   - Extract all provided information: requirements, constraints, reference paths, testing preferences
   - If user provided rich context (requirements, constraints, references), use it directly
   - If minimal context provided (just a name), prepare to ask follow-up questions

3. **Check for reference implementation** (if not already in $ARGUMENTS):
   - If user mentioned reference paths in arguments (e.g., "See src/legacy/billing.ts"), read and analyze them
   - If no reference mentioned, ask: "Do you have a reference implementation I should analyze? (Provide path or say 'no')"
   - If reference provided, read and analyze it to inform the planning

4. **Gather testing methodology** (CRITICAL - if not already in $ARGUMENTS):
   - If user provided testing details in arguments (e.g., "Testing: Simulation-based per service"), use them directly and skip to step 5
   - Otherwise, ask: "How do you prefer to verify implementations? Choose or describe:
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
   - "Use `/flow-brainstorm-start [topic]` to begin first iteration"

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

## /flow-plan-update

**File**: `flow-plan-update.md`

```markdown
---
description: Update existing plan to match latest Flow framework structure
---

You are executing the `/flow-plan-update` command from the Flow framework.

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

## /flow-phase-add

**File**: `flow-phase-add.md`

```markdown
---
description: Add a new phase to the development plan
---

You are executing the `/flow-phase-add` command from the Flow framework.

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

## /flow-phase-start

**File**: `flow-phase-start.md`

```markdown
---
description: Mark current phase as in progress
---

You are executing the `/flow-phase-start` command from the Flow framework.

**Purpose**: Mark the current phase as 🚧 IN PROGRESS (when first task starts).

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

2. **Find current phase**: Look for last phase marked ⏳ PENDING

3. **Update phase status**: Change marker from ⏳ to 🚧 IN PROGRESS

4. **Update Progress Dashboard**:
   - Find "## 📋 Progress Dashboard" section
   - Update current phase information
   - Update last updated timestamp
   - Add action description: "Phase [N] started"

5. **Confirm to user**: "Started Phase [N]: [Name]. Use `/flow-task-add [description]` to create tasks."

**Output**: Update .flow/PLAN.md with phase status change and Progress Dashboard update.
```

---

## /flow-phase-complete

**File**: `flow-phase-complete.md`

```markdown
---
description: Mark current phase as complete
---

You are executing the `/flow-phase-complete` command from the Flow framework.

**Purpose**: Mark the current phase as ✅ COMPLETE (when all tasks done).

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current phase**: Look for phase marked 🚧 IN PROGRESS

3. **Verify all tasks complete**: Check that all tasks in this phase are marked ✅ COMPLETE
   - If incomplete tasks found: "Phase has incomplete tasks. Complete them first or mark as ❌ CANCELLED / 🔮 DEFERRED."

4. **Update phase status**: Change marker from 🚧 to ✅ COMPLETE

5. **Update Progress Dashboard**:
   - Find "## 📋 Progress Dashboard" section
   - Update current phase to next phase (or mark project complete if no next phase)
   - Update completion percentages
   - Update last updated timestamp
   - Add action description: "Phase [N] complete"

6. **Check for next phase**:
   - If next phase exists: Auto-advance to next phase (show name)
   - If no next phase: "All phases complete! Project finished."

7. **Confirm to user**: "Phase [N] marked complete! Next: Phase [N+1]: [Name]. Use `/flow-phase-start` when ready."

**Output**: Update .flow/PLAN.md with phase completion and Progress Dashboard update.
```

---

## /flow-task-add

**File**: `flow-task-add.md`

```markdown
---
description: Add a new task under the current phase
---

You are executing the `/flow-task-add` command from the Flow framework.

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

## /flow-task-start

**File**: `flow-task-start.md`

```markdown
---
description: Mark current task as in progress
---

You are executing the `/flow-task-start` command from the Flow framework.

**Purpose**: Mark the current task as 🚧 IN PROGRESS (when first iteration starts).

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

2. **Find current task**: Look for last task marked ⏳ PENDING in current phase

3. **Update task status**: Change marker from ⏳ to 🚧 IN PROGRESS

4. **Update Progress Dashboard**:
   - Find "## 📋 Progress Dashboard" section
   - Update current task information
   - Update last updated timestamp
   - Add action description: "Task [N] started"

5. **Confirm to user**: "Started Task [N]: [Name]. Use `/flow-iteration-add [description]` to create iterations."

**Output**: Update .flow/PLAN.md with task status change and Progress Dashboard update.
```

---

## /flow-task-complete

**File**: `flow-task-complete.md`

```markdown
---
description: Mark current task as complete
---

You are executing the `/flow-task-complete` command from the Flow framework.

**Purpose**: Mark the current task as ✅ COMPLETE (when all iterations done).

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current task**: Look for task marked 🚧 IN PROGRESS

3. **Verify all iterations complete**: Check that all iterations in this task are marked ✅ COMPLETE
   - If incomplete iterations found: "Task has incomplete iterations. Complete them first or mark as ❌ CANCELLED / 🔮 DEFERRED."

4. **Update task status**: Change marker from 🚧 to ✅ COMPLETE

5. **Update Progress Dashboard**:
   - Find "## 📋 Progress Dashboard" section
   - Update current task to next task (or next phase if all tasks done)
   - Update completion percentages
   - Update last updated timestamp
   - Add action description: "Task [N] complete"

6. **Check if phase complete**:
   - If all tasks in phase are ✅ COMPLETE: Suggest `/flow-phase-complete`
   - If more tasks: Auto-advance to next task (show name)

7. **Confirm to user**: "Task [N] marked complete! Next: Task [N+1]: [Name]. Use `/flow-task-start` when ready."

**Output**: Update .flow/PLAN.md with task completion and Progress Dashboard update.
```

---

## /flow-iteration-add

**File**: `flow-iteration-add.md`

```markdown
---
description: Add a new iteration under the current task
---

You are executing the `/flow-iteration-add` command from the Flow framework.

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

6. **Confirm to user**: "Added Iteration [N]: [$ARGUMENTS] to current task. Use `/flow-brainstorm-start [topic]` to begin."

**Output**: Update .flow/PLAN.md with new iteration.
```

---

## /flow-brainstorm-start

**File**: `flow-brainstorm-start.md`

```markdown
---
description: Start brainstorming session with user-provided topics
---

You are executing the `/flow-brainstorm-start` command from the Flow framework.

**Purpose**: Begin a brainstorming session for the current iteration with subjects provided by the user.

**Signature**: `/flow-brainstorm-start [optional: free-form text describing topics to discuss]`

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

2. **Find current iteration**: Look for last iteration marked ⏳ or 🚧

3. **Determine mode** (two modes available):

   **MODE 1: With Argument** (user provides topics in command)
   - Parse `$ARGUMENTS` = user's free-form text describing topics
   - Extract individual subjects from the text (1-100+ topics)
   - User controls WHAT to brainstorm, AI structures HOW
   - Example: `/flow-brainstorm-start "API design, database schema, auth flow, error handling"`
   - AI extracts: [API design, database schema, auth flow, error handling]

   **MODE 2: Without Argument** (interactive)
   - No arguments provided
   - Prompt user: "What subjects would you like to brainstorm in this session?"
   - Wait for user response with topics
   - Extract subjects from user's response

4. **Extract subjects from user input**:
   - Parse natural language text
   - Identify distinct topics/subjects (comma-separated, "and", bullet points, etc.)
   - Create numbered list
   - Handle 1 to 100+ topics gracefully
   - If ambiguous, use best judgment or ask user for clarification

5. **Update iteration status**: Change to 🚧 IN PROGRESS (Brainstorming)

6. **Create brainstorming section**:
   ```markdown
   ### **Brainstorming Session - [Brief description from user input]**

   **Focus**: [Summarize the main goal based on subjects]

   **Subjects to Discuss** (tackle one at a time):

   1. ⏳ **[Subject 1]** - [Brief description if needed]
   2. ⏳ **[Subject 2]** - [Brief description if needed]
   3. ⏳ **[Subject 3]** - [Brief description if needed]
   ...

   **Resolved Subjects**:

   ---
   ```

7. **Update Progress Dashboard**: Update current iteration status to "🚧 BRAINSTORMING"

8. **Confirm to user**:
   - "Started brainstorming session with [N] subjects."
   - List all subjects
   - "Use `/flow-next-subject` to start discussing the first subject."

**Key Principle**: User always provides topics (via argument or interactive prompt). AI never invents subjects on its own.

**Output**: Update .flow/PLAN.md with brainstorming section, subject list, and status change.
```

---

## /flow-brainstorm-subject

**File**: `flow-brainstorm-subject.md`

```markdown
---
description: Add a subject to discuss in brainstorming
---

You are executing the `/flow-brainstorm-subject` command from the Flow framework.

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

## /flow-brainstorm-review

**File**: `flow-brainstorm-review.md`

```markdown
---
description: Review all resolved subjects, suggest follow-up work
---

You are executing the `/flow-brainstorm-review` command from the Flow framework.

**Purpose**: Review all resolved brainstorming subjects, verify completeness, summarize decisions, show action items, and suggest follow-up work (iterations/pre-tasks) before marking the brainstorming session complete.

**This is the review gate before `/flow-brainstorm-complete`.**

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Read framework documentation**: Find and read DEVELOPMENT_FRAMEWORK.md (search in .claude/, project root, or ~/.claude/flow/)

3. **Locate current iteration**: Use "Progress Dashboard" to find current Phase/Task/Iteration

4. **Verify all subjects resolved**:
   - Check "Subjects to Discuss" section under current iteration's "Brainstorming Session"
   - Count total subjects vs ✅ resolved subjects
   - If ANY subjects remain unmarked (⏳ PENDING), warn user: "Not all subjects resolved. Run `/flow-next-subject` to complete remaining subjects."
   - If all subjects are ✅ resolved, proceed to next step

5. **Summarize resolved subjects**:
   - Read all entries in "Resolved Subjects" section
   - Create concise summary of each resolution:
     - Subject name
     - Decision made
     - Key rationale points
   - Present in numbered list format

6. **Show all action items**:
   - Extract all documented action items from resolved subjects
   - Categorize by type:
     - **Pre-Implementation Tasks**: Work that must be done BEFORE implementing this iteration
     - **Follow-up Iterations**: Future work to tackle after this iteration
     - **Documentation Updates**: Files/docs that need changes
     - **Other Actions**: Miscellaneous tasks
   - Present in organized format

7. **Suggest follow-up work**:
   - Analyze all action items and suggest:
     - Which items should become pre-implementation tasks (in current iteration)
     - Which items should become new iterations (under current task)
     - Which items can be deferred to future tasks/phases
   - Present suggestions in this format:
     ```
     **Suggested Pre-Implementation Tasks** (complete before /flow-implement-start):
     - [Task description]
     - [Task description]

     **Suggested New Iterations** (add with /flow-iteration-add):
     - Iteration N+1: [Name and description]
     - Iteration N+2: [Name and description]

     **Can Be Deferred**:
     - [Task description] - Reason for deferral
     ```

8. **Await user instructions**:
   - Do NOT automatically create iterations or pre-tasks
   - Prompt user: "Would you like me to create these pre-tasks/iterations, or would you prefer to adjust the suggestions?"
   - Wait for user confirmation before taking action

**Next Steps After Review**:
- If user wants to add pre-tasks → document in "Pre-Implementation Tasks" section
- If user wants to add iterations → use `/flow-iteration-add` for each
- Once all pre-tasks are complete → run `/flow-brainstorm-complete`

**Output**: Comprehensive review summary with actionable suggestions, awaiting user confirmation.
```

---

## /flow-brainstorm-complete

**File**: `flow-brainstorm-complete.md`

```markdown
---
description: Complete brainstorming and generate action items
---

You are executing the `/flow-brainstorm-complete` command from the Flow framework.

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

6. **Confirm to user**: "Brainstorming session complete. Iteration is now 🎨 READY FOR IMPLEMENTATION. Use `/flow-implement-start` to begin."

**Output**: Update .flow/PLAN.md with brainstorming completion status.
```

---

## /flow-implement-start

**File**: `flow-implement-start.md`

```markdown
---
description: Begin implementation of current iteration
---

You are executing the `/flow-implement-start` command from the Flow framework.

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

6. **Confirm to user**: "Implementation started for Iteration [N]. Work through action items and check them off as you complete them. Use `/flow-implement-complete` when done."

**Output**: Update .flow/PLAN.md with implementation section and status change.
```

---

## /flow-implement-complete

**File**: `flow-implement-complete.md`

```markdown
---
description: Mark current iteration as complete
---

You are executing the `/flow-implement-complete` command from the Flow framework.

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

9. **Confirm to user**: "Iteration [N] marked complete! Use `/flow-iteration-add [description]` to start next iteration, or `/flow-status` to see current state."

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

**Purpose**: Show current position in the plan and verify active work consistency.

**PERFORMANCE NOTE**: This command uses Dashboard-first approach for token efficiency. For large PLAN.md files (2000+ lines), this reduces token usage by 95% (from 32,810 → ~1,530 tokens).

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Read Progress Dashboard ONLY** (Dashboard-first approach):
   ```bash
   # Use Grep to read ONLY the Progress Dashboard section (~50 lines)
   Grep pattern: "^## 📋 Progress Dashboard"
   Use -A 20 flag to read ~20 lines after match
   ```

   Extract from Dashboard text:
   - Last Updated timestamp
   - Current Phase number and name
   - Current Task number and name
   - Current Iteration number and name
   - Current status (⏳ PENDING / 🚧 IMPLEMENTING / 🎨 READY / etc)
   - Completion percentages

3. **Verify current markers** (micro integrity - current work only):

   Use 3 targeted Greps to verify ONLY the current items claimed by Dashboard:

   **Grep 1 - Verify Current Phase**:
   ```bash
   # If Dashboard says "Phase 2", verify Phase 2 marker
   pattern: "^#### Phase 2:"
   Use -A 2 to read status line
   Extract: Status emoji (⏳ 🚧 🎨 ✅ ❌ 🔮)
   ```

   **Grep 2 - Verify Current Task**:
   ```bash
   # If Dashboard says "Task 4", verify Task 4 marker
   pattern: "^##### Task 4:"
   Use -A 2 to read status line
   Extract: Status emoji
   ```

   **Grep 3 - Verify Current Iteration**:
   ```bash
   # If Dashboard says "Iteration 6", verify Iteration 6 marker
   pattern: "^###### Iteration 6:"
   Use -A 2 to read status line
   Extract: Status emoji
   ```

4. **Micro integrity check** (active work only):
   - Compare Dashboard claims vs actual markers for current phase/task/iteration
   - **Skip all ✅ COMPLETE items** - Already verified, now frozen
   - Report verification results:
     ```
     🔍 Consistency Check (Current Work Only):

     ✅ Phase 2 marker: 🚧 IN PROGRESS ✓
     ✅ Task 4 marker: 🚧 IN PROGRESS ✓
     ✅ Iteration 6 marker: 🚧 IMPLEMENTING ✓

     Status: Dashboard aligned with markers ✓
     ```

5. **If inconsistency detected**:
   ```
   ⚠️  INCONSISTENCY DETECTED:

   Dashboard claims: Iteration 6 🚧 IMPLEMENTING
   Actual marker:    Iteration 6 ⏳ PENDING

   Action: Update Progress Dashboard to match markers
   (Status markers are ground truth, Dashboard is pointer)
   ```

6. **Display current position**:
   ```
   📋 Current Position:

   Phase [N]: [Name] [Status]
     └─ Task [N]: [Name] [Status]
         └─ Iteration [N]: [Name] [Status]

   Last Updated: [Timestamp from Dashboard]
   ```

7. **Suggest next action** (based on current iteration status):
   - If ⏳ PENDING → "Use `/flow-brainstorm-start [topics]` to begin brainstorming"
   - If 🚧 IMPLEMENTING (in brainstorm phase) → "Continue with `/flow-next-subject` to resolve subjects"
   - If 🎨 READY → "Use `/flow-implement-start` to begin implementation"
   - If 🚧 IMPLEMENTING (in implementation phase) → "Work through action items, use `/flow-implement-complete` when done"
   - If ✅ COMPLETE → "Use `/flow-iteration-add [description]` to start next iteration"

8. **Show completion summary** (from Dashboard percentages):
   - Display Phase completion percentage
   - Display Task completion percentage
   - Display overall project completion

**Key Differences from `/flow-summarize`**:
- `/flow-status` = **Micro scope** (current work only, ~1,530 tokens)
- `/flow-summarize` = **Macro scope** (entire project tree, higher token usage)
- Both verify integrity at their respective scopes

**Output**: Display current position, micro verification results, next action suggestion.
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
description: Discuss next subject, capture decision, and mark resolved
---

You are executing the `/flow-next-subject` command from the Flow framework.

**Purpose**: Show next unresolved subject, facilitate discussion, capture decision, and mark as ✅ resolved (all in one command).

**New Workflow** (streamlined - one command per subject):
```
/flow-next-subject → discuss → capture decision → mark ✅ → auto-advance
/flow-next-subject → (repeat for remaining subjects)
```

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current brainstorming session**: Look for "Subjects to Discuss" section

3. **Find first unresolved subject**: Look for first ⏳ subject in the list

4. **If found** (subject needs discussion):

   **Step A: Present subject**
   - Display subject name and description
   - Present relevant context from iteration goal

   **Step B: Facilitate discussion**
   - Discuss with user about the subject
   - Present options, analysis, or recommendations
   - User provides their decision/direction

   **Step C: Capture decision**
   - Prompt user: "What's your decision for this subject?"
   - Prompt user: "What's the rationale?" (comma-separated reasons)
   - Prompt user: "Any action items?" (optional)

   **Step D: Document resolution**
   - Mark subject ✅ in "Subjects to Discuss" list
   - Add resolution section under "Resolved Subjects":
     ```markdown
     ### ✅ **Subject [N]: [Name]**

     **Decision**: [User's decision]

     **Rationale**:
     - [Reason 1]
     - [Reason 2]

     **Action Items** (if any):
     - [ ] [Item 1]
     - [ ] [Item 2]

     ---
     ```

   **Step E: Auto-advance**
   - Update PLAN.md with resolution
   - Show progress: "[N] of [Total] subjects resolved"
   - Auto-show next unresolved subject (if any)
   - If all resolved: "All subjects resolved! Use `/flow-brainstorm-review` to review decisions and plan follow-up work."

5. **If all resolved**:
   - Notify: "All subjects resolved! Use `/flow-brainstorm-review` to review decisions, identify pre-tasks, and plan follow-up work."
   - Show summary of what was decided

**Key Principle**: Moving to next subject implies current is resolved. No separate "resolve" command needed.

**Output**: Update .flow/PLAN.md with subject resolution and show next subject.
```

---

## /flow-next-iteration

**File**: `flow-next-iteration.md`

```markdown
---
description: Show next iteration details
---

You are executing the `/flow-next-iteration` command from the Flow framework.

**Purpose**: Display details about the next pending iteration in the current task.

**Pattern**: Works like `/flow-next-subject` but for iterations - shows what's coming next.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current task**: Look for task marked 🚧 IN PROGRESS

3. **Find next pending iteration**: Look for first iteration in current task marked ⏳ PENDING

4. **If found, display iteration details**:
   ```
   📋 Next Iteration:

   **Iteration [N]**: [Name]

   **Goal**: [What this iteration builds]

   **Status**: ⏳ PENDING

   **Approach**: [Brief description from iteration section if available]

   ---
   Ready to start? Use `/flow-brainstorm-start [topic]` to begin.
   ```

5. **If NOT found (no pending iterations)**:
   - Check if current iteration is in progress: "Still working on Iteration [N]: [Name]. Use `/flow-implement-complete` when done."
   - Otherwise: "No more iterations in current task. Use `/flow-iteration-add [description]` to create next iteration, or `/flow-task-complete` if task is done."

6. **Show progress**: "Iteration [current] of [total] in current task"

**Output**: Display next iteration details and suggest appropriate next action.
```

---

## /flow-next

**File**: `flow-next.md`

```markdown
---
description: Smart helper - suggests next action based on current context
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
   - OR "Use `/flow-brainstorm-complete` if all subjects done"

   **If ready for implementation (🎨)**:
   - "Use `/flow-implement-start` to begin implementation"

   **If implementing (🚧)**:
   - Show unchecked action items count
   - "Complete action items and use `/flow-implement-complete` when done"

   **If iteration complete (✅)**:
   - "Use `/flow-next-iteration` to move to next iteration"

   **If pending (⏳)**:
   - "Use `/flow-brainstorm-start [topic]` to begin this iteration"

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
/flow-brainstorm-subject (repeat as needed)
    ↓
/flow-brainstorm_resolve (for each subject)
    ↓
Complete pre-implementation tasks (if any)
    ↓
/flow-brainstorm_complete
    ↓
/flow-implement-start
    ↓
Work through action items (check them off)
    ↓
/flow-implement-complete
    ↓
Repeat for next iteration
```

**Helper commands** available at any time:
- `/flow-status` - Check current position
- `/flow-next` - Auto-advance to next step
- `/flow-rollback` - Undo last change
- `/flow-phase-add`, `/flow-task-add`, `/flow-iteration-add` - Add structure as needed

---

**Version**: 1.0.9
**Last Updated**: 2025-10-02
