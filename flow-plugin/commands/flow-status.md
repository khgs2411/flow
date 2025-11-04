---
description: Show current position and project progress
---

You are executing the `/flow-status` command from the Flow framework.

**Purpose**: Display current work position and project progress from the dashboard.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md**
- Dashboard-first approach - reads ONLY DASHBOARD.md
- Extremely efficient: <100 lines to read vs thousands in old architecture
- This is the REFERENCE MODEL command - simplest example of multi-file navigation

**Multi-File Architecture**: Flow now uses separate files:
- `DASHBOARD.md` - Progress tracking (⭐ read by this command)
- `PLAN.md` - Static context (not read by this command)
- `phase-N/task-M.md` - Task details (not read by this command)

**Instructions**:

1. **Find .flow/DASHBOARD.md**:
   ```bash
   # Primary location
   .flow/DASHBOARD.md

   # If not found
   Suggest: "/flow-blueprint to create new project" or "/flow-plan-update to migrate old single-file plan"
   ```

2. **Read DASHBOARD.md** (entire file):
   ```bash
   # Simply read the whole file - it's small and focused
   Read: .flow/DASHBOARD.md
   ```

   DASHBOARD.md contains everything you need:
   - Current work pointer (Phase/Task/Iteration)
   - Progress overview for all phases
   - Completion percentages
   - Next actions
   - Recent activity
   - Last updated timestamp

3. **Extract key information**:

   From "📍 Current Work" section:
   - Current Phase (number and name)
   - Current Task (number and name)
   - Current Iteration (number and name)
   - Current status emoji (⏳ 🚧 🎨 ✅ etc.)
   - Focus description

   From "📊 Progress Overview" section:
   - All phases with their status
   - Tasks within each phase
   - Iteration counts per task
   - Completion indicators

   From "📈 Completion Status" section:
   - Phases: X/Y complete
   - Tasks: X/Y complete
   - Iterations: X/Y complete
   - Overall percentage

   From "🎯 Next Actions" section:
   - Immediate actions (today)
   - Short-term actions (this week)
   - Upcoming milestones

4. **Display formatted status**:

   ```
   # [Project Name] - Status

   📍 **Current Work**
   Phase [N]: [Name] [Status]
     └─ Task [M]: [Name] [Status]
         └─ Iteration [K]: [Name] [Status]

   **Focus**: [Current focus description from dashboard]

   ---

   📊 **Progress Overview**

   ### Phase 1: [Name] [Status]
   - Task 1: [Name] [Status] ([X/Y iterations])
   - Task 2: [Name] [Status] ([X/Y iterations])

   ### Phase 2: [Name] [Status] ← CURRENT
   - Task 1: [Name] [Status] ([X/Y iterations])
   - Task 2: [Name] [Status] ([X/Y iterations]) ← CURRENT

   ### Phase 3: [Name] [Status]
   ...

   ---

   📈 **Completion**
   - Phases: [X/Y] ([percentage]%)
   - Tasks: [X/Y] ([percentage]%)
   - Iterations: [X/Y] ([percentage]%)
   - **Overall**: [percentage]%

   ---

   🎯 **Next Actions**
   Immediate:
   - [Action 1]
   - [Action 2]

   Short-term:
   - [Goal 1]
   - [Goal 2]

   ---

   📝 **Recent Activity**
   [Show 3-5 most recent items from dashboard]

   ---

   **Last Updated**: [Timestamp from dashboard]
   ```

5. **Suggest next action** (based on current iteration status):

   Read the current iteration status from dashboard and suggest:

   **If ⏳ PENDING**:
   → "Use `/flow-brainstorm-start` to begin brainstorming this iteration"

   **If 🚧 IN PROGRESS (Brainstorming)**:
   → "Use `/flow-next-subject` to continue brainstorming"
   → Or check "Next Actions" section in dashboard for specific guidance

   **If 🚧 IN PROGRESS (Implementing)**:
   → "Continue implementation. Use `/flow-implement-complete` when done"

   **If 🎨 READY**:
   → "Use `/flow-implement-start` to begin implementation"

   **If ✅ COMPLETE**:
   → "Use `/flow-iteration-add` to add next iteration"
   → Or if task complete: "Use `/flow-task-complete` to finish this task"

6. **Optional: Verify dashboard is up-to-date**:

   Check "Last Updated" timestamp:
   - If recent (< 1 hour): All good
   - If stale (> 24 hours): Suggest running `/flow-verify-plan` to check consistency

   Note: Don't read task files to verify - that's `/flow-verify-plan`'s job. This command trusts the dashboard.

**Key Principle**: DASHBOARD.md is the source of truth for current state. This command simply displays what's in the dashboard - it doesn't validate against task files (that's what `/flow-verify-plan` does).
