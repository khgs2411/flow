---
description: Add a new iteration under the current task
---

You are executing the `/flow-iteration-add` command from the Flow framework.

**Purpose**: Add a new iteration to the current task file and update DASHBOARD.md.

**Multi-File Architecture**: This command:
- Adds iteration section to `phase-N/task-M.md` file
- Updates `DASHBOARD.md` with new iteration

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Iteration Patterns, Task Structure Rules
- **Deep dive if needed**: Read lines 238-566 for Task Structure Rules using Read(offset=238, limit=329)

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this iteration that are NOT part of the current work:

1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Navigate from dashboard** (dashboard-first pattern):
   - Read `DASHBOARD.md`
   - Find current phase and task from "📍 Current Work" section
   - Extract: Phase number N, Task number M

2. **Parse arguments**:
   - `iteration_name` = Name/goal of iteration (required)
   - `iteration_description` = Optional description

3. **Read current task file**:
   - Open `phase-N/task-M.md`
   - Count existing iterations to determine next iteration number
   - Find "## Iterations" section

4. **Add new iteration section** to task file:

   ```markdown
   ### ⏳ Iteration [N]: [iteration_name]

   **Goal**: [iteration_name expanded or iteration_description if provided]
   **Status**: ⏳ PENDING

   ---
   ```

   **Template Notes**:
   - Place AFTER last iteration in "## Iterations" section
   - Use `###` heading level (three hashes)
   - Status always starts as ⏳ PENDING
   - Infer goal from iteration_name if no description provided

5. **Update DASHBOARD.md**:

   a. **Find current task entry** in "📊 Progress Overview" section

   b. **Update task iteration count**:
      - Change: `- 🚧 **Task 3**: API Integration (1/3 iterations)`
      - To: `- 🚧 **Task 3**: API Integration (1/4 iterations)`

   c. **Add iteration to expanded list** (if task is expanded):
      ```markdown
      - 🚧 **Task 3**: API Integration (1/4 iterations) ← CURRENT
        - ✅ Iteration 1: REST Client Setup
        - 🚧 Iteration 2: Error Handling ← ACTIVE
        - ⏳ Iteration 3: Retry Logic
        - ⏳ Iteration 4: [NEW ITERATION NAME]
      ```

   d. **Update completion percentages**:
      - Recalculate phase percentage: `(completed_iterations / total_iterations) * 100`
      - Recalculate overall percentage
      - Update "📈 Completion Status" section

   e. **Update "Last Updated" timestamp** at top of dashboard

6. **Confirm to user**:
   ```
   ✅ Added Iteration [N]: [iteration_name] to Task [M]: [Task Name]

   Next steps:
   - Use `/flow-brainstorm-start [topics]` to plan this iteration
   - Or add more iterations with `/flow-iteration-add [name]`
   ```
