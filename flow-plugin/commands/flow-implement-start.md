---
description: Begin implementation of current iteration
---

You are executing the `/flow-implement-start` command from the Flow framework.

**Purpose**: Begin implementation phase for the current iteration.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from DASHBOARD.md and task file**

- State transition (🎨 READY/⏳ PENDING → 🚧 IMPLEMENTING)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1798-1836 for implementation workflow

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current work
- Updates iteration status in `phase-N/task-M.md`
- Updates `DASHBOARD.md` current work section
- **Prerequisite**: Brainstorming must be ✅ COMPLETE and all pre-implementation tasks done

**🚨 SCOPE BOUNDARY RULE** (CRITICAL - see .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 339-540):

If you discover NEW issues during implementation that are NOT part of the current iteration's action items:

1. **STOP** immediately - Don't make assumptions or proceed
2. **NOTIFY** user - Present discovered issue(s) with structured analysis
3. **DISCUSS** - Provide structured options (A/B/C/D format):
   - **A**: Create pre-implementation task (< 30 min work, blocking)
   - **B**: Add as new brainstorming subject (design needed)
   - **C**: Handle immediately (only if user approves)
   - **D**: Defer to separate iteration (after current work)
4. **AWAIT USER APPROVAL** - Never proceed without explicit user decision

**Use the Scope Boundary Alert Template** (see .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 356-390)

**Exception**: Syntax errors or blocking bugs in files you must modify (document what you fixed in Implementation Notes)

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current task: Phase N, Task M, Iteration K
   - Navigate to task file link

2. **Read current task file** (`phase-N/task-M.md`):
   - Find iteration K in "## Iterations" section
   - Check iteration status (should be 🎨 READY or ⏳ PENDING)

3. **Read Testing Strategy** (CRITICAL):
   - Read `PLAN.md` "## Testing Strategy" section
   - Understand verification methodology (simulation, unit tests, TDD, manual QA)
   - Note file locations, naming conventions
   - **IMPORTANT**: Follow Testing Strategy exactly - do NOT violate conventions

4. **Verify readiness** (if iteration was 🎨 READY):
   - Brainstorming should be marked ✅ COMPLETE
   - All pre-implementation tasks should be ✅ COMPLETE
   - If not ready: Warn user and ask to complete brainstorming/pre-tasks first

5. **Handle ⏳ PENDING iterations** (no brainstorming yet):
   - Ask user: "Previous iteration complete. Do you want to brainstorm this iteration first (recommended) or skip directly to implementation?"
     - **User chooses brainstorm**: "Please run `/flow-brainstorm-start` first"
     - **User chooses skip**: Proceed with implementation

6. **Update task file** (`phase-N/task-M.md`):

   a. **Update iteration status** from 🎨/⏳ to 🚧 IN PROGRESS:
      ```markdown
      ### 🎨 Iteration 2: Error Handling
      ```
      Becomes:
      ```markdown
      ### 🚧 Iteration 2: Error Handling
      ```

   b. **Create implementation section** in task file:
      ```markdown
      #### Implementation - Iteration 2: Error Handling

      **Status**: 🚧 IN PROGRESS (2025-01-15)

      **Action Items**: See resolved subjects above (Type D items)

      **Implementation Notes**:
      [Leave blank - filled during work]

      **Files Modified**:
      [Leave blank - filled as work progresses]

      **Verification**: [Leave blank - how work verified]

      ---
      ```

   **IMPORTANT**: Implementation section REFERENCES subjects (don't duplicate action items)

7. **Update parent task status** (if needed):
   - If task is ⏳ PENDING: Change to 🚧 IN PROGRESS in task file AND DASHBOARD.md
   - If task already 🚧: Skip

8. **Update DASHBOARD.md**:

   a. **Update "📍 Current Work" section**:
      ```markdown
      ## 📍 Current Work
      - **Phase**: [Phase 2 - Core Implementation](phase-2/)
      - **Task**: [Task 3 - API Integration](phase-2/task-3.md)
      - **Iteration**: [Iteration 2 - Error Handling](phase-2/task-3.md#iteration-2-error-handling) 🚧 IMPLEMENTING
      - **Focus**: Implementing comprehensive error handling with retry logic
      ```

   b. **Update iteration status in "📊 Progress Overview"**:
      - Change iteration marker from 🎨/⏳ to 🚧
      - Add "← ACTIVE" indicator

   c. **Update "Last Updated" timestamp** at top

9. **Confirm to user**:
   ```
   ✅ Started implementation of Iteration [K]: [Name]

   Action items from brainstorming subjects:
   - [List Type D action items from resolved subjects]

   Follow Testing Strategy in PLAN.md for verification.
   ```
