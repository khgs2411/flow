---
description: Verify plan file matches actual codebase state
---

You are executing the `/flow-verify-plan` command from the Flow framework.

**Purpose**: Verify that plan files (DASHBOARD.md, PLAN.md, task files) are synchronized with actual project state.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Framework Structure validation, Status Markers (in Quick Reference)
- **Deep dive if needed**: Read lines 105-179 for Framework Structure using Read(offset=105, limit=75)

**Multi-File Architecture**: This command verifies:
- `DASHBOARD.md` - Progress tracking and current work pointers
- `PLAN.md` - Static overview (architecture, testing, constraints)
- `phase-N/task-M.md` - Individual task files with iterations
- Task files contain actual action items and implementation details

**Context**:

- **Framework Guide**: .flow/framework/DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working Files**: .flow/DASHBOARD.md, .flow/PLAN.md, .flow/phase-N/task-M.md
- **Use case**: Run before starting new AI session or compacting conversation to ensure context is accurate

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section for current phase/task/iteration
   - Extract current phase number, task number, iteration number
   - Note current iteration status (🚧 IN PROGRESS or 🎨 READY)

2. **Read current task file**:
   - Locate `.flow/phase-N/task-M.md` based on DASHBOARD.md
   - Find current iteration section (marked 🚧 IN PROGRESS or 🎨 READY)
   - Read "Implementation - Iteration [N]" section
   - Identify all action items
   - Note which items are marked as ✅ complete

3. **Verify claimed completions against actual project state**:

   - For each ✅ completed action item, check if it actually exists:
     - "Create UserAuth.ts" → Verify file exists using Glob or Read
     - "Add login endpoint" → Search for login endpoint in code using Grep
     - "Update database schema" → Check schema files exist
   - List any discrepancies found

4. **Check for unreported work**:

   - Look for modified files that aren't mentioned in task file
   - Check git status (if available) for uncommitted changes
   - Identify files that were changed but not documented

5. **Verify DASHBOARD.md accuracy**:
   - Check that current work pointers match actual task file statuses
   - Verify completion percentages align with actual work done
   - Check that phase/task/iteration hierarchy is consistent

6. **Report findings**:
```

📋 Plan Verification Results:

**Current Work** (from DASHBOARD.md):
- Phase [N], Task [M], Iteration [K]

**Task File**: [phase-N/task-M.md](phase-N/task-M.md)

✅ Verified Complete:
- [List action items that are correctly marked complete]

❌ Discrepancies Found:
- [List action items marked complete but evidence not found]
- [List DASHBOARD.md pointers that don't match task files]

📝 Unreported Work:
- [List files changed but not mentioned in task file]

Status: [SYNCHRONIZED / NEEDS UPDATE]

```

7. **If discrepancies found**:
- Ask user: "Plan files are out of sync with project state. Update files now? (yes/no)"
- If yes: Update plan files to reflect actual state:
  - Update task file (phase-N/task-M.md): Uncheck items that aren't actually done
  - Update DASHBOARD.md: Fix current work pointers, completion percentages
  - Add notes about files modified in task file "Implementation Notes" section
  - Update status markers if needed
- If no: "Review discrepancies above and update plan files manually."

8. **If synchronized**:
- "Plan files are synchronized with project state. Ready to continue work."

**Manual alternative**:
- Review DASHBOARD.md for current work location
- Read current task file manually
- Check each completed action item exists in codebase
- Use `git status` and `git diff` to verify changes
- Update task file and DASHBOARD.md to match reality
