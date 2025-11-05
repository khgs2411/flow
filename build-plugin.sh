#!/usr/bin/env bash

################################################################################
# Build Plugin for Claude Code
#
# This script generates the flow-plugin directory structure by extracting
# commands from framework/SLASH_COMMANDS.md and copying skills from
# framework/skills/. This ensures the plugin stays in sync with framework.
################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_DIR="$SCRIPT_DIR/framework"
PLUGIN_DIR="$SCRIPT_DIR/flow-plugin"
VERSION_FILE="$SCRIPT_DIR/VERSION"

# Read version from VERSION file (single source of truth)
if [ ! -f "$VERSION_FILE" ]; then
  echo "❌ VERSION file not found!"
  exit 1
fi
FLOW_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')

echo "🔨 Building Flow plugin v${FLOW_VERSION}..."
echo ""

# Ultra-lightweight plugin - only include flow-init command
# flow-init downloads everything else from GitHub
echo "🔍 Extracting flow-init command from framework/SLASH_COMMANDS.md..."

COMMANDS=("flow-init")

echo "   ✅ Building ultra-lightweight plugin (1 command: flow-init)"
echo ""

# Extract a single command from SLASH_COMMANDS.md
extract_command() {
  local cmd="$1"
  local marker="## /${cmd}\$"

  awk -v marker="$marker" '
    $0 ~ marker {found=1; next}
    found && /<!-- COMMAND_START -->/ {inside=1; next}
    found && inside && /<!-- COMMAND_END -->/ {exit}
    found && inside {print}
  ' "$FRAMEWORK_DIR/SLASH_COMMANDS.md"
}

# Create plugin directory structure
create_plugin_structure() {
  echo "📁 Creating plugin directory structure..."

  # Create minimal directories - only need commands/ for flow-init
  mkdir -p "$PLUGIN_DIR/commands"
  mkdir -p "$PLUGIN_DIR/.claude-plugin"

  echo "   ✅ Created flow-plugin/commands/"
  echo "   ✅ Created flow-plugin/.claude-plugin/"
  echo ""
}

# Deploy flow-init command to plugin/commands/
deploy_commands() {
  echo "📝 Extracting flow-init from framework/SLASH_COMMANDS.md..."
  echo ""

  local output_file="$PLUGIN_DIR/commands/flow-init.md"
  local content=$(extract_command "flow-init")

  if [ -n "$content" ]; then
    # Write content directly (frontmatter already included in source)
    echo "$content" > "$output_file"
    echo "   ✅ Extracted /flow-init"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ Successfully extracted flow-init command!"
    echo ""
    return 0
  else
    echo "   ❌ Failed to extract /flow-init"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❌ Extraction failed!"
    echo ""
    return 1
  fi
}

# Generate plugin.json manifest
generate_plugin_manifest() {
  echo "📄 Generating plugin.json manifest..."
  echo ""

  local manifest_file="$PLUGIN_DIR/.claude-plugin/plugin.json"

  cat > "$manifest_file" <<EOF
{
  "name": "flow",
  "description": "Flow framework - Ultra-lightweight installer. Run /flow-init to download all 28 commands + 10 agent skills",
  "version": "$FLOW_VERSION",
  "author": {
    "name": "Topsyde Utils",
    "url": "https://github.com/topsyde-utils/flow"
  }
}
EOF

  if [ $? -eq 0 ]; then
    echo "   ✅ Generated plugin.json (version $FLOW_VERSION)"
    echo ""
    return 0
  else
    echo "   ❌ Failed to generate plugin.json"
    echo ""
    return 1
  fi
}

# Generate marketplace.json manifest
generate_marketplace_manifest() {
  echo "📄 Generating marketplace.json manifest..."
  echo ""

  local marketplace_dir="$SCRIPT_DIR"
  local manifest_file="$marketplace_dir/.claude-plugin/marketplace.json"

  # Create marketplace directory structure if needed
  mkdir -p "$marketplace_dir/.claude-plugin"

  cat > "$manifest_file" <<EOF
{
  "name": "topsyde-utils",
  "owner": {
    "name": "Topsyde Utils"
  },
  "plugins": [
    {
      "name": "flow",
      "source": "./flow-plugin",
      "description": "Flow framework - Ultra-lightweight installer. Run /flow-init to download all 28 commands + 10 agent skills"
    }
  ]
}
EOF

  if [ $? -eq 0 ]; then
    echo "   ✅ Generated marketplace.json at .claude-plugin/"
    echo ""
    return 0
  else
    echo "   ❌ Failed to generate marketplace.json"
    echo ""
    return 1
  fi
}

# Deploy all skills to plugin/skills/
deploy_skills() {
  echo "📦 Copying skills from framework/skills/..."
  echo ""

  local copied=0
  local failed=0

  # Copy each flow-* skill directory
  for skill_dir in "$FRAMEWORK_DIR/skills"/flow-*; do
    if [ -d "$skill_dir" ]; then
      local skill_name=$(basename "$skill_dir")
      local target_dir="$PLUGIN_DIR/skills/$skill_name"

      # Copy entire skill directory with all files
      if cp -r "$skill_dir" "$target_dir" 2>/dev/null; then
        echo "   ✅ Copied $skill_name/"
        ((copied++))
      else
        echo "   ❌ Failed to copy $skill_name/"
        ((failed++))
      fi
    fi
  done

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  if [ "$failed" -gt 0 ]; then
    echo "⚠️  Copied $copied skills, $failed failed"
    echo ""
    return 1
  else
    echo "✅ Successfully copied all $copied skills!"
    echo ""
    return 0
  fi
}

# Deploy framework files to plugin/framework/
deploy_framework() {
  echo "📚 Copying framework files..."
  echo ""

  local errors=0

  # Copy DEVELOPMENT_FRAMEWORK.md
  if cp "$FRAMEWORK_DIR/DEVELOPMENT_FRAMEWORK.md" "$PLUGIN_DIR/framework/DEVELOPMENT_FRAMEWORK.md" 2>/dev/null; then
    echo "   ✅ Copied DEVELOPMENT_FRAMEWORK.md"
  else
    echo "   ❌ Failed to copy DEVELOPMENT_FRAMEWORK.md"
    ((errors++))
  fi

  # Copy examples directory
  if cp -r "$FRAMEWORK_DIR/examples/." "$PLUGIN_DIR/framework/examples/" 2>/dev/null; then
    echo "   ✅ Copied examples/ directory"
  else
    echo "   ❌ Failed to copy examples/ directory"
    ((errors++))
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  if [ "$errors" -gt 0 ]; then
    echo "⚠️  Framework deployment had $errors errors"
    echo ""
    return 1
  else
    echo "✅ Successfully deployed framework files!"
    echo ""
    return 0
  fi
}

# Main execution
main() {
  # Clean old build if --clean flag provided
  if [ "$1" = "--clean" ]; then
    echo "🧹 Cleaning old build..."
    rm -rf "$PLUGIN_DIR"
    rm -rf "$SCRIPT_DIR/.claude-plugin"
    echo "   ✅ Removed flow-plugin/"
    echo "   ✅ Removed .claude-plugin/"
    echo ""
  fi

  # Create directory structure
  create_plugin_structure

  # Deploy flow-init command only
  deploy_commands || exit 1

  # Generate manifests
  generate_plugin_manifest || exit 1
  generate_marketplace_manifest || exit 1

  # Get file size
  local flow_init_size=$(wc -c < "$PLUGIN_DIR/commands/flow-init.md" | tr -d ' ')

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ Ultra-lightweight plugin build complete!"
  echo ""
  echo "📦 Plugin output: $PLUGIN_DIR"
  echo "📦 Marketplace manifest: $SCRIPT_DIR/.claude-plugin/marketplace.json"
  echo "📊 Version: $FLOW_VERSION"
  echo ""
  echo "Plugin structure:"
  echo "  - 1 command (flow-init.md) - ${flow_init_size} bytes"
  echo "  - plugin.json manifest with version $FLOW_VERSION"
  echo "  - marketplace.json at repository root"
  echo ""
  echo "🚀 Installation instructions:"
  echo "  1. Install plugin: /plugin marketplace add khgs2411/flow"
  echo "  2. Install Flow: /plugin install flow@topsyde-utils"
  echo "  3. Download framework: /flow-init"
  echo ""
}

# Run main function
main "$@"
