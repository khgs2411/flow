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
