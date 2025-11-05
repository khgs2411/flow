---
description: Mark current phase as complete
---

You are executing the `/flow-phase-complete` command from the Flow framework.

**Purpose**: Mark the current phase as ✅ COMPLETE (when all tasks done).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md**

- State transition (🚧 IN PROGRESS → ✅ COMPLETE)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 567-613 for completion criteria

**Multi-File Architecture**: This command:
- Updates `DASHBOARD.md` phase status
- No changes to PLAN.md or task files

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📊 Progress Overview" section
   - Locate current phase marked 🚧 IN PROGRESS

2. **Verify all tasks complete** in dashboard:
   - Check that all tasks in this phase are marked ✅ COMPLETE
   - If incomplete tasks found:
     ```
     ❌ Cannot complete phase - incomplete tasks found:
     - Task 3: API Integration (🚧 IN PROGRESS)
     - Task 5: Webhook Handler (⏳ PENDING)

     Complete all tasks first or mark them as ❌ CANCELLED / 🔮 DEFERRED.
     ```

3. **Update phase status in dashboard**:
   - Change phase marker from 🚧 IN PROGRESS to ✅ COMPLETE
   - Example:
     ```markdown
     ### Phase 2: Core Implementation 🚧 IN PROGRESS
     ```
     Becomes:
     ```markdown
     ### Phase 2: Core Implementation ✅ COMPLETE
     ```

4. **Update "📍 Current Work" section**:
   - **If next phase exists**: Advance to next phase (⏳ PENDING)
     ```markdown
     ## 📍 Current Work
     - **Phase**: [Phase 3 - Testing & Hardening](phase-3/) ⏳ PENDING
     - **Task**: None yet - use `/flow-phase-start` to begin this phase
     ```
   - **If no next phase**: Mark project complete
     ```markdown
     ## 📍 Current Work
     - **Status**: 🎉 All phases complete!
     - **Next**: Consider archiving or planning V2
     ```

5. **Update completion percentages**:
   - Recalculate phase percentages
   - Update "📈 Completion Status" section
   - Update overall project percentage

6. **Update "Last Updated" timestamp** at top of dashboard

7. **Confirm to user**:
   ```
   ✅ Completed Phase [N]: [Name]

   **What's Next**:
   - **Next phase exists?** → Use `/flow-phase-start` to begin Phase [N+1]: [Name]
   - **All phases complete?** → Project finished! 🎉 Use `/flow-summarize` to review
   ```
