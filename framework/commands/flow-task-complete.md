---
description: Mark current task as complete
---

You are executing the `/flow-task-complete` command from the Flow framework.

**Purpose**: Mark the current task as ✅ COMPLETE (when all iterations done).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md and task file**

- State transition (🚧 IN PROGRESS → ✅ COMPLETE)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 567-613 for completion criteria

**Multi-File Architecture**: This command:
- Updates task status in `phase-N/task-M.md`
- Updates `DASHBOARD.md` with completion and next work

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current task: Phase N, Task M
   - Navigate to task file link

2. **Read current task file** (`phase-N/task-M.md`):
   - Verify all iterations marked ✅ COMPLETE
   - If incomplete iterations found:
     ```
     ❌ Cannot complete task - incomplete iterations found:
     - Iteration 2: Error Handling (🚧 IN PROGRESS)
     - Iteration 3: Retry Logic (⏳ PENDING)

     Complete all iterations first or mark as ❌ CANCELLED / 🔮 DEFERRED.
     ```

3. **Update task file** (`phase-N/task-M.md`):
   - Change task status at top:
     ```markdown
     **Status**: 🚧 IN PROGRESS
     ```
     Becomes:
     ```markdown
     **Status**: ✅ COMPLETE
     ```

4. **Update DASHBOARD.md**:

   a. **Update task status in "📊 Progress Overview"**:
      - Change task marker from 🚧 to ✅
      - Remove "← CURRENT" indicator
      - Example:
        ```markdown
        - 🚧 **Task 3**: API Integration (4/4 iterations) ← CURRENT
        ```
        Becomes:
        ```markdown
        - ✅ **Task 3**: API Integration (4/4 iterations)
        ```

   b. **Update "📍 Current Work" section**:
      - **If more tasks in phase**: Advance to next task
        ```markdown
        ## 📍 Current Work
        - **Phase**: [Phase 2 - Core Implementation](phase-2/)
        - **Task**: [Task 4 - Webhook Handler](phase-2/task-4.md) ⏳ PENDING
        - **Next**: Use `/flow-task-start` to begin this task
        ```
      - **If all tasks in phase complete**: Suggest phase completion
        ```markdown
        ## 📍 Current Work
        - **Phase**: [Phase 2 - Core Implementation](phase-2/) - All tasks complete!
        - **Next**: Use `/flow-phase-complete` to mark phase as done
        ```

   c. **Update completion percentages**:
      - Recalculate phase percentage
      - Recalculate overall percentage
      - Update "📈 Completion Status" section

   d. **Update "Last Updated" timestamp** at top

5. **Confirm to user**:
   ```
   ✅ Completed Task [N]: [Name]

   **What's Next**:
   - **More tasks in phase?** → Use `/flow-task-start` to begin Task [N+1]: [Name]
   - **All tasks complete?** → Use `/flow-phase-complete` to mark phase as done
   ```
