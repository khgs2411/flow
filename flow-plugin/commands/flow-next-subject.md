---
description: Discuss next subject, capture decision, and mark resolved
---

You are executing the `/flow-next-subject` command from the Flow framework.

**Purpose**: Show next unresolved subject, present options collaboratively, include your recommendation with rationale, wait for user decision, then mark as ✅ resolved.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Subject Resolution Types (lines in Quick Reference) - Types A/B/C/D decision matrix
- **Deep dive if needed**: Read lines 1167-1797 for Brainstorming Pattern using Read(offset=1167, limit=631)

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current iteration
- Reads/updates brainstorming session in `phase-N/task-M.md`
- Marks subjects ✅ resolved in task file

**Framework Reference**: This command requires framework knowledge to properly categorize resolution types. See Quick Reference guide above for essential patterns.

**🚨 SCOPE BOUNDARY RULE** (CRITICAL - see .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 339-540):

If you discover NEW issues while discussing subjects that are NOT part of the current iteration:

1. **STOP** immediately - Don't make assumptions or proceed
2. **NOTIFY** user - Present discovered issue(s) with structured analysis
3. **DISCUSS** - Provide structured options (A/B/C/D format):
   - **A**: Create pre-implementation task (< 30 min work, blocking)
   - **B**: Add as new brainstorming subject (design needed)
   - **C**: Handle immediately (only if user approves)
   - **D**: Defer to separate iteration (after current work)
4. **AWAIT USER APPROVAL** - Never proceed without explicit user decision

**Use the Scope Boundary Alert Template** (see .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 356-390)

**Why This Matters**: User stays in control of priorities. AI finds issues proactively but doesn't make scope decisions.

**New Collaborative Workflow** (two-phase approach):
```

Phase 1 (Present):
/flow-next-subject → present subject + options → ask user → 🛑 STOP & WAIT

Phase 2 (Capture - triggered by user response):
User responds → capture decision → document → mark ✅ → auto-advance to next

```

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current iteration: Phase N, Task M, Iteration K

2. **Read current task file** (`phase-N/task-M.md`):
   - Find iteration K's brainstorming session
   - Locate "Subjects to Discuss" section

3. **Find first unresolved subject**: Look for first ⏳ subject in the list

4. **If found** (subject needs discussion):

   **Step A: Present subject**
   - Display subject name and description
   - Present relevant context from iteration goal
   - **DO NOT read codebase files**
   - **DO NOT analyze existing implementation**
   - **DO NOT create detailed solutions**
   - Keep it brief - this is just presenting the topic

   **Step B: Present options and STOP** ⚠️ CRITICAL
   - **DO NOT research code** before presenting options
   - **DO NOT read files** to understand current implementation
   - **DO NOT create detailed architecture diagrams**
   - Suggest 2-4 high-level options/approaches based on GENERAL knowledge
   - Present each option with brief pros/cons (1-2 sentences each)
   - Format as numbered list for clarity
   - Include option for "Your own approach"
   - Include your recommendation with rationale
   - Ask user explicitly: "Which option do you prefer? Or provide your own approach."
   - **🛑 STOP HERE - Wait for user response (do NOT proceed to capture decision)**
   - **DO NOT** decide on behalf of user
   - **DO NOT** document any decision yet
   - **DO NOT** create massive detailed resolutions
   - Command execution ends here - user will respond in next message

   **Step C: Capture user's decision** (only execute AFTER user responds)
   - Read user's response from their message
   - If decision is clear: proceed to document it
   - If unclear: ask clarifying questions
   - If rationale not provided: ask "What's your reasoning for this choice?"
   - Optional: "Any action items to track for this decision?"
   - **KEEP DOCUMENTATION CONCISE** (1-3 paragraphs, not 336 lines!)
   - **NO massive architecture diagrams** unless user explicitly provides one
   - **NO detailed implementation plans** - save for implementation phase
   - Capture: Decision + Rationale + Action Items (if any)

   **Step D: Document resolution in task file**
   - Mark subject ✅ in "Subjects to Discuss" list (in `phase-N/task-M.md`)
   - Add **CONCISE** resolution section under "Resolved Subjects":
     ```markdown
     ### ✅ **Subject [N]: [Name]**

     **Decision**: [User's decision from their response - 1-2 sentences]

     **Rationale**:
     - [Reason 1 from user or follow-up]
     - [Reason 2]

     **Action Items** (if any):
     - [ ] [Item 1 - brief, not detailed implementation steps]
     - [ ] [Item 2]

     ---
     ```
   - **Example of TOO MUCH**: 336 line resolution with interfaces, diagrams, detailed architecture
   - **Example of GOOD**: 10-20 line resolution with decision, rationale, 3-5 action items

   **Step E: Auto-advance OR prompt for review**
   - Save changes to `phase-N/task-M.md`
   - Show progress: "[N] of [Total] subjects resolved"
   - Check if more ⏳ subjects exist:
     - **If YES** (more pending): Auto-show next unresolved subject
     - **If NO** (all resolved): Show workflow prompt below

5. **If all resolved** (this was the last subject):
   - **Show brief summary** of decisions made
   - **⚠️ CRITICAL - Show "What's Next" Section (MANDATORY - AI MUST NOT SKIP THIS)**:
     ```markdown
     ✅ All subjects resolved!

     ## 🎯 What's Next

     **REQUIRED NEXT STEP**: Run `/flow-brainstorm-review` to:
     - Analyze all resolved subjects
     - Categorize action items (pre-tasks vs implementation vs new iterations)
     - Generate follow-up work suggestions
     - Prepare for implementation

     **DO NOT run `/flow-brainstorm-complete` yet** - review comes first!

     **Workflow Reminder**:
     1. ✅ NOW: `/flow-brainstorm-review` (analyze & suggest)
     2. THEN: Create any pre-tasks if needed
     3. THEN: Complete pre-tasks (if any)
     4. FINALLY: `/flow-brainstorm-complete` (mark 🎨 READY)

     **Why this order matters**: Review identifies blockers (pre-tasks) that must be done before implementation starts.
     ```
   - **AI BEHAVIOR**: Do NOT suggest `/flow-brainstorm-complete` or any other command. The "What's Next" section MUST explicitly guide to `/flow-brainstorm-review` first.

**Key Principle**: Moving to next subject implies current is resolved. No separate "resolve" command needed.
