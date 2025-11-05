---
description: Create a new task file in current phase directory
---

You are executing the `/flow-task-add` command from the Flow framework.

**Purpose**: Create a new task file in the current phase directory and update DASHBOARD.md.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-600 (Quick Reference) - if not already in context
- **Focus on**: Task Structure Rules (lines 164-223) - ALL tasks have iterations
- **Read task template**: Lines 2383-2472 for task file template (with iterations)

**Multi-File Architecture**: This command:
- Creates `phase-N/task-M.md` file
- Updates `DASHBOARD.md` with new task
- Optionally updates `PLAN.md` if phase description needs updating

**Instructions**:

1. **INPUT VALIDATION**:

   ```
   IF $ARGUMENTS is empty OR just whitespace:
     REJECT: "❌ Missing task name. Example: /flow-task-add 'User Authentication'"
     STOP
   ```

   Accept minimal input - will use [TBD] for missing metadata.

2. **Read DASHBOARD.md**:
   - Find current phase from "📍 Current Work" section
   - Count existing tasks in current phase to determine next task number
   - Example: If phase-2/ has task-1.md and task-2.md, new task is task-3.md

3. **Parse arguments and infer metadata**:

   From `$ARGUMENTS`, extract or infer:
   - **Task name**: Use $ARGUMENTS directly
   - **Purpose**: Try to infer:
     - "User Authentication" → "Implement user authentication system"
     - "API Design" → "Design and document API endpoints"
     - "Database Schema" → "Design and implement database schema"
     - "Testing" → "Implement testing infrastructure"
     - Can't infer → "[TBD] - Define during task start"
   - **Task structure**: ALL tasks have iterations (no standalone tasks)
     - Simple tasks → 1-2 iterations with direct action items
     - Complex tasks → Multiple iterations with brainstorming
     - Always create with at least 1 iteration

4. **Create task file**:

   Create `phase-N/task-M.md` using template from .flow/framework/DEVELOPMENT_FRAMEWORK.md:

   ```markdown
   # Task [M]: [Task Name]

   **Status**: ⏳ PENDING
   **Phase**: [Phase N - Name](../DASHBOARD.md#phase-N-name)
   **Purpose**: [Inferred or [TBD]]

   ---

   ## Task Overview

   [Brief description based on task name]

   **Why This Task**: [TBD] - Define during task start or brainstorming

   [If complex task - add Dependencies section:]
   **Dependencies**:
   - **Requires**: [TBD]
   - **Blocks**: [TBD]

   ---

   ## Iterations

   ### ⏳ Iteration 1: [TBD]

   **Goal**: [TBD] - Define during brainstorming or task start

   **Status**: ⏳ PENDING

   ---

   #### Action Items

   - [ ] [TBD] - Define during brainstorming or add directly

   ---

   ## Task Notes

   **Discoveries**: (To be filled during work)

   **Decisions**: (To be filled during work)

   **References**: (Add relevant code/docs here)
   ```

5. **Update DASHBOARD.md**:

   Add to current phase in "📊 Progress Overview" section:
   ```markdown
   - ⏳ **Task [M]**: [Task Name]
   ```

   Update "📈 Completion Status":
   - Increment task count for current phase
   - Update phase completion percentage

   Update "🎯 Next Actions" if this is the first task:
   - "Use /flow-task-start to begin Task [M]"

6. **Update DASHBOARD.md timestamp**:
   - Update "Last Updated" to current timestamp

7. **Confirm to user**:
   ```
   "✅ Created Task [M]: [Task Name]

   📂 Created: .flow/phase-N/task-M.md
   📝 Updated: DASHBOARD.md

   [If used [TBD]:]
   📝 Used [TBD] placeholders for: [Purpose/Action Items/Iterations]
   💡 Refine during task start or brainstorming

   🎯 Next Steps:
   - Use `/flow-task-start` to begin work on this task
   - Use `/flow-iteration-add` to add more iterations (if needed)
   - Use `/flow-brainstorm-start` when ready to design"
   ```
