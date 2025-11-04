---
description: Pull task from backlog back into active plan
---

You are executing the `/flow-backlog-pull` command from the Flow framework.

**Purpose**: Move a task from BACKLOG.md back to PLAN.md with sequential renumbering in active phase.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from DASHBOARD.md, BACKLOG.md, and task files**

- Moves task file back from backlog/ to phase directory
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 3407-3682 for backlog patterns

**Multi-File Architecture**: This command:
- Moves `backlog/phase-N-task-M.md` back to `phase-N/task-M.md`
- Updates `DASHBOARD.md` to show task
- Updates `BACKLOG.md` to remove task

**Signature**: `/flow-backlog-pull <task-number> [position]`

**Examples**:
- `/flow-backlog-pull 14` - Pull Task 14 back to its original phase
- `/flow-backlog-pull 14 add to phase 5` - Pull Task 14 to Phase 5 instead

**Instructions**:

1. **Check if BACKLOG.md exists**:
   - If NOT found: "📦 Backlog is empty. Nothing to pull."
   - If found: Proceed

2. **Parse arguments**:
   - Required: `task_number` - Task number to pull (e.g., "14")
   - Optional: `position` - Positioning instruction (e.g., "add to phase 5")

3. **Validate task exists in backlog**:
   - Read BACKLOG.md to find task entry
   - Find backlog file: `backlog/phase-N-task-M.md`
   - If NOT found: "Task [N] not found in backlog. Use `/flow-backlog-view` to see available."
   - If found: Proceed

4. **Determine target phase**:
   - **Default**: Use task's original phase (from filename `phase-N-task-M.md`)
   - **With position instruction**: Parse for target phase
     - "add to phase 5" → Move to phase-5/
   - **If phase doesn't exist**: Create phase directory

5. **Determine new task number**:
   - List existing tasks in target phase
   - Find highest task number
   - New task number = highest + 1
   - Example: phase-2/ has task-1.md, task-2.md → new task is task-3.md

6. **Move task file back**:
   - Move `backlog/phase-N-task-M.md` to `phase-N/task-K.md` (K = new number)
   - Update task metadata in file:
     - Update task number in header
     - Reset status to ⏳ PENDING
   - Preserve all content (iterations, brainstorming, everything)

7. **Update BACKLOG.md**:
   - Remove task from "📋 Backlog Tasks" list
   - Decrement "Tasks in Backlog" count
   - Update "Last Updated" timestamp

8. **Update DASHBOARD.md**:
   - Add task to "📊 Progress Overview" in target phase
   - Mark as ⏳ PENDING
   - Update phase task count
   - Update completion percentages

9. **Verify and confirm**:
   ```
   ✅ Pulled from backlog!

   **Task**: Task [old-number] → Task [new-number]
   **File**: backlog/phase-N-task-M.md → phase-N/task-K.md
   **Phase**: Phase [N]: [Name]
   **Status**: ⏳ PENDING (ready to start)

   **Backlog**: [N-1] tasks remaining

   Use `/flow-task-start` to begin this task when ready.
   ```

**Edge Cases**:
- **Backlog empty**: "Backlog is empty. Nothing to pull."
- **Task not in backlog**: "Task [N] not in backlog."
- **Target phase doesn't exist**: Create phase directory
- **No active phase**: Ask user which phase to add task to
