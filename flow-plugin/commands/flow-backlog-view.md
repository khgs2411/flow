---
description: Show backlog contents (tasks waiting)
---

You are executing the `/flow-backlog-view` command from the Flow framework.

**Purpose**: Display backlog showing all tasks currently in backlog directory.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from BACKLOG.md and backlog/ directory**

- Simple read operation (shows backlog list)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 3407-3682 for backlog context

**Multi-File Architecture**: This command:
- Reads `BACKLOG.md` for task list
- Lists files in `backlog/` directory

**Instructions**:

1. **Check if BACKLOG.md exists**:
   - If NOT found: "📦 Backlog is empty. Use `/flow-backlog-add <task>` to move tasks."
   - If found: Proceed to step 2

2. **Read BACKLOG.md**:
   - Extract "Last Updated" timestamp
   - Extract "Tasks in Backlog" count
   - Read "📋 Backlog Tasks" section for task list

3. **Verify backlog/ directory**:
   - List files in `backlog/` directory
   - Confirm task files exist: `backlog/phase-N-task-M.md`

4. **Display backlog contents**:

   ```
   📦 Backlog Contents ([N] tasks):

   **Last Updated**: [Date]

   **Tasks Waiting**:
   - **Task 14**: Potency system - [backlog/phase-2-task-14.md](backlog/phase-2-task-14.md)
   - **Task 15**: Points & Luck systems - [backlog/phase-2-task-15.md](backlog/phase-2-task-15.md)
   - **Task 16**: Database persistence - [backlog/phase-3-task-16.md](backlog/phase-3-task-16.md)

   ---

   **Next Steps**:
   - Use `/flow-backlog-pull <task-number>` to move a task back to active work
   - Example: `/flow-backlog-pull 14` brings Task 14 back to its original phase
   ```

5. **Optional: Show task details** (if user wants more info):
   - Can read full task file from backlog/ on request
   - Default view is just list (lightweight)
