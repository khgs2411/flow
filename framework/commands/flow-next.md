---
description: Smart helper - suggests next action based on current context
---

You are executing the `/flow-next` command from the Flow framework.

**Purpose**: Auto-detect current context and suggest the next logical step.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md and task file**

- Smart navigation using Dashboard and current context
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 3277-3356 for decision tree reference

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current work
- Reads `phase-N/task-M.md` to determine current state
- Suggests next command based on context

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current iteration: Phase N, Task M, Iteration K

2. **Read current task file** (`phase-N/task-M.md`):
   - Find iteration K
   - Check iteration status (⏳ 🚧 🎨 ✅)

3. **Determine current context**:

   - Check if in brainstorming session:
     - Look for "Subjects to Discuss" section
     - Count unresolved subjects (⏳ markers)
   - Check for pre-implementation tasks:
     - Look for "#### Pre-Implementation Tasks" section
     - Count pending vs complete
   - Check if in main implementation:
     - Look for "#### Implementation" section

4. **Suggest next command based on context**:

   **Determine exact state**:

   **If status = ⏳ PENDING**:
   → "Use `/flow-brainstorm-start [topic]` to begin this iteration"

   **If status = 🚧 IN PROGRESS**:
   **Check phase progression** (in this order):

   1. **Check unresolved subjects**:
      If any "⏳" subjects in "Subjects to Discuss":
      → "Use `/flow-next-subject` to resolve next subject"
      Show: "X subjects remaining: [list]"

   2. **Check pre-implementation tasks**:
      If "### **Pre-Implementation Tasks:**" section exists:
      Count pending tasks (^#### ⏳)

      If pending > 0:
      → "Continue with Task X: [Name]"
      Show: "[X/Y] pre-implementation tasks complete"

      If pending = 0:
      → "Pre-implementation complete. Use `/flow-brainstorm-complete`"

   3. **Check main implementation**:
      If "### **Implementation**" section exists:
      → "Continue main implementation"
      Show: "Use `/flow-implement-complete` when done"

   4. **Default** (subjects resolved, no pre-tasks):
      → "Use `/flow-brainstorm-complete` to finish brainstorming"

   **If status = 🎨 READY**:
   → "Use `/flow-implement-start` to begin implementation"

   **If status = ✅ COMPLETE**:
   → "Use `/flow-next-iteration` to move to next iteration"

4. **Show current status summary**: Brief summary of where you are
