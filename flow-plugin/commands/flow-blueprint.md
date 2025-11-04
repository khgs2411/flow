---
description: Create new multi-file Flow project structure from scratch
---

You are executing the `/flow-blueprint` command from the Flow framework.

**Purpose**: Create a brand new multi-file Flow project structure from scratch.

**🔴 REQUIRED: Read Framework Quick Reference & Templates First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-600 (Quick Reference section) - if not already in context
- **Read file templates**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 2101-2600 (DASHBOARD.md, PLAN.md, task-N.md templates)
- **Read examples**: `.flow/framework/examples/` directory for real-world examples

**Multi-File Architecture**: This command creates:
- `DASHBOARD.md` - Progress tracking (single source of truth, user's main workspace)
- `PLAN.md` - Static context (overview, architecture, scope)
- `phase-N/` directories (if enough info provided)
- `phase-N/task-M.md` files (if enough info provided)

**IMPORTANT**: This command ALWAYS creates fresh files, overwriting any existing. Use `/flow-migrate` to convert existing docs or `/flow-plan-update` to migrate old single-file plans.

**💡 TIP FOR USERS**: Provide rich context! The more details you provide upfront, the better the plan.

**Good example** (explicit tasks = creates phase directories + task files):
```
/flow-blueprint "WebSocket Chat App

1. Create Bun.js web server with Express
2. Implement Socket.IO for real-time messaging  
3. Build frontend app to communicate with WebSocket server

Testing: Simulation-based per service"
```

**Minimal example** (AI will ask follow-up questions, may only create DASHBOARD + PLAN):
```
/flow-blueprint "websocket server"
```

**Instructions**:

1. **INPUT VALIDATION** (Run BEFORE reading framework):

   **Step 1: Quick Scan**:
   ```
   IF $ARGUMENTS is empty OR just whitespace:
     REJECT: "❌ Missing project description. Provide at least a project name or brief description."
     STOP
   ```

   **Step 2: Detect Blueprint Mode**:

   **Mode A: SUGGEST Structure** (User wants AI to design)
   - Trigger: NO explicit structure markers in $ARGUMENTS
   - Examples: "websocket server", "user auth system"
   - Behavior: Ask questions, generate suggested structure

   **Mode B: CREATE Explicit Structure** (User designed it)
   - Trigger: Contains numbered lists, "Phase N:", "Task N:", or bullet structure
   - Examples: 
     - "1. server, 2. socket.io, 3. frontend"  
     - "Phase 1: Foundation\n- Task 1: Setup\nPhase 2: Implementation"
   - Behavior: Honor user's structure exactly (with [TBD] for missing metadata)

   **Step 3: Semantic Check** (Mode A only):
   - If too vague ("help", "project", "thing"):
     ```
     "🤔 Need more context. What are you building? Examples:
     - 'WebSocket chat server with Socket.IO'
     - 'User authentication system with JWT'
     
     Or provide explicit structure:
     1. [First step]
     2. [Second step]
     3. [Third step]"
     ```

   **Step 4: Dry-Run Preview** (Mode B only):
   - Parse structure and show what will be created:
     ```
     "📋 Detected explicit structure. I will create:
     
     Phase 1: Bun.js Web Server ⏳
       - phase-1/task-1.md (Create Express server)
     
     Phase 2: Socket.IO Implementation ⏳  
       - phase-2/task-1.md (Implement real-time messaging)
     
     Phase 3: Frontend App ⏳
       - phase-3/task-1.md (Build WebSocket client)
     
     Also creating: DASHBOARD.md, PLAN.md
     
     Proceed? (yes/no)"
     ```

2. **Read framework guide AND examples** (after validation):
   - Search for .flow/framework/DEVELOPMENT_FRAMEWORK.md (`.flow/`, `.claude/`, `./`, `~/.claude/flow/`)
   - Search for examples in `.flow/framework/examples/` (DASHBOARD.md, PLAN.md, task files)
   - Read to understand:
     - Multi-file structure (DASHBOARD vs PLAN vs task files)
     - File templates
     - Required sections
     - Status markers

3. **Analyze feature request** (Mode-specific):

   **If Mode A (SUGGEST)**:
   - Extract: requirements, constraints, references, testing
   - If minimal context, prepare to ask questions

   **If Mode B (CREATE)**:
   - Parse structure (phases/tasks from numbered lists or explicit markers)
   - Extract metadata if provided
   - Use [TBD] for missing metadata

4. **Gather information** (Mode A only):

   a. **Reference implementations**:
      - If mentioned in args, read and analyze
      - Otherwise ask: "Reference implementation to analyze? (path or 'no')"

   b. **Testing methodology**:
      - If provided in args, use directly
      - Otherwise ask:
        ```
        "How do you prefer to verify implementations?
        - Simulation-based (per-service): scripts/{service}.scripts.ts
        - Unit tests: Jest/Vitest after implementation
        - TDD: Tests before implementation
        - Manual QA: No automated tests
        - Custom: Describe your approach
        
        Also tell me:
        - Test file naming? (e.g., {service}.scripts.ts, {feature}.test.ts)
        - Test file location? (e.g., scripts/, __tests__/, tests/)
        - When to create NEW vs add to existing?"
        ```

   c. **Estimate phase/task structure** (Mode A only):
      - Based on requirements, estimate phases needed
      - Ask: "I'm thinking X phases: [list]. Does this structure make sense? Any changes?"

   d. **Ask about Key Decisions** (IMPORTANT - human-in-loop):
      - If you identify design decisions during structure creation, **ASK USER IMMEDIATELY**:
        ```
        "I identified a decision point: [question]"
        "- Option A: [description]"
        "- Option B: [description]"
        "Your choice? (or say 'decide later' to add to Key Decisions section)"
        ```
      - **If user chooses**: Document choice in PLAN.md Architecture section or relevant file
      - **If user says "decide later"**: Add to DASHBOARD.md Key Decisions section as unresolved
      - **DO NOT** create unresolved Key Decisions without asking user first
      - Examples of decisions to ask about:
        - Version numbering (v1.X.0 vs v2.0.0)
        - Architecture patterns (REST vs GraphQL, SQL vs NoSQL)
        - Testing approach (if not already gathered in step 4b)
        - Deployment strategy (if relevant to project)

5. **Determine what files to create**:

   **ALWAYS CREATE**:
   - `DASHBOARD.md` (required - single source of truth for progress)
   - `PLAN.md` (required - static context)

   **CREATE phase-N/ directories + task files IF**:
   - Mode B (explicit structure) → Always create
   - Mode A with rich context (clear tasks identified) → Create
   - Mode A with minimal context → Don't create yet (user adds with /flow-phase-add later)

6. **Generate files**:

   **💡 BEST PRACTICE - Turn-Based Approach**:
   For large projects with many phases/tasks, use a turn-based approach to manage context:
   1. **First turn**: Create PLAN.md only (architecture, scope, overview)
   2. **Second turn**: Create DASHBOARD.md (list all phases/tasks structure)
   3. **Third+ turns**: Create task files incrementally (Phase 1, then Phase 2, etc.)

   This prevents context overflow and allows human review between steps.

   **When to use turn-based**:
   - 3+ phases with multiple tasks each
   - Complex projects requiring detailed task descriptions
   - When human wants to review structure before task file creation

   **When to use single-turn**:
   - Small projects (1-2 phases, few tasks)
   - Clear structure from user's description
   - Minimal task file content needed

   a. **Create PLAN.md FIRST** (turn 1 if using turn-based approach):
      - Use template from .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 2232-2321
      - Include (MINIMAL - no assumptions):
        - Header with purpose
        - Overview (Purpose, Goals - text format NO checklists, Scope V1 only)
        - Architecture (high-level system context if info provided)
        - DO/DON'T Guidelines
        - Notes & Learnings (empty initially)
      - **DO NOT INCLUDE** (unless user explicitly requests):
        - V2/V3 Scope sections
        - Testing Strategy section (user decides during brainstorming)
        - Development Phases section
        - Future Enhancements section
      - **If turn-based**: Stop here, confirm with user, ask if ready for DASHBOARD

   b. **Create DASHBOARD.md SECOND** (turn 2 if using turn-based approach):
      - Use template from .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 2102-2200
      - Fill in project name, purpose
      - Current Work: Set to Phase 1, Task 1, Iteration 1 (if phases created) OR "No phases yet" (if not)
      - Progress Overview: List all phases/tasks structure (with iteration counts)
      - Completion Status: 0% initially
      - Next Actions: "Use /flow-phase-add to add first phase" OR "Use /flow-phase-start to begin"
      - Last Updated: Current timestamp
      - **If turn-based**: Stop here, ask user which phase to create task files for first

   c. **Create phase-N/ directories** (turn 3+ if using turn-based approach):
      - Create one directory per phase
      - Naming: `phase-1/`, `phase-2/`, etc.

   d. **Create phase-N/task-M.md files** (turn 3+ if using turn-based approach):
      - Use template from .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 2383-2472 (task with iterations)
      - **ALL tasks have iterations** (no standalone tasks)
      - **CRITICAL: Create task files for EVERY task listed in DASHBOARD.md**
        - If DASHBOARD.md shows "Task 1: Name" under Phase 2, then `phase-2/task-1.md` MUST exist
        - NEVER create incomplete structures where DASHBOARD promises tasks that don't exist
        - If uncertain about task details, use [TBD] placeholders - but file must exist
      - **If turn-based**: Create one phase at a time (e.g., all Phase 1 tasks, then ask before Phase 2)
      - Fill in:
        - Task name and purpose
        - Phase link back to DASHBOARD.md
        - Status: ⏳ PENDING initially
        - Task Overview with "Why This Task"
        - Dependencies (if known)
        - At least 1 iteration per task (with placeholder goal)
        - Task Notes section (empty initially)
      - **Context management**: For large projects, ask user after each phase if ready to continue

7. **Verify completeness** (self-check):
   - [ ] DASHBOARD.md created with all required sections?
   - [ ] PLAN.md created with minimal required sections (no assumptions)?
   - [ ] phase-N/ directories created (if applicable)?
   - [ ] phase-N/task-M.md files created with iterations (if applicable)?
   - [ ] **CRITICAL: Every task listed in DASHBOARD.md has a corresponding task file?**
     - Parse DASHBOARD.md "Progress Overview" section
     - For each task entry (e.g., "Task 1: Name"), verify phase-N/task-M.md exists
     - **NEVER create "phantom tasks"** - if DASHBOARD lists it, file MUST exist
   - [ ] DASHBOARD.md Current Work points to correct location?

8. **Confirm to user**:

   **If using turn-based approach**:
   - After PLAN.md: "✨ Created PLAN.md. Review the architecture and scope. Ready to create DASHBOARD.md?"
   - After DASHBOARD.md: "✨ Created DASHBOARD.md with [X] phases, [Y] tasks. Which phase should I create task files for first? (Suggest: Phase 1)"
   - After each phase's tasks: "✅ Created [N] task files for Phase [X]. Ready to create Phase [X+1] task files?"

   **If Mode A (SUGGEST) with phases created** (single-turn approach):
   ```
   "✨ Created multi-file Flow project structure:

   📂 Files Created:
   - DASHBOARD.md (your main workspace - single source of truth)
   - PLAN.md (static context - minimal assumptions)
   - phase-1/ with [X] task files (all with iterations)
   - phase-2/ with [Y] task files (all with iterations)
   
   📊 Structure: [X] phases, [Y] tasks, [Z] iterations
   
   🎯 Next Steps:
   - Use `/flow-status` to see current state
   - Use `/flow-phase-start` to begin Phase 1
   - Use `/flow-brainstorm-start` when ready to design first iteration"
   ```

   **If Mode A (SUGGEST) without phases** (minimal context):
   ```
   "✨ Created initial Flow project structure:

   📂 Files Created:
   - DASHBOARD.md (your main workspace)
   - PLAN.md (static context - V1 scope only)
   
   📝 Note: No phases created yet (need more context)
   
   🎯 Next Steps:
   - Use `/flow-phase-add "Phase Name"` to add your first phase
   - Then use `/flow-task-add "Task Name"` to add tasks
   - Or re-run `/flow-blueprint` with more detailed requirements"
   ```

   **If Mode B (CREATE)**:
   ```
   "✨ Created multi-file Flow project from your explicit structure:

   📂 Files Created:
   - DASHBOARD.md (single source of truth)
   - PLAN.md (minimal assumptions)
   - phase-1/ → [X] tasks (all with iterations)
   - phase-2/ → [Y] tasks (all with iterations)
   - phase-3/ → [Z] tasks (all with iterations)
   
   📊 Structure: [X] phases, [Y] tasks (as you specified)
   📝 [TBD] placeholders: [list sections with [TBD]]
   
   🎯 Next Steps:
   - Use `/flow-status` to see current state
   - Refine [TBD] sections during brainstorming
   - Use `/flow-phase-start` to begin work"
   ```
