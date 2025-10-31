#!/usr/bin/env bash

################################################################################
# Build Standalone Flow Script
#
# This script generates a self-contained flow-standalone.sh that includes
# all framework content embedded within it.
################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_DIR="$SCRIPT_DIR/framework"
OUTPUT_FILE="$SCRIPT_DIR/flow.sh"
VERSION_FILE="$SCRIPT_DIR/VERSION"

# Read version from VERSION file (single source of truth)
if [ ! -f "$VERSION_FILE" ]; then
  echo "❌ VERSION file not found!"
  exit 1
fi
FLOW_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')

echo "🔨 Building standalone Flow framework script v${FLOW_VERSION}..."
echo ""

# Validation function: Check command-framework mappings
validate_framework_references() {
  echo "🔍 Validating command→framework references..."
  echo ""

  local commands_file="$FRAMEWORK_DIR/SLASH_COMMANDS.md"
  local framework_file="$FRAMEWORK_DIR/DEVELOPMENT_FRAMEWORK.md"
  local errors=0
  local warnings=0

  # Get total number of command sections
  local total_commands=$(grep -c "^## /" "$commands_file")

  echo "📋 Found $total_commands command definitions in SLASH_COMMANDS.md"
  echo ""

  # Extract all command names
  local cmd_names=($(grep "^## /" "$commands_file" | sed 's/^## \///'))

  for cmd in "${cmd_names[@]}"; do
    # Check if command has reading requirement notice (new 🔴/🟢 pattern)
    # Get line number of command header
    local cmd_line=$(grep -n "^## /$cmd\$" "$commands_file" | cut -d: -f1)

    # Get line number of next command (or end of file)
    local next_cmd_line=$(grep -n "^## /" "$commands_file" | awk -F: -v line="$cmd_line" '$1 > line {print $1; exit}')
    [ -z "$next_cmd_line" ] && next_cmd_line=$(wc -l < "$commands_file")

    # Extract command section
    local cmd_section=$(sed -n "${cmd_line},${next_cmd_line}p" "$commands_file")

    # Check for new pattern (🔴 REQUIRED or 🟢 NO FRAMEWORK READING REQUIRED)
    local has_new_pattern=$(echo "$cmd_section" | grep -c "^\*\*🔴 REQUIRED:\|^\*\*🟢 NO FRAMEWORK READING REQUIRED")

    # Check for old pattern (backward compatibility)
    local has_old_pattern=$(echo "$cmd_section" | grep -c "^\*\*Framework Reference\*\*:")

    if [ "$has_new_pattern" -eq 0 ] && [ "$has_old_pattern" -eq 0 ]; then
      echo "❌ /$cmd: Missing framework reading requirement notice (🔴/🟢)"
      ((errors++))
      continue
    fi

    # If using new pattern, validate it
    if [ "$has_new_pattern" -gt 0 ]; then
      # Check if it's Category A (🔴 REQUIRED)
      local is_category_a=$(echo "$cmd_section" | grep -c "^\*\*🔴 REQUIRED:")

      if [ "$is_category_a" -gt 0 ]; then
        # Verify it has Quick Reference reading instruction (either old "MUST READ" or new "Read once per session")
        local read_instruction=$(echo "$cmd_section" | grep -E "^- \*\*(MUST READ|Read once per session)\*\*:")
        if [ -z "$read_instruction" ]; then
          echo "⚠️  /$cmd: Category A command missing Quick Reference reading instruction"
          ((warnings++))
        else
          echo "✅ /$cmd: Category A (🔴 REQUIRED - Quick Reference)"
        fi
      else
        # Category B command
        echo "✅ /$cmd: Category B (🟢 NO FRAMEWORK READING)"
      fi
    else
      # Old pattern - still validate line numbers for backward compatibility
      local ref_line=$(echo "$cmd_section" | grep "^\*\*Framework Reference\*\*:" | head -1)
      local line_ranges=$(echo "$ref_line" | grep -oE '\(lines? [0-9]+-?[0-9]*\)|\(line [0-9]+\)')

      if [ -z "$line_ranges" ]; then
        echo "⚠️  /$cmd: Old pattern - Framework Reference found but no line numbers"
        ((warnings++))
      else
        echo "✅ /$cmd: Old pattern (will migrate to 🔴/🟢 in future)"
      fi
    fi
  done

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  if [ "$errors" -gt 0 ]; then
    echo "❌ Validation FAILED: $errors error(s), $warnings warning(s)"
    echo ""
    echo "Please fix the errors before building:"
    echo "  - Ensure all commands have **Framework Reference**: sections"
    echo "  - Verify all line numbers are within framework file bounds"
    echo "  - Check SLASH_COMMANDS.md and DEVELOPMENT_FRAMEWORK.md"
    echo ""
    return 1
  elif [ "$warnings" -gt 0 ]; then
    echo "⚠️  Validation passed with $warnings warning(s)"
    echo ""
  else
    echo "✅ All $total_commands commands have valid framework references!"
    echo ""
  fi

  return 0
}

# Run validation before building
validate_framework_references || exit 1

echo "🔨 Building standalone Flow framework script v${FLOW_VERSION}..."
echo ""

# Start building the standalone script
cat > "$OUTPUT_FILE" <<'HEADER_EOF'
#!/usr/bin/env bash

################################################################################
# Flow Framework Deployment Script
#
# Self-contained script with all framework content embedded.
# Distribute this single file to install the Flow framework.
#
# Version: __FLOW_VERSION__
# Generated by build-standalone.sh
################################################################################

set -e

FLOW_VERSION="__FLOW_VERSION__"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

COMMANDS=(
  # Plan Initialization (4 commands)
  "flow-blueprint" "flow-migrate" "flow-plan-update" "flow-plan-split"
  # Phase Lifecycle (3 commands)
  "flow-phase-add" "flow-phase-start" "flow-phase-complete"
  # Task Lifecycle (3 commands)
  "flow-task-add" "flow-task-start" "flow-task-complete"
  # Iteration Lifecycle (6 commands: add, start, subject, review, complete, implement-start, implement-complete = 7 total)
  "flow-iteration-add"
  "flow-brainstorm-start" "flow-brainstorm-subject" "flow-brainstorm-review" "flow-brainstorm-complete"
  "flow-implement-start" "flow-implement-complete"
  # Navigation (3 commands)
  "flow-next" "flow-next-subject" "flow-next-iteration"
  # Status & Validation (5 commands)
  "flow-status" "flow-summarize" "flow-verify-plan" "flow-compact" "flow-rollback"
  # Backlog Management (3 commands)
  "flow-backlog-add" "flow-backlog-view" "flow-backlog-pull"
)

# Deprecated commands (renamed/removed in v1.0.11+) - cleaned up during --force
DEPRECATED_COMMANDS=(
  "flow-phase" "flow-task" "flow-iteration"
  "flow-brainstorm_start" "flow-brainstorm_subject" "flow-brainstorm_resolve" "flow-brainstorm_complete"
  "flow-implement_start" "flow-implement_complete"
  "flow-update-plan-version"
  "flow-brainstorm-resolve"  # Removed in v1.0.12 - redundant command
)

FORCE=false

print_help() {
  cat <<EOF

Flow Framework Deployment Script v$FLOW_VERSION

USAGE:
  ./flow.sh [OPTIONS]

OPTIONS:
  --force, -f       Overwrite existing files
  --version, -v     Show version information
  --help, -h        Show this help

DEPLOYMENT STRUCTURE:
  .claude/commands/          Slash commands (\${#COMMANDS[@]} files)
  .claude/skills/            Agent Skills (6 Skills with supporting files)
  .flow/framework/           AI reference files (read-only for user)
    ├── DEVELOPMENT_FRAMEWORK.md
    ├── skills/SKILLS_GUIDE.md
    └── examples/

This script is SELF-CONTAINED - no external files needed!

EOF
}

print_version() {
  cat <<EOF
Flow Framework v$FLOW_VERSION

A spec-driven iterative development methodology combining
Domain-Driven Design principles with Agile philosophy.

Created by: Liad Goren
Repository: https://github.com/khgs2411/flow
License: Open for personal and commercial use

EOF
}

extract_command() {
  local cmd="$1"
  local marker="## /${cmd}$"
  awk -v marker="$marker" '
    $0 ~ marker {found=1; next}
    found && /<!-- COMMAND_START -->/ {inside=1; next}
    found && inside && /<!-- COMMAND_END -->/ {exit}
    found && inside {print}
  ' <<'COMMANDS_DATA_EOF'
HEADER_EOF

# Embed SLASH_COMMANDS.md content
cat "$FRAMEWORK_DIR/SLASH_COMMANDS.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE1_EOF'
COMMANDS_DATA_EOF
}

get_framework_content() {
  cat <<'FRAMEWORK_DATA_EOF'
MIDDLE1_EOF

# Embed DEVELOPMENT_FRAMEWORK.md content
cat "$FRAMEWORK_DIR/DEVELOPMENT_FRAMEWORK.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE2_EOF'
FRAMEWORK_DATA_EOF
}

get_example_dashboard() {
  cat <<'EXAMPLE_DASHBOARD_EOF'
MIDDLE2_EOF

# Embed examples/DASHBOARD.md content
cat "$FRAMEWORK_DIR/examples/DASHBOARD.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE3_EOF'
EXAMPLE_DASHBOARD_EOF
}

get_example_plan() {
  cat <<'EXAMPLE_PLAN_EOF'
MIDDLE3_EOF

# Embed examples/PLAN.md content
cat "$FRAMEWORK_DIR/examples/PLAN.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE4_EOF'
EXAMPLE_PLAN_EOF
}

get_example_task_standalone() {
  cat <<'EXAMPLE_TASK_STANDALONE_EOF'
MIDDLE4_EOF

# Embed examples/phase-1/task-1.md content
cat "$FRAMEWORK_DIR/examples/phase-1/task-1.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE5_EOF'
EXAMPLE_TASK_STANDALONE_EOF
}

get_example_task_iterations() {
  cat <<'EXAMPLE_TASK_ITERATIONS_EOF'
MIDDLE5_EOF

# Embed examples/phase-2/task-3.md content
cat "$FRAMEWORK_DIR/examples/phase-2/task-3.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE6_EOF'
EXAMPLE_TASK_ITERATIONS_EOF
}

get_skills_guide() {
  cat <<'SKILLS_GUIDE_EOF'
MIDDLE6_EOF

# Embed SKILLS_GUIDE.md content
cat "$FRAMEWORK_DIR/skills/SKILLS_GUIDE.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE7_EOF'
SKILLS_GUIDE_EOF
}

# Skill extraction functions
get_skill_flow_navigator() {
  cat <<'SKILL_FLOW_NAVIGATOR_EOF'
MIDDLE7_EOF

# Embed flow-navigator SKILL.md
cat "$FRAMEWORK_DIR/skills/flow-navigator/SKILL.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE8_EOF'
SKILL_FLOW_NAVIGATOR_EOF
}

get_skill_flow_planner() {
  cat <<'SKILL_FLOW_PLANNER_EOF'
MIDDLE8_EOF

# Embed flow-planner SKILL.md
cat "$FRAMEWORK_DIR/skills/flow-planner/SKILL.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE9_EOF'
SKILL_FLOW_PLANNER_EOF
}

get_skill_flow_planner_templates() {
  cat <<'SKILL_FLOW_PLANNER_TEMPLATES_EOF'
MIDDLE9_EOF

# Embed flow-planner TEMPLATES.md
cat "$FRAMEWORK_DIR/skills/flow-planner/TEMPLATES.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE10_EOF'
SKILL_FLOW_PLANNER_TEMPLATES_EOF
}

get_skill_flow_implementer() {
  cat <<'SKILL_FLOW_IMPLEMENTER_EOF'
MIDDLE10_EOF

# Embed flow-implementer SKILL.md
cat "$FRAMEWORK_DIR/skills/flow-implementer/SKILL.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE11_EOF'
SKILL_FLOW_IMPLEMENTER_EOF
}

get_skill_flow_implementer_patterns() {
  cat <<'SKILL_FLOW_IMPLEMENTER_PATTERNS_EOF'
MIDDLE11_EOF

# Embed flow-implementer PATTERNS.md
cat "$FRAMEWORK_DIR/skills/flow-implementer/PATTERNS.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE12_EOF'
SKILL_FLOW_IMPLEMENTER_PATTERNS_EOF
}

get_skill_flow_implementer_verification() {
  cat <<'SKILL_FLOW_IMPLEMENTER_VERIFICATION_EOF'
MIDDLE12_EOF

# Embed flow-implementer VERIFICATION.md
cat "$FRAMEWORK_DIR/skills/flow-implementer/VERIFICATION.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE13_EOF'
SKILL_FLOW_IMPLEMENTER_VERIFICATION_EOF
}

get_skill_flow_architect() {
  cat <<'SKILL_FLOW_ARCHITECT_EOF'
MIDDLE13_EOF

# Embed flow-architect SKILL.md
cat "$FRAMEWORK_DIR/skills/flow-architect/SKILL.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE14_EOF'
SKILL_FLOW_ARCHITECT_EOF
}

get_skill_flow_architect_plan_updates() {
  cat <<'SKILL_FLOW_ARCHITECT_PLAN_UPDATES_EOF'
MIDDLE14_EOF

# Embed flow-architect PLAN_UPDATES.md
cat "$FRAMEWORK_DIR/skills/flow-architect/PLAN_UPDATES.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE15_EOF'
SKILL_FLOW_ARCHITECT_PLAN_UPDATES_EOF
}

get_skill_flow_reviewer() {
  cat <<'SKILL_FLOW_REVIEWER_EOF'
MIDDLE15_EOF

# Embed flow-reviewer SKILL.md
cat "$FRAMEWORK_DIR/skills/flow-reviewer/SKILL.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE16_EOF'
SKILL_FLOW_REVIEWER_EOF
}

get_skill_flow_reviewer_verify() {
  cat <<'SKILL_FLOW_REVIEWER_VERIFY_EOF'
MIDDLE16_EOF

# Embed flow-reviewer VERIFY.md
cat "$FRAMEWORK_DIR/skills/flow-reviewer/VERIFY.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE17_EOF'
SKILL_FLOW_REVIEWER_VERIFY_EOF
}

get_skill_flow_documenter() {
  cat <<'SKILL_FLOW_DOCUMENTER_EOF'
MIDDLE17_EOF

# Embed flow-documenter SKILL.md
cat "$FRAMEWORK_DIR/skills/flow-documenter/SKILL.md" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE18_EOF'
SKILL_FLOW_DOCUMENTER_EOF
}

MIDDLE18_EOF

# Write the main deployment logic
cat >> "$OUTPUT_FILE" <<'FOOTER_EOF'
update_claude_md() {
  local force="$1"
  local claude_md="$(pwd)/CLAUDE.md"

  # Flow framework notice content (without header for insertion)
  local flow_content='- **This project leverages '\''flow framework'\''**: This project uses the flow framework for project management. Follow flow conventions for tasks, iterations, and brainstorming. Try to use the skills agents where possible for the best results. Alternatively, use the slash commands to interact with the flow system.'

  echo -e "${CYAN}📝 Checking CLAUDE.md...${NC}"

  # Check if CLAUDE.md exists
  if [ ! -f "$claude_md" ]; then
    # CLAUDE.md doesn't exist - skip
    echo -e "${YELLOW}⏭️  No CLAUDE.md found - skipping${NC}"
    return 0
  fi

  # CLAUDE.md exists - check if Flow notice is present
  if grep -qi "flow framework" "$claude_md"; then
    # Flow framework mention found
    if [ "$force" = true ]; then
      # Force mode: update/replace the section
      echo -e "${YELLOW}🔄 Updating Flow framework section (--force mode)...${NC}"

      # Strategy: Remove old flow section, then add new one
      local temp_file="${claude_md}.tmp"
      local in_flow_section=0

      # First pass: remove old flow section
      while IFS= read -r line; do
        if [[ "$line" =~ ^##\ Important\ rules\ and\ guidelines ]]; then
          in_flow_section=1
          continue
        fi

        if [ $in_flow_section -eq 1 ] && [[ "$line" =~ ^## ]]; then
          in_flow_section=0
        fi

        if [[ "$line" =~ flow\ framework ]] && [ $in_flow_section -eq 1 ]; then
          continue
        fi

        if [ $in_flow_section -eq 0 ]; then
          echo "$line"
        fi
      done < "$claude_md" > "$temp_file"

      # Second pass: add new flow section after title + boilerplate
      local final_file="${claude_md}.final"
      local inserted=0
      local after_title=0

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
            echo "${flow_content}"
            echo ""
            inserted=1
          fi
        fi

        # Fallback: if we hit another ## section and still haven't inserted, insert before it
        if [[ "$line" =~ ^## ]] && [ $inserted -eq 0 ] && [ $after_title -eq 0 ]; then
          echo "## Important rules and guidelines"
          echo "${flow_content}"
          echo ""
          inserted=1
          echo "$line"
          continue
        fi
      done < "$temp_file" > "$final_file"

      # If never inserted (no title, no ## sections), add at top
      if [ $inserted -eq 0 ]; then
        {
          echo "## Important rules and guidelines"
          echo "${flow_content}"
          echo ""
          cat "$temp_file"
        } > "$final_file"
      fi

      mv "$final_file" "$claude_md"
      rm -f "$temp_file"
      echo -e "${GREEN}✅ Updated Flow framework section in CLAUDE.md${NC}"
    else
      # Not force mode - skip
      echo -e "${GREEN}✅ CLAUDE.md already has Flow framework notice (use --force to update)${NC}"
    fi
    return 0
  fi

  # Flow notice not found - add it
  echo -e "${BLUE}Adding Flow framework notice to CLAUDE.md...${NC}"

  local temp_file="${claude_md}.tmp"
  local inserted=0
  local after_title=0
  local prev_line=""

  # Check if file has "# CLAUDE.md" title
  if grep -q "^# CLAUDE.md" "$claude_md"; then
    # Has title - insert after title + boilerplate
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
          echo "${flow_content}"
          echo ""
          inserted=1
        fi
      fi

      prev_line="$line"
    done < "$claude_md" > "$temp_file"
  else
    # No title - insert at very top
    {
      echo "## Important rules and guidelines"
      echo "${flow_content}"
      echo ""
      cat "$claude_md"
    } > "$temp_file"
  fi

  mv "$temp_file" "$claude_md"
  echo -e "${GREEN}✅ Added Flow framework notice to CLAUDE.md${NC}"
}

deploy_commands() {
  local target_dir="$1"
  local force="$2"
  local success_count=0

  # If force mode, clean up deprecated commands first
  if [ "$force" = true ]; then
    echo -e "${CYAN}🧹 Cleaning deprecated commands...${NC}"
    for deprecated_cmd in "${DEPRECATED_COMMANDS[@]}"; do
      local deprecated_file="$target_dir/${deprecated_cmd}.md"
      if [ -f "$deprecated_file" ]; then
        rm -f "$deprecated_file"
        echo -e "${YELLOW}🗑️  Removed deprecated: ${deprecated_cmd}.md${NC}"
      fi
    done
    echo ""
  fi

  for cmd in "${COMMANDS[@]}"; do
    local cmd_file="$target_dir/${cmd}.md"

    # If force mode, delete existing file first to ensure clean write
    if [ "$force" = true ] && [ -f "$cmd_file" ]; then
      rm -f "$cmd_file"
    fi

    [ -f "$cmd_file" ] && [ "$force" = false ] && { echo -e "${YELLOW}⏭️  Skip ${cmd}.md${NC}"; continue; }

    local content=$(extract_command "$cmd")
    [ -z "$content" ] && { echo -e "${RED}❌ Failed ${cmd}${NC}"; continue; }

    echo "$content" > "$cmd_file" && { echo -e "${GREEN}✅ ${cmd}.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ ${cmd}.md${NC}"
  done

  echo "$success_count"
}

deploy_framework() {
  local target_dir="$1"
  local force="$2"
  local framework_dir="$target_dir/framework"
  local framework_file="$framework_dir/DEVELOPMENT_FRAMEWORK.md"
  local examples_dir="$framework_dir/examples"

  # Create framework directory
  mkdir -p "$framework_dir" || { echo -e "${RED}❌ mkdir framework/${NC}"; return 1; }

  # If force mode, delete existing files first to ensure clean write
  if [ "$force" = true ]; then
    [ -f "$framework_file" ] && rm -f "$framework_file"
    [ -d "$examples_dir" ] && rm -rf "$examples_dir"
  fi

  # Deploy framework guide
  if [ -f "$framework_file" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip framework/DEVELOPMENT_FRAMEWORK.md${NC}"
  else
    get_framework_content > "$framework_file" && echo -e "${GREEN}✅ framework/DEVELOPMENT_FRAMEWORK.md${NC}" || { echo -e "${RED}❌ Framework${NC}"; return 1; }
  fi

  # Deploy examples
  if [ -d "$examples_dir" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip framework/examples/${NC}"
  else
    # Create examples directory structure
    mkdir -p "$examples_dir/phase-1" || { echo -e "${RED}❌ framework/examples/phase-1${NC}"; return 1; }
    mkdir -p "$examples_dir/phase-2" || { echo -e "${RED}❌ framework/examples/phase-2${NC}"; return 1; }

    # Deploy example files
    get_example_dashboard > "$examples_dir/DASHBOARD.md" && echo -e "${GREEN}✅ framework/examples/DASHBOARD.md${NC}" || { echo -e "${RED}❌ framework/examples/DASHBOARD.md${NC}"; return 1; }
    get_example_plan > "$examples_dir/PLAN.md" && echo -e "${GREEN}✅ framework/examples/PLAN.md${NC}" || { echo -e "${RED}❌ framework/examples/PLAN.md${NC}"; return 1; }
    get_example_task_standalone > "$examples_dir/phase-1/task-1.md" && echo -e "${GREEN}✅ framework/examples/phase-1/task-1.md${NC}" || { echo -e "${RED}❌ framework/examples/phase-1/task-1.md${NC}"; return 1; }
    get_example_task_iterations > "$examples_dir/phase-2/task-3.md" && echo -e "${GREEN}✅ framework/examples/phase-2/task-3.md${NC}" || { echo -e "${RED}❌ framework/examples/phase-2/task-3.md${NC}"; return 1; }
  fi

  # Deploy Skills Guide
  local skills_guide="$framework_dir/skills/SKILLS_GUIDE.md"
  mkdir -p "$framework_dir/skills" || { echo -e "${RED}❌ mkdir framework/skills${NC}"; return 1; }

  if [ -f "$skills_guide" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip framework/skills/SKILLS_GUIDE.md${NC}"
  else
    get_skills_guide > "$skills_guide" && echo -e "${GREEN}✅ framework/skills/SKILLS_GUIDE.md${NC}" || { echo -e "${RED}❌ Skills Guide${NC}"; return 1; }
  fi

  return 0
}

deploy_skills() {
  local target_dir="$1"
  local force="$2"
  local success_count=0

  # target_dir already points to .claude/skills, no need to add /skills again
  mkdir -p "$target_dir" || { echo -e "${RED}❌ mkdir skills/${NC}"; return 1; }

  # Deploy flow-navigator Skill
  local navigator_dir="$target_dir/flow-navigator"
  mkdir -p "$navigator_dir" || { echo -e "${RED}❌ mkdir flow-navigator${NC}"; return 1; }

  if [ "$force" = true ] && [ -f "$navigator_dir/SKILL.md" ]; then
    rm -f "$navigator_dir/SKILL.md"
  fi

  if [ -f "$navigator_dir/SKILL.md" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip flow-navigator/SKILL.md${NC}"
  else
    get_skill_flow_navigator > "$navigator_dir/SKILL.md" && { echo -e "${GREEN}✅ flow-navigator/SKILL.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ flow-navigator/SKILL.md${NC}"
  fi

  # Deploy flow-planner Skill
  local planner_dir="$target_dir/flow-planner"
  mkdir -p "$planner_dir" || { echo -e "${RED}❌ mkdir flow-planner${NC}"; return 1; }

  if [ "$force" = true ]; then
    [ -f "$planner_dir/SKILL.md" ] && rm -f "$planner_dir/SKILL.md"
    [ -f "$planner_dir/TEMPLATES.md" ] && rm -f "$planner_dir/TEMPLATES.md"
  fi

  if [ -f "$planner_dir/SKILL.md" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip flow-planner/SKILL.md${NC}"
  else
    get_skill_flow_planner > "$planner_dir/SKILL.md" && { echo -e "${GREEN}✅ flow-planner/SKILL.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ flow-planner/SKILL.md${NC}"
  fi

  if [ -f "$planner_dir/TEMPLATES.md" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip flow-planner/TEMPLATES.md${NC}"
  else
    get_skill_flow_planner_templates > "$planner_dir/TEMPLATES.md" && { echo -e "${GREEN}✅ flow-planner/TEMPLATES.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ flow-planner/TEMPLATES.md${NC}"
  fi

  # Deploy flow-implementer Skill
  local implementer_dir="$target_dir/flow-implementer"
  mkdir -p "$implementer_dir" || { echo -e "${RED}❌ mkdir flow-implementer${NC}"; return 1; }

  if [ "$force" = true ]; then
    [ -f "$implementer_dir/SKILL.md" ] && rm -f "$implementer_dir/SKILL.md"
    [ -f "$implementer_dir/PATTERNS.md" ] && rm -f "$implementer_dir/PATTERNS.md"
    [ -f "$implementer_dir/VERIFICATION.md" ] && rm -f "$implementer_dir/VERIFICATION.md"
  fi

  if [ -f "$implementer_dir/SKILL.md" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip flow-implementer/SKILL.md${NC}"
  else
    get_skill_flow_implementer > "$implementer_dir/SKILL.md" && { echo -e "${GREEN}✅ flow-implementer/SKILL.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ flow-implementer/SKILL.md${NC}"
  fi

  if [ -f "$implementer_dir/PATTERNS.md" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip flow-implementer/PATTERNS.md${NC}"
  else
    get_skill_flow_implementer_patterns > "$implementer_dir/PATTERNS.md" && { echo -e "${GREEN}✅ flow-implementer/PATTERNS.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ flow-implementer/PATTERNS.md${NC}"
  fi

  if [ -f "$implementer_dir/VERIFICATION.md" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip flow-implementer/VERIFICATION.md${NC}"
  else
    get_skill_flow_implementer_verification > "$implementer_dir/VERIFICATION.md" && { echo -e "${GREEN}✅ flow-implementer/VERIFICATION.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ flow-implementer/VERIFICATION.md${NC}"
  fi

  # Deploy flow-architect Skill
  local architect_dir="$target_dir/flow-architect"
  mkdir -p "$architect_dir" || { echo -e "${RED}❌ mkdir flow-architect${NC}"; return 1; }

  if [ "$force" = true ]; then
    [ -f "$architect_dir/SKILL.md" ] && rm -f "$architect_dir/SKILL.md"
    [ -f "$architect_dir/PLAN_UPDATES.md" ] && rm -f "$architect_dir/PLAN_UPDATES.md"
  fi

  if [ -f "$architect_dir/SKILL.md" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip flow-architect/SKILL.md${NC}"
  else
    get_skill_flow_architect > "$architect_dir/SKILL.md" && { echo -e "${GREEN}✅ flow-architect/SKILL.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ flow-architect/SKILL.md${NC}"
  fi

  if [ -f "$architect_dir/PLAN_UPDATES.md" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip flow-architect/PLAN_UPDATES.md${NC}"
  else
    get_skill_flow_architect_plan_updates > "$architect_dir/PLAN_UPDATES.md" && { echo -e "${GREEN}✅ flow-architect/PLAN_UPDATES.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ flow-architect/PLAN_UPDATES.md${NC}"
  fi

  # Deploy flow-reviewer Skill
  local reviewer_dir="$target_dir/flow-reviewer"
  mkdir -p "$reviewer_dir" || { echo -e "${RED}❌ mkdir flow-reviewer${NC}"; return 1; }

  if [ "$force" = true ]; then
    [ -f "$reviewer_dir/SKILL.md" ] && rm -f "$reviewer_dir/SKILL.md"
    [ -f "$reviewer_dir/VERIFY.md" ] && rm -f "$reviewer_dir/VERIFY.md"
  fi

  if [ -f "$reviewer_dir/SKILL.md" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip flow-reviewer/SKILL.md${NC}"
  else
    get_skill_flow_reviewer > "$reviewer_dir/SKILL.md" && { echo -e "${GREEN}✅ flow-reviewer/SKILL.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ flow-reviewer/SKILL.md${NC}"
  fi

  if [ -f "$reviewer_dir/VERIFY.md" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip flow-reviewer/VERIFY.md${NC}"
  else
    get_skill_flow_reviewer_verify > "$reviewer_dir/VERIFY.md" && { echo -e "${GREEN}✅ flow-reviewer/VERIFY.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ flow-reviewer/VERIFY.md${NC}"
  fi

  # Deploy flow-documenter Skill
  local documenter_dir="$target_dir/flow-documenter"
  mkdir -p "$documenter_dir" || { echo -e "${RED}❌ mkdir flow-documenter${NC}"; return 1; }

  if [ "$force" = true ] && [ -f "$documenter_dir/SKILL.md" ]; then
    rm -f "$documenter_dir/SKILL.md"
  fi

  if [ -f "$documenter_dir/SKILL.md" ] && [ "$force" = false ]; then
    echo -e "${YELLOW}⏭️  Skip flow-documenter/SKILL.md${NC}"
  else
    get_skill_flow_documenter > "$documenter_dir/SKILL.md" && { echo -e "${GREEN}✅ flow-documenter/SKILL.md${NC}"; ((success_count++)); } || echo -e "${RED}❌ flow-documenter/SKILL.md${NC}"
  fi

  echo "$success_count"
  return 0
}

validate() {
  local commands_dir="$1"
  local flow_dir="$2"
  local skills_dir="$3"
  local valid=true

  echo -e "\n${CYAN}🔍 Validating...${NC}\n"

  # Check framework
  [ ! -f "$flow_dir/framework/DEVELOPMENT_FRAMEWORK.md" ] && { echo -e "${RED}❌ Framework missing${NC}"; valid=false; } || echo -e "${GREEN}✅ Framework${NC}"

  # Check examples
  [ ! -d "$flow_dir/framework/examples" ] && { echo -e "${RED}❌ Examples missing${NC}"; valid=false; } || echo -e "${GREEN}✅ Examples (4 files)${NC}"

  # Check commands
  local count=0
  for cmd in "${COMMANDS[@]}"; do
    [ -f "$commands_dir/${cmd}.md" ] && ((count++))
  done

  echo -e "${GREEN}✅ Commands: $count/${#COMMANDS[@]}${NC}"
  [ "$count" -eq 0 ] && { echo -e "${RED}❌ No commands${NC}"; valid=false; }

  # Check Skills
  local skills_count=0
  [ -f "$skills_dir/flow-navigator/SKILL.md" ] && ((skills_count++))
  [ -f "$skills_dir/flow-planner/SKILL.md" ] && ((skills_count++))
  [ -f "$skills_dir/flow-implementer/SKILL.md" ] && ((skills_count++))
  [ -f "$skills_dir/flow-architect/SKILL.md" ] && ((skills_count++))
  [ -f "$skills_dir/flow-reviewer/SKILL.md" ] && ((skills_count++))
  [ -f "$skills_dir/flow-documenter/SKILL.md" ] && ((skills_count++))

  if [ "$skills_count" -eq 6 ]; then
    echo -e "${GREEN}✅ Skills: $skills_count/6 (with supporting files)${NC}"
  elif [ "$skills_count" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Skills: $skills_count/6 (partial)${NC}"
  else
    echo -e "${RED}❌ No Skills${NC}"
    valid=false
  fi

  [ "$valid" = true ]
}

main() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --force|-f) FORCE=true; shift;;
      --version|-v) print_version; exit 0;;
      --help|-h) print_help; exit 0;;
      *) echo -e "${RED}Unknown: $1${NC}"; print_help; exit 1;;
    esac
  done

  echo -e "\n${BLUE}🚀 Flow Framework v$FLOW_VERSION${NC}\n"
  echo -e "Target Project: ${BLUE}$(pwd)${NC}"
  echo -e "Force: $([ "$FORCE" = true ] && echo "${GREEN}Yes${NC}" || echo "${RED}No${NC}")"
  echo -e "Mode: ${CYAN}Self-contained${NC}\n"

  local commands_dir="$(pwd)/.claude/commands"
  local skills_dir="$(pwd)/.claude/skills"
  local flow_dir="$(pwd)/.flow"

  # Create directories
  mkdir -p "$commands_dir" || { echo -e "${RED}❌ mkdir .claude/commands failed${NC}"; exit 1; }
  mkdir -p "$skills_dir" || { echo -e "${RED}❌ mkdir .claude/skills failed${NC}"; exit 1; }
  mkdir -p "$flow_dir" || { echo -e "${RED}❌ mkdir .flow failed${NC}"; exit 1; }
  echo -e "${BLUE}📁 Created directories${NC}\n"

  # Deploy slash commands
  echo -e "${BLUE}📦 Installing slash commands...${NC}\n"
  local count=$(deploy_commands "$commands_dir" "$FORCE")

  # Deploy framework docs
  echo -e "\n${BLUE}📚 Installing framework documentation...${NC}\n"
  deploy_framework "$flow_dir" "$FORCE"

  # Deploy Skills
  echo -e "\n${BLUE}🎯 Installing Agent Skills...${NC}\n"
  local skills_count=$(deploy_skills "$skills_dir" "$FORCE")

  # Update CLAUDE.md
  echo -e "\n${BLUE}📝 Updating project CLAUDE.md...${NC}\n"
  update_claude_md "$FORCE"

  # Validate
  if validate "$commands_dir" "$flow_dir" "$skills_dir"; then
    echo ""
    echo "=================================================="
    echo -e "${GREEN}✅ Flow Framework Installed!${NC}\n"
    echo -e "${CYAN}📂 Structure:${NC}"
    echo "   .claude/commands/       (${#COMMANDS[@]} slash commands)"
    echo "   .claude/skills/         (6 Agent Skills)"
    echo "   .flow/                  (your workspace)"
    echo "     └── framework/        (AI reference files)"
    echo "         ├── DEVELOPMENT_FRAMEWORK.md"
    echo "         ├── skills/SKILLS_GUIDE.md"
    echo "         └── examples/"
    echo "             ├── DASHBOARD.md"
    echo "             ├── PLAN.md"
    echo "             ├── phase-1/task-1.md"
    echo "             └── phase-2/task-3.md"
    echo ""
    echo -e "${CYAN}🎯 Agent Skills Installed:${NC}"
    echo "   flow-navigator       - Dashboard-first navigation"
    echo "   flow-planner         - Planning new features/iterations"
    echo "   flow-implementer     - Implementation workflow guidance"
    echo "   flow-architect       - Architecture decisions & DO/DON'Ts"
    echo "   flow-reviewer        - Plan/code verification (read-only)"
    echo "   flow-documenter      - Task notes & discoveries"
    echo ""
    echo -e "${CYAN}🚀 Next Steps:${NC}"
    echo "   1. Restart Claude Code (if running)"
    echo "   2. Run: /flow-blueprint <your-feature-name>"
    echo "   3. Read: .flow/framework/DEVELOPMENT_FRAMEWORK.md"
    echo "   4. Examples: .flow/framework/examples/"
    echo "   5. Skills Guide: .flow/framework/skills/SKILLS_GUIDE.md"
    echo ""
    echo "💡 Share this script - it's self-contained!"
    echo "=================================================="
    echo ""
    exit 0
  else
    echo ""
    echo -e "${YELLOW}⚠️  Deployment completed with warnings${NC}"
    echo ""
    exit 1
  fi
}

main "$@"
FOOTER_EOF

chmod +x "$OUTPUT_FILE"

# Replace version placeholder with actual version
sed -i '' "s/__FLOW_VERSION__/${FLOW_VERSION}/g" "$OUTPUT_FILE"

echo "✅ Created: $OUTPUT_FILE"
echo ""
echo "📊 Size: $(wc -c < "$OUTPUT_FILE") bytes"
echo "📝 Lines: $(wc -l < "$OUTPUT_FILE") lines"
echo ""

echo "✨ The standalone script is ready to distribute!"
echo "   Includes: Commands + Framework (complete package)"
