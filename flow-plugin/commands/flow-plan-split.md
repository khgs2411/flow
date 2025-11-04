---
description: Archive old completed tasks to reduce PLAN.md size
---

You are executing the `/flow-plan-split` command from the Flow framework.

**Purpose**: Archive old completed tasks to reduce DASHBOARD.md clutter while preserving full project history in `archive/` directory.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from plan files**

- Moves completed task FILES to archive/ directory (keeps recent 3 tasks visible)
- Updates DASHBOARD.md and CHANGELOG.md to reflect archived tasks
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 2363-2560 for archival patterns

**Multi-File Architecture**: This command:
- Moves `phase-N/task-M.md` files to `archive/phase-N/task-M.md`
- Updates `DASHBOARD.md` to mark tasks as archived
- Updates `CHANGELOG.md` to reference archived task files

**Context**:

- **Framework Guide**: .flow/framework/DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working Files**: .flow/DASHBOARD.md, .flow/phase-N/task-M.md
- **Archive Directory**: .flow/archive/ (task files moved here)
- **Changelog**: .flow/CHANGELOG.md (updated with archive references)

**When to Use**: When DASHBOARD.md has 10+ completed tasks, causing clutter or difficult navigation.

**Archiving Strategy - Recent Context Window**:

- **Keep visible in DASHBOARD.md**: Current task + 3 previous tasks (regardless of status)
- **Archive**: All ✅ COMPLETE tasks older than "current - 3"
- **Always Keep Visible**: Non-complete tasks (⏳ 🚧 ❌ 🔮 🎨) regardless of age

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current task number (e.g., Task 13)
   - Find "📊 Progress Overview" to list all tasks

2. **Calculate archiving threshold**:

   - Threshold = Current task number - 3
   - Example: Current = 13, Threshold = 10
   - **Archive candidates**: Tasks 1-9 (if ✅ COMPLETE)
   - **Keep visible**: Tasks 10, 11, 12, 13 (current + 3 previous)

3. **Identify archivable tasks**:

   - Find all tasks with number < threshold AND status = ✅ COMPLETE
   - List task files: `phase-N/task-M.md` for each archivable task
   - **IMPORTANT**: Keep non-complete tasks visible (⏳ 🚧 ❌ 🔮 🎨) even if old

4. **Move task files to archive**:

   - Create `archive/` directory if doesn't exist
   - For each archivable task:
     - Create phase directory in archive: `archive/phase-N/` if needed
     - Move `phase-N/task-M.md` to `archive/phase-N/task-M.md`
     - Preserve full task content (iterations, brainstorming, everything)

5. **Update CHANGELOG.md**:

   **If .flow/CHANGELOG.md does NOT exist** (first archive):

   ```markdown
   # Project Changelog

   This file contains historical records of completed tasks moved to archive.

   ## 📦 Archived Tasks

   ### Phase N: [Phase Name]

   - **Task M**: [Task Name] - [archive/phase-N/task-M.md](archive/phase-N/task-M.md)
     - Completed: [Date]
     - Archived: [Date]

   ---

   **Last Updated**: [Date]
   **Total Archived**: [Count] tasks
   ```

   **If .flow/CHANGELOG.md ALREADY exists**:
   - Read existing CHANGELOG.md
   - Add new archived tasks under appropriate phase sections
   - Update "Last Updated" and "Total Archived" count
   - Maintain phase hierarchy (don't duplicate phase headers)

6. **Update DASHBOARD.md**:

   **A. Update Progress Overview**:
   - Add 📦 marker to archived tasks
   - Format: `- ✅📦 Task 5: Feature Name (archived)`
   - Keep task in list but mark as archived
   - Update completion percentages to reflect remaining visible tasks

   **B. Update phase headers** (if all phase tasks archived):
   ```markdown
   ### Phase 1: Foundation ✅ COMPLETE

   **Goal**: [Phase goal]
   **Status**: 100% complete ([N] tasks archived to [archive/phase-1/](archive/phase-1/))
   ```

7. **Verify and confirm**:

   - Count archived files
   - Calculate DASHBOARD.md size reduction
   - Confirm to user:

     ```
     ✅ Plan split complete!

     **Archived**: [X] tasks to .flow/archive/
     **Files moved**:
       - phase-1/task-1.md → archive/phase-1/task-1.md
       - phase-1/task-2.md → archive/phase-1/task-2.md
       ...

     **DASHBOARD.md**: Updated to mark [X] tasks as 📦 archived
     **CHANGELOG.md**: Updated with archive references
     **Recent context**: Kept Task [threshold] through Task [current] visible

     Your Progress Dashboard still shows complete project history.
     Archived task files available in .flow/archive/
     ```

**Edge Cases**:

- **No old completed tasks**: "No tasks to archive. All completed tasks are within recent context window (current + 3 previous)."
- **Current task < 4**: "Current task is Task [N]. Need at least Task 4 to enable archiving (keeps current + 3 previous)."
- **Non-complete old tasks**: Keep visible in DASHBOARD.md: "Task [N] kept visible (not complete - status: [status])"
