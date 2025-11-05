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
   ✓ Framework docs → .flow/framework/
   ✓ Example files → .flow/framework/examples/

   Total download size: ~200KB

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
