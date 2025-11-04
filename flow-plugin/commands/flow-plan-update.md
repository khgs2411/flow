---
description: Update existing plan to match latest Flow framework structure
---

You are executing the `/flow-plan-update` command from the Flow framework.

**Purpose**: Update an existing multi-file Flow structure to match the latest framework patterns.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Multi-File Architecture, File Templates
- **Deep dive if needed**: Read lines 2101-2600 for File Templates using Read(offset=2101, limit=500)

**Multi-File Architecture**: This command updates:
- `DASHBOARD.md` - Ensures correct format and sections
- `PLAN.md` - Ensures correct format and sections
- `phase-N/task-M.md` files - Ensures correct format
- Adds missing files (CHANGELOG.md, BACKLOG.md if needed)

**IMPORTANT**: This command updates your current multi-file structure to match framework changes (e.g., new dashboard sections, status markers, structural improvements).

**Instructions**:

1. **Read the framework guide**:
   - Read .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference)
   - Read .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 2101-2600 (File Templates)
   - Read framework/examples/ directory for current format

2. **Read current structure**:
   - Read `DASHBOARD.md`
   - Read `PLAN.md`
   - List phase directories: `ls .flow/phase-*/`
   - Sample task files: Read a few `phase-N/task-M.md` files

3. **Create backups**:
   - Create `.flow/backup-$(date +%Y-%m-%d-%H%M%S)/` directory
   - Copy all current files to backup directory
   - Confirm: "✅ Backed up current structure to [backup]"

4. **Update files to match current templates**:

   **DASHBOARD.md**:
   - Ensure "📍 Current Work" section exists and is current
   - Ensure "📊 Progress Overview" section exists with all phases
   - Ensure "📈 Completion Status" section exists with percentages
   - Update "Last Updated" timestamp

   **PLAN.md**:
   - Ensure Overview section exists (Purpose, Scope with V1/V2 split)
   - Ensure Architecture section exists
   - Ensure Testing Strategy section exists
   - Ensure Development Phases section exists (high-level only)
   - NO detailed tasks in PLAN.md (those go in task files)

   **Task Files** (`phase-N/task-M.md`):
   - Ensure each has Task Overview section
   - Ensure each has Iterations section
   - Ensure brainstorming sessions are properly formatted
   - Ensure status markers are correct (✅ ⏳ 🚧 🎨 ❌ 🔮)

   **Missing Files**:
   - Create CHANGELOG.md if missing
   - Create BACKLOG.md if deferred tasks exist

5. **Report changes**:

   Compare user's PLAN.md against these patterns and identify what needs updating:

   **✅ CORRECT PATTERNS (v1.2.1+)**:

   **A. Section Order**:
   1. Title + Framework Reference header
   2. Overview (Purpose, Goals, Scope)
   3. Progress Dashboard (after Overview, before Architecture)
   4. Architecture
   5. Testing Strategy
   6. Development Plan (Phases → Tasks → Iterations)
   7. Changelog

   **B. Implementation Section Pattern** (NO ACTION ITEM DUPLICATION):
   ```markdown
   ### **Implementation - Iteration [N]: [Name]**

   **Status**: 🚧 IN PROGRESS

   **Action Items**: See resolved subjects above (Type 2/D items)

   **Implementation Notes**:
   [Document progress, discoveries, challenges]

   **Files Modified**:
   - `path/to/file.ts` - Description

   **Verification**: [How verified]
   ```

   **C. Progress Dashboard Jump Links**:
   ```markdown
   **Current Work**:
   - **Phase**: [Phase 2 - Core Implementation](#phase-2-core-implementation-)
   - **Task**: [Task 5 - Error Handling](#task-5-error-handling-)
   - **Iteration**: [Iteration 6 - Circuit Breaker](#iteration-6-circuit-breaker-) 🚧 IN PROGRESS
   ```

   **D. Iteration Lists** (EXPANDED, not collapsed):
   ```markdown
   - 🚧 **Task 23**: Refactor Architecture (3/3 iterations)
     - ✅ **Iteration 1**: Separate Concerns - COMPLETE
     - ⏳ **Iteration 2**: Extract Logic - PENDING
     - ⏳ **Iteration 3**: Optimize - PENDING
   ```

   **E. Status Markers**: ✅ ⏳ 🚧 🎨 ❌ 🔮 (standardized)

   ---

   **❌ DEPRECATED PATTERNS (pre-v1.2.1)**:

   **A. Duplicated Action Items** (REMOVE):
   ```markdown
   ### ✅ Subject 1: Feature X
   **Action Items**:
   - [ ] Item 1
   - [ ] Item 2

   ### **Implementation - Iteration 1**
   **Action Items** (from brainstorming):  ← DUPLICATE! REMOVE THIS
   - [ ] Item 1
   - [ ] Item 2
   ```
   **FIX**: Replace Implementation action items with "See resolved subjects above"

   **B. Collapsed Iteration Lists** (EXPAND):
   ```markdown
   - 🚧 Task 23: Architecture (3 iterations total)  ← WRONG!
   ```
   **FIX**: Expand to show all iterations as sub-bullets

   **C. Duplicate Progress Sections** (REMOVE):
   - Old "Current Phase" headers scattered throughout
   - Multiple "Implementation Tasks" trackers
   - Redundant status summaries
   **FIX**: Single Progress Dashboard after Overview

   **D. Text-based Status Pointers** (REPLACE):
   ```markdown
   Current work: Search for "Current Phase" below  ← WRONG!
   ```
   **FIX**: Use jump links: `[Progress Dashboard](#-progress-dashboard)`

   **E. Missing Testing Strategy Section** (ADD):
   **FIX**: Add Testing Strategy section (see EXAMPLE_PLAN.md lines 87-129)

6. **Present analysis to user**:

   **DO NOT automatically make changes**. Instead, present findings:

   ```markdown
   ## 📋 Plan Structure Analysis

   I've compared your PLAN.md against the latest Flow framework (v1.2.1).

   **✅ Already Correct**:
   - [List patterns that match current framework]

   **❌ Needs Updates**:

   1. **Action Item Duplication** (Found in X iterations)
      - Problem: Implementation sections duplicate action items from subjects
      - Fix: Replace with "See resolved subjects above"
      - Saves: ~600-1000 tokens per iteration

   2. **Progress Dashboard Location** (if applicable)
      - Problem: Dashboard is [location]
      - Fix: Move to after Overview, before Architecture

   3. **[Other issues found]**
      - Problem: [description]
      - Fix: [what needs to change]

   **Recommendation**: Should I update your PLAN.md to fix these issues?
   - I'll create a backup first
   - All content will be preserved
   - Only structure/formatting changes
   ```

7. **If user approves, update plan structure** (preserve ALL content):

   **Create backup first**:
   - Copy: `.flow/PLAN.md.version-update-backup-$(date +%Y-%m-%d-%H%M%S)`

   **Apply fixes** based on analysis from step 5:
   - Fix action item duplication (replace with references)
   - Move Progress Dashboard to correct location
   - Remove duplicate progress sections
   - Update status pointers to jump links
   - Add missing sections (Testing Strategy, Changelog)
   - Expand collapsed iteration lists
   - Standardize status markers

   **Preserve ALL**:
   - Decisions and rationale
   - Brainstorming subjects and resolutions
   - Implementation notes
   - Completion dates
   - Bug discoveries
   - Code examples

8. **Verify consistency**:

   - Check Progress Dashboard matches status markers
   - Verify all sections follow framework structure
   - Ensure no content was lost

6. **Confirm to user**:
```

✨ Multi-file structure updated to match latest Flow framework!

💾 Backup: .flow/backup-[timestamp]/
🎯 Updated: All Flow files

**Files Updated**:
- DASHBOARD.md - Updated sections and format
- PLAN.md - Updated sections and format
- phase-N/task-M.md - Updated [X] task files
- Created missing files (if applicable)

Changes made:
+ Updated dashboard sections
+ Ensured all files match current templates
+ Standardized status markers
+ Fixed [N] formatting issues
+ Created [Y] missing files

Next steps:
1. Review changes: diff -r [backup] .flow/
2. Verify: /flow-status
3. Continue work: /flow-next

All your content preserved - only structure enhanced.

```

7. **Handle edge cases**:
- If `.flow/DASHBOARD.md` doesn't exist: Suggest `/flow-blueprint` or `/flow-migrate`
- If structure already matches latest: Report "Already up to date!"
- If can't determine what to update: Ask user for clarification
