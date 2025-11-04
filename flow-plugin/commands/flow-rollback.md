---
description: Undo last plan change
---

You are executing the `/flow-rollback` command from the Flow framework.

**Purpose**: Undo the last change made to plan files (DASHBOARD.md or task files).

**🟢 NO FRAMEWORK READING REQUIRED - This command works from plan files**

- Undoes last change using CHANGELOG.md
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1969-2014 for rollback patterns

**Multi-File Architecture**: This command can rollback:
- DASHBOARD.md status updates (phase/task/iteration status changes)
- Task file changes (iteration added, status updated)
- File moves (task archived, moved to backlog)

**Instructions**:

1. **Read CHANGELOG.md**:
   - Look for "📝 Recent Activity" section
   - If no CHANGELOG.md or no recent entries: "No recent changes to rollback."

2. **Identify last change**:

   - Parse last entry in CHANGELOG.md
   - Extract what was changed:
     - "Phase N started" → DASHBOARD.md phase status
     - "Task M completed" → DASHBOARD.md + task file status
     - "Iteration K added" → Task file iteration section
     - "Task M moved to backlog" → File moved to backlog/
     - "Task M archived" → File moved to archive/

3. **Ask for confirmation**:

   - Display last change details:
     ```
     Last change ([Date/Time]):
     - Action: [Description]
     - File(s): [Affected files]
     - Change: [What was modified]

     Rollback this change? (yes/no)
     ```

4. **If confirmed, revert change based on type**:

   **A. Status change rollback**:
   - Read DASHBOARD.md
   - Revert status marker to previous state
   - Example: `🚧 IN PROGRESS` → `⏳ PENDING`
   - Update task file status marker if applicable

   **B. File move rollback**:
   - Move file back: `backlog/phase-N-task-M.md` → `phase-N/task-M.md`
   - Or: `archive/phase-N/task-M.md` → `phase-N/task-M.md`
   - Update DASHBOARD.md to remove archived/backlog markers
   - Update BACKLOG.md or CHANGELOG.md accordingly

   **C. Section added rollback**:
   - Remove last added section from task file
   - Example: Remove last iteration, pre-task, or brainstorm subject
   - Update DASHBOARD.md if iteration count changed

   **D. Checkbox rollback**:
   - Uncheck last checked checkbox in task file
   - Find Implementation section, uncheck last ✅ item

5. **Update CHANGELOG.md**: Add rollback entry

   ```markdown
   ### [Date/Time]
   - 🔄 Rolled back: [Description of reverted change]
   ```

6. **Confirm to user**:

   ```
   ✅ Rolled back: [Description of change]

   **Reverted**:
   - File: [file path]
   - Change: [what was undone]

   CHANGELOG.md updated with rollback entry.
   ```

**Limitation**: Can only rollback one step at a time. For major reverts, manually edit files or use git to revert commits.
