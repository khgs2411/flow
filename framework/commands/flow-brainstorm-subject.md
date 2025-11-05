---
description: Add a subject to discuss in brainstorming
---

You are executing the `/flow-brainstorm-subject` command from the Flow framework.

**Purpose**: Add a new subject to the current brainstorming session.

**🔴 REQUIRED: Read Framework Quick Reference First**
- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Subject Creation Patterns (lines in Quick Reference)
- **Deep dive if needed**: Read lines 1167-1797 for Brainstorming Pattern using Read(offset=1167, limit=631)

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current iteration
- Updates "Subjects to Discuss" list in `phase-N/task-M.md`

**🚨 SCOPE BOUNDARY RULE** (CRITICAL):

Adding subjects dynamically is a KEY feature of Flow. When you discover NEW issues while discussing current subjects:

1. **STOP** immediately - Don't make assumptions or proceed
2. **NOTIFY** user - Present discovered issue(s) with structured analysis
3. **DISCUSS** - Provide structured options (A/B/C/D format):
   - **A**: Create pre-implementation task (< 30 min work, blocking current subject resolution)
   - **B**: Add as new brainstorming subject (this command - design needed)
   - **C**: Handle immediately as part of current subject (only if user approves)
   - **D**: Defer to separate iteration (after current work)
4. **AWAIT USER APPROVAL** - Never proceed without explicit user decision

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current iteration: Phase N, Task M, Iteration K

2. **Parse arguments**: `subject_text` = subject name and optional brief description

3. **Read current task file** (`phase-N/task-M.md`):
   - Find current iteration's brainstorming session
   - Locate "Subjects to Discuss" section

4. **Add subject to list** in task file:
   - Count existing subjects
   - Append new subject:
     ```markdown
     5. ⏳ **[Subject Text]** - [Brief description if provided]
     ```

5. **Update task file**: Save changes to `phase-N/task-M.md`

6. **Confirm to user**:
   ```
   ✅ Added Subject [N]: [Subject Text] to brainstorming session

   Use `/flow-next-subject` to discuss subjects in order.
   ```
