---
description: Mark current phase as in progress
---

You are executing the `/flow-phase-start` command from the Flow framework.

**Purpose**: Mark the current phase as 🚧 IN PROGRESS (when first task starts).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md**
- State transition (⏳ PENDING → 🚧 IN PROGRESS)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 567-613 for lifecycle context

**Multi-File Architecture**: This command:
- Updates `DASHBOARD.md` phase status
- No changes to PLAN.md or task files

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this phase that are NOT part of the current work:
1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📊 Progress Overview" section
   - Locate first ⏳ PENDING phase

2. **Update phase status in dashboard**:
   - Change phase marker from ⏳ PENDING to 🚧 IN PROGRESS
   - Example:
     ```markdown
     ### Phase 2: Core Implementation ⏳ PENDING
     ```
     Becomes:
     ```markdown
     ### Phase 2: Core Implementation 🚧 IN PROGRESS
     ```

3. **Update "📍 Current Work" section**:
   - Set current phase to the phase just started
   - Clear task/iteration (no current work yet)
   ```markdown
   ## 📍 Current Work
   - **Phase**: [Phase 2 - Core Implementation](phase-2/)
   - **Task**: None yet - use `/flow-task-add [name]` to create first task
   ```

4. **Update "Last Updated" timestamp** at top of dashboard

5. **Confirm to user**:
   ```
   ✅ Started Phase [N]: [Name]

   Next steps:
   - Use `/flow-task-add [name]` to create tasks in this phase
   - Or use `/flow-blueprint` if you want to regenerate the plan structure
   ```
