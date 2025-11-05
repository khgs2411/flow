---
description: Move task(s) to backlog to reduce active plan clutter
---

You are executing the `/flow-backlog-add` command from the Flow framework.

**Purpose**: Move pending tasks to BACKLOG.md to reduce active dashboard clutter while preserving all task content.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from DASHBOARD.md and task files**

- Moves task files to backlog directory (token efficiency feature)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 3407-3682 for backlog management patterns

**Multi-File Architecture**: This command:
- Moves `phase-N/task-M.md` files to `backlog/` directory
- Updates `DASHBOARD.md` to remove tasks from active view
- Creates/updates `BACKLOG.md` with references to backogged tasks

**Key Insight**: Backlog is for **token efficiency**, not prioritization. Tasks aren't "low priority" - they're just "not now" (weeks/months away).

**Signature**: `/flow-backlog-add <task-number>` or `/flow-backlog-add <start>-<end>`

**Examples**:
- `/flow-backlog-add 14` - Move Task 14 to backlog
- `/flow-backlog-add 14-22` - Move Tasks 14 through 22 to backlog

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📊 Progress Overview" section
   - Locate tasks by number

2. **Parse arguments**:
   - Single task: `task_numbers` = task number (e.g., "14")
   - Range: `task_numbers` = start-end (e.g., "14-22")
   - Extract task number(s) to move

3. **Validate tasks**:
   - Find task files: `phase-N/task-M.md`
   - Check task status - warn if moving tasks that are 🚧 IN PROGRESS or ✅ COMPLETE
   - Recommended: Only move ⏳ PENDING tasks
   - If user confirms moving non-pending tasks, proceed

4. **Move task files to backlog**:
   - Create `backlog/` directory if doesn't exist
   - For each task:
     - Move `phase-N/task-M.md` to `backlog/phase-N-task-M.md`
     - Preserve all content (iterations, brainstorming, everything)

5. **Update BACKLOG.md**:

   **If BACKLOG.md does NOT exist** (first time):

   ```markdown
   # Project Backlog

   This file lists tasks moved to backlog/ directory to reduce active dashboard size.

   **Backlog Info**:
   - Task files moved to backlog/ directory
   - Tasks retain original numbers for easy reference
   - Full content preserved (brainstorming, iterations, everything)
   - Pull tasks back when ready to work on them

   **Last Updated**: [Current date]
   **Tasks in Backlog**: [Count]

   ---

   ## 📋 Backlog Tasks

   - **Task [N]**: [Name] - [backlog/phase-N-task-M.md](backlog/phase-N-task-M.md)
   - **Task [N]**: [Name] - [backlog/phase-N-task-M.md](backlog/phase-N-task-M.md)
   ```

   **If BACKLOG.md ALREADY exists**:
   - Read existing BACKLOG.md
   - Update "Last Updated" timestamp
   - Update "Tasks in Backlog" count
   - Add tasks to "📋 Backlog Tasks" list

6. **Update DASHBOARD.md**:
   - Remove tasks from "📊 Progress Overview" section
   - Or mark as moved: `- ⏳ Task 14: Potency system (moved to backlog)`
   - Update completion percentages

7. **Reset task status to ⏳ PENDING** (in backlog files):
   - Open each backlog file
   - Change task status to ⏳ PENDING
   - Fresh start when pulled back

8. **Verify and confirm**:
   - Count moved files
   - Confirm to user:

     ```
     ✅ Moved to backlog!

     **Backlogged**: [N] task(s) to backlog/ directory
     **Files moved**: Task [list of numbers]
     **Location**: backlog/phase-N-task-M.md

     Use `/flow-backlog-view` to see backlog contents.
     Use `/flow-backlog-pull <task-number>` to bring a task back when ready.
     ```

**Edge Cases**:
- **Task doesn't exist**: "Task [N] not found"
- **Invalid range**: "Invalid range format. Use: /flow-backlog-add 14-22"
- **Empty range**: "No tasks found in range 14-22"
- **Already in backlog**: Check backlog/ directory first, warn if task already there
