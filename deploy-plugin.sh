#!/usr/bin/env bash

################################################################################
# Flow Plugin Deployment Script
#
# Deploys the Flow plugin to GitHub for marketplace distribution.
# Can be run standalone or as part of the release workflow.
#
# Usage:
#   ./deploy-plugin.sh              # Deploy current build
#   ./deploy-plugin.sh --build      # Build first, then deploy
################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_FILE="$SCRIPT_DIR/VERSION"
PLUGIN_DIR="$SCRIPT_DIR/flow-plugin"
MARKETPLACE_DIR="$SCRIPT_DIR/topsyde-utils-marketplace"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Parse arguments
BUILD_FIRST=false
while [[ $# -gt 0 ]]; do
  case $1 in
    --build)
      BUILD_FIRST=true
      shift
      ;;
    --help|-h)
      echo "Usage: ./deploy-plugin.sh [--build]"
      echo ""
      echo "Options:"
      echo "  --build    Build plugin first before deploying"
      echo "  (none)     Deploy current build"
      echo ""
      echo "Example:"
      echo "  ./deploy-plugin.sh --build    # Build and deploy"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Read version
if [ ! -f "$VERSION_FILE" ]; then
  echo -e "${RED}❌ VERSION file not found!${NC}"
  exit 1
fi

VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')

echo -e "${BLUE}🚀 Flow Plugin Deployment Script${NC}"
echo ""
echo -e "Version: ${CYAN}v${VERSION}${NC}"
echo ""

# Step 1: Build if requested
if [ "$BUILD_FIRST" = true ]; then
  echo -e "${BLUE}📦 Step 1: Building plugin...${NC}"
  echo ""
  bash "$SCRIPT_DIR/build-plugin.sh" --clean
  echo ""
fi

# Step 2: Verify plugin exists
echo -e "${BLUE}🔍 Verifying plugin build...${NC}"
echo ""

if [ ! -d "$PLUGIN_DIR" ]; then
  echo -e "${RED}❌ Plugin directory not found: $PLUGIN_DIR${NC}"
  echo "Run with --build flag or run ./build-plugin.sh first"
  exit 1
fi

if [ ! -d "$MARKETPLACE_DIR" ]; then
  echo -e "${RED}❌ Marketplace directory not found: $MARKETPLACE_DIR${NC}"
  echo "Run with --build flag or run ./build-plugin.sh first"
  exit 1
fi

# Verify manifests exist
if [ ! -f "$PLUGIN_DIR/.claude-plugin/plugin.json" ]; then
  echo -e "${RED}❌ Plugin manifest not found${NC}"
  exit 1
fi

if [ ! -f "$MARKETPLACE_DIR/.claude-plugin/marketplace.json" ]; then
  echo -e "${RED}❌ Marketplace manifest not found${NC}"
  exit 1
fi

echo -e "${GREEN}✅ Plugin build verified${NC}"
echo ""

# Step 3: Git status check
echo -e "${BLUE}📊 Checking git status...${NC}"
echo ""

# Check if plugin files are tracked
if ! git ls-files --error-unmatch "$PLUGIN_DIR" >/dev/null 2>&1; then
  echo -e "${YELLOW}⚠️  Plugin files not tracked in git${NC}"
  echo "Adding plugin files..."
  git add "$PLUGIN_DIR/" "$MARKETPLACE_DIR/"
fi

# Check for uncommitted changes
if ! git diff --quiet "$PLUGIN_DIR" "$MARKETPLACE_DIR" 2>/dev/null; then
  echo -e "${YELLOW}Plugin files have uncommitted changes${NC}"
  echo ""

  read -p "Commit plugin changes now? (y/n): " -n 1 -r
  echo ""

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add "$PLUGIN_DIR/" "$MARKETPLACE_DIR/"
    git commit -m "Update Flow plugin to v${VERSION}

- Rebuilt plugin with version ${VERSION}
- Updated marketplace manifest
- 28 commands and 10 skills included
"
    echo -e "${GREEN}✅ Committed plugin changes${NC}"
  else
    echo -e "${YELLOW}⚠️  Skipping commit${NC}"
  fi
  echo ""
fi

# Step 4: Push to GitHub
echo -e "${BLUE}🚀 Pushing to GitHub...${NC}"
echo ""

read -p "Push plugin to GitHub? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Get current branch
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

  git push origin "$CURRENT_BRANCH"

  echo -e "${GREEN}✅ Pushed to GitHub (branch: $CURRENT_BRANCH)${NC}"
  echo ""
else
  echo -e "${YELLOW}⚠️  Skipped GitHub push${NC}"
  echo ""
  echo "To push manually:"
  echo "  git push origin $(git rev-parse --abbrev-ref HEAD)"
  echo ""
fi

# Step 5: Display installation instructions
echo ""
echo "=================================================="
echo -e "${GREEN}✅ Plugin Deployment Complete!${NC}"
echo "=================================================="
echo ""
echo -e "${CYAN}Distribution:${NC}"
echo "  • Version: v${VERSION}"
echo "  • Plugin: flow-plugin/"
echo "  • Marketplace: topsyde-utils-marketplace/"
echo ""
echo -e "${CYAN}Installation (for users):${NC}"
echo "  1. Add marketplace:"
echo "     /plugin marketplace add khgs2411/flow"
echo ""
echo "  2. Install plugin:"
echo "     /plugin install flow@khgs2411"
echo ""
echo -e "${CYAN}Local testing:${NC}"
echo "  In a different project:"
echo "     /plugin marketplace add $MARKETPLACE_DIR"
echo "     /plugin install flow@topsyde-utils"
echo ""
