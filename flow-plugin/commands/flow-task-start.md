---
description: Mark current task as in progress
---

You are executing the `/flow-task-start` command from the Flow framework.

**Purpose**: Mark the current task as 🚧 IN PROGRESS (when first iteration starts).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md and task file**
- State transition (⏳ PENDING → 🚧 IN PROGRESS)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 567-613 for lifecycle context

**Multi-File Architecture**: This command:
- Updates task status in `phase-N/task-M.md`
- Updates `DASHBOARD.md` current work section
- Auto-starts parent phase if needed

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this task that are NOT part of the current work:
1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📊 Progress Overview" section
   - Locate current phase (🚧 IN PROGRESS or ⏳ PENDING)
   - Find next ⏳ PENDING task in that phase

2. **Determine target task**:
   - Use first ⏳ PENDING task in current phase
   - Extract phase number N and task number M

3. **Update task file** (`phase-N/task-M.md`):
   - Change task status at top of file:
     ```markdown
     **Status**: ⏳ PENDING
     ```
     Becomes:
     ```markdown
     **Status**: 🚧 IN PROGRESS
     ```

4. **Update parent phase status** (if needed):
   - If phase is ⏳ PENDING: Change to 🚧 IN PROGRESS in DASHBOARD.md
   - If phase already 🚧 IN PROGRESS: Skip this step

5. **Update DASHBOARD.md**:

   a. **Update "📍 Current Work" section**:
      ```markdown
      ## 📍 Current Work
      - **Phase**: [Phase 2 - Core Implementation](phase-2/)
      - **Task**: [Task 3 - API Integration](phase-2/task-3.md)
      - **Iteration**: None yet - use `/flow-iteration-add` or `/flow-brainstorm-start`
      ```

   b. **Update task status in "📊 Progress Overview"**:
      - Change task marker from ⏳ to 🚧
      - Example:
        ```markdown
        - ⏳ **Task 3**: API Integration (0/4 iterations)
        ```
        Becomes:
        ```markdown
        - 🚧 **Task 3**: API Integration (0/4 iterations) ← CURRENT
        ```

   c. **Update "Last Updated" timestamp** at top

6. **Confirm to user**:
   ```
   ✅ Started Task [N]: [Name]

   Next steps:
   - Use `/flow-iteration-add [name]` to add iterations
   - Or use `/flow-brainstorm-start [topics]` to plan this task
   ```
