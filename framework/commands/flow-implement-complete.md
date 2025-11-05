---
description: Mark current iteration as complete
---

You are executing the `/flow-implement-complete` command from the Flow framework.

**Purpose**: Mark the current iteration as complete.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from DASHBOARD.md and task file**
- State transition (🚧 IMPLEMENTING → ✅ COMPLETE)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1798-1836 for completion criteria

**Multi-File Architecture**: This command:
- Updates iteration status in `phase-N/task-M.md`
- Updates `DASHBOARD.md` completion percentages
- Advances to next iteration or suggests task completion

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current iteration: Phase N, Task M, Iteration K
   - Navigate to task file link

2. **Read current task file** (`phase-N/task-M.md`):
   - Find iteration K in "## Iterations" section
   - Verify iteration marked 🚧 IN PROGRESS

3. **Verify completion**:
   - Check brainstorming action items (if brainstorming was done)
   - If unchecked items remain: Ask "There are unchecked action items. Are you sure you want to mark complete?"

4. **Check for existing verification information**:
   - Read Implementation Notes section in task file
   - Review recent conversation (last 5-10 messages) for testing/verification discussion
   - If verification info found: Skip to step 6 (don't ask redundant questions)
   - If NO verification info found: Proceed to step 5

5. **Prompt for verification notes** (ONLY if not already available):
   ```
   How did you verify this iteration works?
   - Tests run? (unit, integration, simulation)
   - Manual checks?
   - Code review?
   ```

6. **Update task file** (`phase-N/task-M.md`):

   a. **Update iteration status** from 🚧 to ✅:
      ```markdown
      ### 🚧 Iteration 2: Error Handling
      ```
      Becomes:
      ```markdown
      ### ✅ Iteration 2: Error Handling
      ```

   b. **Update implementation section**:
      ```markdown
      #### Implementation - Iteration 2: Error Handling

      **Status**: ✅ COMPLETE (2025-01-15)

      **Implementation Notes**:
      - Created `src/integrations/stripe/ErrorMapper.ts` (98 lines)
      - Created `src/integrations/stripe/RetryPolicy.ts` (76 lines)
      - Updated StripeClient with error handling and retry

      **Files Modified**:
      - `src/integrations/stripe/StripeClient.ts` - Added error handling
      - `src/integrations/stripe/ErrorMapper.ts` - Created
      - [... more files ...]

      **Verification**:
      - ✅ All error mapping tests passing
      - ✅ Retry logic tests passing
      - ✅ Integration test with Stripe API successful
      ```

7. **Check if task/phase complete**:
   - Count iterations: How many ✅ COMPLETE vs total?
   - If all iterations complete: Task is ready for `/flow-task-complete`

8. **Update DASHBOARD.md**:

   a. **Update iteration status in "📊 Progress Overview"**:
      - Change iteration marker from 🚧 to ✅
      - Update iteration count: `(1/4 iterations)` → `(2/4 iterations)`

   b. **Update "📍 Current Work" section**:
      - **If more iterations**: Advance to next iteration
        ```markdown
        ## 📍 Current Work
        - **Phase**: [Phase 2 - Core Implementation](phase-2/)
        - **Task**: [Task 3 - API Integration](phase-2/task-3.md)
        - **Iteration**: [Iteration 3 - Retry Logic](phase-2/task-3.md#iteration-3-retry-logic) ⏳ PENDING
        - **Next**: Use `/flow-brainstorm-start` or `/flow-implement-start`
        ```
      - **If all iterations complete**:
        ```markdown
        ## 📍 Current Work
        - **Phase**: [Phase 2 - Core Implementation](phase-2/)
        - **Task**: [Task 3 - API Integration](phase-2/task-3.md) - All iterations complete!
        - **Next**: Use `/flow-task-complete` to mark task as done
        ```

   c. **Update completion percentages**:
      - Recalculate phase percentage
      - Recalculate overall percentage
      - Update "📈 Completion Status" section

   d. **Update "Last Updated" timestamp** at top

9. **Confirm to user**:
   ```
   ✅ Completed Iteration [K]: [Name]

   **What's Next**:
   - **More iterations?** → Use `/flow-brainstorm-start` or `/flow-implement-start` for next iteration
   - **All iterations done?** → Use `/flow-task-complete` to mark task as complete

   **Current state**: [X]/[Y] iterations complete
   ```
