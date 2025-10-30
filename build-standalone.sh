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
  .flow/framework/           AI reference files (read-only for user)
    ├── DEVELOPMENT_FRAMEWORK.md
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

MIDDLE6_EOF

# Write the main deployment logic
cat >> "$OUTPUT_FILE" <<'FOOTER_EOF'
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

  return 0
}

validate() {
  local commands_dir="$1"
  local flow_dir="$2"
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
  local flow_dir="$(pwd)/.flow"

  # Create directories
  mkdir -p "$commands_dir" || { echo -e "${RED}❌ mkdir .claude/commands failed${NC}"; exit 1; }
  mkdir -p "$flow_dir" || { echo -e "${RED}❌ mkdir .flow failed${NC}"; exit 1; }
  echo -e "${BLUE}📁 Created directories${NC}\n"

  # Deploy slash commands
  echo -e "${BLUE}📦 Installing slash commands...${NC}\n"
  local count=$(deploy_commands "$commands_dir" "$FORCE")

  # Deploy framework docs
  echo -e "\n${BLUE}📚 Installing framework documentation...${NC}\n"
  deploy_framework "$flow_dir" "$FORCE"

  # Validate
  if validate "$commands_dir" "$flow_dir"; then
    echo ""
    echo "=================================================="
    echo -e "${GREEN}✅ Flow Framework Installed!${NC}\n"
    echo -e "${CYAN}📂 Structure:${NC}"
    echo "   .claude/commands/       (${#COMMANDS[@]} slash commands)"
    echo "   .flow/                  (your workspace)"
    echo "     └── framework/        (AI reference files)"
    echo "         ├── DEVELOPMENT_FRAMEWORK.md"
    echo "         └── examples/"
    echo "             ├── DASHBOARD.md"
    echo "             ├── PLAN.md"
    echo "             ├── phase-1/task-1.md"
    echo "             └── phase-2/task-3.md"
    echo ""
    echo -e "${CYAN}🚀 Next Steps:${NC}"
    echo "   1. Restart Claude Code (if running)"
    echo "   2. Run: /flow-blueprint <your-feature-name>"
    echo "   3. Read: .flow/framework/DEVELOPMENT_FRAMEWORK.md"
    echo "   4. Examples: .flow/framework/examples/"
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
