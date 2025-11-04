---
description: Migrate existing PRD/PLAN/TODO to Flow's .flow/PLAN.md format
---

You are executing the `/flow-migrate` command from the Flow framework.

**Purpose**: Migrate existing project documentation (PLAN.md, TODO.md, etc.) to Flow's multi-file format (DASHBOARD.md, PLAN.md, phase-N/task-M.md files).

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Multi-File Architecture, File Templates, Task Structure Rules, Status Markers
- **Deep dive if needed**: Read lines 2101-2600 for File Templates using Read(offset=2101, limit=500)

**Multi-File Architecture**: This command creates:
- `DASHBOARD.md` - Progress tracking (single source of truth)
- `PLAN.md` - Static context (overview, architecture, scope)
- `phase-N/` directories
- `phase-N/task-M.md` files for each task (all with iterations)
- `BACKLOG.md` - Deferred tasks (if applicable)

**Framework Reference**: This command requires framework knowledge to convert existing docs to Flow's multi-file structure. See Quick Reference guide above for essential patterns.

**IMPORTANT**: This command ALWAYS creates fresh Flow files, overwriting any existing multi-file structure. It reads your current documentation and converts it to multi-file Flow format.

**Instructions**:

1. **Read the framework guide AND examples** ⚠️ CRITICAL:

   - **Read .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353** (Quick Reference)
   - **Read .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 2101-2600** (File Templates)
   - **Read framework/examples/** directory to see multi-file structure:
     - `framework/examples/DASHBOARD.md` - Dashboard format
     - `framework/examples/PLAN.md` - Static plan format
     - `framework/examples/phase-1/task-1.md` - Standalone task example
     - `framework/examples/phase-2/task-3.md` - Task with iterations example
   - **Understand**:
     - Multi-file hierarchy: DASHBOARD.md + PLAN.md + phase-N/task-M.md
     - Flow's hierarchy: PHASE → TASK → ITERATION → BRAINSTORM → IMPLEMENTATION
     - All status markers (✅ ⏳ 🚧 🎨 ❌ 🔮 🎯)

2. **Discover existing documentation**:

   - Check if user provided path in `$ARGUMENTS`
   - Otherwise, search project root for common files (in order):
     - `PRD.md` (common in TaskMaster AI, Spec-Kit)
     - `PLAN.md`
     - `TODO.md`
     - `DEVELOPMENT.md`
     - `ROADMAP.md`
     - `TASKS.md`
   - If multiple found, list them and ask: "Found [X] files. Which should I migrate? (number or path)"
   - If none found, ask: "No plan files found. Provide path to file you want to migrate, or use `/flow-blueprint` to start fresh."

3. **Read and analyze source file**:

   - Read entire source file
   - Detect structure type:
     - **STRUCTURED** (Path A): Has phases/tasks/iterations or similar hierarchy
     - **FLAT_LIST** (Path B): Simple todo list or numbered items
     - **UNSTRUCTURED** (Path C): Free-form notes, ideas, design docs
   - Extract key information:
     - Project context/purpose
     - Existing work completed
     - Current status/position
     - Remaining work
     - Architecture/design notes
     - V1/V2 splits (if mentioned)
     - Deferred items
     - Cancelled items

4. **Create backup**:

   - Copy source file: `[original].pre-flow-backup-$(date +%Y-%m-%d-%H%M%S)`
   - Confirm: "✅ Backed up [original] to [backup]"

5. **Generate multi-file Flow structure** based on detected structure (ALWAYS overwrites if exists):

   **Multi-File Generation Process**:
   - Create `DASHBOARD.md` with progress tracking (single source of truth)
   - Create `PLAN.md` with overview, architecture, scope (minimal assumptions)
   - Create `phase-N/` directories for each phase
   - Create `phase-N/task-M.md` files for each task (all with iterations)
   - Create `BACKLOG.md` if deferred items exist

   **Path A - STRUCTURED** (already has phases/tasks):

   - Keep existing hierarchy
   - **CRITICAL**: Use framework/examples/ directory as reference for all files
   - **Create DASHBOARD.md** (use framework/examples/DASHBOARD.md as template):
     - "📍 Current Work" section with current phase/task/iteration
     - "📊 Progress Overview" with all phases and tasks
     - "📈 Completion Status" with percentages
   - **Create PLAN.md** (use framework/examples/PLAN.md as template):
     - Overview section with Purpose, Goals (text only, no checklists), Scope (V1 only unless user specifies V2)
     - Architecture section with system context (high-level, not prescriptive)
     - DO/DON'T Guidelines section
     - Notes & Learnings section
   - **Create phase-N/ directories** for each phase
   - **Create task files** (use framework/examples/phase-2/task-3.md as template):
     - Task overview
     - Iterations with brainstorming sessions
     - Pre-implementation tasks (if applicable)
     - Implementation sections
     ```markdown
     > **📖 Framework Guide**: See .flow/framework/DEVELOPMENT_FRAMEWORK.md for complete methodology and patterns used in this plan
     >
     > **🎯 Purpose**: [Brief description of what this plan covers - extract from existing docs]

     **Created**: [Original date if available]
     **Version**: V1
     **Plan Location**: `.flow/PLAN.md` (managed by Flow)
     ```
   - **Add/enhance Progress Dashboard section** (after Overview, before Architecture):
     - Follow EXAMPLE_PLAN.md lines 29-62 format exactly
     - Include: Last Updated, Current Work (with jump links), Completion Status, Progress Overview
     - **Ensure iteration lists are expanded** (read .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 2555-2567 for format)
     - **Remove duplicate progress sections** (search for patterns like "Current Phase:", "Implementation Tasks", old progress trackers)
     - **Update status pointers** (change "Search for 'Current Phase' below" to jump link to Progress Dashboard)
   - **Add Testing Strategy section** if missing (see EXAMPLE_PLAN.md lines 87-129):
     - Ask user about testing methodology if not clear from existing docs
     - Include all required fields: Methodology, Location, Naming, When to create, When to add
   - **Add Changelog section** if missing (see EXAMPLE_PLAN.md lines 544-549):
     - Populate with existing completion dates if available
     - Format: `**YYYY-MM-DD**: - ✅ [Iteration X]: [description]`
   - **Identify redundant framework docs** (ask user if sections like "Brainstorming Framework" should be removed since Flow provides this)
   - Standardize status markers (✅ ⏳ 🚧 🎨 ❌ 🔮)
   - Add jump links to Progress Dashboard
   - Preserve all content, decisions, and context
   - Reformat sections to match Flow template
   - Report: "Enhanced existing structure (preserved [X] phases, [Y] tasks, [Z] iterations, added Progress Dashboard, Testing Strategy, Changelog, removed [N] duplicate sections)"

   **Path B - FLAT_LIST** (todos/bullets):

   - Ask: "Group items into phases? (Y/n)"
   - If yes, intelligently group related items
   - If no, create single phase with items as iterations
   - **CRITICAL**: Use EXAMPLE_PLAN.md as reference for all sections
   - **Add framework reference header** (copy format from EXAMPLE_PLAN.md lines 1-11)
   - **Add Progress Dashboard** (follow EXAMPLE_PLAN.md lines 29-62)
   - **Add Testing Strategy section** (ask user about methodology, see EXAMPLE_PLAN.md lines 87-129)
   - **Add Changelog section** (see EXAMPLE_PLAN.md lines 544-549)
   - Convert items to Flow iteration format
   - Add placeholder brainstorming sessions
   - Mark completed items as ✅, pending as ⏳
   - Report: "Converted flat list to Flow structure ([X] phases, [Y] tasks, [Z] iterations, added Progress Dashboard, Testing Strategy, Changelog)"

   **Path C - UNSTRUCTURED** (notes):

   - Extract key concepts and features mentioned
   - **CRITICAL**: Use EXAMPLE_PLAN.md as reference for all sections
   - **Create Framework reference header** (copy format from EXAMPLE_PLAN.md lines 1-11)
   - Create Overview section from notes
   - Create Architecture section if design mentioned
   - **Create Progress Dashboard** (minimal - project just starting, see EXAMPLE_PLAN.md lines 29-62)
   - **Create Testing Strategy section** (ask user about methodology, see EXAMPLE_PLAN.md lines 87-129)
   - **Create Changelog section** with initial entry (see EXAMPLE_PLAN.md lines 544-549)
   - Create initial brainstorming session with subjects from notes
   - Mark everything as ⏳ PENDING
   - Report: "Created Flow plan from notes (extracted [X] key concepts as brainstorming subjects, added all required sections)"

6. **Add standard Flow sections** (all paths):

   - **Framework reference header** (follow EXAMPLE_PLAN.md lines 1-11)
   - Progress Dashboard (follow EXAMPLE_PLAN.md lines 29-62)
   - Testing Strategy (follow EXAMPLE_PLAN.md lines 87-129)
   - Changelog (follow EXAMPLE_PLAN.md lines 544-549)
   - Development Plan with proper hierarchy
   - Status markers at every level

7. **Smart content preservation**:

   - NEVER discard user's original content
   - Preserve all decisions, rationale, context
   - Preserve code examples, file paths, references
   - Preserve completion status and dates
   - Enhance with Flow formatting, don't replace

8. **Verify completeness before saving** ⚠️ CRITICAL SELF-CHECK:
   - [ ] Framework reference header present (with 🎯 Purpose line)?
   - [ ] Overview section present?
   - [ ] Progress Dashboard present (NOT optional - REQUIRED)?
   - [ ] Testing Strategy section present (ask user if missing)?
   - [ ] Changelog section present?
   - [ ] Development Plan with phases/tasks/iterations?
   - [ ] All iteration lists expanded (NOT "(X iterations total)")?
   - [ ] All original content preserved?
   - **If any checkbox is unchecked, review EXAMPLE_PLAN.md again and add missing section**

9. **Confirm to user**:
```

✨ Migration complete!

📂 Source: [original file path]
💾 Backup: [backup file path]
🎯 Output: Multi-file Flow structure created

**Files Created**:
- DASHBOARD.md - Progress tracking dashboard
- PLAN.md - Static overview and architecture
- phase-1/ → phase-N/ - Phase directories
- phase-N/task-M.md - Individual task files
- CHANGELOG.md - Historical record
- BACKLOG.md - Deferred tasks (if applicable)

Migration type: [STRUCTURED/FLAT_LIST/UNSTRUCTURED]
Changes: + Created [X] phase directories + Created [Y] task files + Migrated [Z] iterations + Preserved all decisions and context

Next steps:
1. Review: /flow-status
2. Verify structure: ls .flow/
3. Start using Flow: /flow-brainstorm-start [topic]

📂 Flow is now managing this project from .flow/ multi-file structure

```

10. **Handle edge cases**:
 - If source file is empty: Suggest `/flow-blueprint` instead
 - If source file is already Flow-compliant: Mention it's already compatible, migrate anyway
 - If can't determine structure: Default to Path C (unstructured)
 - If migration fails: Keep backup safe, report error, suggest manual approach
