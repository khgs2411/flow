# Flow Framework - Slash Commands File.

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
  1. `.flow/framework/DEVELOPMENT_FRAMEWORK.md` (primary - in user's project)
  2. `.claude/DEVELOPMENT_FRAMEWORK.md` (project root)
  3. `./DEVELOPMENT_FRAMEWORK.md` (project root)
  4. `~/.claude/flow/DEVELOPMENT_FRAMEWORK.md` (global)
- **Examples**: `.flow/framework/examples/` (reference files for AI to learn from)

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

**File**: `flow-blueprint.md`

```markdown
<!-- COMMAND_START -->
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

<!-- COMMAND_END -->
**Output**: Create multi-file Flow project structure and confirm to user.

---

## /flow-init

**File**: `flow-init.md`

```markdown
<!-- COMMAND_START -->
---
description: Install/update complete Flow framework (commands, skills, framework files)
---

You are executing the `/flow-init` command from the Flow framework.

**Purpose**: Download and install Flow framework files directly from GitHub repository.

**🟢 NO FRAMEWORK READING REQUIRED - This is the installation command**

**Instructions**:

1. **Detect installation mode**:

   Check if `.claude/commands/` directory exists with flow-*.md files:
   ```bash
   if [ -d ".claude/commands" ] && ls .claude/commands/flow-*.md >/dev/null 2>&1; then
     echo "UPDATE"
   else
     echo "INSTALL"
   fi
   ```

2. **Show what will be installed** and get user confirmation:

   ```
   📥 Flow Framework [MODE - INSTALL or UPDATE]

   I will download and install from GitHub (khgs2411/flow):
   ✓ 29 slash commands → .claude/commands/
   ✓ 8 agent skills → .claude/skills/
   ✓ 1 Claude agent → .claude/agents/
   ✓ Framework docs → .flow/framework/
   ✓ Example files → .flow/framework/examples/

   Total download size: ~210KB

   [If UPDATE mode: ⚠️  Existing Flow files will be overwritten]

   Proceed with installation? (y/n)
   ```

3. **If user declines**, stop and show:
   ```
   ⚠️  Installation cancelled. Run /flow-init again when ready.
   ```

4. **If user approves**, execute installation using Bash tool:

   Run this complete bash script:

   ```bash
   # Base URL for GitHub raw files
   BASE_URL="https://raw.githubusercontent.com/khgs2411/flow/master"

   echo "📦 Installing Flow framework..."
   echo ""

   # Create directories
   mkdir -p .claude/commands
   mkdir -p .claude/skills
   mkdir -p .claude/agents
   mkdir -p .flow/framework/examples/phase-1
   mkdir -p .flow/framework/examples/phase-2

   echo "📝 Downloading slash commands from framework/commands/..."

   # Download all 29 commands
   COMMANDS=(
     "flow-backlog-add" "flow-backlog-pull" "flow-backlog-view"
     "flow-blueprint" "flow-brainstorm-complete" "flow-brainstorm-review"
     "flow-brainstorm-start" "flow-brainstorm-subject" "flow-compact"
     "flow-implement-complete" "flow-implement-start" "flow-iteration-add"
     "flow-migrate" "flow-next" "flow-next-iteration"
     "flow-next-subject" "flow-phase-add" "flow-phase-complete"
     "flow-phase-start" "flow-plan-split" "flow-plan-update"
     "flow-rollback" "flow-status" "flow-summarize"
     "flow-task-add" "flow-task-complete" "flow-task-start"
     "flow-verify-plan" "flow-init"
   )

   for cmd in "${COMMANDS[@]}"; do
     if curl -sS -f -o ".claude/commands/${cmd}.md" \
        "$BASE_URL/framework/commands/${cmd}.md" 2>/dev/null; then
       echo "  ✓ ${cmd}"
     else
       echo "  ✗ ${cmd} (download failed)"
     fi
   done

   echo ""
   echo "🤖 Downloading agent skills from framework/skills/..."

   # Download all skill directories
   SKILLS=(
     "flow-builder" "flow-completer" "flow-curator"
     "flow-designer" "flow-initializer" "flow-navigator"
     "flow-planner" "flow-verifier"
   )

   for skill in "${SKILLS[@]}"; do
     mkdir -p ".claude/skills/${skill}"

     # Download SKILL.md (required)
     if curl -sS -f -o ".claude/skills/${skill}/SKILL.md" \
        "$BASE_URL/framework/skills/${skill}/SKILL.md" 2>/dev/null; then

       # Try to download additional skill files if they exist (optional)
       for file in TEMPLATES.md PATTERNS.md VERIFICATION.md EXAMPLES.md DASHBOARD_TEMPLATE.md MIGRATION_PATTERNS.md OTHER_TEMPLATES.md PLAN_TEMPLATE.md TASK_TEMPLATES.md RESOLUTION_TYPES.md PLAN_UPDATES.md VERIFY.md; do
         curl -sS -f -o ".claude/skills/${skill}/${file}" \
           "$BASE_URL/framework/skills/${skill}/${file}" 2>/dev/null || true
       done

       echo "  ✓ ${skill}"
     else
       echo "  ✗ ${skill} (download failed)"
     fi
   done

   echo ""
   echo "🤖 Downloading Claude agent from framework/agents/..."

   # Download Flow agent
   if curl -sS -f -o ".claude/agents/flow.md" \
      "$BASE_URL/framework/agents/flow.md" 2>/dev/null; then
     echo "  ✓ flow"
   else
     echo "  ✗ flow (download failed)"
   fi

   echo ""
   echo "📝 Updating CLAUDE.md..."

   # Update CLAUDE.md with Flow agent delegation instruction
   CLAUDE_MD="$(pwd)/CLAUDE.md"
   FLOW_INSTRUCTION='**This project uses the Flow framework for project management.**

**CRITICAL DELEGATION RULE**: You MUST delegate ALL Flow-related operations to the Flow sub-agent.

**HOW TO DELEGATE TO FLOW:**
```
Task tool → subagent_type: "flow" → description + prompt
```

**DO NOT use these (they execute in YOUR context, not Flow'\''s):**
- ❌ Skill tool with flow-* skills
- ❌ SlashCommand tool with /flow-* commands
- ❌ Reading .flow/ files directly
- ❌ Task tool with subagent_type: "general-purpose"

**ALWAYS delegate when the user**:
- Asks about status/progress: "what am I working on?", "what'\''s next?", "show my status"
- Manages work: "add a task", "create a phase", "start iteration", "mark as complete"
- Plans features: "I want to build X", "let'\''s plan Y", "add feature Z"
- Updates architecture: "update PLAN.md", "add a guideline", "change the approach"
- Asks methodology questions: "what are iterations?", "how do phases work?"
- Mentions ANY of: tasks, phases, iterations, DASHBOARD, PLAN, brainstorm, .flow/ files, /flow-* commands

**ROLE SEPARATION:**
- Flow agent = PROJECT MANAGER (workflow, planning, status)
- You = ENGINEER (code implementation, debugging, git operations)'

   if [ -f "$CLAUDE_MD" ]; then
     # CLAUDE.md exists - update it
     if grep -qi "flow framework" "$CLAUDE_MD"; then
       # Flow notice exists - replace it with updated version
       echo "  ↻ Updating existing Flow framework notice"

       # Strategy: Remove entire old flow section, then add new one
       TEMP_FILE="${CLAUDE_MD}.tmp"
       in_flow_section=0
       blank_count=0

       # First pass: remove the entire flow framework block (all lines until next section header)
       while IFS= read -r line; do
         # Detect start of flow framework section
         if [[ "$line" =~ flow\ framework ]] && [ $in_flow_section -eq 0 ]; then
           in_flow_section=1
           blank_count=0
           continue
         fi

         # If in flow section, skip until we hit TWO consecutive blank lines or a new section header
         if [ $in_flow_section -eq 1 ]; then
           # Check if this is a new markdown section (##)
           if [[ "$line" =~ ^##\  ]]; then
             in_flow_section=0
             echo "$line"
             continue
           fi

           # Track consecutive blank lines
           if [[ "$line" =~ ^$ ]]; then
             blank_count=$((blank_count + 1))
             # Two consecutive blank lines = end of flow section
             if [ $blank_count -ge 2 ]; then
               in_flow_section=0
               echo "$line"
               continue
             fi
           else
             blank_count=0
           fi

           # Still in flow section, skip this line
           continue
         fi

         echo "$line"
       done < "$CLAUDE_MD" > "$TEMP_FILE"

       # Second pass: add new flow content
       FINAL_FILE="${CLAUDE_MD}.final"
       inserted=0

       # Check if "## Important rules and guidelines" still exists
       if grep -q "^## Important rules and guidelines" "$TEMP_FILE"; then
         # Guidelines header exists - insert under it
         while IFS= read -r line; do
           echo "$line"

           if [[ "$line" =~ ^##\ Important\ rules\ and\ guidelines ]] && [ $inserted -eq 0 ]; then
             echo "$FLOW_INSTRUCTION"
             inserted=1
           fi
         done < "$TEMP_FILE" > "$FINAL_FILE"
       else
         # No guidelines header - need to create it
         after_title=0
         while IFS= read -r line; do
           echo "$line"

           # Track when we pass the title
           if [[ "$line" =~ ^#\ CLAUDE\.md ]]; then
             after_title=1
           fi

           # Insert after the boilerplate line (the "This file provides..." line)
           if [ $after_title -eq 1 ] && [ $inserted -eq 0 ]; then
             if [[ "$line" =~ This\ file\ provides\ guidance ]]; then
               echo ""
               echo "## Important rules and guidelines"
               echo "$FLOW_INSTRUCTION"
               echo ""
               inserted=1
             fi
           fi
         done < "$TEMP_FILE" > "$FINAL_FILE"

         # If never inserted, add at top
         if [ $inserted -eq 0 ]; then
           {
             echo "## Important rules and guidelines"
             echo "$FLOW_INSTRUCTION"
             echo ""
             cat "$TEMP_FILE"
           } > "$FINAL_FILE"
         fi
       fi

       mv "$FINAL_FILE" "$CLAUDE_MD"
       rm -f "$TEMP_FILE"
     else
       # No flow notice - add it
       echo "  + Adding Flow framework notice"

       TEMP_FILE="${CLAUDE_MD}.tmp"
       inserted=0

       if grep -q "^## Important rules and guidelines" "$CLAUDE_MD"; then
         # Guidelines header exists - insert under it
         while IFS= read -r line; do
           echo "$line"

           if [[ "$line" =~ ^##\ Important\ rules\ and\ guidelines ]] && [ $inserted -eq 0 ]; then
             echo "$FLOW_INSTRUCTION"
             inserted=1
           fi
         done < "$CLAUDE_MD" > "$TEMP_FILE"
         mv "$TEMP_FILE" "$CLAUDE_MD"
       else
         # No guidelines header - create it
         after_title=0
         while IFS= read -r line; do
           echo "$line"

           if [[ "$line" =~ ^#\ CLAUDE\.md ]]; then
             after_title=1
           fi

           if [ $after_title -eq 1 ] && [ $inserted -eq 0 ]; then
             if [[ "$line" =~ This\ file\ provides\ guidance ]]; then
               echo ""
               echo "## Important rules and guidelines"
               echo "$FLOW_INSTRUCTION"
               echo ""
               inserted=1
             fi
           fi
         done < "$CLAUDE_MD" > "$TEMP_FILE"

         if [ $inserted -eq 0 ]; then
           {
             echo "## Important rules and guidelines"
             echo "$FLOW_INSTRUCTION"
             echo ""
             cat "$CLAUDE_MD"
           } > "$TEMP_FILE"
         fi

         mv "$TEMP_FILE" "$CLAUDE_MD"
       fi
     fi
     echo "  ✓ CLAUDE.md updated"
   else
     echo "  ⏭️  No CLAUDE.md found - skipping"
   fi

   echo ""
   echo "📚 Downloading framework documentation..."

   # Download framework reference
   if curl -sS -f -o .flow/framework/DEVELOPMENT_FRAMEWORK.md \
      "$BASE_URL/framework/DEVELOPMENT_FRAMEWORK.md" 2>/dev/null; then
     echo "  ✓ DEVELOPMENT_FRAMEWORK.md"
   else
     echo "  ✗ DEVELOPMENT_FRAMEWORK.md (download failed)"
   fi

   # Download examples (failures are ok - not all may exist)
   echo ""
   echo "📂 Downloading framework examples..."

   curl -sS -f -o .flow/framework/examples/DASHBOARD.md \
     "$BASE_URL/framework/examples/DASHBOARD.md" 2>/dev/null && \
     echo "  ✓ examples/DASHBOARD.md" || echo "  ✗ examples/DASHBOARD.md (optional file not found)"

   curl -sS -f -o .flow/framework/examples/PLAN.md \
     "$BASE_URL/framework/examples/PLAN.md" 2>/dev/null && \
     echo "  ✓ examples/PLAN.md" || echo "  ✗ examples/PLAN.md (optional file not found)"

   curl -sS -f -o .flow/framework/examples/phase-1/task-1.md \
     "$BASE_URL/framework/examples/phase-1/task-1.md" 2>/dev/null && \
     echo "  ✓ examples/phase-1/task-1.md" || echo "  ✗ examples/phase-1/task-1.md (optional file not found)"

   curl -sS -f -o .flow/framework/examples/phase-2/task-3.md \
     "$BASE_URL/framework/examples/phase-2/task-3.md" 2>/dev/null && \
     echo "  ✓ examples/phase-2/task-3.md" || echo "  ✗ examples/phase-2/task-3.md (optional file not found)"
   ```

5. **Show completion message**:

   ```bash
   echo ""
   echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   echo "✅ Flow framework installed successfully!"
   echo ""
   echo "📦 Installation summary:"
   echo "  • 29 commands in .claude/commands/"
   echo "  • 8 skills in .claude/skills/"
   echo "  • 1 agent in .claude/agents/"
   echo "  • Framework docs in .flow/framework/"
   echo "  • Example files in .flow/framework/examples/"
   echo ""
   echo "🎯 Next steps:"
   echo ""

   if [ ! -f ".flow/DASHBOARD.md" ]; then
     echo "**New Flow project**:"
     echo "  Run: /flow-blueprint \"Your Project Description\""
     echo ""
     echo "**Migrate existing docs**:"
     echo "  Run: /flow-migrate"
   else
     echo "**Existing Flow project detected**"
     echo "  Framework files updated"
     echo "  Continue with: /flow-status"
   fi

   echo ""
   echo "⚠️  IMPORTANT: Restart Claude Code to load the new commands!"
   echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   ```

6. **Error handling**:
   - Network errors: Show "❌ Download failed. Check internet connection"
   - Permission errors: Show "❌ Permission denied. Check directory permissions"
   - Partial failures are OK - show which files succeeded/failed

<!-- COMMAND_END -->
**Output**: Download and install all Flow framework files to user's project.
```

---

## /flow-migrate

**File**: `flow-migrate.md`

```markdown
<!-- COMMAND_START -->
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

<!-- COMMAND_END -->
**Output**: Create multi-file Flow structure (DASHBOARD.md, PLAN.md, phase-N/task-M.md files) from existing documentation, create backup, confirm migration to user.
```

---

## /flow-plan-update

**File**: `flow-plan-update.md`

```markdown
<!-- COMMAND_START -->
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

<!-- COMMAND_END -->
**Output**: Update all Flow files to latest framework structure, create backup, confirm changes to user.
```

---

## /flow-phase-add

**File**: `flow-phase-add.md`

```markdown
<!-- COMMAND_START -->
---
description: Add a new phase directory and update dashboard
---

You are executing the `/flow-phase-add` command from the Flow framework.

**Purpose**: Add a new phase to the project by creating a phase directory and updating DASHBOARD.md.

**🟢 NO FRAMEWORK READING REQUIRED - Simple structure creation**

**Multi-File Architecture**: This command:
- Creates `phase-N/` directory
- Updates `DASHBOARD.md` with new phase
- Updates `PLAN.md` Development Phases section

**Instructions**:

1. **INPUT VALIDATION**:

   ```
   IF $ARGUMENTS is empty OR just whitespace:
     REJECT: "❌ Missing phase name. Example: /flow-phase-add 'Testing and QA'"
     STOP
   ```

   Accept even minimal input like "Testing" - will use [TBD] for missing metadata.

2. **Find .flow/DASHBOARD.md**:
   ```bash
   Primary location: .flow/DASHBOARD.md

   If not found:
     Suggest: "Run /flow-blueprint first to create project structure"
   ```

3. **Read DASHBOARD.md**:
   - Count existing phases to determine next phase number
   - Example: If "Phase 1" and "Phase 2" exist, new phase is "Phase 3"

4. **Parse arguments and infer metadata**:

   From `$ARGUMENTS`, extract or infer:
   - **Phase name**: Use $ARGUMENTS directly
   - **Strategy**: Try to infer from name:
     - "Foundation" → "Setup and establish core architecture"
     - "Implementation" / "Core" → "Build main features and functionality"
     - "Testing" / "QA" → "Comprehensive testing and quality assurance"
     - "Polish" / "Enhancement" → "Refinement and optimization"
     - Can't infer → "[TBD] - Define during phase start"
   - **Goal**: Try to infer from name:
     - "Foundation" → "Establish solid project foundation"
     - "Implementation" → "Complete core feature set"
     - "Testing" → "Ensure production-ready quality"
     - Can't infer → "[TBD] - Define during phase start"

5. **Create phase directory**:
   ```bash
   mkdir .flow/phase-N/

   # Where N = next phase number (e.g., phase-3/)
   ```

6. **Update DASHBOARD.md**:

   Add to "📊 Progress Overview" section:
   ```markdown
   ### Phase [N]: [Phase Name] ⏳ PENDING

   **Goal**: [Inferred or [TBD]]
   **Status**: Not started

   (No tasks yet - use /flow-task-add to add tasks)
   ```

   Update "📈 Completion Status" section:
   - Increment phase count
   - Add phase to breakdown (0% complete initially)

7. **Update PLAN.md**:

   Add to "Development Phases" section:
   ```markdown
   ### Phase [N]: [Phase Name] ⏳

   **Strategy**: [Inferred or [TBD]]
   **Goal**: [Inferred or [TBD]]

   **Tasks**: See [phase-N/](phase-N/) directory for detailed task files
   ```

8. **Update DASHBOARD.md timestamp**:
   - Update "Last Updated" to current timestamp

9. **Confirm to user**:
   ```
   "✅ Added Phase [N]: [Phase Name]

   📂 Created: .flow/phase-N/ directory
   📝 Updated: DASHBOARD.md, PLAN.md

   [If used [TBD]:]
   📝 Used [TBD] placeholders for: [Strategy/Goal]
   💡 Refine these during phase start

   🎯 Next Steps:
   - Use `/flow-task-add "Task Name"` to add tasks to this phase
   - Use `/flow-phase-start` when ready to begin work"
   ```

<!-- COMMAND_END -->
**Output**: Create phase-N/ directory and update DASHBOARD.md + PLAN.md with new phase.

```

---

## /flow-phase-start

**File**: `flow-phase-start.md`

```markdown
<!-- COMMAND_START -->
---
description: Mark current phase as in progress
---

You are executing the `/flow-phase-start` command from the Flow framework.

**Purpose**: Mark the current phase as 🚧 IN PROGRESS (when first task starts).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md**
- State transition (⏳ PENDING → 🚧 IN PROGRESS)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 567-613 for lifecycle context

**Multi-File Architecture**: This command:
- Updates `DASHBOARD.md` phase status
- No changes to PLAN.md or task files

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this phase that are NOT part of the current work:
1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📊 Progress Overview" section
   - Locate first ⏳ PENDING phase

2. **Update phase status in dashboard**:
   - Change phase marker from ⏳ PENDING to 🚧 IN PROGRESS
   - Example:
     ```markdown
     ### Phase 2: Core Implementation ⏳ PENDING
     ```
     Becomes:
     ```markdown
     ### Phase 2: Core Implementation 🚧 IN PROGRESS
     ```

3. **Update "📍 Current Work" section**:
   - Set current phase to the phase just started
   - Clear task/iteration (no current work yet)
   ```markdown
   ## 📍 Current Work
   - **Phase**: [Phase 2 - Core Implementation](phase-2/)
   - **Task**: None yet - use `/flow-task-add [name]` to create first task
   ```

4. **Update "Last Updated" timestamp** at top of dashboard

5. **Confirm to user**:
   ```
   ✅ Started Phase [N]: [Name]

   Next steps:
   - Use `/flow-task-add [name]` to create tasks in this phase
   - Or use `/flow-blueprint` if you want to regenerate the plan structure
   ```

<!-- COMMAND_END -->
**Output**: Updated `DASHBOARD.md` with phase status change.
```

---

## /flow-phase-complete

**File**: `flow-phase-complete.md`

```markdown
<!-- COMMAND_START -->
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

<!-- COMMAND_END -->
**Output**: Updated `DASHBOARD.md` with phase completion and next steps.
```

---

## /flow-task-add

**File**: `flow-task-add.md`

```markdown
<!-- COMMAND_START -->
---
description: Create a new task file in current phase directory
---

You are executing the `/flow-task-add` command from the Flow framework.

**Purpose**: Create a new task file in the current phase directory and update DASHBOARD.md.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-600 (Quick Reference) - if not already in context
- **Focus on**: Task Structure Rules (lines 164-223) - ALL tasks have iterations
- **Read task template**: Lines 2383-2472 for task file template (with iterations)

**Multi-File Architecture**: This command:
- Creates `phase-N/task-M.md` file
- Updates `DASHBOARD.md` with new task
- Optionally updates `PLAN.md` if phase description needs updating

**Instructions**:

1. **INPUT VALIDATION**:

   ```
   IF $ARGUMENTS is empty OR just whitespace:
     REJECT: "❌ Missing task name. Example: /flow-task-add 'User Authentication'"
     STOP
   ```

   Accept minimal input - will use [TBD] for missing metadata.

2. **Read DASHBOARD.md**:
   - Find current phase from "📍 Current Work" section
   - Count existing tasks in current phase to determine next task number
   - Example: If phase-2/ has task-1.md and task-2.md, new task is task-3.md

3. **Parse arguments and infer metadata**:

   From `$ARGUMENTS`, extract or infer:
   - **Task name**: Use $ARGUMENTS directly
   - **Purpose**: Try to infer:
     - "User Authentication" → "Implement user authentication system"
     - "API Design" → "Design and document API endpoints"
     - "Database Schema" → "Design and implement database schema"
     - "Testing" → "Implement testing infrastructure"
     - Can't infer → "[TBD] - Define during task start"
   - **Task structure**: ALL tasks have iterations (no standalone tasks)
     - Simple tasks → 1-2 iterations with direct action items
     - Complex tasks → Multiple iterations with brainstorming
     - Always create with at least 1 iteration

4. **Create task file**:

   Create `phase-N/task-M.md` using template from .flow/framework/DEVELOPMENT_FRAMEWORK.md:

   ```markdown
   # Task [M]: [Task Name]

   **Status**: ⏳ PENDING
   **Phase**: [Phase N - Name](../DASHBOARD.md#phase-N-name)
   **Purpose**: [Inferred or [TBD]]

   ---

   ## Task Overview

   [Brief description based on task name]

   **Why This Task**: [TBD] - Define during task start or brainstorming

   [If complex task - add Dependencies section:]
   **Dependencies**:
   - **Requires**: [TBD]
   - **Blocks**: [TBD]

   ---

   ## Iterations

   ### ⏳ Iteration 1: [TBD]

   **Goal**: [TBD] - Define during brainstorming or task start

   **Status**: ⏳ PENDING

   ---

   #### Action Items

   - [ ] [TBD] - Define during brainstorming or add directly

   ---

   ## Task Notes

   **Discoveries**: (To be filled during work)

   **Decisions**: (To be filled during work)

   **References**: (Add relevant code/docs here)
   ```

5. **Update DASHBOARD.md**:

   Add to current phase in "📊 Progress Overview" section:
   ```markdown
   - ⏳ **Task [M]**: [Task Name]
   ```

   Update "📈 Completion Status":
   - Increment task count for current phase
   - Update phase completion percentage

   Update "🎯 Next Actions" if this is the first task:
   - "Use /flow-task-start to begin Task [M]"

6. **Update DASHBOARD.md timestamp**:
   - Update "Last Updated" to current timestamp

7. **Confirm to user**:
   ```
   "✅ Created Task [M]: [Task Name]

   📂 Created: .flow/phase-N/task-M.md
   📝 Updated: DASHBOARD.md

   [If used [TBD]:]
   📝 Used [TBD] placeholders for: [Purpose/Action Items/Iterations]
   💡 Refine during task start or brainstorming

   🎯 Next Steps:
   - Use `/flow-task-start` to begin work on this task
   - Use `/flow-iteration-add` to add more iterations (if needed)
   - Use `/flow-brainstorm-start` when ready to design"
   ```

<!-- COMMAND_END -->
**Output**: Create phase-N/task-M.md file and update DASHBOARD.md.

```

---

## /flow-task-start

**File**: `flow-task-start.md`

```markdown
<!-- COMMAND_START -->
---
description: Mark current task as in progress
---

You are executing the `/flow-task-start` command from the Flow framework.

**Purpose**: Mark the current task as 🚧 IN PROGRESS (when first iteration starts).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md and task file**
- State transition (⏳ PENDING → 🚧 IN PROGRESS)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 567-613 for lifecycle context

**Multi-File Architecture**: This command:
- Updates task status in `phase-N/task-M.md`
- Updates `DASHBOARD.md` current work section
- Auto-starts parent phase if needed

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this task that are NOT part of the current work:
1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📊 Progress Overview" section
   - Locate current phase (🚧 IN PROGRESS or ⏳ PENDING)
   - Find next ⏳ PENDING task in that phase

2. **Determine target task**:
   - Use first ⏳ PENDING task in current phase
   - Extract phase number N and task number M

3. **Update task file** (`phase-N/task-M.md`):
   - Change task status at top of file:
     ```markdown
     **Status**: ⏳ PENDING
     ```
     Becomes:
     ```markdown
     **Status**: 🚧 IN PROGRESS
     ```

4. **Update parent phase status** (if needed):
   - If phase is ⏳ PENDING: Change to 🚧 IN PROGRESS in DASHBOARD.md
   - If phase already 🚧 IN PROGRESS: Skip this step

5. **Update DASHBOARD.md**:

   a. **Update "📍 Current Work" section**:
      ```markdown
      ## 📍 Current Work
      - **Phase**: [Phase 2 - Core Implementation](phase-2/)
      - **Task**: [Task 3 - API Integration](phase-2/task-3.md)
      - **Iteration**: None yet - use `/flow-iteration-add` or `/flow-brainstorm-start`
      ```

   b. **Update task status in "📊 Progress Overview"**:
      - Change task marker from ⏳ to 🚧
      - Example:
        ```markdown
        - ⏳ **Task 3**: API Integration (0/4 iterations)
        ```
        Becomes:
        ```markdown
        - 🚧 **Task 3**: API Integration (0/4 iterations) ← CURRENT
        ```

   c. **Update "Last Updated" timestamp** at top

6. **Confirm to user**:
   ```
   ✅ Started Task [N]: [Name]

   Next steps:
   - Use `/flow-iteration-add [name]` to add iterations
   - Or use `/flow-brainstorm-start [topics]` to plan this task
   ```

<!-- COMMAND_END -->
**Output**:
- Updated `phase-N/task-M.md` status
- Updated `DASHBOARD.md` current work and task status
```

---

## /flow-task-complete

**File**: `flow-task-complete.md`

```markdown
<!-- COMMAND_START -->
---
description: Mark current task as complete
---

You are executing the `/flow-task-complete` command from the Flow framework.

**Purpose**: Mark the current task as ✅ COMPLETE (when all iterations done).

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md and task file**

- State transition (🚧 IN PROGRESS → ✅ COMPLETE)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 567-613 for completion criteria

**Multi-File Architecture**: This command:
- Updates task status in `phase-N/task-M.md`
- Updates `DASHBOARD.md` with completion and next work

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current task: Phase N, Task M
   - Navigate to task file link

2. **Read current task file** (`phase-N/task-M.md`):
   - Verify all iterations marked ✅ COMPLETE
   - If incomplete iterations found:
     ```
     ❌ Cannot complete task - incomplete iterations found:
     - Iteration 2: Error Handling (🚧 IN PROGRESS)
     - Iteration 3: Retry Logic (⏳ PENDING)

     Complete all iterations first or mark as ❌ CANCELLED / 🔮 DEFERRED.
     ```

3. **Update task file** (`phase-N/task-M.md`):
   - Change task status at top:
     ```markdown
     **Status**: 🚧 IN PROGRESS
     ```
     Becomes:
     ```markdown
     **Status**: ✅ COMPLETE
     ```

4. **Update DASHBOARD.md**:

   a. **Update task status in "📊 Progress Overview"**:
      - Change task marker from 🚧 to ✅
      - Remove "← CURRENT" indicator
      - Example:
        ```markdown
        - 🚧 **Task 3**: API Integration (4/4 iterations) ← CURRENT
        ```
        Becomes:
        ```markdown
        - ✅ **Task 3**: API Integration (4/4 iterations)
        ```

   b. **Update "📍 Current Work" section**:
      - **If more tasks in phase**: Advance to next task
        ```markdown
        ## 📍 Current Work
        - **Phase**: [Phase 2 - Core Implementation](phase-2/)
        - **Task**: [Task 4 - Webhook Handler](phase-2/task-4.md) ⏳ PENDING
        - **Next**: Use `/flow-task-start` to begin this task
        ```
      - **If all tasks in phase complete**: Suggest phase completion
        ```markdown
        ## 📍 Current Work
        - **Phase**: [Phase 2 - Core Implementation](phase-2/) - All tasks complete!
        - **Next**: Use `/flow-phase-complete` to mark phase as done
        ```

   c. **Update completion percentages**:
      - Recalculate phase percentage
      - Recalculate overall percentage
      - Update "📈 Completion Status" section

   d. **Update "Last Updated" timestamp** at top

5. **Confirm to user**:
   ```
   ✅ Completed Task [N]: [Name]

   **What's Next**:
   - **More tasks in phase?** → Use `/flow-task-start` to begin Task [N+1]: [Name]
   - **All tasks complete?** → Use `/flow-phase-complete` to mark phase as done
   ```

<!-- COMMAND_END -->
**Output**:
- Updated `phase-N/task-M.md` status
- Updated `DASHBOARD.md` with completion and next work
```

---

## /flow-iteration-add

**File**: `flow-iteration-add.md`

```markdown
<!-- COMMAND_START -->
---
description: Add a new iteration under the current task
---

You are executing the `/flow-iteration-add` command from the Flow framework.

**Purpose**: Add a new iteration to the current task file and update DASHBOARD.md.

**Multi-File Architecture**: This command:
- Adds iteration section to `phase-N/task-M.md` file
- Updates `DASHBOARD.md` with new iteration

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Iteration Patterns, Task Structure Rules
- **Deep dive if needed**: Read lines 238-566 for Task Structure Rules using Read(offset=238, limit=329)

**🚨 SCOPE BOUNDARY RULE**:
If you discover NEW issues while working on this iteration that are NOT part of the current work:

1. **STOP** immediately
2. **NOTIFY** user of the new issue
3. **DISCUSS** what to do (add to brainstorm, create pre-task, defer, or handle now)
4. **ONLY** proceed with user's explicit approval

**Instructions**:

1. **Navigate from dashboard** (dashboard-first pattern):
   - Read `DASHBOARD.md`
   - Find current phase and task from "📍 Current Work" section
   - Extract: Phase number N, Task number M

2. **Parse arguments**:
   - `iteration_name` = Name/goal of iteration (required)
   - `iteration_description` = Optional description

3. **Read current task file**:
   - Open `phase-N/task-M.md`
   - Count existing iterations to determine next iteration number
   - Find "## Iterations" section

4. **Add new iteration section** to task file:

   ```markdown
   ### ⏳ Iteration [N]: [iteration_name]

   **Goal**: [iteration_name expanded or iteration_description if provided]
   **Status**: ⏳ PENDING

   ---
   ```

   **Template Notes**:
   - Place AFTER last iteration in "## Iterations" section
   - Use `###` heading level (three hashes)
   - Status always starts as ⏳ PENDING
   - Infer goal from iteration_name if no description provided

5. **Update DASHBOARD.md**:

   a. **Find current task entry** in "📊 Progress Overview" section

   b. **Update task iteration count**:
      - Change: `- 🚧 **Task 3**: API Integration (1/3 iterations)`
      - To: `- 🚧 **Task 3**: API Integration (1/4 iterations)`

   c. **Add iteration to expanded list** (if task is expanded):
      ```markdown
      - 🚧 **Task 3**: API Integration (1/4 iterations) ← CURRENT
        - ✅ Iteration 1: REST Client Setup
        - 🚧 Iteration 2: Error Handling ← ACTIVE
        - ⏳ Iteration 3: Retry Logic
        - ⏳ Iteration 4: [NEW ITERATION NAME]
      ```

   d. **Update completion percentages**:
      - Recalculate phase percentage: `(completed_iterations / total_iterations) * 100`
      - Recalculate overall percentage
      - Update "📈 Completion Status" section

   e. **Update "Last Updated" timestamp** at top of dashboard

6. **Confirm to user**:
   ```
   ✅ Added Iteration [N]: [iteration_name] to Task [M]: [Task Name]

   Next steps:
   - Use `/flow-brainstorm-start [topics]` to plan this iteration
   - Or add more iterations with `/flow-iteration-add [name]`
   ```

<!-- COMMAND_END -->
**Output**:
- Updated `phase-N/task-M.md` with new iteration section
- Updated `DASHBOARD.md` with iteration count and percentages

```

---

## /flow-brainstorm-start

**File**: `flow-brainstorm-start.md`

```markdown
<!-- COMMAND_START -->
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

<!-- COMMAND_END -->
**Output**:
- Updated `phase-N/task-M.md` with brainstorming section
- Updated `DASHBOARD.md` with "🚧 BRAINSTORMING" status

```

---

## /flow-brainstorm-subject

**File**: `flow-brainstorm-subject.md`

```markdown
<!-- COMMAND_START -->
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

<!-- COMMAND_END -->
**Output**: Updated `phase-N/task-M.md` with new subject in "Subjects to Discuss" list.
```

---

## /flow-brainstorm-review

**File**: `flow-brainstorm-review.md`

```markdown
<!-- COMMAND_START -->
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

<!-- COMMAND_END -->
**Output**:
- **READ-ONLY** - No files modified
- Comprehensive review summary with actionable suggestions, awaiting user confirmation
- User must confirm before proceeding to `/flow-brainstorm-complete`
```

---

## /flow-brainstorm-complete

**File**: `flow-brainstorm-complete.md`

```markdown
<!-- COMMAND_START -->
---
description: Complete brainstorming and generate action items
---

You are executing the `/flow-brainstorm-complete` command from the Flow framework.

**Purpose**: Close the current brainstorming session (only after pre-implementation tasks are done).

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Completion Criteria (lines in Quick Reference)
- **Deep dive if needed**: Read lines 1167-1797 for Brainstorming Pattern using Read(offset=1167, limit=631)

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current iteration
- Updates iteration status to 🎨 READY in `phase-N/task-M.md`
- Updates `DASHBOARD.md` with "🎨 READY FOR IMPLEMENTATION" status

**IMPORTANT**: Pre-implementation tasks should be documented in task file during brainstorming, then completed BEFORE running this command.

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current iteration: Phase N, Task M, Iteration K

2. **Read current task file** (`phase-N/task-M.md`):
   - Find iteration K
   - Verify all subjects in "Subjects to Discuss" are ✅ resolved

3. **Check for pre-implementation tasks** in task file:

   - Look for "#### Pre-Implementation Tasks" section in iteration
   - If found:
     - Check if all pre-tasks are marked ✅ COMPLETE
     - If any are ⏳ PENDING or 🚧 IN PROGRESS:
       ```
       ❌ Pre-implementation tasks exist but are not complete:
       - [Task 1]: ⏳ PENDING
       - [Task 2]: 🚧 IN PROGRESS

       Complete them first, then run this command again.
       ```
     - If all are ✅ COMPLETE: Proceed to step 4
   - If not found: Proceed to step 4

4. **Verify iteration has up-to-date action items**:

   - Read the iteration's goal or action items
   - Check if they reference the brainstorming session:
     - ✅ **Good patterns**:
       - References brainstorming subjects
       - Has action items from Type D resolutions
     - ❌ **Outdated patterns**:
       - No reference to brainstorming
       - Action items don't match resolved subjects

   - **If action items are outdated**:
     - Warn user: "The iteration's action items don't reference the brainstorming session. Should I update them to match the brainstorming subjects?"
     - Wait for user confirmation

   - **If action items are up-to-date**: Proceed to step 5

5. **Update task file** (`phase-N/task-M.md`):

   a. **Update iteration status** from 🚧 to 🎨:
      ```markdown
      ### 🚧 Iteration 2: Error Handling
      ```
      Becomes:
      ```markdown
      ### 🎨 Iteration 2: Error Handling
      ```

   b. **Add completion note** after brainstorming session:
      ```markdown
      **Brainstorming Status**: ✅ COMPLETE
      **Pre-Implementation Tasks**: ✅ COMPLETE (if applicable)
      **Ready for**: `/flow-implement-start`
      ```

6. **Update DASHBOARD.md**:

   a. **Update "📍 Current Work" section**:
      ```markdown
      ## 📍 Current Work
      - **Phase**: [Phase 2 - Core Implementation](phase-2/)
      - **Task**: [Task 3 - API Integration](phase-2/task-3.md)
      - **Iteration**: [Iteration 2 - Error Handling](phase-2/task-3.md#iteration-2-error-handling) 🎨 READY FOR IMPLEMENTATION
      - **Next**: Use `/flow-implement-start` to begin implementation
      ```

   b. **Update iteration status in "📊 Progress Overview"**:
      - Change iteration marker to show 🎨 READY

   c. **Update "Last Updated" timestamp** at top

   d. **Reminder**: If you discover new issues during implementation (scope violations), STOP and discuss with the user before proceeding.

7. **Confirm to user**:
   ```
   ✅ Brainstorming session complete! Iteration [K]: [Name] marked 🎨 READY FOR IMPLEMENTATION

   **Next Step**: Use `/flow-implement-start` to begin implementation

  
   ```

<!-- COMMAND_END -->
**Output**:
- Updated `phase-N/task-M.md` with 🎨 READY status
- Updated `DASHBOARD.md` with "🎨 READY FOR IMPLEMENTATION"
```

---

## /flow-implement-start

**File**: `flow-implement-start.md`

```markdown
<!-- COMMAND_START -->
---
description: Begin implementation of current iteration
---

You are executing the `/flow-implement-start` command from the Flow framework.

**Purpose**: Begin implementation phase for the current iteration.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from DASHBOARD.md and task file**

- State transition (🎨 READY/⏳ PENDING → 🚧 IMPLEMENTING)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1798-1836 for implementation workflow

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current work
- Updates iteration status in `phase-N/task-M.md`
- Updates `DASHBOARD.md` current work section
- **Prerequisite**: Brainstorming must be ✅ COMPLETE and all pre-implementation tasks done

**🚨 SCOPE BOUNDARY RULE** (CRITICAL - see .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 339-540):

If you discover NEW issues during implementation that are NOT part of the current iteration's action items:

1. **STOP** immediately - Don't make assumptions or proceed
2. **NOTIFY** user - Present discovered issue(s) with structured analysis
3. **DISCUSS** - Provide structured options (A/B/C/D format):
   - **A**: Create pre-implementation task (< 30 min work, blocking)
   - **B**: Add as new brainstorming subject (design needed)
   - **C**: Handle immediately (only if user approves)
   - **D**: Defer to separate iteration (after current work)
4. **AWAIT USER APPROVAL** - Never proceed without explicit user decision

**Use the Scope Boundary Alert Template** (see .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 356-390)

**Exception**: Syntax errors or blocking bugs in files you must modify (document what you fixed in Implementation Notes)

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current task: Phase N, Task M, Iteration K
   - Navigate to task file link

2. **Read current task file** (`phase-N/task-M.md`):
   - Find iteration K in "## Iterations" section
   - Check iteration status (should be 🎨 READY or ⏳ PENDING)

3. **Read Testing Strategy** (CRITICAL):
   - Read `PLAN.md` "## Testing Strategy" section
   - Understand verification methodology (simulation, unit tests, TDD, manual QA)
   - Note file locations, naming conventions
   - **IMPORTANT**: Follow Testing Strategy exactly - do NOT violate conventions

4. **Verify readiness** (if iteration was 🎨 READY):
   - Brainstorming should be marked ✅ COMPLETE
   - All pre-implementation tasks should be ✅ COMPLETE
   - If not ready: Warn user and ask to complete brainstorming/pre-tasks first

5. **Handle ⏳ PENDING iterations** (no brainstorming yet):
   - Ask user: "Previous iteration complete. Do you want to brainstorm this iteration first (recommended) or skip directly to implementation?"
     - **User chooses brainstorm**: "Please run `/flow-brainstorm-start` first"
     - **User chooses skip**: Proceed with implementation

6. **Update task file** (`phase-N/task-M.md`):

   a. **Update iteration status** from 🎨/⏳ to 🚧 IN PROGRESS:
      ```markdown
      ### 🎨 Iteration 2: Error Handling
      ```
      Becomes:
      ```markdown
      ### 🚧 Iteration 2: Error Handling
      ```

   b. **Create implementation section** in task file:
      ```markdown
      #### Implementation - Iteration 2: Error Handling

      **Status**: 🚧 IN PROGRESS (2025-01-15)

      **Action Items**: See resolved subjects above (Type D items)

      **Implementation Notes**:
      [Leave blank - filled during work]

      **Files Modified**:
      [Leave blank - filled as work progresses]

      **Verification**: [Leave blank - how work verified]

      ---
      ```

   **IMPORTANT**: Implementation section REFERENCES subjects (don't duplicate action items)

7. **Update parent task status** (if needed):
   - If task is ⏳ PENDING: Change to 🚧 IN PROGRESS in task file AND DASHBOARD.md
   - If task already 🚧: Skip

8. **Update DASHBOARD.md**:

   a. **Update "📍 Current Work" section**:
      ```markdown
      ## 📍 Current Work
      - **Phase**: [Phase 2 - Core Implementation](phase-2/)
      - **Task**: [Task 3 - API Integration](phase-2/task-3.md)
      - **Iteration**: [Iteration 2 - Error Handling](phase-2/task-3.md#iteration-2-error-handling) 🚧 IMPLEMENTING
      - **Focus**: Implementing comprehensive error handling with retry logic
      ```

   b. **Update iteration status in "📊 Progress Overview"**:
      - Change iteration marker from 🎨/⏳ to 🚧
      - Add "← ACTIVE" indicator

   c. **Update "Last Updated" timestamp** at top

9. **Confirm to user**:
   ```
   ✅ Started implementation of Iteration [K]: [Name]

   Action items from brainstorming subjects:
   - [List Type D action items from resolved subjects]

   Follow Testing Strategy in PLAN.md for verification.
   ```

<!-- COMMAND_END -->
**Output**:
- Updated `phase-N/task-M.md` with implementation section
- Updated `DASHBOARD.md` current work

```

---

## /flow-implement-complete

**File**: `flow-implement-complete.md`

```markdown
<!-- COMMAND_START -->
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

<!-- COMMAND_END -->
**Output**:
- Updated `phase-N/task-M.md` with completion status
- Updated `DASHBOARD.md` with progress and next work

```

---

## /flow-status

**File**: `flow-status.md`

```markdown
<!-- COMMAND_START -->
---
description: Show current position and project progress
---

You are executing the `/flow-status` command from the Flow framework.

**Purpose**: Display current work position and project progress from the dashboard.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md**
- Dashboard-first approach - reads ONLY DASHBOARD.md
- Extremely efficient: <100 lines to read vs thousands in old architecture
- This is the REFERENCE MODEL command - simplest example of multi-file navigation

**Multi-File Architecture**: Flow now uses separate files:
- `DASHBOARD.md` - Progress tracking (⭐ read by this command)
- `PLAN.md` - Static context (not read by this command)
- `phase-N/task-M.md` - Task details (not read by this command)

**Instructions**:

1. **Find .flow/DASHBOARD.md**:
   ```bash
   # Primary location
   .flow/DASHBOARD.md

   # If not found
   Suggest: "/flow-blueprint to create new project" or "/flow-plan-update to migrate old single-file plan"
   ```

2. **Read DASHBOARD.md** (entire file):
   ```bash
   # Simply read the whole file - it's small and focused
   Read: .flow/DASHBOARD.md
   ```

   DASHBOARD.md contains everything you need:
   - Current work pointer (Phase/Task/Iteration)
   - Progress overview for all phases
   - Completion percentages
   - Next actions
   - Recent activity
   - Last updated timestamp

3. **Extract key information**:

   From "📍 Current Work" section:
   - Current Phase (number and name)
   - Current Task (number and name)
   - Current Iteration (number and name)
   - Current status emoji (⏳ 🚧 🎨 ✅ etc.)
   - Focus description

   From "📊 Progress Overview" section:
   - All phases with their status
   - Tasks within each phase
   - Iteration counts per task
   - Completion indicators

   From "📈 Completion Status" section:
   - Phases: X/Y complete
   - Tasks: X/Y complete
   - Iterations: X/Y complete
   - Overall percentage

   From "🎯 Next Actions" section:
   - Immediate actions (today)
   - Short-term actions (this week)
   - Upcoming milestones

4. **Display formatted status**:

   ```
   # [Project Name] - Status

   📍 **Current Work**
   Phase [N]: [Name] [Status]
     └─ Task [M]: [Name] [Status]
         └─ Iteration [K]: [Name] [Status]

   **Focus**: [Current focus description from dashboard]

   ---

   📊 **Progress Overview**

   ### Phase 1: [Name] [Status]
   - Task 1: [Name] [Status] ([X/Y iterations])
   - Task 2: [Name] [Status] ([X/Y iterations])

   ### Phase 2: [Name] [Status] ← CURRENT
   - Task 1: [Name] [Status] ([X/Y iterations])
   - Task 2: [Name] [Status] ([X/Y iterations]) ← CURRENT

   ### Phase 3: [Name] [Status]
   ...

   ---

   📈 **Completion**
   - Phases: [X/Y] ([percentage]%)
   - Tasks: [X/Y] ([percentage]%)
   - Iterations: [X/Y] ([percentage]%)
   - **Overall**: [percentage]%

   ---

   🎯 **Next Actions**
   Immediate:
   - [Action 1]
   - [Action 2]

   Short-term:
   - [Goal 1]
   - [Goal 2]

   ---

   📝 **Recent Activity**
   [Show 3-5 most recent items from dashboard]

   ---

   **Last Updated**: [Timestamp from dashboard]
   ```

5. **Suggest next action** (based on current iteration status):

   Read the current iteration status from dashboard and suggest:

   **If ⏳ PENDING**:
   → "Use `/flow-brainstorm-start` to begin brainstorming this iteration"

   **If 🚧 IN PROGRESS (Brainstorming)**:
   → "Use `/flow-next-subject` to continue brainstorming"
   → Or check "Next Actions" section in dashboard for specific guidance

   **If 🚧 IN PROGRESS (Implementing)**:
   → "Continue implementation. Use `/flow-implement-complete` when done"

   **If 🎨 READY**:
   → "Use `/flow-implement-start` to begin implementation"

   **If ✅ COMPLETE**:
   → "Use `/flow-iteration-add` to add next iteration"
   → Or if task complete: "Use `/flow-task-complete` to finish this task"

6. **Optional: Verify dashboard is up-to-date**:

   Check "Last Updated" timestamp:
   - If recent (< 1 hour): All good
   - If stale (> 24 hours): Suggest running `/flow-verify-plan` to check consistency

   Note: Don't read task files to verify - that's `/flow-verify-plan`'s job. This command trusts the dashboard.

**Key Principle**: DASHBOARD.md is the source of truth for current state. This command simply displays what's in the dashboard - it doesn't validate against task files (that's what `/flow-verify-plan` does).

<!-- COMMAND_END -->
**Output**: Formatted status display with current position, progress overview, completion stats, and next action suggestion.

```

---

## /flow-summarize

**File**: `flow-summarize.md`

```markdown
<!-- COMMAND_START -->
---
description: Generate summary of all phases/tasks/iterations
---

You are executing the `/flow-summarize` command from the Flow framework.

**Purpose**: Generate high-level overview of entire project structure and completion state.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from DASHBOARD.md and task files**
- Uses DASHBOARD.md for high-level view
- Reads task files for detailed iteration status
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 105-179 for hierarchy context

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` for overall structure
- Reads all `phase-N/task-M.md` files for detailed status
- Generates comprehensive summary from all files

**Use case**: "Bird's eye view" of project health, progress across all phases, quick status reports

**Comparison to other commands**:
- `/flow-status` = "Where am I RIGHT NOW?" (micro view - reads DASHBOARD.md only)
- `/flow-summarize` = "What's the WHOLE PICTURE?" (macro view - reads all files)
- `/flow-verify-plan` = "Is this accurate?" (validation)

**Instructions**:

1. **Read DASHBOARD.md**:
   - Extract current work position
   - Get all phases and tasks from "📊 Progress Overview"
   - Get completion percentages from "📈 Completion Status"

2. **Read all task files**:
   - List all phase directories: `ls .flow/phase-*/`
   - For each phase, list task files: `ls .flow/phase-N/`
   - Read each `phase-N/task-M.md` to get:
     - Task status
     - All iterations with status markers
     - Brainstorming status (if applicable)

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

<!-- COMMAND_END -->
**Output**: Hierarchical summary of entire project structure with completion tracking.
```

---

## /flow-next-subject

**File**: `flow-next-subject.md`

```markdown
<!-- COMMAND_START -->
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

<!-- COMMAND_END -->
**Output**: Updated `phase-N/task-M.md` with subject resolution and show next subject.
```

---

## /flow-next-iteration

**File**: `flow-next-iteration.md`

```markdown
<!-- COMMAND_START -->
---
description: Show next iteration details
---

You are executing the `/flow-next-iteration` command from the Flow framework.

**Purpose**: Display details about the next pending iteration in the current task.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md and task file**

- Finds next ⏳ PENDING iteration in current task
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 567-613 for iteration context

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current task
- Reads `phase-N/task-M.md` to find next pending iteration

**Pattern**: Works like `/flow-next-subject` but for iterations - shows what's coming next.

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current task: Phase N, Task M

2. **Read current task file** (`phase-N/task-M.md`):
   - Find "## Iterations" section
   - Look for first iteration marked ⏳ PENDING

3. **Find next pending iteration**: First ⏳ PENDING iteration in task file

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

<!-- COMMAND_END -->
**Output**: Display next iteration details and suggest appropriate next action.
```

---

## /flow-next

**File**: `flow-next.md`

```markdown
<!-- COMMAND_START -->
---
description: Smart helper - suggests next action based on current context
---

You are executing the `/flow-next` command from the Flow framework.

**Purpose**: Auto-detect current context and suggest the next logical step.

**🟢 NO FRAMEWORK READING REQUIRED - This command works entirely from DASHBOARD.md and task file**

- Smart navigation using Dashboard and current context
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 3277-3356 for decision tree reference

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` to find current work
- Reads `phase-N/task-M.md` to determine current state
- Suggests next command based on context

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current iteration: Phase N, Task M, Iteration K

2. **Read current task file** (`phase-N/task-M.md`):
   - Find iteration K
   - Check iteration status (⏳ 🚧 🎨 ✅)

3. **Determine current context**:

   - Check if in brainstorming session:
     - Look for "Subjects to Discuss" section
     - Count unresolved subjects (⏳ markers)
   - Check for pre-implementation tasks:
     - Look for "#### Pre-Implementation Tasks" section
     - Count pending vs complete
   - Check if in main implementation:
     - Look for "#### Implementation" section

4. **Suggest next command based on context**:

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

<!-- COMMAND_END -->
**Output**: Suggest appropriate next command based on context.
```

---

## /flow-rollback

**File**: `flow-rollback.md`

```markdown
<!-- COMMAND_START -->
---
description: Undo last plan change
---

You are executing the `/flow-rollback` command from the Flow framework.

**Purpose**: Undo the last change made to plan files (DASHBOARD.md or task files).

**🟢 NO FRAMEWORK READING REQUIRED - This command works from plan files**

- Undoes last change using CHANGELOG.md
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1969-2014 for rollback patterns

**Multi-File Architecture**: This command can rollback:
- DASHBOARD.md status updates (phase/task/iteration status changes)
- Task file changes (iteration added, status updated)
- File moves (task archived, moved to backlog)

**Instructions**:

1. **Read CHANGELOG.md**:
   - Look for "📝 Recent Activity" section
   - If no CHANGELOG.md or no recent entries: "No recent changes to rollback."

2. **Identify last change**:

   - Parse last entry in CHANGELOG.md
   - Extract what was changed:
     - "Phase N started" → DASHBOARD.md phase status
     - "Task M completed" → DASHBOARD.md + task file status
     - "Iteration K added" → Task file iteration section
     - "Task M moved to backlog" → File moved to backlog/
     - "Task M archived" → File moved to archive/

3. **Ask for confirmation**:

   - Display last change details:
     ```
     Last change ([Date/Time]):
     - Action: [Description]
     - File(s): [Affected files]
     - Change: [What was modified]

     Rollback this change? (yes/no)
     ```

4. **If confirmed, revert change based on type**:

   **A. Status change rollback**:
   - Read DASHBOARD.md
   - Revert status marker to previous state
   - Example: `🚧 IN PROGRESS` → `⏳ PENDING`
   - Update task file status marker if applicable

   **B. File move rollback**:
   - Move file back: `backlog/phase-N-task-M.md` → `phase-N/task-M.md`
   - Or: `archive/phase-N/task-M.md` → `phase-N/task-M.md`
   - Update DASHBOARD.md to remove archived/backlog markers
   - Update BACKLOG.md or CHANGELOG.md accordingly

   **C. Section added rollback**:
   - Remove last added section from task file
   - Example: Remove last iteration, pre-task, or brainstorm subject
   - Update DASHBOARD.md if iteration count changed

   **D. Checkbox rollback**:
   - Uncheck last checked checkbox in task file
   - Find Implementation section, uncheck last ✅ item

5. **Update CHANGELOG.md**: Add rollback entry

   ```markdown
   ### [Date/Time]
   - 🔄 Rolled back: [Description of reverted change]
   ```

6. **Confirm to user**:

   ```
   ✅ Rolled back: [Description of change]

   **Reverted**:
   - File: [file path]
   - Change: [what was undone]

   CHANGELOG.md updated with rollback entry.
   ```

**Limitation**: Can only rollback one step at a time. For major reverts, manually edit files or use git to revert commits.

<!-- COMMAND_END -->
**Output**: Revert last change in plan files, update CHANGELOG.md.
```

---

## /flow-verify-plan

**File**: `flow-verify-plan.md`

```markdown
<!-- COMMAND_START -->
---
description: Verify plan file matches actual codebase state
---

You are executing the `/flow-verify-plan` command from the Flow framework.

**Purpose**: Verify that plan files (DASHBOARD.md, PLAN.md, task files) are synchronized with actual project state.

**🔴 REQUIRED: Read Framework Quick Reference First**

- **Read once per session**: .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 1-353 (Quick Reference section) - if not already in context from earlier in session, read it now
- **Focus on**: Framework Structure validation, Status Markers (in Quick Reference)
- **Deep dive if needed**: Read lines 105-179 for Framework Structure using Read(offset=105, limit=75)

**Multi-File Architecture**: This command verifies:
- `DASHBOARD.md` - Progress tracking and current work pointers
- `PLAN.md` - Static overview (architecture, testing, constraints)
- `phase-N/task-M.md` - Individual task files with iterations
- Task files contain actual action items and implementation details

**Context**:

- **Framework Guide**: .flow/framework/DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working Files**: .flow/DASHBOARD.md, .flow/PLAN.md, .flow/phase-N/task-M.md
- **Use case**: Run before starting new AI session or compacting conversation to ensure context is accurate

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section for current phase/task/iteration
   - Extract current phase number, task number, iteration number
   - Note current iteration status (🚧 IN PROGRESS or 🎨 READY)

2. **Read current task file**:
   - Locate `.flow/phase-N/task-M.md` based on DASHBOARD.md
   - Find current iteration section (marked 🚧 IN PROGRESS or 🎨 READY)
   - Read "Implementation - Iteration [N]" section
   - Identify all action items
   - Note which items are marked as ✅ complete

3. **Verify claimed completions against actual project state**:

   - For each ✅ completed action item, check if it actually exists:
     - "Create UserAuth.ts" → Verify file exists using Glob or Read
     - "Add login endpoint" → Search for login endpoint in code using Grep
     - "Update database schema" → Check schema files exist
   - List any discrepancies found

4. **Check for unreported work**:

   - Look for modified files that aren't mentioned in task file
   - Check git status (if available) for uncommitted changes
   - Identify files that were changed but not documented

5. **Verify DASHBOARD.md accuracy**:
   - Check that current work pointers match actual task file statuses
   - Verify completion percentages align with actual work done
   - Check that phase/task/iteration hierarchy is consistent

6. **Report findings**:
```

📋 Plan Verification Results:

**Current Work** (from DASHBOARD.md):
- Phase [N], Task [M], Iteration [K]

**Task File**: [phase-N/task-M.md](phase-N/task-M.md)

✅ Verified Complete:
- [List action items that are correctly marked complete]

❌ Discrepancies Found:
- [List action items marked complete but evidence not found]
- [List DASHBOARD.md pointers that don't match task files]

📝 Unreported Work:
- [List files changed but not mentioned in task file]

Status: [SYNCHRONIZED / NEEDS UPDATE]

```

7. **If discrepancies found**:
- Ask user: "Plan files are out of sync with project state. Update files now? (yes/no)"
- If yes: Update plan files to reflect actual state:
  - Update task file (phase-N/task-M.md): Uncheck items that aren't actually done
  - Update DASHBOARD.md: Fix current work pointers, completion percentages
  - Add notes about files modified in task file "Implementation Notes" section
  - Update status markers if needed
- If no: "Review discrepancies above and update plan files manually."

8. **If synchronized**:
- "Plan files are synchronized with project state. Ready to continue work."

**Manual alternative**:
- Review DASHBOARD.md for current work location
- Read current task file manually
- Check each completed action item exists in codebase
- Use `git status` and `git diff` to verify changes
- Update task file and DASHBOARD.md to match reality

<!-- COMMAND_END -->
**Output**: Verification report and optional plan file updates.
```

---

## /flow-compact

**File**: `flow-compact.md`

```markdown
<!-- COMMAND_START -->
You are executing the `/flow-compact` command from the Flow framework.

**Purpose**: Generate comprehensive conversation report for context transfer to new AI instance.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from plan files**

- Generates comprehensive report using DASHBOARD.md, PLAN.md, and task file content
- Uses `/flow-status` dashboard-first logic for current position
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 2327-2362 for context preservation patterns

**Multi-File Architecture**: This command reads:
- `DASHBOARD.md` - Current work location and progress overview
- `PLAN.md` - Architecture, testing strategy, constraints (static context)
- `phase-N/task-M.md` - Current task file with iterations, brainstorming, implementation

**Context**:

- **Framework Guide**: .flow/framework/DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working Files**: .flow/DASHBOARD.md, .flow/PLAN.md, .flow/phase-N/task-M.md
- **Use case**: Before compacting conversation or starting new AI session - ensures zero context loss

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section for current phase/task/iteration
   - Read "📊 Progress Overview" for completed work
   - Read "🎯 Next Actions" for pending items
   - Read "📝 Recent Activity" for conversation history
   - Read "💡 Key Decisions This Week" for important context

2. **Read PLAN.md**:
   - Extract "## 🎯 Project Goal" for feature overview
   - Read "## 🏗️ Architecture" section for technical context
   - Read "## 🧪 Testing Strategy" for quality requirements
   - Read "## 📋 Constraints" for limitations
   - Read "## 🎓 Learning Goals" for educational objectives

3. **Read current task file** (from DASHBOARD.md pointers):
   - Locate `.flow/phase-N/task-M.md`
   - Read "Task Overview" section (purpose, dependencies, scope)
   - Read current iteration brainstorming subjects (decisions, rationale)
   - Read "Implementation - Iteration [N]" section (action items, progress)
   - Read "Task Notes" section (discoveries, decisions, references)

4. **Generate comprehensive report covering**:

   **Current Work Context**:

   - What feature/task are we working on? (from DASHBOARD.md)
   - What phase/task/iteration are we in? (with status)
   - What was the original goal? (from PLAN.md + task Purpose)

   **Conversation History**:

   - What decisions were made during brainstorming? (from task file subjects)
   - What subjects were discussed and resolved? (with resolution types)
   - What pre-implementation tasks were identified and completed? (from task file)
   - What action items were generated? (from Implementation section)

   **Implementation Progress**:

   - What has been implemented so far? (from task file Implementation Notes)
   - What files were created/modified? (from Files Modified section)
   - What verification was done? (from Verification section)
   - What remains incomplete? (unchecked action items)

   **Challenges & Solutions**:

   - What blockers were encountered? (from Implementation Notes)
   - How were they resolved? (from Pre-Implementation Tasks or notes)
   - What design trade-offs were made? (from brainstorming rationale)

   **Next Steps**:

   - What is the immediate next action? (from DASHBOARD.md "🎯 Next Actions")
   - What are the pending action items? (from current iteration)
   - What should the next AI instance focus on?

   **Important Context**:

   - Any quirks or special considerations (from Task Notes)
   - Technical constraints (from PLAN.md + Task Overview dependencies)
   - User preferences or decisions that must be preserved (from decisions)

5. **Report format**:
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
- "Use `/flow-verify-plan` before starting new session to ensure plan files (DASHBOARD.md, task files) are synchronized."

**Manual alternative**:
- Read entire conversation history manually
- Read DASHBOARD.md for current status
- Read current task file for detailed context
- Read PLAN.md for architectural constraints
- Summarize key points, decisions, and progress
- Document in separate notes file

<!-- COMMAND_END -->
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

**File**: `flow-plan-split.md`

```markdown
<!-- COMMAND_START -->
---
description: Archive old completed tasks to reduce PLAN.md size
---

You are executing the `/flow-plan-split` command from the Flow framework.

**Purpose**: Archive old completed tasks to reduce DASHBOARD.md clutter while preserving full project history in `archive/` directory.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from plan files**

- Moves completed task FILES to archive/ directory (keeps recent 3 tasks visible)
- Updates DASHBOARD.md and CHANGELOG.md to reflect archived tasks
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 2363-2560 for archival patterns

**Multi-File Architecture**: This command:
- Moves `phase-N/task-M.md` files to `archive/phase-N/task-M.md`
- Updates `DASHBOARD.md` to mark tasks as archived
- Updates `CHANGELOG.md` to reference archived task files

**Context**:

- **Framework Guide**: .flow/framework/DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working Files**: .flow/DASHBOARD.md, .flow/phase-N/task-M.md
- **Archive Directory**: .flow/archive/ (task files moved here)
- **Changelog**: .flow/CHANGELOG.md (updated with archive references)

**When to Use**: When DASHBOARD.md has 10+ completed tasks, causing clutter or difficult navigation.

**Archiving Strategy - Recent Context Window**:

- **Keep visible in DASHBOARD.md**: Current task + 3 previous tasks (regardless of status)
- **Archive**: All ✅ COMPLETE tasks older than "current - 3"
- **Always Keep Visible**: Non-complete tasks (⏳ 🚧 ❌ 🔮 🎨) regardless of age

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section
   - Extract current task number (e.g., Task 13)
   - Find "📊 Progress Overview" to list all tasks

2. **Calculate archiving threshold**:

   - Threshold = Current task number - 3
   - Example: Current = 13, Threshold = 10
   - **Archive candidates**: Tasks 1-9 (if ✅ COMPLETE)
   - **Keep visible**: Tasks 10, 11, 12, 13 (current + 3 previous)

3. **Identify archivable tasks**:

   - Find all tasks with number < threshold AND status = ✅ COMPLETE
   - List task files: `phase-N/task-M.md` for each archivable task
   - **IMPORTANT**: Keep non-complete tasks visible (⏳ 🚧 ❌ 🔮 🎨) even if old

4. **Move task files to archive**:

   - Create `archive/` directory if doesn't exist
   - For each archivable task:
     - Create phase directory in archive: `archive/phase-N/` if needed
     - Move `phase-N/task-M.md` to `archive/phase-N/task-M.md`
     - Preserve full task content (iterations, brainstorming, everything)

5. **Update CHANGELOG.md**:

   **If .flow/CHANGELOG.md does NOT exist** (first archive):

   ```markdown
   # Project Changelog

   This file contains historical records of completed tasks moved to archive.

   ## 📦 Archived Tasks

   ### Phase N: [Phase Name]

   - **Task M**: [Task Name] - [archive/phase-N/task-M.md](archive/phase-N/task-M.md)
     - Completed: [Date]
     - Archived: [Date]

   ---

   **Last Updated**: [Date]
   **Total Archived**: [Count] tasks
   ```

   **If .flow/CHANGELOG.md ALREADY exists**:
   - Read existing CHANGELOG.md
   - Add new archived tasks under appropriate phase sections
   - Update "Last Updated" and "Total Archived" count
   - Maintain phase hierarchy (don't duplicate phase headers)

6. **Update DASHBOARD.md**:

   **A. Update Progress Overview**:
   - Add 📦 marker to archived tasks
   - Format: `- ✅📦 Task 5: Feature Name (archived)`
   - Keep task in list but mark as archived
   - Update completion percentages to reflect remaining visible tasks

   **B. Update phase headers** (if all phase tasks archived):
   ```markdown
   ### Phase 1: Foundation ✅ COMPLETE

   **Goal**: [Phase goal]
   **Status**: 100% complete ([N] tasks archived to [archive/phase-1/](archive/phase-1/))
   ```

7. **Verify and confirm**:

   - Count archived files
   - Calculate DASHBOARD.md size reduction
   - Confirm to user:

     ```
     ✅ Plan split complete!

     **Archived**: [X] tasks to .flow/archive/
     **Files moved**:
       - phase-1/task-1.md → archive/phase-1/task-1.md
       - phase-1/task-2.md → archive/phase-1/task-2.md
       ...

     **DASHBOARD.md**: Updated to mark [X] tasks as 📦 archived
     **CHANGELOG.md**: Updated with archive references
     **Recent context**: Kept Task [threshold] through Task [current] visible

     Your Progress Dashboard still shows complete project history.
     Archived task files available in .flow/archive/
     ```

**Edge Cases**:

- **No old completed tasks**: "No tasks to archive. All completed tasks are within recent context window (current + 3 previous)."
- **Current task < 4**: "Current task is Task [N]. Need at least Task 4 to enable archiving (keeps current + 3 previous)."
- **Non-complete old tasks**: Keep visible in DASHBOARD.md: "Task [N] kept visible (not complete - status: [status])"

<!-- COMMAND_END -->
**Output**: Move task files to archive/, update DASHBOARD.md and CHANGELOG.md (full history preserved).

```

---

## /flow-backlog-add

**File**: `flow-backlog-add.md`

```markdown
<!-- COMMAND_START -->
---
description: Move task(s) to backlog to reduce active plan clutter
---

You are executing the `/flow-backlog-add` command from the Flow framework.

**Purpose**: Move pending tasks to BACKLOG.md to reduce active dashboard clutter while preserving all task content.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from DASHBOARD.md and task files**

- Moves task files to backlog directory (token efficiency feature)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 3407-3682 for backlog management patterns

**Multi-File Architecture**: This command:
- Moves `phase-N/task-M.md` files to `backlog/` directory
- Updates `DASHBOARD.md` to remove tasks from active view
- Creates/updates `BACKLOG.md` with references to backogged tasks

**Key Insight**: Backlog is for **token efficiency**, not prioritization. Tasks aren't "low priority" - they're just "not now" (weeks/months away).

**Signature**: `/flow-backlog-add <task-number>` or `/flow-backlog-add <start>-<end>`

**Examples**:
- `/flow-backlog-add 14` - Move Task 14 to backlog
- `/flow-backlog-add 14-22` - Move Tasks 14 through 22 to backlog

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📊 Progress Overview" section
   - Locate tasks by number

2. **Parse arguments**:
   - Single task: `task_numbers` = task number (e.g., "14")
   - Range: `task_numbers` = start-end (e.g., "14-22")
   - Extract task number(s) to move

3. **Validate tasks**:
   - Find task files: `phase-N/task-M.md`
   - Check task status - warn if moving tasks that are 🚧 IN PROGRESS or ✅ COMPLETE
   - Recommended: Only move ⏳ PENDING tasks
   - If user confirms moving non-pending tasks, proceed

4. **Move task files to backlog**:
   - Create `backlog/` directory if doesn't exist
   - For each task:
     - Move `phase-N/task-M.md` to `backlog/phase-N-task-M.md`
     - Preserve all content (iterations, brainstorming, everything)

5. **Update BACKLOG.md**:

   **If BACKLOG.md does NOT exist** (first time):

   ```markdown
   # Project Backlog

   This file lists tasks moved to backlog/ directory to reduce active dashboard size.

   **Backlog Info**:
   - Task files moved to backlog/ directory
   - Tasks retain original numbers for easy reference
   - Full content preserved (brainstorming, iterations, everything)
   - Pull tasks back when ready to work on them

   **Last Updated**: [Current date]
   **Tasks in Backlog**: [Count]

   ---

   ## 📋 Backlog Tasks

   - **Task [N]**: [Name] - [backlog/phase-N-task-M.md](backlog/phase-N-task-M.md)
   - **Task [N]**: [Name] - [backlog/phase-N-task-M.md](backlog/phase-N-task-M.md)
   ```

   **If BACKLOG.md ALREADY exists**:
   - Read existing BACKLOG.md
   - Update "Last Updated" timestamp
   - Update "Tasks in Backlog" count
   - Add tasks to "📋 Backlog Tasks" list

6. **Update DASHBOARD.md**:
   - Remove tasks from "📊 Progress Overview" section
   - Or mark as moved: `- ⏳ Task 14: Potency system (moved to backlog)`
   - Update completion percentages

7. **Reset task status to ⏳ PENDING** (in backlog files):
   - Open each backlog file
   - Change task status to ⏳ PENDING
   - Fresh start when pulled back

8. **Verify and confirm**:
   - Count moved files
   - Confirm to user:

     ```
     ✅ Moved to backlog!

     **Backlogged**: [N] task(s) to backlog/ directory
     **Files moved**: Task [list of numbers]
     **Location**: backlog/phase-N-task-M.md

     Use `/flow-backlog-view` to see backlog contents.
     Use `/flow-backlog-pull <task-number>` to bring a task back when ready.
     ```

**Edge Cases**:
- **Task doesn't exist**: "Task [N] not found"
- **Invalid range**: "Invalid range format. Use: /flow-backlog-add 14-22"
- **Empty range**: "No tasks found in range 14-22"
- **Already in backlog**: Check backlog/ directory first, warn if task already there

<!-- COMMAND_END -->
**Output**: Move task files to backlog/ directory, update DASHBOARD.md and BACKLOG.md.

```

---

## /flow-backlog-view

**File**: `flow-backlog-view.md`

```markdown
<!-- COMMAND_START -->
---
description: Show backlog contents (tasks waiting)
---

You are executing the `/flow-backlog-view` command from the Flow framework.

**Purpose**: Display backlog showing all tasks currently in backlog directory.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from BACKLOG.md and backlog/ directory**

- Simple read operation (shows backlog list)
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 3407-3682 for backlog context

**Multi-File Architecture**: This command:
- Reads `BACKLOG.md` for task list
- Lists files in `backlog/` directory

**Instructions**:

1. **Check if BACKLOG.md exists**:
   - If NOT found: "📦 Backlog is empty. Use `/flow-backlog-add <task>` to move tasks."
   - If found: Proceed to step 2

2. **Read BACKLOG.md**:
   - Extract "Last Updated" timestamp
   - Extract "Tasks in Backlog" count
   - Read "📋 Backlog Tasks" section for task list

3. **Verify backlog/ directory**:
   - List files in `backlog/` directory
   - Confirm task files exist: `backlog/phase-N-task-M.md`

4. **Display backlog contents**:

   ```
   📦 Backlog Contents ([N] tasks):

   **Last Updated**: [Date]

   **Tasks Waiting**:
   - **Task 14**: Potency system - [backlog/phase-2-task-14.md](backlog/phase-2-task-14.md)
   - **Task 15**: Points & Luck systems - [backlog/phase-2-task-15.md](backlog/phase-2-task-15.md)
   - **Task 16**: Database persistence - [backlog/phase-3-task-16.md](backlog/phase-3-task-16.md)

   ---

   **Next Steps**:
   - Use `/flow-backlog-pull <task-number>` to move a task back to active work
   - Example: `/flow-backlog-pull 14` brings Task 14 back to its original phase
   ```

5. **Optional: Show task details** (if user wants more info):
   - Can read full task file from backlog/ on request
   - Default view is just list (lightweight)

<!-- COMMAND_END -->
**Output**: Display backlog list with task files and guidance.

```

---

## /flow-backlog-pull

**File**: `flow-backlog-pull.md`

```markdown
<!-- COMMAND_START -->
---
description: Pull task from backlog back into active plan
---

You are executing the `/flow-backlog-pull` command from the Flow framework.

**Purpose**: Move a task from BACKLOG.md back to PLAN.md with sequential renumbering in active phase.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from DASHBOARD.md, BACKLOG.md, and task files**

- Moves task file back from backlog/ to phase directory
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 3407-3682 for backlog patterns

**Multi-File Architecture**: This command:
- Moves `backlog/phase-N-task-M.md` back to `phase-N/task-M.md`
- Updates `DASHBOARD.md` to show task
- Updates `BACKLOG.md` to remove task

**Signature**: `/flow-backlog-pull <task-number> [position]`

**Examples**:
- `/flow-backlog-pull 14` - Pull Task 14 back to its original phase
- `/flow-backlog-pull 14 add to phase 5` - Pull Task 14 to Phase 5 instead

**Instructions**:

1. **Check if BACKLOG.md exists**:
   - If NOT found: "📦 Backlog is empty. Nothing to pull."
   - If found: Proceed

2. **Parse arguments**:
   - Required: `task_number` - Task number to pull (e.g., "14")
   - Optional: `position` - Positioning instruction (e.g., "add to phase 5")

3. **Validate task exists in backlog**:
   - Read BACKLOG.md to find task entry
   - Find backlog file: `backlog/phase-N-task-M.md`
   - If NOT found: "Task [N] not found in backlog. Use `/flow-backlog-view` to see available."
   - If found: Proceed

4. **Determine target phase**:
   - **Default**: Use task's original phase (from filename `phase-N-task-M.md`)
   - **With position instruction**: Parse for target phase
     - "add to phase 5" → Move to phase-5/
   - **If phase doesn't exist**: Create phase directory

5. **Determine new task number**:
   - List existing tasks in target phase
   - Find highest task number
   - New task number = highest + 1
   - Example: phase-2/ has task-1.md, task-2.md → new task is task-3.md

6. **Move task file back**:
   - Move `backlog/phase-N-task-M.md` to `phase-N/task-K.md` (K = new number)
   - Update task metadata in file:
     - Update task number in header
     - Reset status to ⏳ PENDING
   - Preserve all content (iterations, brainstorming, everything)

7. **Update BACKLOG.md**:
   - Remove task from "📋 Backlog Tasks" list
   - Decrement "Tasks in Backlog" count
   - Update "Last Updated" timestamp

8. **Update DASHBOARD.md**:
   - Add task to "📊 Progress Overview" in target phase
   - Mark as ⏳ PENDING
   - Update phase task count
   - Update completion percentages

9. **Verify and confirm**:
   ```
   ✅ Pulled from backlog!

   **Task**: Task [old-number] → Task [new-number]
   **File**: backlog/phase-N-task-M.md → phase-N/task-K.md
   **Phase**: Phase [N]: [Name]
   **Status**: ⏳ PENDING (ready to start)

   **Backlog**: [N-1] tasks remaining

   Use `/flow-task-start` to begin this task when ready.
   ```

**Edge Cases**:
- **Backlog empty**: "Backlog is empty. Nothing to pull."
- **Task not in backlog**: "Task [N] not in backlog."
- **Target phase doesn't exist**: Create phase directory
- **No active phase**: Ask user which phase to add task to

<!-- COMMAND_END -->
**Output**: Move task file from backlog/ to phase directory, update DASHBOARD.md and BACKLOG.md.

```

