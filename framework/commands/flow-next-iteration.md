---
description: Show next iteration details
---

You are executing the `/flow-next-iteration` command from the Flow framework.

**Purpose**: Display details about the next pending iteration in the current task.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md and task file**

- Finds next ⏳ PENDING iteration in current task
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 567-613 for iteration context

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current task
- Reads `phase-N/task-M.md` to find next pending iteration

**Pattern**: Works like `/flow-next-subject` but for iterations - shows what's coming next.

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current task: Phase N, Task M

2. **Read current task file** (`phase-N/task-M.md`):
   - Find "## Iterations" section
   - Look for first iteration marked ⏳ PENDING

3. **Find next pending iteration**: First ⏳ PENDING iteration in task file

4. **If found, display iteration details**:
```

📋 Next Iteration:

**Iteration [N]**: [Name]

**Goal**: [What this iteration builds]

**Status**: ⏳ PENDING

**Approach**: [Brief description from iteration section if available]

---

Ready to start? Use `/flow-brainstorm-start [topic]` to begin.

```

5. **If NOT found (no pending iterations)**:
- Check if current iteration is in progress: "Still working on Iteration [N]: [Name]. Use `/flow-implement-complete` when done."
- Otherwise: "No more iterations in current task. Use `/flow-iteration-add [description]` to create next iteration, or `/flow-task-complete` if task is done."

6. **Show progress**: "Iteration [current] of [total] in current task"
