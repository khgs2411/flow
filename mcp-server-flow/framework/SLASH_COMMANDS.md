# Flow Framework - Slash Commands File

This file contains all slash command definitions for the Flow framework. Copy these to `.claude/commands/` when ready to use.

---

## Command Guidelines

**IMPORTANT**: Every command must:

1. **Read the framework guide** at the start to understand patterns and structure
2. **Find and parse .flow/PLAN.md** to understand current state
3. **Follow framework patterns exactly** (status markers, section structure, etc.)
4. **Update .flow/PLAN.md** according to framework conventions
5. **Provide clear next steps** to the user

**File Locations**:

- **Plan File**: `.flow/PLAN.md` (Flow manages the plan from this directory)
- **Framework Guide**: Search in order:
  1. `.flow/DEVELOPMENT_FRAMEWORK.md`
  2. `.claude/DEVELOPMENT_FRAMEWORK.md`
  3. `./DEVELOPMENT_FRAMEWORK.md` (project root)
  4. `~/.claude/flow/DEVELOPMENT_FRAMEWORK.md` (global)

**Finding PLAN.md** (all commands except `/flow-blueprint` and `/flow-migrate`):

- Primary location: `.flow/PLAN.md`
- If not found, search project root and traverse up
- If still not found: Suggest `/flow-blueprint` (new project) or `/flow-migrate` (existing docs)

**Status Markers** (use consistently):

- ✅ Complete
- ⏳ Pending
- 🚧 In Progress
- 🎨 Ready for Implementation
- ❌ Cancelled
- 🔮 Deferred

**Tool Usage for Pattern Matching**:

When commands instruct you to "Find", "Look for", or "Locate" patterns in PLAN.md:

- **Use Grep tool** for:

  - Simple pattern existence checks (does pattern exist?)
  - Counting occurrences (`grep -c`)
  - Reading specific sections with context (`grep -A`, `-B`, `-C`)
  - Examples: Finding phase markers, checking status, locating sections

- **Use awk** ONLY for:

  - Extracting content between two patterns (range extraction)
  - Example: `awk '/start_pattern/,/end_pattern/ {print}'`

- **Prefer Grep over awk** for simple tasks - it's more efficient and clearer

**Examples**:

```bash
# ✅ GOOD - Use Grep for pattern checking
grep "^### Phase 4:" PLAN.md
grep -c "^#### ⏳ Task" PLAN.md
grep -A 2 "^## 📋 Progress Dashboard" PLAN.md

# ✅ GOOD - Use awk for range extraction
awk '/^##### Iteration 5:/,/^#####[^#]|^####[^#]/ {print}' PLAN.md
awk '/\*\*Subjects to Discuss\*\*:/,/\*\*Resolved Subjects\*\*:/ {print}' PLAN.md

# ❌ BAD - Don't use awk for simple existence checks
awk '/^### Phase 4:/ {print}' PLAN.md  # Use grep instead
```

---

## /flow-blueprint

<!-- MCP_METADATA
function_name: flow_blueprint
category: planning_creation
parameters:
  - name: project_description
    type: str
    required: true
    description: Rich description of the feature/project including requirements, constraints, references, and testing methodology
returns: dict[str, Any]
plan_operations: [WRITE]
framework_reading_required: true
framework_sections:
  - Quick Reference (lines 1-544)
  - Plan File Template (lines 2731-2928)
MCP_METADATA_END -->

**File**: `flow-blueprint.md`

```markdown
---
description: Create new .flow/PLAN.md for a feature/project from scratch
---

You are executing the `/flow-blueprint` command from the Flow framework.

**Purpose**: Create a brand new PLAN.md file from scratch for a new feature/project/bug/issue.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: DEVELOPMENT_FRAMEWORK.md lines 1-544 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Plan File Template pattern (lines 134-207), Task Structure Rules (lines 47-107)
- **Deep dive if needed**: Read lines 2731-2928 for complete Plan File Template using Read(offset=2731, limit=197)

**Framework Reference**: This command requires framework knowledge to generate correct plan structure. See Quick Reference guide above for essential patterns.

**IMPORTANT**: This command ALWAYS creates a fresh `.flow/PLAN.md`, overwriting any existing plan file. Use `/flow-migrate` if you want to convert existing documentation.

**💡 TIP FOR USERS**: Provide rich context in $ARGUMENTS! You are the domain expert - the more details you provide upfront, the better the plan.

**Good example**:
```

/flow-blueprint "Payment Gateway Integration

Requirements:

- Integrate with Stripe API for credit card processing
- Support webhooks for async payment notifications
- Handle failed payments with retry logic (3 attempts, exponential backoff)

Constraints:

- Must work with existing Express.js backend
- Maximum 2-second response time

Reference:

- See src/legacy/billing.ts for old PayPal integration
- Similar webhook pattern in src/webhooks/shipment.ts

Testing:

- Simulation-based per service (scripts/{service}.scripts.ts)
  "

```

**Minimal example** (AI will ask follow-up questions):
```

/flow-blueprint "payment gateway"

```

**Instructions**:

1. **INPUT VALIDATION** (Token-Efficient - Run BEFORE reading framework) ⚠️ UX PRINCIPLE 1:

   **Goal**: Determine whether to CREATE explicit structure or SUGGEST structure, while minimizing token waste on invalid input.

   **Step 1: Quick Scan for Hard Rules** (< 10 tokens check):
   ```
   IF $ARGUMENTS is empty OR just whitespace:
     REJECT: "❌ Missing project description. Provide at least a project name or brief description."
     STOP (don't proceed to framework reading)
   ```

   **Step 2: Detect Blueprint Mode** (< 50 tokens analysis) ⚠️ UX PRINCIPLE 4 (Explicit > Implicit):

   **Mode A: SUGGEST Structure** (User wants AI to design the plan)
   - Trigger: $ARGUMENTS contains NO explicit structure markers
   - Examples: "payment gateway", "user auth system", "build a todo app"
   - Behavior: Read framework, ask questions, generate suggested plan structure

   **Mode B: CREATE Explicit Structure** (User designed the plan already)
   - Trigger: $ARGUMENTS contains structural markers like:
     - "Phase 1:", "Phase 2:"
     - "Task 1:", "Task 2:"
     - "Iteration 1:", "Iteration 2:"
     - Or bullet lists suggesting phases/tasks/iterations
   - Examples:
     ```
     "Payment Gateway
     Phase 1: Foundation
     - Task 1: Setup Stripe SDK
     - Task 2: Create payment models

     Phase 2: Implementation
     - Task 1: Payment processing
       - Iteration 1: Basic flow
       - Iteration 2: Error handling"
     ```
   - Behavior: Honor user's explicit structure, create it as-is (with [TBD] for missing metadata)

   **Step 3: Semantic Check** (Only if Mode A and input seems vague):
   - Check if description is too vague to generate meaningful plan
   - Examples that ARE OK: "payment gateway", "user authentication", "real-time chat"
   - Examples that ARE TOO VAGUE: "help", "project", "thing"
   - If too vague:
     ```
     "🤔 Need more context. What are you building? Examples:
     - 'Payment gateway integration with Stripe'
     - 'Real-time collaborative text editor'
     - 'User authentication system with JWT'

     Or provide explicit structure:
     Phase 1: [your phase]
     - Task 1: [your task]"
     ```
   - If OK, proceed to step 4 (framework reading)

   **Step 4: Dry-Run Preview** (Only if Mode B - explicit structure detected):
   - Parse user's structure and show what will be created
   - Example output (200-500 tokens vs 5000+ token full generation):
     ```
     "📋 Detected explicit structure. I will create:

     **Phase 1: Foundation** ⏳
     - Task 1: Setup Stripe SDK ⏳
     - Task 2: Create payment models ⏳

     **Phase 2: Implementation** ⏳
     - Task 1: Payment processing ⏳
       - Iteration 1: Basic flow ⏳
       - Iteration 2: Error handling ⏳

     Missing metadata will use [TBD] placeholders (you can refine later).

     Proceed? (yes/no)"
     ```
   - If user says "no", ask what to change
   - If user says "yes", proceed to framework reading and creation

   **Token Savings**: Validation + preview = 200-500 tokens vs full generation rejection = 5000+ tokens wasted

2. **Read the framework guide AND example plan** ⚠️ CRITICAL (Only after validation passes):
   - **Search for DEVELOPMENT_FRAMEWORK.md** in these locations (in order):
     - `.flow/DEVELOPMENT_FRAMEWORK.md`
     - `.claude/DEVELOPMENT_FRAMEWORK.md`
     - `./DEVELOPMENT_FRAMEWORK.md` (project root)
     - `~/.claude/flow/DEVELOPMENT_FRAMEWORK.md` (global)
   - **Search for EXAMPLE_PLAN.md** in same locations
   - **Read BOTH files completely** to understand:
     - Hierarchy: PHASE → TASK → ITERATION → BRAINSTORM → IMPLEMENTATION
     - Plan file template structure (DEVELOPMENT_FRAMEWORK.md lines 2731-2928)
     - Real-world example structure (EXAMPLE_PLAN.md - all 509 lines)
     - Required sections: Framework Guide header, Overview, Progress Dashboard, Architecture, Testing Strategy, Development Plan, Changelog
     - Progress Dashboard format with iteration lists
     - Brainstorming session structure with Resolution Type labels (Type A/B/C/D)
     - Status markers and their lifecycle

3. **Analyze the feature request**: `$ARGUMENTS` (Mode-specific behavior) ⚠️ UX PRINCIPLE 4:

   **If Mode A (SUGGEST)**: AI designs the structure
   - Extract all provided information: requirements, constraints, reference paths, testing preferences
   - If user provided rich context (requirements, constraints, references), use it directly
   - If minimal context provided (just a name), prepare to ask follow-up questions in steps 4-5

   **If Mode B (CREATE)**: Honor user's explicit structure
   - Parse the provided structure (phases, tasks, iterations)
   - Extract any metadata provided (goals, purposes, requirements)
   - Use [TBD] for missing metadata (⚠️ UX PRINCIPLE 2: Never block for cosmetic reasons)
   - Skip questions in steps 4-5 UNLESS user explicitly asked for them
   - Example: If user provided structure but no testing strategy, use "[TBD] - Testing strategy to be defined"

4. **Check for reference implementation** (Mode A only, skip if Mode B):
   - If user mentioned reference paths in arguments (e.g., "See src/legacy/billing.ts"), read and analyze them
   - If no reference mentioned, ask: "Do you have a reference implementation I should analyze? (Provide path or say 'no')"
   - If reference provided, read and analyze it to inform the planning

5. **Gather testing methodology** (Mode A only, skip if Mode B - CRITICAL if asking):
   - If user provided testing details in arguments (e.g., "Testing: Simulation-based per service"), use them directly and skip to step 6
   - Otherwise, ask: "How do you prefer to verify implementations? Choose or describe:
     - **Simulation-based (per-service)**: Each service has its own test file (e.g., `{service}.scripts.ts`)
     - **Simulation-based (single file)**: All tests in one orchestration file (e.g., `run.scripts.ts`)
     - **Unit tests**: Test individual functions/classes after implementation (Jest/Vitest/etc.)
     - **TDD**: Write tests before implementation, then make them pass
     - **Integration/E2E**: Focus on end-to-end workflows, minimal unit tests
     - **Manual QA**: No automated tests, manual verification only
     - **Custom**: Describe your approach"
   - **CRITICAL follow-up questions**:
     - "What's your test file naming convention?" (e.g., `{service}.scripts.ts`, `{feature}.test.ts`, `{feature}.spec.ts`)
     - "Where do test files live?" (e.g., `scripts/`, `__tests__/`, `tests/`, `e2e/`)
     - "When should I create NEW test files vs. add to existing?" (e.g., "Create `{service}.scripts.ts` for new services, add to existing for enhancements")
   - **IMPORTANT**: These answers determine how AI creates/modifies test files in every iteration

6. **Gather any other project-specific patterns** (Mode A only, skip if Mode B):
   - File naming conventions (if mentioned or user specifies)
   - Directory structure preferences (if relevant)
   - Code style preferences (if mentioned)
   - Skip if not applicable to project type

7. **Generate .flow/PLAN.md** following EXAMPLE_PLAN.md structure exactly ⚠️ CRITICAL (ALWAYS overwrites if exists):

   **Mode-Specific Behavior**:

   **If Mode A (SUGGEST)**: AI-generated comprehensive plan
   - Use information gathered from steps 4-6
   - Generate full structure with AI-designed phases/tasks/iterations
   - Fill in all metadata sections with detailed content
   - Follow all subsections below

   **If Mode B (CREATE)**: Honor user's explicit structure
   - Use user's provided structure exactly
   - Fill in metadata where provided by user
   - Use [TBD] placeholders for missing metadata (⚠️ UX PRINCIPLE 2 & 6: Honest communication)
   - Example Testing Strategy if not provided: "[TBD] - Testing strategy to be defined during first iteration brainstorming"
   - Example Architecture if not provided: "[TBD] - Architecture to be documented during design phase"
   - Still create ALL required sections (don't skip sections just because metadata is missing)
   - Note: .flow/ directory already exists (created by flow.sh installation)
   - **CRITICAL**: Use EXAMPLE_PLAN.md as your template - follow its structure exactly

   - **Framework reference header** (REQUIRED - copy format from EXAMPLE_PLAN.md lines 1-11):
     ```markdown
     # [Project Name] - Development Plan

     > **📖 Framework Guide**: See DEVELOPMENT_FRAMEWORK.md for complete methodology and patterns used in this plan
     >
     > **🎯 Purpose**: [Brief description of what this plan covers]

     **Created**: [Date]
     **Version**: V1
     **Plan Location**: `.flow/PLAN.md` (managed by Flow)
     ```

   - **Overview section** (see EXAMPLE_PLAN.md lines 13-27):
     - Purpose, Goals, Scope (Included/Excluded with version markers)

   - **Progress Dashboard section** ⚠️ REQUIRED (see EXAMPLE_PLAN.md lines 29-62):
     - **Last Updated** timestamp
     - **Current Work** with jump links to Phase/Task/Iteration
     - **Completion Status** percentage per phase
     - **Progress Overview** with full iteration lists (NOT "(X iterations total)")
     - Format: Follow EXAMPLE_PLAN.md lines 44-61 exactly for iteration list structure
     - Read DEVELOPMENT_FRAMEWORK.md lines 2555-2567 for iteration list format rules

   - **Architecture section** (see EXAMPLE_PLAN.md lines 65-85):
     - High-level design, key components, dependencies

   - **Testing Strategy section** ⚠️ REQUIRED (see EXAMPLE_PLAN.md lines 87-129):
     - **Methodology**: Document testing methodology from step 4
     - **Approach**: Integration/Unit/E2E/Manual QA details
     - **Location**: Where test files live
     - **Naming Convention**: Test file naming pattern
     - **When to create**: Conditions for new test files
     - **When to add**: When to add to existing files
     - **Coverage**: What to test
     - **IMPORTANT** section with ✅ DO and ❌ DO NOT examples
     - Include file structure visualization if helpful

   - **Development Plan section** (see EXAMPLE_PLAN.md lines 134+):
     - Estimate 2-4 phases (Foundation, Core Implementation, Testing, Enhancement/Polish)
     - For each phase: Status, Started/Completed dates, Strategy, Goal
     - For each task: 1-5 tasks with Status, Purpose
     - For each task: 2-10 iterations with Goal (high-level names only)
     - Mark everything as ⏳ PENDING initially
     - Add placeholder brainstorming sessions (see EXAMPLE_PLAN.md lines 164-259 for structure)
     - Include Resolution Type labels (Type A/B/C/D) in subject resolutions
     - Include placeholder Implementation sections (see EXAMPLE_PLAN.md lines 260-283)

   - **Changelog section** ⚠️ REQUIRED (see EXAMPLE_PLAN.md lines 544-549):
     - Initial entry with creation date
     - Format: `**YYYY-MM-DD**: - ✅ [Iteration X]: [description] - 🚧 [Iteration Y]: [description] (in progress)`

8. **Depth**: Medium detail
   - Phase names and strategies
   - Task names and purposes
   - Iteration names only (no brainstorming subjects yet)

9. **Verify completeness before saving** ⚠️ CRITICAL SELF-CHECK:
   - [ ] Framework reference header present (with 🎯 Purpose line)?
   - [ ] Overview section present (Purpose, Goals, Scope)?
   - [ ] Progress Dashboard present (NOT optional - REQUIRED)?
   - [ ] Architecture section present (can be [TBD] in Mode B)?
   - [ ] Testing Strategy section present with all fields (can be [TBD] in Mode B)?
   - [ ] Development Plan with phases/tasks/iterations?
   - [ ] Placeholder brainstorming sessions with Resolution Type labels (Type A/B/C/D)?
   - [ ] Changelog section present?
   - [ ] All iteration lists expanded (NOT "(X iterations total)")?
   - **If any checkbox is unchecked, review EXAMPLE_PLAN.md again and add missing section**

10. **Confirm to user** (Mode-specific):

    **If Mode A (SUGGEST)**:
    - "✨ Created .flow/PLAN.md with [X] phases, [Y] tasks, [Z] iterations"
    - "📂 Flow is now managing this project from .flow/ directory"
    - "📋 Included: Progress Dashboard, Testing Strategy, Changelog, placeholder brainstorming sessions"
    - "Use `/flow-status` to see current state"
    - "Use `/flow-brainstorm-start [topic]` to begin first iteration"

    **If Mode B (CREATE)**:
    - "✨ Created .flow/PLAN.md from your explicit structure"
    - "📊 Structure: [X] phases, [Y] tasks, [Z] iterations (as you specified)"
    - "📝 [TBD] placeholders used for: [list sections with [TBD]]"
    - "💡 Refine [TBD] sections during brainstorming or use `/flow-plan-update`"
    - "Use `/flow-status` to see current state"

**Output**: Create `.flow/PLAN.md` file and confirm creation to user.
```

---

## /flow-migrate

<!-- MCP_METADATA
function_name: flow_migrate
category: planning_creation
parameters:
  - name: existing_file_path
    type: str
    required: false
    default: ""
    description: Path to existing plan file (auto-discovers if not provided)
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: true
framework_sections:
  - Quick Reference (lines 1-544)
  - Plan File Template (lines 2731-2928)
MCP_METADATA_END -->

**File**: `flow-migrate.md`

```markdown
---
description: Migrate existing PRD/PLAN/TODO to Flow's .flow/PLAN.md format
---

You are executing the `/flow-migrate` command from the Flow framework.

**Purpose**: Migrate existing project documentation (PLAN.md, TODO.md, etc.) to Flow-compliant `.flow/PLAN.md` format.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: DEVELOPMENT_FRAMEWORK.md lines 1-544 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Plan File Template pattern (lines 134-207), Task Structure Rules (lines 47-107), Status Markers (lines 28-46)
- **Deep dive if needed**: Read lines 2731-2928 for complete Plan File Template using Read(offset=2731, limit=197)

**Framework Reference**: This command requires framework knowledge to convert existing docs to Flow structure. See Quick Reference guide above for essential patterns.

**IMPORTANT**: This command ALWAYS creates a fresh `.flow/PLAN.md`, overwriting any existing plan file. It reads your current documentation and converts it to Flow format.

**Instructions**:

1. **Read the framework guide AND example plan** ⚠️ CRITICAL:

   - **Search for DEVELOPMENT_FRAMEWORK.md** in these locations (in order):
     - `.flow/DEVELOPMENT_FRAMEWORK.md`
     - `.claude/DEVELOPMENT_FRAMEWORK.md`
     - `./DEVELOPMENT_FRAMEWORK.md` (project root)
     - `~/.claude/flow/DEVELOPMENT_FRAMEWORK.md` (global)
   - **Search for EXAMPLE_PLAN.md** in same locations
   - **Read BOTH files completely** to understand:
     - Flow's hierarchy: PHASE → TASK → ITERATION → BRAINSTORM → IMPLEMENTATION
     - Plan file template structure (DEVELOPMENT_FRAMEWORK.md lines 2731-2928)
     - Real-world example structure (EXAMPLE_PLAN.md - all 509 lines)
     - Required sections: Framework Guide header, Overview, Progress Dashboard, Architecture, Testing Strategy, Development Plan, Changelog
     - Progress Dashboard format with iteration lists
     - All status markers (✅ ⏳ 🚧 🎨 ❌ 🔮)

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

5. **Generate .flow/PLAN.md** based on detected structure (ALWAYS overwrites if exists):

   - Note: .flow/ directory already exists (created by flow.sh installation)

   **Path A - STRUCTURED** (already has phases/tasks):

   - Keep existing hierarchy
   - **CRITICAL**: Use EXAMPLE_PLAN.md as reference for all sections
   - **Add framework reference header at top** (copy format from EXAMPLE_PLAN.md lines 1-11):
     ```markdown
     > **📖 Framework Guide**: See DEVELOPMENT_FRAMEWORK.md for complete methodology and patterns used in this plan
     >
     > **🎯 Purpose**: [Brief description of what this plan covers - extract from existing docs]

     **Created**: [Original date if available]
     **Version**: V1
     **Plan Location**: `.flow/PLAN.md` (managed by Flow)
     ```
   - **Add/enhance Progress Dashboard section** (after Overview, before Architecture):
     - Follow EXAMPLE_PLAN.md lines 29-62 format exactly
     - Include: Last Updated, Current Work (with jump links), Completion Status, Progress Overview
     - **Ensure iteration lists are expanded** (read DEVELOPMENT_FRAMEWORK.md lines 2555-2567 for format)
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
🎯 Output: .flow/PLAN.md

Migration type: [STRUCTURED/FLAT_LIST/UNSTRUCTURED]
Changes: + Added Progress Dashboard with jump links + Enhanced [X] status markers + Preserved [Y] completed items + Preserved [Z] pending items + [other changes specific to migration type]

Next steps: 1. Review: diff [backup] .flow/PLAN.md 2. Verify: /flow-status 3. Start using Flow: /flow-brainstorm_start [topic]

📂 Flow is now managing this project from .flow/ directory

```

10. **Handle edge cases**:
 - If source file is empty: Suggest `/flow-blueprint` instead
 - If source file is already Flow-compliant: Mention it's already compatible, migrate anyway
 - If can't determine structure: Default to Path C (unstructured)
 - If migration fails: Keep backup safe, report error, suggest manual approach

**Output**: Create `.flow/PLAN.md` from existing documentation, create backup, confirm migration to user.
```

---

## /flow-plan-update

<!-- MCP_METADATA
function_name: flow_plan_update
category: maintenance
parameters: []
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: true
framework_sections:
  - Quick Reference (lines 1-544)
  - Plan File Template (lines 2731-2928)
MCP_METADATA_END -->

**File**: `flow-plan-update.md`

```markdown
---
description: Update existing plan to match latest Flow framework structure
---

You are executing the `/flow-plan-update` command from the Flow framework.

**Purpose**: Update an existing `.flow/PLAN.md` to match the latest Flow framework structure and patterns.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: DEVELOPMENT_FRAMEWORK.md lines 1-544 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Plan File Template (lines 272-353)
- **Deep dive if needed**: Read lines 105-179 for Framework Structure using Read(offset=105, limit=75)

**IMPORTANT**: This command updates your current plan file to match framework changes (e.g., Progress Dashboard moved, new status markers, structural improvements).

**Instructions**:

1. **Read the framework guide**:

   - Search for DEVELOPMENT_FRAMEWORK.md in these locations (in order):
     - `.flow/DEVELOPMENT_FRAMEWORK.md`
     - `.claude/DEVELOPMENT_FRAMEWORK.md`
     - `./DEVELOPMENT_FRAMEWORK.md` (project root)
     - `~/.claude/flow/DEVELOPMENT_FRAMEWORK.md` (global)
   - Understand current framework structure and patterns
   - Study the Progress Dashboard template and its location
   - Note all status markers and section structure requirements

2. **Read the example plan**:

   - Search for EXAMPLE_PLAN.md in these locations (in order):
     - `.flow/EXAMPLE_PLAN.md`
     - `.claude/EXAMPLE_PLAN.md`
     - `~/.claude/flow/EXAMPLE_PLAN.md` (global)
   - Study the section order and formatting
   - Note how Progress Dashboard is positioned
   - Understand the complete structure template

3. **Read current plan**:

   - Read `.flow/PLAN.md` (your project's current plan)
   - Analyze its current structure
   - Identify what needs updating to match framework

4. **Create backup**:

   - Copy current plan: `.flow/PLAN.md.version-update-backup-$(date +%Y-%m-%d-%H%M%S)`
   - Confirm: "✅ Backed up .flow/PLAN.md to [backup]"

5. **Analyze current plan against framework checklist**:

   **CRITICAL FRAMEWORK VERSION PATTERNS** (v1.2.1+):

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

9. **Confirm to user**:
```

✨ Plan structure updated to match latest Flow framework!

💾 Backup: .flow/PLAN.md.version-update-backup-[timestamp]
🎯 Updated: .flow/PLAN.md

Changes made: + Fixed [N] iterations with duplicated action items (replaced with references) + Moved Progress Dashboard to correct location (if needed) + Removed duplicate progress sections (if found) + Updated status pointers to use jump links (if needed) + Added jump links to "Current Work" section (if missing) + Expanded [Y] collapsed iteration lists + Standardized status markers + [other changes specific to this update]

Next steps: 1. Review changes: diff [backup] .flow/PLAN.md 2. Verify: /flow-status 3. Continue work: /flow-next

All your content preserved - only structure enhanced.

```

10. **Handle edge cases**:
- If `.flow/PLAN.md` doesn't exist: Suggest `/flow-blueprint` or `/flow-migrate`
- If plan already matches latest structure: Report "Already up to date!"
- If can't determine what to update: Ask user what framework version they're coming from

**Output**: Update `.flow/PLAN.md` to latest framework structure, create backup, confirm changes to user.
```

---

## /flow-phase-add

<!-- MCP_METADATA
function_name: flow_phase_add
category: structure_addition
parameters:
  - name: phase_name
    type: str
    required: true
    description: Name of the phase to add
  - name: phase_description
    type: str
    required: false
    default: ""
    description: Optional description of the phase
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-phase-add.md`

```markdown
---
description: Add a new phase to the development plan
---

You are executing the `/flow-phase-add` command from the Flow framework.

**Purpose**: Add a new phase to the current PLAN.md file.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**

- Simple structure addition (adds new phase section to PLAN.md)
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 567-613 for phase patterns

**Context**:

- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this phase that are NOT part of the current work:

1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **INPUT VALIDATION** (Token-Efficient - Run BEFORE reading PLAN.md) ⚠️ UX PRINCIPLE 1 & 2:

   **Goal**: Accept minimal input, use [TBD] for missing metadata - never block for cosmetic reasons.

   **Step 1: Hard Rule Check** (< 10 tokens):
   ```
   IF $ARGUMENTS is empty OR just whitespace:
     REJECT: "❌ Missing phase name/description. Example: /flow-phase-add 'Testing and QA'"
     STOP (don't proceed)
   ```

   **Step 2: Accept Everything Else** ⚠️ UX PRINCIPLE 2 (Never Block for Cosmetic Reasons):
   - Even minimal input like "Testing" is OK
   - Will use [TBD] for Strategy and Goal if not inferable
   - Proceed to step 2

2. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

3. **Verify framework understanding**: Know that phases are top-level milestones (e.g., "Foundation", "Core Implementation", "Testing")

4. **Parse arguments and extract metadata**: `$ARGUMENTS` = phase description

   **Extract Strategy and Goal** (if provided in $ARGUMENTS):
   - Example: "Testing Phase | Strategy: Comprehensive QA | Goal: Zero critical bugs"
   - If metadata provided, use it
   - If NOT provided, try to infer from phase name:
     - "Testing" → Strategy: "Quality assurance and validation", Goal: "Ensure code quality and stability"
     - "Foundation" → Strategy: "Setup and architecture", Goal: "Establish project foundation"
     - "Polish" → Strategy: "UX and optimization", Goal: "Production-ready quality"
   - If can't infer (unusual phase name or too vague), use [TBD]:
     - Strategy: "[TBD] - Define strategy during phase start"
     - Goal: "[TBD] - Define goal during phase start"

5. **Add new phase section** ⚠️ UX PRINCIPLE 6 (Honest Communication):

   ```markdown
   ### Phase [N]: [$ARGUMENTS] ⏳

   **Strategy**: [Extracted/Inferred/[TBD]]

   **Goal**: [Extracted/Inferred/[TBD]]

   ---
   ```

6. **Update .flow/PLAN.md**: Append new phase to Development Plan section

7. **Update Progress Dashboard** (if it exists):

   - Update phase count in Progress Overview section
   - No need to change "Current Work" pointer (new phase is ⏳ PENDING)
   - Add new phase to completion status if tracking percentages

8. **Confirm to user** (show what was used):
   - "✅ Added Phase [N]: [$ARGUMENTS]"
   - IF used [TBD]: "📝 Used [TBD] placeholders for: [Strategy/Goal]"
   - IF inferred metadata: "💡 Inferred: Strategy = '[value]', Goal = '[value]'"
   - "💡 Refine with `/flow-phase-start` when ready to begin"

**Output**: Update .flow/PLAN.md with new phase.

```

---

## /flow-phase-start

<!-- MCP_METADATA
function_name: flow_phase_start
category: state_management
parameters: []
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-phase-start.md`

```markdown
---
description: Mark current phase as in progress
---

You are executing the `/flow-phase-start` command from the Flow framework.

**Purpose**: Mark the current phase as 🚧 IN PROGRESS (when first task starts).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**
- State transition (⏳ PENDING → 🚧 IN PROGRESS)
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 567-613 for lifecycle context

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this phase that are NOT part of the current work:
1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current phase**: Look for last phase marked ⏳ PENDING

3. **Update phase status**: Change marker from ⏳ to 🚧 IN PROGRESS

4. **Update Progress Dashboard**:
   - Find "## 📋 Progress Dashboard" section
   - Update current phase information
   - Update last updated timestamp
   - Add action description: "Phase [N] started"

5. **Confirm to user**: "Started Phase [N]: [Name]. Use `/flow-task-add [description]` to create tasks."

**Output**: Update .flow/PLAN.md with phase status change and Progress Dashboard update.
```

---

## /flow-phase-complete

<!-- MCP_METADATA
function_name: flow_phase_complete
category: state_management
parameters: []
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-phase-complete.md`

```markdown
---
description: Mark current phase as complete
---

You are executing the `/flow-phase-complete` command from the Flow framework.

**Purpose**: Mark the current phase as ✅ COMPLETE (when all tasks done).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**

- State transition (🚧 IN PROGRESS → ✅ COMPLETE)
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 567-613 for completion criteria

**Context**:

- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current phase**: Look for phase marked 🚧 IN PROGRESS

3. **Verify all tasks complete**: Check that all tasks in this phase are marked ✅ COMPLETE

   - If incomplete tasks found: "Phase has incomplete tasks. Complete them first or mark as ❌ CANCELLED / 🔮 DEFERRED."

4. **Update phase status**: Change marker from 🚧 to ✅ COMPLETE

5. **Update Progress Dashboard**:

   - Find "## 📋 Progress Dashboard" section
   - Update current phase to next phase (or mark project complete if no next phase)
   - Update completion percentages
   - Update last updated timestamp
   - Add action description: "Phase [N] complete"

6. **Check for next phase**:

   - If next phase exists: Auto-advance to next phase (show name)
   - If no next phase: "All phases complete! Project finished."

7. **Show "What's Next" Section**:
   ```markdown
   ## 🎯 What's Next

   Phase [N]: [Name] marked complete!

   **Decision Tree**:
   - **Next phase exists?** → Use `/flow-phase-start [optional: number]` to begin next phase
   - **All phases complete?** → Project finished! 🎉 Consider archiving or starting V2 planning
   - **Want to review progress?** → Use `/flow-summarize` to see complete project overview

   **Next phase**: Phase [N+1]: [Name] (if applicable)
   ```

**Output**: Update .flow/PLAN.md with phase completion, Progress Dashboard update, and clear next-step guidance.
```

---

## /flow-task-add

<!-- MCP_METADATA
function_name: flow_task_add
category: structure_addition
parameters:
  - name: task_name
    type: str
    required: true
    description: Name of the task to add
  - name: task_description
    type: str
    required: false
    default: ""
    description: Optional description of the task
  - name: task_purpose
    type: str
    required: false
    default: ""
    description: Optional purpose statement for the task
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: true
framework_sections:
  - Task Structure Rules (lines 238-566)
MCP_METADATA_END -->

**File**: `flow-task-add.md`

```markdown
---
description: Add a new task under the current phase
---

You are executing the `/flow-task-add` command from the Flow framework.

**Purpose**: Add a new task to the current phase in PLAN.md.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: DEVELOPMENT_FRAMEWORK.md lines 1-544 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Task Structure Rules (lines 47-107) - Golden Rule: Standalone OR Iterations, Never Both
- **Deep dive if needed**: Read lines 597-920 for complete Task Structure Rules using Read(offset=597, limit=323)

**Framework Reference**: This command requires framework knowledge to create correct task structure. See Quick Reference guide above for essential patterns.

**Context**:

- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this task that are NOT part of the current work:

1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **INPUT VALIDATION** (Token-Efficient - Run BEFORE reading PLAN.md) ⚠️ UX PRINCIPLE 1 & 2:

   **Goal**: Accept minimal input, use [TBD] for missing metadata - never block for cosmetic reasons.

   **Step 1: Hard Rule Check** (< 10 tokens):
   ```
   IF $ARGUMENTS is empty OR just whitespace:
     REJECT: "❌ Missing task name/description. Example: /flow-task-add 'User Authentication'"
     STOP (don't proceed)
   ```

   **Step 2: Accept Everything Else** ⚠️ UX PRINCIPLE 2 (Never Block for Cosmetic Reasons):
   - Even minimal input like "API Design" is OK
   - Will use [TBD] for Purpose if not inferable
   - Proceed to step 2

2. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

3. **Parse arguments and extract metadata**: `$ARGUMENTS` = task description

   **Extract Purpose** (if provided in $ARGUMENTS):
   - Example: "User Authentication | Purpose: Implement secure login system"
   - If metadata provided, use it
   - If NOT provided, try to infer from task name:
     - "User Authentication" → Purpose: "Implement user authentication system"
     - "API Design" → Purpose: "Design and document API endpoints"
     - "Testing Infrastructure" → Purpose: "Setup testing framework and utilities"
   - If can't infer (unusual task name or too vague), use [TBD]:
     - Purpose: "[TBD] - Define purpose during task start or brainstorming"

4. **Find current phase**: Look for last phase marked ⏳ or 🚧

5. **Add new task section** ⚠️ UX PRINCIPLE 6 (Honest Communication):

   ```markdown
   #### Task [N]: [$ARGUMENTS] ⏳

   **Status**: PENDING
   **Purpose**: [Extracted/Inferred/[TBD]]

   ---
   ```

6. **Update .flow/PLAN.md**: Append task under current phase

7. **Update Progress Dashboard** (if it exists):

   - Update task count in Progress Overview
   - Add new task to phase's task list
   - No need to change "Current Work" pointer (new task is ⏳ PENDING)

8. **Confirm to user** (show what was used):
   - "✅ Added Task [N]: [$ARGUMENTS] to current phase"
   - IF used [TBD]: "📝 Used [TBD] placeholder for Purpose"
   - IF inferred metadata: "💡 Inferred Purpose = '[value]'"
   - "💡 Refine with `/flow-task-start` or `/flow-brainstorm-start` when ready"

**Output**: Update .flow/PLAN.md with new task.

```

---

## /flow-task-start

<!-- MCP_METADATA
function_name: flow_task_start
category: state_management
parameters: []
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-task-start.md`

```markdown
---
description: Mark current task as in progress
---

You are executing the `/flow-task-start` command from the Flow framework.

**Purpose**: Mark the current task as 🚧 IN PROGRESS (when first iteration starts).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**
- State transition (⏳ PENDING → 🚧 IN PROGRESS)
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 567-613 for lifecycle context

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this task that are NOT part of the current work:
1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Determine target task** (argument is optional):

   **If task number provided as argument**:
   - Use the specified task number
   - Verify task exists and is ⏳ PENDING
   - If not found or not PENDING: "Task [N] not found or not in PENDING state"

   **If no argument provided** (auto-detection):
   - Find current phase (marked 🚧 IN PROGRESS)
   - Find last ✅ COMPLETE task in that phase
   - Calculate next task number (last complete + 1)
   - Verify next task exists and is ⏳ PENDING
   - If not found: List available ⏳ PENDING tasks in current phase and ask user to specify
   - Example error: "Cannot auto-detect next task. Available pending tasks in Phase 2: Task 5, Task 7, Task 9. Use `/flow-task-start [number]` to specify."

3. **Update task status**: Change marker from ⏳ to 🚧 IN PROGRESS

4. **Update Progress Dashboard**:
   - Find "## 📋 Progress Dashboard" section
   - Update current task information
   - Update last updated timestamp
   - Add action description: "Task [N] started"

5. **Confirm to user**:
   - If argument provided: "✅ Started Task [N]: [Name]"
   - If auto-detected: "✅ Started Task [N]: [Name] (auto-detected next task)"
   - Suggest next steps: "Use `/flow-iteration-add [description]` to create iterations, or `/flow-brainstorm-start [topics]` to brainstorm first."

**Output**: Update .flow/PLAN.md with task status change and Progress Dashboard update.
```

---

## /flow-task-complete

<!-- MCP_METADATA
function_name: flow_task_complete
category: state_management
parameters: []
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-task-complete.md`

```markdown
---
description: Mark current task as complete
---

You are executing the `/flow-task-complete` command from the Flow framework.

**Purpose**: Mark the current task as ✅ COMPLETE (when all iterations done).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**

- State transition (🚧 IN PROGRESS → ✅ COMPLETE)
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 567-613 for completion criteria

**Context**:

- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current task**: Look for task marked 🚧 IN PROGRESS

3. **Verify all iterations complete**: Check that all iterations in this task are marked ✅ COMPLETE

   - If incomplete iterations found: "Task has incomplete iterations. Complete them first or mark as ❌ CANCELLED / 🔮 DEFERRED."

4. **Update task status**: Change marker from 🚧 to ✅ COMPLETE

5. **Update Progress Dashboard**:

   - Find "## 📋 Progress Dashboard" section
   - Update current task to next task (or next phase if all tasks done)
   - Update completion percentages
   - Update last updated timestamp
   - Add action description: "Task [N] complete"

6. **Check if phase complete**:

   - If all tasks in phase are ✅ COMPLETE: Suggest `/flow-phase-complete`
   - If more tasks: Auto-advance to next task (show name)

7. **Show "What's Next" Section**:
   ```markdown
   ## 🎯 What's Next

   Task [N]: [Name] marked complete!

   **Decision Tree**:
   - **All tasks in phase complete?** → Use `/flow-phase-complete` to mark phase as ✅ COMPLETE
   - **More tasks in phase?** → Use `/flow-task-start [optional: number]` to begin next task
   - **Want to see current state?** → Use `/flow-status` to see suggestions

   **Next task**: Task [N+1]: [Name] (if applicable)
   ```

**Output**: Update .flow/PLAN.md with task completion, Progress Dashboard update, and clear next-step guidance.
```

---

## /flow-iteration-add

<!-- MCP_METADATA
function_name: flow_iteration_add
category: structure_addition
parameters:
  - name: iteration_name
    type: str
    required: true
    description: Name/goal of the iteration to add
  - name: iteration_description
    type: str
    required: false
    default: ""
    description: Optional description of the iteration
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: true
framework_sections:
  - Quick Reference (lines 1-544)
  - Task Structure Rules (lines 606-934)
MCP_METADATA_END -->

**File**: `flow-iteration-add.md`

```markdown
---
description: Add a new iteration under the current task
---

You are executing the `/flow-iteration-add` command from the Flow framework.

**Purpose**: Add a new iteration to the current task in PLAN.md.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: DEVELOPMENT_FRAMEWORK.md lines 1-544 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Iteration Patterns (lines in Quick Reference)
- **Deep dive if needed**: Read lines 567-613 for Development Workflow using Read(offset=567, limit=47)

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this iteration that are NOT part of the current work:

1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Parse arguments**: `$ARGUMENTS` = iteration description

3. **Find current task**: Look for last task marked ⏳ or 🚧

4. **Add new iteration section**:

   ```markdown
   ##### Iteration [N]: [$ARGUMENTS] ⏳

   **Status**: PENDING
   **Goal**: [What this iteration builds]

   ---
   ```
```

5. **Update .flow/PLAN.md**: Append iteration under current task

6. **Update Progress Dashboard** (if it exists):

   **CRITICAL - Read Framework Reference for Iteration List Format**:
   - **Read DEVELOPMENT_FRAMEWORK.md lines 2555-2567** for CRITICAL iteration list format
   - The framework specifies EXACT format for showing iterations in Progress Dashboard
   - Key rules from framework:
     - Task line shows count: `- 🚧 **Task 11**: Name Generation (3/5 iterations)`
     - Each iteration MUST be listed as indented sub-bullet with number, name, and status
     - Update both task count AND overall iteration count
   - **DO NOT** write "(X iterations total)" without actually listing them
   - **ALWAYS** expand the task to show full iteration list when adding iterations

7. **Confirm to user**: "Added Iteration [N]: [$ARGUMENTS] to current task. Use `/flow-brainstorm-start [topic]` to begin."

**Output**: Update .flow/PLAN.md with new iteration.

```

---

## /flow-brainstorm-start

<!-- MCP_METADATA
function_name: flow_brainstorm_start
category: brainstorming
parameters:
  - name: topics
    type: str
    required: false
    default: ""
    description: Topics to discuss (prompts if not provided)
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: true
framework_sections:
  - Quick Reference (lines 1-544)
  - Brainstorming Session Pattern (lines 1535-2165)
MCP_METADATA_END -->

**File**: `flow-brainstorm-start.md`

```markdown
---
description: Start brainstorming session with user-provided topics
---

You are executing the `/flow-brainstorm-start` command from the Flow framework.

**Purpose**: Begin a brainstorming session for the current iteration with subjects provided by the user.

**🔴 REQUIRED: Read Framework Quick Reference First**
- **Read once per session**: DEVELOPMENT_FRAMEWORK.md lines 1-544 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Subject Resolution Types (lines 108-128), Common Patterns (lines 134-207)
- **Deep dive if needed**: Read lines 1531-2156 for complete Brainstorming Pattern using Read(offset=1531, limit=625)

**Framework Reference**: This command requires framework knowledge to structure brainstorming session correctly. See Quick Reference guide above for essential patterns.

**Signature**: `/flow-brainstorm-start [optional: free-form text describing topics to discuss]`

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Framework Pattern**: See "Brainstorming Session Pattern" section in framework guide

**🚨 SCOPE BOUNDARY RULE** (CRITICAL - see DEVELOPMENT_FRAMEWORK.md lines 339-540):

If you discover NEW issues during brainstorming that are NOT part of the current iteration:

1. **STOP** immediately - Don't make assumptions or proceed
2. **NOTIFY** user - Present discovered issue(s) with structured analysis
3. **DISCUSS** - Provide structured options (A/B/C/D format):
   - **A**: Create pre-implementation task (< 30 min work, blocking)
   - **B**: Add as new brainstorming subject (design needed)
   - **C**: Handle immediately (only if user approves)
   - **D**: Defer to separate iteration (after current work)
4. **AWAIT USER APPROVAL** - Never proceed without explicit user decision

**Use the Scope Boundary Alert Template** (see DEVELOPMENT_FRAMEWORK.md lines 356-390)

**Why This Matters**: User stays in control of priorities, AI finds issues proactively but doesn't make scope decisions

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current iteration**: Look for last iteration marked ⏳ or 🚧

3. **Determine mode** (two modes available):

   **MODE 1: With Argument** (user provides topics in command)
   - User provided topics in `$ARGUMENTS` (free-form text)
   - Parse the user's input and extract individual subjects
   - User controls WHAT to brainstorm, AI structures HOW
   - Example: `/flow-brainstorm-start "API design, database schema, auth flow, error handling"`
   - AI extracts: [API design, database schema, auth flow, error handling]
   - **Proceed to step 4**

   **MODE 2: Without Argument** (interactive) ⚠️ CRITICAL
   - **NO arguments provided** by user
   - **DO NOT** auto-generate subjects from task description
   - **DO NOT** read PLAN.md and invent subjects automatically
   - **DO NOT** proceed to create brainstorming section yet
   - **STOP and ask the user**:

     Example prompt to user:
     ```
     I'll start a brainstorming session for [Task/Iteration Name].

     **What subjects would you like to discuss?**

     You can provide:
     - Comma-separated topics: "API design, database, auth"
     - Free-form text describing areas to explore
     - Bullet list of specific topics

     Based on the task scope, here are some suggestions:
     - [Suggestion 1 based on task description]
     - [Suggestion 2 based on task description]
     - [Suggestion 3 based on task description]

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

5. **Update iteration status**: Change to 🚧 IN PROGRESS (Brainstorming)

6. **Create brainstorming section**:
   ```markdown
   ### **Brainstorming Session - [Brief description from user input]**

   **Focus**: [Summarize the main goal based on subjects]

   **Subjects to Discuss** (tackle one at a time):

   1. ⏳ **[Subject 1]** - [Brief description if needed]
   2. ⏳ **[Subject 2]** - [Brief description if needed]
   3. ⏳ **[Subject 3]** - [Brief description if needed]
   ...

   **Resolved Subjects**:

   ---
```

7. **Update Progress Dashboard**: Update current iteration status to "🚧 BRAINSTORMING"

8. **Confirm to user** (only after creating brainstorming section):
   - "Started brainstorming session with [N] subjects."
   - List all subjects
   - "Use `/flow-next-subject` to start discussing the first subject."

**Key Principles**:
- ✅ **User always provides topics** (via argument or when prompted)
- ❌ **AI NEVER invents subjects** from task description without user input
- ❌ **AI NEVER auto-generates** a subject list when no argument provided
- ✅ **If no argument**: STOP, suggest topics, WAIT for user response
- ✅ **After user provides topics**: THEN create brainstorming section

**Output**: Update .flow/PLAN.md with brainstorming section, subject list, and status change (ONLY after user provides topics).

```

---

## /flow-brainstorm-subject

<!-- MCP_METADATA
function_name: flow_brainstorm_subject
category: brainstorming
parameters:
  - name: subject_text
    type: str
    required: true
    description: Subject to add to discussion
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: true
framework_sections:
  - Quick Reference (lines 1-544)
  - Brainstorming Session Pattern (lines 1535-2165)
MCP_METADATA_END -->

**File**: `flow-brainstorm-subject.md`

```markdown
---
description: Add a subject to discuss in brainstorming
---

You are executing the `/flow-brainstorm-subject` command from the Flow framework.

**Purpose**: Add a new subject to the current brainstorming session.

**🔴 REQUIRED: Read Framework Quick Reference First**
- **Read once per session**: DEVELOPMENT_FRAMEWORK.md lines 1-544 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Subject Creation Patterns (lines in Quick Reference)
- **Deep dive if needed**: Read lines 1215-1313 for Subject Resolution Types using Read(offset=1215, limit=99)

**🚨 SCOPE BOUNDARY RULE** (CRITICAL - see DEVELOPMENT_FRAMEWORK.md lines 339-540):

Adding subjects dynamically is a KEY feature of Flow. When you discover NEW issues while discussing current subjects:

1. **STOP** immediately - Don't make assumptions or proceed
2. **NOTIFY** user - Present discovered issue(s) with structured analysis
3. **DISCUSS** - Provide structured options (A/B/C/D format):
   - **A**: Create pre-implementation task (< 30 min work, blocking current subject resolution)
   - **B**: Add as new brainstorming subject (this command - design needed)
   - **C**: Handle immediately as part of current subject (only if user approves)
   - **D**: Defer to separate iteration (after current work)
4. **AWAIT USER APPROVAL** - Never proceed without explicit user decision

**Use the Scope Boundary Alert Template** (see DEVELOPMENT_FRAMEWORK.md lines 356-390)

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Parse arguments**: `$ARGUMENTS` = subject name and optional brief description

3. **Find current brainstorming session**: Look for "Subjects to Discuss" section

4. **Add subject to list**:
   - Count existing subjects
   - Append: `[N]. ⏳ **[$ARGUMENTS]** - [Brief description if provided]`

5. **Update .flow/PLAN.md**: Add subject to "Subjects to Discuss" list

6. **Confirm to user**: "Added Subject [N]: [$ARGUMENTS] to brainstorming session."

**Output**: Update .flow/PLAN.md with new subject.
```

---

## /flow-brainstorm-review

<!-- MCP_METADATA
function_name: flow_brainstorm_review
category: brainstorming
parameters: []
returns: dict[str, Any]
plan_operations: [READ]
framework_reading_required: true
framework_sections:
  - Quick Reference (lines 1-544)
  - Brainstorming Session Pattern (lines 1535-2165)
MCP_METADATA_END -->

**File**: `flow-brainstorm-review.md`

```markdown
---
description: Review all resolved subjects, suggest follow-up work
---

You are executing the `/flow-brainstorm-review` command from the Flow framework.

**Purpose**: Review all resolved brainstorming subjects, verify completeness, summarize decisions, show action items, and suggest follow-up work (iterations/pre-tasks) before marking the brainstorming session complete.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: DEVELOPMENT_FRAMEWORK.md lines 1-544 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Subject Resolution Types (A/B/C/D) (lines in Quick Reference)
- **Deep dive if needed**: Read lines 1167-1797 for Brainstorming Session Pattern using Read(offset=1167, limit=631)

**This is the review gate before `/flow-brainstorm-complete`.**

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Read framework documentation**: Find and read DEVELOPMENT_FRAMEWORK.md (search in .claude/, project root, or ~/.claude/flow/)

3. **Locate current iteration**: Use "Progress Dashboard" to find current Phase/Task/Iteration

4. **Verify all subjects resolved**:

   - Check "Subjects to Discuss" section under current iteration's "Brainstorming Session"
   - Count total subjects vs ✅ resolved subjects
   - If ANY subjects remain unmarked (⏳ PENDING), warn user: "Not all subjects resolved. Run `/flow-next-subject` to complete remaining subjects."
   - If all subjects are ✅ resolved, proceed to next step

5. **Summarize resolved subjects**:

   - Read all entries in "Resolved Subjects" section
   - Create concise summary of each resolution:
     - Subject name
     - Decision made
     - Key rationale points
   - Present in numbered list format

6. **Show all action items**:

   - Extract all documented action items from resolved subjects
   - Categorize by type:
     - **Pre-Implementation Tasks**: Work that must be done BEFORE implementing this iteration
     - **Follow-up Iterations**: Future work to tackle after this iteration
     - **Documentation Updates**: Files/docs that need changes
     - **Other Actions**: Miscellaneous tasks
   - Present in organized format

7. **Categorize action items** (CRITICAL - Ask user to clarify):

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

8. **Await user confirmation**:
   - Do NOT automatically create iterations or pre-tasks
   - Show categorization above
   - Ask: "Does this categorization look correct? Should I adjust anything?"
   - If user confirms Type 1 (pre-tasks) exist: Ask if they want them created now
   - If user confirms Type 3 (new iterations): Ask if they want them created now
   - Type 2 (implementation work) stays in iteration - no creation needed

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

**Output**: Comprehensive review summary with actionable suggestions, awaiting user confirmation.
```

---

## /flow-brainstorm-complete

<!-- MCP_METADATA
function_name: flow_brainstorm_complete
category: brainstorming
parameters: []
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: true
framework_sections:
  - Quick Reference (lines 1-544)
  - Brainstorming Session Pattern (lines 1535-2165)
MCP_METADATA_END -->

**File**: `flow-brainstorm-complete.md`

```markdown
---
description: Complete brainstorming and generate action items
---

You are executing the `/flow-brainstorm-complete` command from the Flow framework.

**Purpose**: Close the current brainstorming session (only after pre-implementation tasks are done).

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: DEVELOPMENT_FRAMEWORK.md lines 1-544 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Completion Criteria (lines in Quick Reference)
- **Deep dive if needed**: Read lines 1740-1797 for Completion Criteria using Read(offset=1740, limit=58)

**IMPORTANT**: Pre-implementation tasks should be documented IN PLAN.md during brainstorming, then completed BEFORE running this command.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Verify all subjects resolved**: Check "Subjects to Discuss" - all should be ✅

3. **Check for pre-implementation tasks**:

   - Look for "### **Pre-Implementation Tasks:**" section in PLAN.md
   - If found:
     - Check if all pre-tasks are marked ✅ COMPLETE
     - If any are ⏳ PENDING or 🚧 IN PROGRESS:
       "Pre-implementation tasks exist but are not complete. Complete them first, then run this command again."
     - If all are ✅ COMPLETE: Proceed to step 4
   - If not found:
     - Ask user: "Are there any pre-implementation tasks that need to be completed before starting the main implementation? (Refactoring, system-wide changes, bug fixes discovered during brainstorming, etc.)"
     - If yes: "Please document pre-implementation tasks in PLAN.md first (see framework guide), complete them, then run this command again."
     - If no: Proceed to step 4

4. **Update iteration status**: Change from 🚧 to 🎨 READY FOR IMPLEMENTATION

5. **Add note**: "**Status**: All brainstorming complete, pre-implementation tasks done, ready for implementation"

6. **Show "What's Next" Section**:
   ```markdown
   ## 🎯 What's Next

   Brainstorming session complete! Iteration marked 🎨 READY FOR IMPLEMENTATION.

   **REQUIRED NEXT STEP**: Use `/flow-implement-start` to begin implementation.

   **Before implementing**: Review your action items and ensure you understand the scope. If you discover new issues during implementation (scope violations), STOP and discuss with the user before proceeding.
   ```

**Output**: Update .flow/PLAN.md with brainstorming completion status and clear next-step guidance.
```

---

## /flow-implement-start

<!-- MCP_METADATA
function_name: flow_implement_start
category: state_management
parameters: []
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-implement-start.md`

```markdown
---
description: Begin implementation of current iteration
---

You are executing the `/flow-implement-start` command from the Flow framework.

**Purpose**: Begin implementation phase for the current iteration.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**

- State transition (🎨 READY/⏳ PENDING → 🚧 IMPLEMENTING)
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 1798-1836 for implementation workflow

**Context**:

- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Framework Pattern**: See "Implementation Pattern" section in framework guide
- **Prerequisite**: Brainstorming must be ✅ COMPLETE and all pre-implementation tasks done

**🚨 SCOPE BOUNDARY RULE** (CRITICAL - see DEVELOPMENT_FRAMEWORK.md lines 339-540):

If you discover NEW issues during implementation that are NOT part of the current iteration's action items:

1. **STOP** immediately - Don't make assumptions or proceed
2. **NOTIFY** user - Present discovered issue(s) with structured analysis
3. **DISCUSS** - Provide structured options (A/B/C/D format):
   - **A**: Create pre-implementation task (< 30 min work, blocking)
   - **B**: Add as new brainstorming subject (design needed)
   - **C**: Handle immediately (only if user approves)
   - **D**: Defer to separate iteration (after current work)
4. **AWAIT USER APPROVAL** - Never proceed without explicit user decision

**Use the Scope Boundary Alert Template** (see DEVELOPMENT_FRAMEWORK.md lines 356-390)

**Exception**: Syntax errors or blocking bugs in files you must modify (document what you fixed in Implementation Notes)

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current iteration**:

   - **First**, look for iteration marked 🎨 READY FOR IMPLEMENTATION
   - **If not found**, check if previous iteration is ✅ COMPLETE and next iteration is ⏳ PENDING
     - If YES: Ask user "Previous iteration complete. Do you want to brainstorm this iteration first (recommended) or skip directly to implementation?"
       - **User chooses brainstorm**: Respond "Please run `/flow-brainstorm-start` first to design this iteration"
       - **User chooses skip**: Proceed with step 3 (treat ⏳ PENDING as ready to implement)
     - If NO: Error "No iteration ready for implementation. Run `/flow-brainstorm-complete` first or check iteration status."

3. **Read Testing Strategy section** (CRITICAL):

   - Locate "## Testing Strategy" section in PLAN.md
   - Understand the verification methodology (simulation, unit tests, TDD, manual QA, etc.)
   - Note file locations, naming conventions, and when verification happens
   - **IMPORTANT**: Follow Testing Strategy exactly - do NOT create test files that violate conventions

4. **Verify readiness** (if iteration was 🎨 READY):

   - Brainstorming should be marked ✅ COMPLETE
   - All pre-implementation tasks should be ✅ COMPLETE
   - If not ready: Warn user and ask to complete brainstorming/pre-tasks first

5. **Update iteration status**: Change from 🎨 (or ⏳ if skipping brainstorm) to 🚧 IN PROGRESS

6. **Create implementation section**:

   ```markdown
   ### **Implementation - Iteration [N]: [Name]**

   **Status**: 🚧 IN PROGRESS

   **Action Items**: See resolved subjects above (Type 2/D items)

   **Implementation Notes**:

   [Leave blank for user to fill during implementation]

   **Files Modified**:

   [Leave blank - will be filled as work progresses]

   **Verification**: [Leave blank - how work will be verified]

   ---
   ```

   **IMPORTANT**: Do NOT copy/duplicate action items from subjects to implementation section. The implementation section REFERENCES subjects where action items are defined. This prevents token waste and maintains single source of truth.
```

7. **Update Progress Dashboard** (if it exists):

   - Update current iteration status to "🚧 IMPLEMENTING" or "🚧 IN PROGRESS"
   - Update "Last Updated" timestamp
   - Current work pointer should already be correct (pointing to this iteration)

8. **Confirm to user**:
   - If brainstorming was done: "Implementation started! Let's begin with the first action item."
   - If brainstorming was skipped: "Implementation started (brainstorming skipped). Let's begin with the first action item."

**Output**: Update .flow/PLAN.md with implementation section, status change, and Dashboard update.

```

---

## /flow-implement-complete

<!-- MCP_METADATA
function_name: flow_implement_complete
category: state_management
parameters: []
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-implement-complete.md`

```markdown
---
description: Mark current iteration as complete
---

You are executing the `/flow-implement-complete` command from the Flow framework.

**Purpose**: Mark the current iteration as complete.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**
- State transition (🚧 IMPLEMENTING → ✅ COMPLETE)
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 1798-1836 for completion criteria

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current iteration**: Look for iteration marked 🚧 IN PROGRESS

3. **Verify completion**:
   - Check all action items are ✅ checked
   - If unchecked items remain: Ask user "There are unchecked action items. Are you sure you want to mark complete? (yes/no)"

4. **Prompt for verification notes**:
   - "How did you verify this iteration works? (tests, manual checks, etc.)"

5. **Update iteration status**: Change from 🚧 to ✅ COMPLETE

6. **Update implementation section**:
   - Add verification notes
   - Add timestamp

7. **Add completion summary**:
   ```markdown
   **Implementation Results**:
   - [Summarize what was built]
   - [List key accomplishments]

   **Verification**: [User's verification method]

   **Completed**: [Date]
```

8. **Check if task/phase complete**:

   - If all iterations in task complete → Mark task ✅
   - If all tasks in phase complete → Mark phase ✅

9. **Update Progress Dashboard** (if it exists):

   - Update current iteration status to "✅ COMPLETE"
   - Update iteration completion count (e.g., "3/6 complete" → "4/6 complete")
   - If moving to next iteration: Update "Current Work" pointer to next ⏳ PENDING iteration
   - If task/phase complete: Update those statuses as well
   - Update "Last Updated" timestamp
   - Update completion percentages if tracked

10. **Show "What's Next" Section**:
    ```markdown
    ## 🎯 What's Next

    Iteration [N] marked complete!

    **Decision Tree**:
    - **More iterations planned?** → Use `/flow-iteration-add [description]` to create next iteration
    - **Task complete (all iterations done)?** → Use `/flow-task-complete` to mark task as ✅ COMPLETE
    - **Not sure what's next?** → Use `/flow-status` to see current state and suggestions
    - **Want to see full project status?** → Use `/flow-summarize` for complete overview

    **Current state**: [Show iteration count, e.g., "3/5 iterations complete" OR "All iterations complete - task ready to close"]
    ```

**Output**: Update .flow/PLAN.md with completion status, summary, Dashboard update, and clear next-step guidance.

```

---

## /flow-status

<!-- MCP_METADATA
function_name: flow_status
category: navigation_query
parameters: []
returns: dict[str, Any]
plan_operations: [READ]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-status.md`

```markdown
---
description: Show current position and verify plan consistency
---

You are executing the `/flow-status` command from the Flow framework.

**Purpose**: Show current position in the plan and verify active work consistency.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**
- Dashboard-first approach using grep-based pattern matching
- Reduces token usage by 95% (from 32,810 → ~1,530 tokens for large files)
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 2015-2314 for dashboard structure reference

**PERFORMANCE NOTE**: This is the reference model for Category B commands - uses targeted greps instead of reading entire framework.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Read Progress Dashboard ONLY** (Dashboard-first approach):
   ```bash
   # Use Grep to read ONLY the Progress Dashboard section (~50 lines)
   Grep pattern: "^## 📋 Progress Dashboard"
   Use -A 20 flag to read ~20 lines after match
```

Extract from Dashboard text:

- Last Updated timestamp
- Current Phase number and name
- Current Task number and name
- Current Iteration number and name
- Current status (⏳ PENDING / 🚧 IMPLEMENTING / 🎨 READY / etc)
- Completion percentages

3.  **Verify current markers** (micro integrity - current work only):

    Use 3 targeted Greps to verify ONLY the current items claimed by Dashboard:

    **Grep 1 - Verify Current Phase**:

    ```bash
    # If Dashboard says "Phase 2", verify Phase 2 marker
    pattern: "^### Phase 2:"
    Use -A 2 to read status line
    Extract: Status emoji (⏳ 🚧 🎨 ✅ ❌ 🔮)
    ```

    **Grep 2 - Verify Current Task**:

    ```bash
    # If Dashboard says "Task 4", verify Task 4 marker
    pattern: "^#### Task 4:"
    Use -A 2 to read status line
    Extract: Status emoji
    ```

    **Grep 3 - Verify Current Iteration**:

    ```bash
    # If Dashboard says "Iteration 6", verify Iteration 6 marker
    pattern: "^##### Iteration 6:"
    Use -A 2 to read status line
    Extract: Status emoji
    ```

    **Grep 4 - Check for Pre-Implementation Tasks**:

    ```bash
    # Check if current iteration has pre-implementation tasks
    pattern: "^### \*\*Pre-Implementation Tasks:\*\*$"
    Search within current iteration scope

    If found:
      Count pending: grep -c "^#### ⏳ Task [0-9]"
      Count complete: grep -c "^#### ✅ Task [0-9]"
      Extract task names and numbers for reporting

    Use awk to scope search to current iteration:
    awk '/^##### Iteration X\.Y:.*🚧/,/^#####[^#]|^####[^#]/ {print}' PLAN.md
    ```

    **Grep 5 - Check Unresolved Brainstorming Subjects**:

    ```bash
    # Check if iteration has unresolved subjects
    Extract "Subjects to Discuss" section:
    awk '/\*\*Subjects to Discuss\*\*:/,/\*\*Resolved Subjects\*\*:/ {print}'

    Count unresolved: grep -c "^[0-9]\+\. ⏳"

    If any unresolved:
      Extract subject names for reporting
    ```

4.  **Micro integrity check** (active work only):

    - Compare Dashboard claims vs actual markers for current phase/task/iteration
    - **Skip all ✅ COMPLETE items** - Already verified, now frozen
    - Report verification results:

      ```
      🔍 Consistency Check (Current Work Only):

      ✅ Phase 2 marker: 🚧 IN PROGRESS ✓
      ✅ Task 4 marker: 🚧 IN PROGRESS ✓
      ✅ Iteration 6 marker: 🚧 IMPLEMENTING ✓

      Status: Dashboard aligned with markers ✓
      ```

5.  **If inconsistency detected**:

    ```
    ⚠️  INCONSISTENCY DETECTED:

    Dashboard claims: Iteration 6 🚧 IMPLEMENTING
    Actual marker:    Iteration 6 ⏳ PENDING

    Action: Update Progress Dashboard to match markers
    (Status markers are ground truth, Dashboard is pointer)
    ```

6.  **Display current position**:

    ```
    📋 Current Position:

    Phase [N]: [Name] [Status]
      └─ Task [N]: [Name] [Status]
          └─ Iteration [N]: [Name] [Status]

    🔍 Current Phase: [Detailed phase description]

    [If in brainstorming with unresolved subjects:]
    - Brainstorming subjects: ⏳ In progress (X/Y resolved)
      - ⏳ Subject Name 1
      - ⏳ Subject Name 2

    [If in brainstorming with pre-tasks:]
    - Brainstorming subjects: ✅ All resolved
    - Pre-implementation tasks: ⏳ In progress (X/Y complete)
      - ✅ Task 1: Name
      - ⏳ Task 2: Name (NEXT)
      - ⏳ Task 3: Name

    Last Updated: [Timestamp from Dashboard]
    ```

7.  **Suggest next action** (comprehensive decision tree):

    **Step 1: Check task status first**

    **If current task is ✅ COMPLETE**:
    → "Task complete! Use `/flow-task-start` [optional: task number] to begin next task"
    → Display next pending task if available: "Next: Task [N]: [Name]"
    → If all tasks in phase complete: "All tasks complete! Use `/flow-phase-complete` to mark phase done"

    **Step 2: Check iteration status marker**

    **If ⏳ PENDING**:
    → "Use `/flow-brainstorm-start [topics]` to begin brainstorming"

    **If 🚧 IN PROGRESS**:
    **Step 3: Determine which phase** (check in this order):

    A. **Check for unresolved subjects** (from Grep 5):
    If unresolved subjects exist:
    → "Continue with `/flow-next-subject` to resolve next subject"
    Display: Show count and list unresolved subject names

    B. **Check for pre-implementation tasks** (from Grep 4):
    If pre-tasks section exists:
    Count pending pre-tasks

         If any pending (⏳):
           → "Continue with Task X: [Name]" (show next pending pre-task)
           Display: "Pre-implementation tasks: [X/Y] complete"

         If all complete (✅):
           → "Pre-implementation tasks complete. Use `/flow-brainstorm-complete` to mark brainstorming done"

    C. **Check for Implementation section**:
    If "### **Implementation**" section exists:
    → "Continue main implementation. Use `/flow-implement-complete` when done"

    D. **Default** (subjects resolved, no pre-tasks, no implementation yet):
    → "Use `/flow-brainstorm-complete` to finish brainstorming"

    **If 🎨 READY**:
    → "Use `/flow-implement-start` to begin implementation"

    **If ✅ COMPLETE**:
    → "Use `/flow-iteration-add [description]` to start next iteration"

8.  **Show completion summary** (from Dashboard percentages):
    - Display Phase completion percentage
    - Display Task completion percentage
    - Display overall project completion

**Key Differences from `/flow-summarize`**:

- `/flow-status` = **Micro scope** (current work only, ~1,530 tokens)
- `/flow-summarize` = **Macro scope** (entire project tree, higher token usage)
- Both verify integrity at their respective scopes

**Output**: Display current position, micro verification results, next action suggestion.

```

---

## /flow-summarize

<!-- MCP_METADATA
function_name: flow_summarize
category: navigation_query
parameters: []
returns: dict[str, Any]
plan_operations: [READ]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-summarize.md`

```markdown
---
description: Generate summary of all phases/tasks/iterations
---

You are executing the `/flow-summarize` command from the Flow framework.

**Purpose**: Generate high-level overview of entire project structure and completion state.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**
- Uses PLAN.md structure only (no framework knowledge needed)
- Parses all phases/tasks/iterations with status markers
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 105-179 for hierarchy context

**Context**:
- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Use case**: "Bird's eye view" of project health, progress across all phases, quick status reports

**Comparison to other commands**:
- `/flow-status` = "Where am I RIGHT NOW?" (micro view - current iteration)
- `/flow-summarize` = "What's the WHOLE PICTURE?" (macro view - all phases/tasks/iterations)
- `/flow-verify-plan` = "Is this accurate?" (validation)
- `/flow-compact` = "Transfer full context" (comprehensive handoff)

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Parse entire PLAN.md structure**:
   - Extract Version (from metadata at top)
   - Extract current Status line (from metadata)
   - Parse ALL phases with their status markers
   - For each phase, parse ALL tasks
   - For each task, parse ALL iterations
   - Track completion percentages at each level

3. **Generate structured summary** (compact, scannable format):

```

📊 Flow Summary

Version: [V1/V2/V3]
Status: [Current phase/task/iteration from metadata]

Phase [N]: [Name] [Status] [%]

- Task [N]: [Name] [Status]
  - Iter [N-N] [Status]: [Concise description]
  - Iter [N] 🚧 CURRENT: [What you're working on]
  - Iter [N] ⏳: [What's next]

Phase [N]: [Name] [Status] [%]

- Task [N-N]: [Grouped if similar] [Status]
- Task [N]: [Name] [Status]

Deferred to V2:

- [Iteration/feature name]
- [Iteration/feature name]

---

TL;DR: [One punchy sentence about overall state]

```

4. **Formatting rules**:
- **Compact**: Group consecutive completed iterations (e.g., "Iter 1-5 ✅")
- **Scannable**: Use emojis (✅ ⏳ 🚧 🎨) and percentages prominently
- **Highlight**: Mark CURRENT work explicitly in bold or with flag
- **Indent**: Phase (no indent), Task (- prefix), Iteration (-- or nested -)
- **Defer section**: Show V2/future items at bottom
- **Skip noise**: Don't list every task name if they're obvious/sequential
- **Focus on active work**: Emphasize in-progress and next items

5. **Example output** (payment gateway):

```

📊 Flow Summary

Version: V1
Status: Phase 2, Task 5, Iteration 2 - In Progress

Phase 1: Foundation ✅ 100%

- Task 1-2: Setup, API, Database schema ✅

Phase 2: Core Implementation 🚧 75%

- Task 3-4: Payment processing, Webhooks ✅
- Task 5: Error Handling
  - Iter 1 ✅: Retry logic
  - Iter 2 🚧 CURRENT: Circuit breaker
  - Iter 3 ⏳: Dead letter queue

Phase 3: Testing & Integration ⏳ 0%

- Task 6: Integration tests (pending)

Deferred to V2:

- Advanced features (monitoring, metrics)
- Name generation

---

TL;DR: Foundation done, core payment flow working, currently building circuit breaker for error handling.

```

**Example output** (RED project - showing V1/V2 split):

```

📊 Flow Summary - RED Ability Generation

=== V1 - Core System ===

Phase 1: Foundation ✅ 100%

- Task 1-4: Constants, enums, types, refactoring ✅

Phase 2: Core Implementation 🚧 85%

- Iter 1-5 ✅: Tier gen, slots, filtering, selection, template parsing
- Iter 6 🚧 NEXT: Green.generate() integration (ties everything together)
- Iter 7 ⏳: Blue validation (input guards)
- Iter 9 ⏳ LAST: Red API wrapper (exposes Blue → Green)

Phase 3: Testing

- Script-based testing (Blue → Green flow)

Deferred to V2:

- Iter 8: Name generation (stub returns "Generated Ability")
- Database persistence
- Stats-based damage calculations

=== V2 - Enhanced System (Phase 4) ===

Enhancements:

- Potency system (stats × formulas replace fixed damage)
- Name generation (124 weighted prefix/suffix combos)
- 12 new placeholders (conditionals, resources, targeting)
- Damage variance (±10% for crits)
- Points & Luck systems
- Database persistence

---

TL;DR:
V1 = Basic working system with hardcoded damage ranges (85% done, integration next)
V2 = Dynamic formulas, character stats integration, full feature set

```

6. **Add deferred/cancelled sections**:
```

🔮 Deferred Items:

- Iteration 10: Name Generation (V2 - complexity, needs 124 components)
- Task 12: Advanced Features (V2 - out of V1 scope)
- Feature X: Multi-provider support (V3 - abstraction layer)

❌ Cancelled Items:

- Task 8: Custom HTTP Client (rejected - SDK is better)
- Subject 3: GraphQL API (rejected - REST is sufficient)

```

7. **Smart verification** (active work only):
- Skip ✅ COMPLETE items (verified & frozen)
- Verify 🚧 ⏳ 🎨 items match Progress Dashboard
- Check ❌ items have reasons
- Check 🔮 items have reasons + destinations
- Report:
  ```
  🔍 Verification (Active Work Only):
  ✅ All active markers (🚧 ⏳) match Progress Dashboard
  ⏭️  Skipped 18 completed items (verified & frozen)
  ```

8. **Handle multiple versions**:
- If PLAN.md has V2/V3 sections, use `=== V1 Summary ===` separator
- V1 gets full Phase/Task/Iteration breakdown
- V2+ get high-level "Enhancements" list (not full iteration tree)
- Separate TL;DR line for each version

9. **After generating summary**:
- "Use `/flow-status` to see detailed current position"
- "Use `/flow-verify-plan` to verify accuracy against actual code"

**Manual alternative**:
- Read entire PLAN.md manually
- Create outline of all phases/tasks/iterations
- Count completions and calculate percentages
- Format into hierarchical view

**Output**: Hierarchical summary of entire project structure with completion tracking.
```

---

## /flow-next-subject

<!-- MCP_METADATA
function_name: flow_next_subject
category: navigation_query
parameters: []
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-next-subject.md`

```markdown
---
description: Discuss next subject, capture decision, and mark resolved
---

You are executing the `/flow-next-subject` command from the Flow framework.

**Purpose**: Show next unresolved subject, present options collaboratively, wait for user decision, then mark as ✅ resolved.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: DEVELOPMENT_FRAMEWORK.md lines 1-544 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Subject Resolution Types (lines 108-132) - Types A/B/C/D decision matrix
- **Deep dive if needed**: Read lines 1570-1680 for Subject Resolution details using Read(offset=1570, limit=110)

**Framework Reference**: This command requires framework knowledge to properly categorize resolution types. See Quick Reference guide above for essential patterns.

**🚨 SCOPE BOUNDARY RULE** (CRITICAL - see DEVELOPMENT_FRAMEWORK.md lines 339-540):

If you discover NEW issues while discussing subjects that are NOT part of the current iteration:

1. **STOP** immediately - Don't make assumptions or proceed
2. **NOTIFY** user - Present discovered issue(s) with structured analysis
3. **DISCUSS** - Provide structured options (A/B/C/D format):
   - **A**: Create pre-implementation task (< 30 min work, blocking)
   - **B**: Add as new brainstorming subject (design needed)
   - **C**: Handle immediately (only if user approves)
   - **D**: Defer to separate iteration (after current work)
4. **AWAIT USER APPROVAL** - Never proceed without explicit user decision

**Use the Scope Boundary Alert Template** (see DEVELOPMENT_FRAMEWORK.md lines 356-390)

**Why This Matters**: User stays in control of priorities. AI finds issues proactively but doesn't make scope decisions.

**New Collaborative Workflow** (two-phase approach):
```

Phase 1 (Present):
/flow-next-subject → present subject + options → ask user → 🛑 STOP & WAIT

Phase 2 (Capture - triggered by user response):
User responds → capture decision → document → mark ✅ → auto-advance to next

```

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current brainstorming session**: Look for "Subjects to Discuss" section

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

   **Step D: Document resolution**
   - Mark subject ✅ in "Subjects to Discuss" list
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
   - Update PLAN.md with resolution
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

**Output**: Update .flow/PLAN.md with subject resolution and show next subject.
```

---

## /flow-next-iteration

<!-- MCP_METADATA
function_name: flow_next_iteration
category: navigation_query
parameters: []
returns: dict[str, Any]
plan_operations: [READ]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-next-iteration.md`

```markdown
---
description: Show next iteration details
---

You are executing the `/flow-next-iteration` command from the Flow framework.

**Purpose**: Display details about the next pending iteration in the current task.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**

- Finds next ⏳ PENDING iteration in current task
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 567-613 for iteration context

**Pattern**: Works like `/flow-next-subject` but for iterations - shows what's coming next.

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current task**: Look for task marked 🚧 IN PROGRESS

3. **Find next pending iteration**: Look for first iteration in current task marked ⏳ PENDING

4. **If found, display iteration details**:
```

📋 Next Iteration:

**Iteration [N]**: [Name]

**Goal**: [What this iteration builds]

**Status**: ⏳ PENDING

**Approach**: [Brief description from iteration section if available]

---

Ready to start? Use `/flow-brainstorm-start [topic]` to begin.

```

5. **If NOT found (no pending iterations)**:
- Check if current iteration is in progress: "Still working on Iteration [N]: [Name]. Use `/flow-implement-complete` when done."
- Otherwise: "No more iterations in current task. Use `/flow-iteration-add [description]` to create next iteration, or `/flow-task-complete` if task is done."

6. **Show progress**: "Iteration [current] of [total] in current task"

**Output**: Display next iteration details and suggest appropriate next action.
```

---

## /flow-next

<!-- MCP_METADATA
function_name: flow_next
category: navigation_query
parameters: []
returns: dict[str, Any]
plan_operations: [READ]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-next.md`

```markdown
---
description: Smart helper - suggests next action based on current context
---

You are executing the `/flow-next` command from the Flow framework.

**Purpose**: Auto-detect current context and suggest the next logical step.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**

- Smart navigation using Dashboard and current context
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 3277-3356 for decision tree reference

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Determine current context**:

   - Check current iteration status (⏳ 🚧 🎨 ✅)
   - Check if in brainstorming session:
     - Look for "Subjects to Discuss" section
     - Count unresolved subjects: grep -c "^[0-9]\+\. ⏳"
   - Check for pre-implementation tasks:
     - Look for "### **Pre-Implementation Tasks:**" section
     - Count pending: grep -c "^#### ⏳ Task [0-9]"
     - Count complete: grep -c "^#### ✅ Task [0-9]"
   - Check if in main implementation (look for "### **Implementation**" section)

3. **Suggest next command based on context**:

   **Determine exact state**:

   **If status = ⏳ PENDING**:
   → "Use `/flow-brainstorm-start [topic]` to begin this iteration"

   **If status = 🚧 IN PROGRESS**:
   **Check phase progression** (in this order):

   1. **Check unresolved subjects**:
      If any "⏳" subjects in "Subjects to Discuss":
      → "Use `/flow-next-subject` to resolve next subject"
      Show: "X subjects remaining: [list]"

   2. **Check pre-implementation tasks**:
      If "### **Pre-Implementation Tasks:**" section exists:
      Count pending tasks (^#### ⏳)

      If pending > 0:
      → "Continue with Task X: [Name]"
      Show: "[X/Y] pre-implementation tasks complete"

      If pending = 0:
      → "Pre-implementation complete. Use `/flow-brainstorm-complete`"

   3. **Check main implementation**:
      If "### **Implementation**" section exists:
      → "Continue main implementation"
      Show: "Use `/flow-implement-complete` when done"

   4. **Default** (subjects resolved, no pre-tasks):
      → "Use `/flow-brainstorm-complete` to finish brainstorming"

   **If status = 🎨 READY**:
   → "Use `/flow-implement-start` to begin implementation"

   **If status = ✅ COMPLETE**:
   → "Use `/flow-next-iteration` to move to next iteration"

4. **Show current status summary**: Brief summary of where you are

**Output**: Suggest appropriate next command based on context.
```

---

## /flow-rollback

<!-- MCP_METADATA
function_name: flow_rollback
category: maintenance
parameters: []
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-rollback.md`

```markdown
---
description: Undo last plan change
---

You are executing the `/flow-rollback` command from the Flow framework.

**Purpose**: Undo the last change made to PLAN.md.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**

- Undoes last change using Changelog section
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 1969-2014 for rollback patterns

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Check if rollback is possible**:

   - Look for "Changelog" section at bottom of PLAN.md
   - If no recent changes logged: "No recent changes to rollback."

3. **Identify last change**:

   - Parse last entry in Changelog
   - Determine what was changed (phase added, task marked complete, etc.)

4. **Ask for confirmation**:

   - "Last change: [Description of change]. Rollback? (yes/no)"

5. **If confirmed, revert change**:

   - Remove last added section, OR
   - Change status marker back to previous state, OR
   - Uncheck last checked checkbox

6. **Update Changelog**: Add rollback entry

7. **Confirm to user**: "Rolled back: [Description of change]"

**Limitation**: Can only rollback one step at a time. For major reverts, manually edit PLAN.md.

**Output**: Revert last change in PLAN.md.
```

---

## /flow-verify-plan

<!-- MCP_METADATA
function_name: flow_verify_plan
category: maintenance
parameters: []
returns: dict[str, Any]
plan_operations: [READ]
framework_reading_required: true
framework_sections:
  - Quick Reference (lines 1-544)
  - Plan File Template (lines 2731-2928)
MCP_METADATA_END -->

**File**: `flow-verify-plan.md`

```markdown
---
description: Verify plan file matches actual codebase state
---

You are executing the `/flow-verify-plan` command from the Flow framework.

**Purpose**: Verify that PLAN.md is synchronized with the actual project state.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: DEVELOPMENT_FRAMEWORK.md lines 1-544 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Framework Structure validation (lines in Quick Reference)
- **Deep dive if needed**: Read lines 105-179 for Framework Structure using Read(offset=105, limit=75)

**Context**:

- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Use case**: Run before starting new AI session or compacting conversation to ensure context is accurate

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current iteration**: Look for iteration marked 🚧 IN PROGRESS or 🎨 READY FOR IMPLEMENTATION

3. **Read current implementation section**:

   - Find "Implementation - Iteration [N]" section
   - Identify all action items
   - Note which items are marked as ✅ complete

4. **Verify claimed completions against actual project state**:

   - For each ✅ completed action item, check if it actually exists:
     - "Create UserAuth.ts" → Verify file exists
     - "Add login endpoint" → Search for login endpoint in code
     - "Update database schema" → Check schema files
   - List any discrepancies found

5. **Check for unreported work**:

   - Look for modified files that aren't mentioned in PLAN.md
   - Check git status (if available) for uncommitted changes
   - Identify files that were changed but not documented

6. **Report findings**:
```

📋 Plan Verification Results:

✅ Verified Complete:

- [List action items that are correctly marked complete]

❌ Discrepancies Found:

- [List action items marked complete but evidence not found]

📝 Unreported Work:

- [List files changed but not mentioned in PLAN.md]

Status: [SYNCHRONIZED / NEEDS UPDATE]

```

7. **If discrepancies found**:
- Ask user: "PLAN.md is out of sync with project state. Update .flow/PLAN.md now? (yes/no)"
- If yes: Update .flow/PLAN.md to reflect actual state:
  - Uncheck items that aren't actually done
  - Add notes about files modified
  - Update status markers if needed
- If no: "Review discrepancies above and update PLAN.md manually."

8. **If synchronized**:
- "PLAN.md is synchronized with project state. Ready to continue work."

**Manual alternative**:
- Review PLAN.md action items manually
- Check each completed item exists in codebase
- Use `git status` and `git diff` to verify changes
- Update .flow/PLAN.md to match reality

**Output**: Verification report and optional PLAN.md updates.
```

---

## /flow-compact

<!-- MCP_METADATA
function_name: flow_compact
category: maintenance
parameters: []
returns: dict[str, Any]
plan_operations: [READ]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-compact.md`

```markdown
You are executing the `/flow-compact` command from the Flow framework.

**Purpose**: Generate comprehensive conversation report for context transfer to new AI instance.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**

- Generates comprehensive report using PLAN.md content and `/flow-status` logic
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 2327-2362 for context preservation patterns

**Context**:

- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Use case**: Before compacting conversation or starting new AI session - ensures zero context loss

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Run status verification first**:

   - Execute `/flow-status` command logic to verify current position
   - Check for conflicting status sections (warn if found)
   - Use this verified status as authoritative source for the report

3. **Generate comprehensive report covering**:

   **Current Work Context**:

   - What feature/task are we working on?
   - What phase/task/iteration are we in? (with status)
   - What was the original goal?

   **Conversation History**:

   - What decisions were made during brainstorming? (with rationale)
   - What subjects were discussed and resolved?
   - What pre-implementation tasks were identified and completed?
   - What action items were generated?

   **Implementation Progress**:

   - What has been implemented so far?
   - What files were created/modified?
   - What verification was done?
   - What remains incomplete?

   **Challenges & Solutions**:

   - What blockers were encountered?
   - How were they resolved?
   - What design trade-offs were made?

   **Next Steps**:

   - What is the immediate next action?
   - What are the pending action items?
   - What should the next AI instance focus on?

   **Important Context**:

   - Any quirks or special considerations for this feature
   - Technical constraints or dependencies
   - User preferences or decisions that must be preserved

4. **Report format**:
```

# Context Transfer Report

## Generated: [Date/Time]

## Current Status

[Phase/Task/Iteration with status markers]

## Feature Overview

[What we're building and why]

## Conversation Summary

[Chronological summary of discussions and decisions]

## Implementation Progress

[What's done, what's in progress, what's pending]

## Key Decisions & Rationale

[Critical decisions made with reasoning]

## Files Modified

[List with brief description of changes]

## Challenges Encountered

[Problems and how they were solved]

## Next Actions

[Immediate next steps for new AI instance]

## Critical Context

[Must-know information for continuation]

```

5. **Important guidelines**:
- **Do NOT include generic project info** (tech stack, architecture overview, etc.)
- **Focus ENTIRELY on the feature at hand** and this conversation
- **Do NOT worry about token output length** - comprehensive is better than brief
- **Include WHY, not just WHAT** - decisions need context
- **Be specific** - reference exact file names, function names, line numbers
- **Preserve user preferences** - if user made specific choices, document them

6. **After generating report**:
- "Context transfer report generated. Copy this report to a new AI session to continue work with zero context loss."
- "Use `/flow-verify-plan` before starting new session to ensure PLAN.md is synchronized."

**Manual alternative**:
- Read entire conversation history manually
- Summarize key points, decisions, and progress
- Document in separate notes file
- Reference PLAN.md for structure

**Output**: Comprehensive context transfer report.
```

---

## Installation Instructions

To use these commands:

1. **Copy individual command files** to `.claude/commands/`:

   ```bash
   mkdir -p .claude/commands
   # Copy each command section above into separate .md files
   # Example: flow-blueprint.md, flow-phase.md, etc.
   ```

2. **Or use the copy-paste method**:

   - Copy the content between the code blocks for each command
   - Create corresponding `.md` files in `.claude/commands/`
   - File names should match command names (e.g., `flow-blueprint.md`)

3. **Test with `/help`**: Run `/help` in Claude Code to see your new commands listed

---

## Command Execution Flow

```
/flow-blueprint
    ↓
Creates PLAN.md with skeleton
    ↓
/flow-brainstorm_start
    ↓
/flow-brainstorm-subject (repeat as needed)
    ↓
/flow-brainstorm_resolve (for each subject)
    ↓
Complete pre-implementation tasks (if any)
    ↓
/flow-brainstorm_complete
    ↓
/flow-implement-start
    ↓
Work through action items (check them off)
    ↓
/flow-implement-complete
    ↓
Repeat for next iteration
```

**Helper commands** available at any time:

- `/flow-status` - Check current position
- `/flow-next` - Auto-advance to next step
- `/flow-rollback` - Undo last change
- `/flow-phase-add`, `/flow-task-add`, `/flow-iteration-add` - Add structure as needed
- `/flow-plan-split` - Archive old completed tasks to reduce PLAN.md size

---

## /flow-plan-split

<!-- MCP_METADATA
function_name: flow_plan_split
category: maintenance
parameters: []
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-plan-split.md`

```markdown
---
description: Archive old completed tasks to reduce PLAN.md size
---

You are executing the `/flow-plan-split` command from the Flow framework.

**Purpose**: Archive old completed tasks outside the recent context window to `.flow/ARCHIVE.md`, reducing PLAN.md size while preserving full project history.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**

- Archives completed tasks to ARCHIVE.md (keeps recent 3 tasks in PLAN.md)
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 2363-2560 for archival patterns

**Context**:

- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Archive File**: .flow/ARCHIVE.md (created/appended)

**When to Use**: When PLAN.md exceeds 2000 lines or has 10+ completed tasks, causing performance issues or difficult navigation.

**Archiving Strategy - Recent Context Window**:

- **Keep in PLAN.md**: Current task + 3 previous tasks (regardless of status)
- **Archive to ARCHIVE.md**: All ✅ COMPLETE tasks older than "current - 3"
- **Always Keep**: Non-complete tasks (⏳ 🚧 ❌ 🔮) regardless of age

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Find current task number**:

   - Read Progress Dashboard to identify current task
   - Extract task number (e.g., if "Task 13" is current, task number = 13)

3. **Calculate archiving threshold**:

   - Threshold = Current task number - 3
   - Example: Current = 13, Threshold = 10
   - **Archive candidates**: Tasks 1-9 (if ✅ COMPLETE)
   - **Keep in PLAN.md**: Tasks 10, 11, 12, 13 (current + 3 previous)

4. **Extract archivable tasks**:

   - Find all tasks with number < threshold AND status = ✅ COMPLETE
   - Extract FULL task content:
     - Task header and metadata
     - All iterations (brainstorming, implementation, verification)
     - All nested content
   - **IMPORTANT**: Keep tasks that are ❌ ⏳ 🚧 🔮 even if old (incomplete work stays visible)

5. **Create or append to ARCHIVE.md**:

   **If .flow/ARCHIVE.md does NOT exist** (first split):

   ```markdown
   # Project Archive

   This file contains completed tasks that have been archived from PLAN.md to reduce file size.

   **Archive Info**:

   - All content preserved (nothing deleted)
   - Organized by Phase → Task → Iteration
   - Reference: See PLAN.md Progress Dashboard for full project history

   **Last Updated**: [Current date]
   **Tasks Archived**: [Count]

   ---

   [Archived task content here - preserve phase structure]
   ```
```

**If .flow/ARCHIVE.md ALREADY exists** (subsequent split):

- Read existing ARCHIVE.md
- Update "Last Updated" and "Tasks Archived" count
- Append new archived tasks to appropriate phase sections
- Maintain phase hierarchy (don't duplicate phase headers if they exist)

6. **Update PLAN.md**:

   **A. Remove archived task content**:

   - Delete full task sections for archived tasks from Development Plan
   - Preserve phase headers (even if all tasks archived)

   **B. Update Progress Dashboard**:

   - Add 📦 marker to archived tasks
   - Format: `- ✅📦 Task 5: Feature Name (archived)`
   - Keep full project history visible in Progress Overview

   **C. Update phase headers** (if all tasks archived):

   ```markdown
   ### Phase 1: Foundation Setup ✅

   **Status**: COMPLETE (tasks archived)
   **Completed**: [Date]
   **Tasks**: [Count] tasks (📦 archived)
   ```

7. **Verify and confirm**:

   - Count lines before/after (use `wc -l`)
   - Calculate reduction: `before - after = saved lines`
   - Confirm to user:

     ```
     ✅ Plan split complete!

     **Archived**: X tasks to .flow/ARCHIVE.md
     **PLAN.md size**: Reduced from Y lines to Z lines (-W lines, -P%)
     **Recent context**: Kept Task [threshold] through Task [current]

     Your Progress Dashboard still shows complete project history.
     Archived content available in .flow/ARCHIVE.md
     ```

**Edge Cases**:

- **No old completed tasks**: "No tasks to archive. All completed tasks are within recent context window (current + 3 previous)."
- **Current task < 4**: "Current task is Task [N]. Need at least Task 4 to enable archiving (keeps current + 3 previous)."
- **Non-complete old tasks**: Keep them in PLAN.md with note: "Task [N] kept in PLAN.md (not complete - status: [status])"

**Output**: Update .flow/PLAN.md (reduced) and create/append .flow/ARCHIVE.md (full history preserved).

```

---

## /flow-backlog-add

<!-- MCP_METADATA
function_name: flow_backlog_add
category: backlog
parameters:
  - name: task_numbers
    type: str
    required: true
    description: Task number(s) to move to backlog (e.g. '14' or '14-22')
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-backlog-add.md`

```markdown
---
description: Move task(s) to backlog to reduce active plan clutter
---

You are executing the `/flow-backlog-add` command from the Flow framework.

**Purpose**: Move pending tasks from PLAN.md to BACKLOG.md to reduce active plan size while preserving all task context (iterations, brainstorming, everything).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md**

- Moves full task content to backlog (token efficiency feature)
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 3407-3682 for backlog management patterns

**Context**:

- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Backlog File**: .flow/BACKLOG.md (created/updated)

**Key Insight**: Backlog is for **token efficiency**, not prioritization. Tasks aren't "low priority" - they're just "not now" (weeks/months away).

**Signature**: `/flow-backlog-add <task-number>` or `/flow-backlog-add <start>-<end>`

**Examples**:
- `/flow-backlog-add 14` - Move Task 14 to backlog
- `/flow-backlog-add 14-22` - Move Tasks 14 through 22 to backlog

**Instructions**:

1. **Find .flow/PLAN.md**: Look for .flow/PLAN.md (primary location: .flow/ directory)

2. **Parse arguments**:
   - Single task: `$ARGUMENTS` = task number (e.g., "14")
   - Range: `$ARGUMENTS` = start-end (e.g., "14-22")
   - Extract task number(s) to move

3. **Validate tasks**:
   - Verify each task exists in PLAN.md
   - Check task status - warn if moving tasks that are 🚧 IN PROGRESS or ✅ COMPLETE
   - Recommended: Only move ⏳ PENDING tasks
   - If user confirms moving non-pending tasks, proceed

4. **Extract full task content from PLAN.md**:
   - For each task number, extract COMPLETE task section:
     - Task header: `#### Task [N]: [Name] [Status]`
     - All task metadata (Status, Purpose, etc.)
     - ALL iterations (full content with brainstorming, implementation, verification)
     - ALL nested content (pre-tasks, bugs discovered, etc.)
   - Use awk range extraction:
     ```bash
     awk '/^#### Task 14:/,/^####[^#]|^###[^#]/ {print}' PLAN.md
     ```

5. **Create or update .flow/BACKLOG.md**:

   **If BACKLOG.md does NOT exist** (first time):

   ```markdown
   # Project Backlog

   This file contains tasks moved from PLAN.md to reduce active plan size while preserving all context.

   **Backlog Info**:
   - Tasks retain original numbers for easy reference
   - Full content preserved (brainstorming, iterations, everything)
   - Pull tasks back to active plan when ready to work on them

   **Last Updated**: [Current date]
   **Tasks in Backlog**: [Count]

   ---

   ## 📋 Backlog Dashboard

   **Tasks Waiting**:
   - **Task [N]**: [Name]
   - **Task [N]**: [Name]

   ---

   ### Phase [N]: [Phase Name from PLAN.md]

   [Extracted task content here - preserve original task numbers]
   ```

   **If BACKLOG.md ALREADY exists**:
   - Read existing BACKLOG.md
   - Update "Last Updated" timestamp
   - Update "Tasks in Backlog" count
   - Add tasks to Backlog Dashboard list
   - Append task content to appropriate phase section
   - Maintain phase hierarchy (don't duplicate phase headers if they exist)

6. **Update PLAN.md**:

   **A. Remove task content**:
   - Delete full task sections for backlogged tasks
   - Leave gap in task numbering (don't renumber)
   - Add comment marking removal:
     ```markdown
     [Task 14 moved to backlog - see .flow/BACKLOG.md]
     [Task 15 moved to backlog - see .flow/BACKLOG.md]
     ```

   **B. Do NOT update Progress Dashboard**:
   - Backlog tasks are invisible to dashboard (no 📦 marker)
   - Keep task numbers in dashboard but mark as moved:
     ```markdown
     - ⏳ Task 14: Potency system (moved to backlog)
     ```
   - Or simply remove from dashboard (user preference)

7. **Reset task status to ⏳ PENDING** (in BACKLOG.md):
   - All backlogged tasks reset to ⏳ PENDING
   - Fresh start when pulled back

8. **Verify and confirm**:
   - Count lines before/after PLAN.md (use `wc -l`)
   - Calculate reduction
   - Confirm to user:

     ```
     ✅ Moved to backlog!

     **Backlogged**: [N] task(s) to .flow/BACKLOG.md
     **PLAN.md size**: Reduced from Y lines to Z lines (-W lines, -P%)
     **Tasks moved**: Task [list of numbers]

     Use `/flow-backlog-view` to see backlog contents.
     Use `/flow-backlog-pull <task-number>` to bring a task back when ready.
     ```

**Edge Cases**:
- **Task doesn't exist**: "Task [N] not found in PLAN.md"
- **Invalid range**: "Invalid range format. Use: /flow-backlog-add 14-22"
- **Empty range**: "No tasks found in range 14-22"
- **Already in backlog**: Check BACKLOG.md first, warn if task already there

**Output**: Update .flow/PLAN.md (reduced), create/update .flow/BACKLOG.md (tasks preserved).

```

---

## /flow-backlog-view

<!-- MCP_METADATA
function_name: flow_backlog_view
category: backlog
parameters: []
returns: dict[str, Any]
plan_operations: [READ]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-backlog-view.md`

```markdown
---
description: Show backlog contents (tasks waiting)
---

You are executing the `/flow-backlog-view` command from the Flow framework.

**Purpose**: Display backlog dashboard showing all tasks currently in backlog.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from BACKLOG.md**

- Simple read operation (shows backlog dashboard)
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 3407-3682 for backlog context

**Context**:

- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Backlog File**: .flow/BACKLOG.md (read-only for this command)

**Instructions**:

1. **Check if .flow/BACKLOG.md exists**:
   - If NOT found: "📦 Backlog is empty. Use `/flow-backlog-add <task>` to move tasks from active plan."
   - If found: Proceed to step 2

2. **Read Backlog Dashboard section**:
   - Use Grep to extract dashboard:
     ```bash
     grep -A 20 "^## 📋 Backlog Dashboard" BACKLOG.md
     ```
   - Extract task list from "Tasks Waiting" section

3. **Parse backlog metadata**:
   - Extract "Last Updated" timestamp
   - Extract "Tasks in Backlog" count
   - Parse task list (task numbers and names)

4. **Display backlog contents**:

   ```
   📦 Backlog Contents ([N] tasks):

   **Last Updated**: [Date]

   **Tasks Waiting**:
   - **Task 14**: Potency system
   - **Task 15**: Points & Luck systems
   - **Task 16**: Database persistence
   - **Task 17**: Damage variance
   - **Task 18**: Game integration
   - **Task 19**: Attribute Guarantee - HIGH
   - **Task 20**: Context Modifiers - CRITICAL
   - **Task 21**: Affix Synergy - MEDIUM
   - **Task 22**: Retry Handler - HIGH

   ---

   **Next Steps**:
   - Use `/flow-backlog-pull <task-number>` to move a task back to active plan
   - Example: `/flow-backlog-pull 14` brings Task 14 back as next task in active phase
   ```

5. **Optional: Show task details** (if user wants more info):
   - Can read full task content from BACKLOG.md on request
   - Default view is just dashboard (lightweight)

**Output**: Display backlog dashboard with task list and guidance.

```

---

## /flow-backlog-pull

<!-- MCP_METADATA
function_name: flow_backlog_pull
category: backlog
parameters:
  - name: task_number
    type: str
    required: true
    description: Task number to pull from backlog
  - name: position
    type: str
    required: false
    default: ""
    description: Optional positioning instruction
returns: dict[str, Any]
plan_operations: [READ, WRITE]
framework_reading_required: false
MCP_METADATA_END -->

**File**: `flow-backlog-pull.md`

```markdown
---
description: Pull task from backlog back into active plan
---

You are executing the `/flow-backlog-pull` command from the Flow framework.

**Purpose**: Move a task from BACKLOG.md back to PLAN.md with sequential renumbering in active phase.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from PLAN.md and BACKLOG.md**

- Moves task content back to active plan
- Optional background reading (NOT required): DEVELOPMENT_FRAMEWORK.md lines 3407-3682 for backlog patterns

**Context**:

- **Framework Guide**: DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working File**: .flow/PLAN.md (current project)
- **Backlog File**: .flow/BACKLOG.md (read and remove from)

**Signature**: `/flow-backlog-pull <task-number> [instruction-text]`

**Examples**:
- `/flow-backlog-pull 14` - Pull Task 14, insert at end of active phase with next available number
- `/flow-backlog-pull 14 insert after task 13` - Pull Task 14, position after Task 13 (but still renumber sequentially)
- `/flow-backlog-pull 14 add to phase 5` - Pull Task 14, add to Phase 5 instead of active phase

**Instructions**:

1. **Check if .flow/BACKLOG.md exists**:
   - If NOT found: "📦 Backlog is empty. Nothing to pull."
   - If found: Proceed

2. **Parse arguments**:
   - Required: Task number to pull (e.g., "14")
   - Optional: Instruction text for positioning (e.g., "insert after task 13")
   - Extract task number and instruction (if provided)

3. **Validate task exists in backlog**:
   - Search BACKLOG.md for `#### Task [N]:`
   - If NOT found: "Task [N] not found in backlog. Use `/flow-backlog-view` to see what's available."
   - If found: Proceed

4. **Extract full task content from BACKLOG.md**:
   - Use awk to extract complete task section:
     ```bash
     awk '/^#### Task 14:/,/^####[^#]|^###[^#]/ {print}' BACKLOG.md
     ```
   - Preserve ALL content (iterations, brainstorming, metadata, etc.)

5. **Determine insertion position in PLAN.md**:

   **A. Find active phase**:
   - Read Progress Dashboard to identify current phase
   - If instruction specifies different phase, use that instead

   **B. Calculate new task number**:
   - Find highest task number in target phase
   - New task number = highest + 1
   - Example: Phase 4 has Tasks 11, 12, 13 → New task becomes Task 14

   **C. Determine insertion point** (where in file):
   - **Default** (no instruction): Insert after last task in target phase
   - **With instruction**: Parse instruction for positioning
     - "insert after task 13" → Find Task 13, insert after it
     - "insert before task 12" → Find Task 12, insert before it
     - "add to phase 5" → Find Phase 5, insert at end
   - **Position ≠ Number**: Task positioned after 13 but numbered as 14 (sequential)

6. **Renumber task header**:
   - Change `#### Task 14:` (old backlog number) to `#### Task [new-number]:`
   - Example: Backlog Task 14 becomes PLAN.md Task 14 (if next available)
   - Update task metadata with new number

7. **Insert task into PLAN.md**:
   - Insert full task content at determined position
   - Maintain proper markdown hierarchy
   - Preserve all nested content

8. **Remove task from BACKLOG.md**:
   - Delete complete task section from BACKLOG.md
   - Update Backlog Dashboard:
     - Remove task from "Tasks Waiting" list
     - Decrement "Tasks in Backlog" count
     - Update "Last Updated" timestamp
   - **No trace left** - as if task was never in backlog

9. **Update PLAN.md Progress Dashboard** (if it exists):
   - Add pulled task to dashboard
   - Update task count for target phase
   - Mark as ⏳ PENDING (fresh start)

10. **Verify and confirm**:
    - Confirm to user:

      ```
      ✅ Pulled from backlog!

      **Task**: Task [old-number] from backlog → Task [new-number] in PLAN.md
      **Phase**: Phase [N]: [Name]
      **Position**: [Description based on instruction or default]
      **Status**: ⏳ PENDING (ready to start)

      **Backlog**: [N-1] tasks remaining

      Use `/flow-task-start [new-number]` to begin this task when ready.
      ```

**Edge Cases**:
- **Backlog empty**: "Backlog is empty. Nothing to pull."
- **Task not in backlog**: "Task [N] not in backlog. Use `/flow-backlog-view` to see available tasks."
- **Invalid instruction**: Warn and use default positioning
- **No active phase**: Ask user which phase to add task to

**Output**: Update .flow/PLAN.md (task added), update .flow/BACKLOG.md (task removed).

```

---

## /flow-reinstall

<!-- MCP_METADATA
function_name: flow_reinstall
category: maintenance
parameters: []
returns: dict[str, Any]
plan_operations: []
framework_reading_required: false
framework_sections: []
MCP_METADATA_END -->

**File**: `flow-reinstall.md`

```markdown
---
description: Force reinstall of Flow MCP server to latest version by clearing cache and restarting
---

# Flow Reinstall - Force Update to Latest Version

You are executing the `/flow-reinstall` command from the Flow framework.

**Purpose**: Clear uvx cache and restart Flow MCP server to ensure you're running the latest published version.

**🟢 NO FRAMEWORK READING REQUIRED - This is a maintenance command that doesn't interact with PLAN.md**

**When to use**:
- After a new Flow version is published to PyPI
- When MCP tool responses seem outdated or incorrect
- When debugging MCP server issues
- When instructed to update Flow

---

## Steps

### 1. Find Running MCP Server Processes

Use `ps` to find all running `mcp-server-flow` processes:

```bash
ps aux | grep mcp-server-flow | grep -v grep
```

**Expected output**: Lines showing Python processes running mcp_server.py

### 2. Kill Running Processes

If processes are found, kill them:

```bash
ps aux | grep mcp-server-flow | grep -v grep | awk '{print $2}' | xargs kill -9
```

**What this does**:
- Finds all mcp-server-flow processes
- Extracts PIDs (process IDs)
- Kills them forcefully with SIGKILL

### 3. Find Cached Versions

Check uvx cache directories for cached Flow installations:

```bash
ls -la ~/.cache/uv/archive-v0/ | grep mcp-server-flow
```

**Expected output**: Directories with hash names containing cached mcp-server-flow wheels

### 4. Delete Cached Versions

Delete all cached Flow installations:

```bash
find ~/.cache/uv/archive-v0/ -type d -name "*" -exec sh -c 'ls {} 2>/dev/null | grep -q mcp-server-flow && echo {}' \; | xargs rm -rf
```

**Alternative (safer)**: List directories first, then delete manually:

```bash
# Find directories containing mcp-server-flow
find ~/.cache/uv/archive-v0/ -type f -name "*mcp-server-flow*" | sed 's|/[^/]*$||' | sort -u

# Then delete each directory manually
rm -rf ~/.cache/uv/archive-v0/[HASH_DIRECTORY]
```

### 5. Verify Cache is Clear

Verify no cached versions remain:

```bash
find ~/.cache/uv -name "*mcp-server-flow*" 2>/dev/null
```

**Expected output**: Empty (no results)

### 6. Instruct User to Restart

After clearing cache and killing processes, inform the user:

```
✅ Flow MCP Server Cache Cleared

**What was done**:
- Killed [N] running mcp-server-flow processes
- Deleted [N] cached installations from ~/.cache/uv/

**Next Step**:
IMPORTANT: You must restart this conversation for changes to take effect.

1. Close this Claude Code session
2. Start a new conversation
3. The latest Flow version will be downloaded automatically on first MCP tool use

**Why restart is needed**:
Claude Code spawns MCP servers at session start. A new session is required to spawn a fresh server with the latest version.
```

---

## Safety Notes

**Safe operations**:
- Killing mcp-server-flow processes only affects Flow MCP server
- Deleting uvx cache only affects cached Python packages (will be re-downloaded on demand)
- No project files or PLAN.md are touched

**What gets deleted**:
- `~/.cache/uv/archive-v0/[HASH]/` - Cached wheel files (~250KB per version)
- No source code or framework files are modified

**Recovery**:
If something goes wrong, the MCP server will be re-downloaded automatically on next use from PyPI.

---

## Example Output

```bash
$ ps aux | grep mcp-server-flow | grep -v grep
user  12345  0.1  0.2  /path/to/python mcp_server.py
user  12346  0.1  0.2  /path/to/python mcp_server.py

$ ps aux | grep mcp-server-flow | grep -v grep | awk '{print $2}' | xargs kill -9
# (no output, processes killed)

$ find ~/.cache/uv/archive-v0/ -type f -name "*mcp-server-flow*"
/Users/user/.cache/uv/archive-v0/7Xzq81CHwYy7mX_2BXpSb/mcp_server_flow-1.2.11-py3-none-any.whl

$ rm -rf ~/.cache/uv/archive-v0/7Xzq81CHwYy7mX_2BXpSb/

$ find ~/.cache/uv -name "*mcp-server-flow*" 2>/dev/null
# (no output, cache cleared)
```

---

## Troubleshooting

**No processes found**: Normal if MCP server hasn't been used yet this session

**Permission denied**: Use `sudo` if cache directories require elevated permissions (rare)

**Cache directory doesn't exist**: Normal on fresh installations, skip deletion step

**Still seeing old version after restart**:
- Verify PyPI has the new version: https://pypi.org/project/mcp-server-flow/
- Check mcp.json doesn't pin old version (should be `"mcp-server-flow"` without version)
- Try `uvx --force mcp-server-flow` manually to test

```

---

**Version**: 1.0.9
**Last Updated**: 2025-10-02
```
