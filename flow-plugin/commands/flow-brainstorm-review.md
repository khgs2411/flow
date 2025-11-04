---
description: Review all resolved subjects, suggest follow-up work
---

You are executing the `/flow-brainstorm-review` command from the Flow framework.

**Purpose**: Review all resolved brainstorming subjects, verify completeness, summarize decisions, show action items, and suggest follow-up work (iterations/pre-tasks) before marking the brainstorming session complete.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Subject Resolution Types (A/B/C/D) (lines in Quick Reference)
- **Deep dive if needed**: Read lines 1167-1797 for Brainstorming Session Pattern using Read(offset=1167, limit=631)

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current iteration
- Reads brainstorming session from `phase-N/task-M.md`
- Reviews all resolved subjects and suggests next steps
- **READ-ONLY** - No file changes (user confirms before completing)

**This is the review gate before `/flow-brainstorm-complete`.**

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current iteration: Phase N, Task M, Iteration K

2. **Read current task file** (`phase-N/task-M.md`):
   - Find iteration K's brainstorming session
   - Read all "Subjects to Discuss" and "Resolved Subjects"

3. **Verify all subjects resolved**:

   - Check "Subjects to Discuss" section in task file
   - Count total subjects vs ✅ resolved subjects
   - If ANY subjects remain unmarked (⏳ PENDING), warn user: "Not all subjects resolved. Run `/flow-next-subject` to complete remaining subjects."
   - If all subjects are ✅ resolved, proceed to next step

4. **Summarize resolved subjects**:

   - Read all entries in "Resolved Subjects" section
   - Create concise summary of each resolution:
     - Subject name
     - Decision made
     - Key rationale points
   - Present in numbered list format

5. **Show all action items**:

   - Extract all documented action items from resolved subjects
   - Categorize by type:
     - **Pre-Implementation Tasks**: Work that must be done BEFORE implementing this iteration
     - **Follow-up Iterations**: Future work to tackle after this iteration
     - **Documentation Updates**: Files/docs that need changes
     - **Other Actions**: Miscellaneous tasks
   - Present in organized format

6. **Categorize action items** (CRITICAL - Ask user to clarify):

   **The 3 Types of Action Items**:

   **Type 1: Pre-Implementation Tasks (Blockers)**
   - Work that MUST be done BEFORE starting main implementation
   - Examples: Refactor legacy code, fix blocking bugs, setup infrastructure
   - These become separate "Pre-Implementation Tasks" section
   - Must be ✅ COMPLETE before running `/flow-implement-start`

   **Type 2: Implementation Work (The Iteration Itself)**
   - The actual work of the current iteration
   - Examples: Command updates, feature additions, new logic
   - These stay as action items IN the iteration description
   - Work on these AFTER running `/flow-implement-start`

   **Type 3: New Iterations (Future Work)**
   - Follow-up work for future iterations
   - Examples: V2 features, optimizations, edge cases discovered
   - Create with `/flow-iteration-add`

   **Decision Tree for AI**:
   - Extract all action items from resolved subjects
   - For each action item, ask yourself:
     - "Does this BLOCK the main work?" → Type 1 (Pre-task)
     - "Is this THE main work?" → Type 2 (Implementation)
     - "Is this FUTURE work?" → Type 3 (New iteration)
   - **If uncertain, ASK THE USER**: "I found these action items. Are they:
     - A) Blockers that must be done first (pre-tasks)
     - B) The implementation work itself
     - C) Future work for new iterations"

   Present categorization in this format:

     ```
     **Pre-Implementation Tasks** (Type 1 - complete before /flow-implement-start):
     - [Task description] - Why it blocks: [reason]

     **Implementation Work** (Type 2 - these ARE the iteration):
     - [Action item 1]
     - [Action item 2]
     (These stay in iteration, work on after /flow-implement-start)

     **New Iterations** (Type 3 - add with /flow-iteration-add):
     - Iteration N+1: [Name] - [Why it's future work]
     ```

7. **Consolidate Resolution Items into Action Items section** (CRITICAL - NEW PATTERN):

   After user confirms categorization:

   - **Extract all "Resolution Items" from Type D subjects**:
     - Read all resolved subjects with "Resolution Type: D"
     - Each Type D subject has a "Resolution Items" list
     - Collect all Resolution Items into a single consolidated list

   - **Replace iteration's Action Items section**:
     ```markdown
     #### Action Items

     (Consolidated from Resolution Items above by `/flow-brainstorm-review`)

     - [ ] [Resolution Item 1 from Subject 1]
     - [ ] [Resolution Item 2 from Subject 1]
     - [ ] [Resolution Item 1 from Subject 2]
     - [ ] [Resolution Item 2 from Subject 2]
     - [ ] [Resolution Item 1 from Subject 3]
     ```

   - **Key Points**:
     - ONE Action Items section per iteration (single source of truth)
     - Preserves all Resolution Items from all Type D subjects
     - Add header comment: "(Consolidated from Resolution Items above by `/flow-brainstorm-review`)"
     - All checkboxes start as unchecked `- [ ]`
     - Resolution Items in subjects remain unchanged (for context)

   - **If NO Type D items** (all subjects are Type A/B/C):
     - Create minimal Action Items section referencing pre-tasks or other work

8. **Await user confirmation**:
   - Do NOT automatically create iterations or pre-tasks
   - Show categorization above
   - Ask: "Does this categorization look correct? Should I adjust anything?"
   - If user confirms Type 1 (pre-tasks) exist: Ask if they want them created now
   - If user confirms Type 3 (new iterations): Ask if they want them created now
   - After confirmation: Ask about action items consolidation (step 7)

8b. **Reminder**: If you discover new issues during implementation (scope violations), STOP and discuss with the user before proceeding.

9. **Show "What's Next" Section**:
   ```markdown
   ## 🎯 What's Next

   **After reviewing**:
   1. If pre-implementation tasks were identified → Create them in "Pre-Implementation Tasks" section
   2. If new iterations were suggested → Use `/flow-iteration-add` to create each one
   3. Once all pre-tasks are ✅ COMPLETE → Run `/flow-brainstorm-complete` to mark iteration 🎨 READY

   **Decision Tree**:
   - Pre-tasks needed? → Create them, complete them, THEN run `/flow-brainstorm-complete`
   - No pre-tasks? → Run `/flow-brainstorm-complete` immediately
   - Need more iterations? → Use `/flow-iteration-add [description]` first
   ```
