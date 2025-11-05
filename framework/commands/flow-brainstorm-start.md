---
description: Start brainstorming session with user-provided topics
---

You are executing the `/flow-brainstorm-start` command from the Flow framework.

**Purpose**: Begin a brainstorming session for the current iteration with subjects provided by the user.

**🔴 REQUIRED: Read Framework Quick Reference First**
- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Subject Resolution Types, Common Patterns
- **Deep dive if needed**: Read lines 1167-1797 for complete Brainstorming Pattern using Read(offset=1167, limit=631)

**Framework Reference**: This command requires framework knowledge to structure brainstorming session correctly. See Quick Reference guide above for essential patterns.

**Signature**: `/flow-brainstorm-start [optional: free-form text describing topics to discuss]`

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current iteration
- Updates brainstorming section in `phase-N/task-M.md`
- Updates `DASHBOARD.md` with "🚧 BRAINSTORMING" status

**🚨 SCOPE BOUNDARY RULE** (CRITICAL - see .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 339-540):

If you discover NEW issues during brainstorming that are NOT part of the current iteration:

1. **STOP** immediately - Don't make assumptions or proceed
2. **NOTIFY** user - Present discovered issue(s) with structured analysis
3. **DISCUSS** - Provide structured options (A/B/C/D format):
   - **A**: Create pre-implementation task (< 30 min work, blocking)
   - **B**: Add as new brainstorming subject (design needed)
   - **C**: Handle immediately (only if user approves)
   - **D**: Defer to separate iteration (after current work)
4. **AWAIT USER APPROVAL** - Never proceed without explicit user decision

**Use the Scope Boundary Alert Template** (see .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 356-390)

**Why This Matters**: User stays in control of priorities, AI finds issues proactively but doesn't make scope decisions

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current iteration: Phase N, Task M, Iteration K
   - Navigate to task file link

2. **Read current task file** (`phase-N/task-M.md`):
   - Find iteration K in "## Iterations" section
   - Check status (should be ⏳ PENDING or 🚧 IN PROGRESS)

3. **Determine mode** (two modes available):

   **MODE 1: With Argument** (user provides topics in command)
   - User provided topics in `topics` parameter (free-form text)
   - Parse the user's input and extract individual subjects
   - User controls WHAT to brainstorm, AI structures HOW
   - Example: `/flow-brainstorm-start "API design, database schema, auth flow, error handling"`
   - AI extracts: [API design, database schema, auth flow, error handling]
   - **Proceed to step 4**

   **MODE 2: Without Argument** (interactive) ⚠️ CRITICAL
   - **NO arguments provided** by user
   - **DO NOT** auto-generate subjects from iteration description
   - **DO NOT** read task file and invent subjects automatically
   - **DO NOT** proceed to create brainstorming section yet
   - **STOP and ask the user**:

     Example prompt to user:
     ```
     I'll start a brainstorming session for Iteration [K]: [Name].

     **What subjects would you like to discuss?**

     You can provide:
     - Comma-separated topics: "API design, database, auth"
     - Free-form text describing areas to explore
     - Bullet list of specific topics

     Based on the iteration scope, here are some suggestions:
     - [Suggestion 1 based on iteration goal]
     - [Suggestion 2 based on iteration goal]
     - [Suggestion 3 based on iteration goal]

     Please provide the topics you'd like to brainstorm.
     ```

   - **WAIT for user response** - do NOT proceed without it
   - **After user responds**, extract subjects from their response
   - **Then proceed to step 4**

4. **Extract subjects from user input** (ONLY after user provides topics):
   - Parse natural language text from user's input
   - Identify distinct topics/subjects (comma-separated, "and", bullet points, etc.)
   - Create numbered list
   - Handle 1 to 100+ topics gracefully
   - If ambiguous, ask user for clarification

5. **Update task file** (`phase-N/task-M.md`):

   a. **Update iteration status** to 🚧 IN PROGRESS (if ⏳ PENDING):
      ```markdown
      ### ⏳ Iteration 2: Error Handling
      ```
      Becomes:
      ```markdown
      ### 🚧 Iteration 2: Error Handling
      ```

   b. **Create brainstorming section** in iteration:
      ```markdown
      #### Brainstorming Session - Error Handling Strategy

      **Focus**: Design comprehensive error handling for Stripe API integration

      **Subjects to Discuss** (tackle one at a time):

      1. ⏳ **API Error Types** - What errors can Stripe return?
      2. ⏳ **Error Mapping** - How to map Stripe errors to our domain?
      3. ⏳ **Retry Strategy** - When to retry, exponential backoff?
      4. ⏳ **User Experience** - How to communicate errors to users?

      **Resolved Subjects**:

      ---
      ```

6. **Update DASHBOARD.md**:

   a. **Update "📍 Current Work" section**:
      ```markdown
      ## 📍 Current Work
      - **Phase**: [Phase 2 - Core Implementation](phase-2/)
      - **Task**: [Task 3 - API Integration](phase-2/task-3.md)
      - **Iteration**: [Iteration 2 - Error Handling](phase-2/task-3.md#iteration-2-error-handling) 🚧 BRAINSTORMING
      - **Focus**: Designing comprehensive error handling strategy
      ```

   b. **Update iteration status in "📊 Progress Overview"**:
      - Change iteration marker to show 🚧 with "BRAINSTORMING" indicator

   c. **Update "Last Updated" timestamp** at top

7. **Confirm to user** (only after creating brainstorming section):
   ```
   ✅ Started brainstorming session with [N] subjects for Iteration [K]: [Name]

   **Subjects**:
   1. [Subject 1]
   2. [Subject 2]
   3. [Subject 3]
   ...

   Use `/flow-next-subject` to start discussing the first subject.
   ```

**Key Principles**:
- ✅ **User always provides topics** (via argument or when prompted)
- ❌ **AI NEVER invents subjects** from iteration description without user input
- ❌ **AI NEVER auto-generates** a subject list when no argument provided
- ✅ **If no argument**: STOP, suggest topics, WAIT for user response
- ✅ **After user provides topics**: THEN create brainstorming section
