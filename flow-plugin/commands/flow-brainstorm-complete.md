---
description: Complete brainstorming and generate action items
---

You are executing the `/flow-brainstorm-complete` command from the Flow framework.

**Purpose**: Close the current brainstorming session (only after pre-implementation tasks are done).

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Completion Criteria (lines in Quick Reference)
- **Deep dive if needed**: Read lines 1167-1797 for Brainstorming Pattern using Read(offset=1167, limit=631)

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current iteration
- Updates iteration status to 🎨 READY in `phase-N/task-M.md`
- Updates `DASHBOARD.md` with "🎨 READY FOR IMPLEMENTATION" status

**IMPORTANT**: Pre-implementation tasks should be documented in task file during brainstorming, then completed BEFORE running this command.

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current iteration: Phase N, Task M, Iteration K

2. **Read current task file** (`phase-N/task-M.md`):
   - Find iteration K
   - Verify all subjects in "Subjects to Discuss" are ✅ resolved

3. **Check for pre-implementation tasks** in task file:

   - Look for "#### Pre-Implementation Tasks" section in iteration
   - If found:
     - Check if all pre-tasks are marked ✅ COMPLETE
     - If any are ⏳ PENDING or 🚧 IN PROGRESS:
       ```
       ❌ Pre-implementation tasks exist but are not complete:
       - [Task 1]: ⏳ PENDING
       - [Task 2]: 🚧 IN PROGRESS

       Complete them first, then run this command again.
       ```
     - If all are ✅ COMPLETE: Proceed to step 4
   - If not found: Proceed to step 4

4. **Verify iteration has up-to-date action items**:

   - Read the iteration's goal or action items
   - Check if they reference the brainstorming session:
     - ✅ **Good patterns**:
       - References brainstorming subjects
       - Has action items from Type D resolutions
     - ❌ **Outdated patterns**:
       - No reference to brainstorming
       - Action items don't match resolved subjects

   - **If action items are outdated**:
     - Warn user: "The iteration's action items don't reference the brainstorming session. Should I update them to match the brainstorming subjects?"
     - Wait for user confirmation

   - **If action items are up-to-date**: Proceed to step 5

5. **Update task file** (`phase-N/task-M.md`):

   a. **Update iteration status** from 🚧 to 🎨:
      ```markdown
      ### 🚧 Iteration 2: Error Handling
      ```
      Becomes:
      ```markdown
      ### 🎨 Iteration 2: Error Handling
      ```

   b. **Add completion note** after brainstorming session:
      ```markdown
      **Brainstorming Status**: ✅ COMPLETE
      **Pre-Implementation Tasks**: ✅ COMPLETE (if applicable)
      **Ready for**: `/flow-implement-start`
      ```

6. **Update DASHBOARD.md**:

   a. **Update "📍 Current Work" section**:
      ```markdown
      ## 📍 Current Work
      - **Phase**: [Phase 2 - Core Implementation](phase-2/)
      - **Task**: [Task 3 - API Integration](phase-2/task-3.md)
      - **Iteration**: [Iteration 2 - Error Handling](phase-2/task-3.md#iteration-2-error-handling) 🎨 READY FOR IMPLEMENTATION
      - **Next**: Use `/flow-implement-start` to begin implementation
      ```

   b. **Update iteration status in "📊 Progress Overview"**:
      - Change iteration marker to show 🎨 READY

   c. **Update "Last Updated" timestamp** at top

   d. **Reminder**: If you discover new issues during implementation (scope violations), STOP and discuss with the user before proceeding.

7. **Confirm to user**:
   ```
   ✅ Brainstorming session complete! Iteration [K]: [Name] marked 🎨 READY FOR IMPLEMENTATION

   **Next Step**: Use `/flow-implement-start` to begin implementation

  
   ```
