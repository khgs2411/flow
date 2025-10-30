#!/usr/bin/env bash

################################################################################
# Flow Framework Release Script
#
# Automates the release process:
# 1. Validates VERSION file exists
# 2. Optionally increments version (--patch, --minor, --major)
# 3. Builds flow.sh with version from VERSION file
# 4. Updates CHANGELOG.md with new version entry
# 5. Creates git commit + tag
# 6. Pushes to GitHub
# 7. Creates GitHub release with flow.sh as asset
#
# Usage:
#   ./release.sh              # Use current VERSION
#   ./release.sh --patch      # Increment patch (1.1.1 → 1.1.2)
#   ./release.sh --minor      # Increment minor (1.1.1 → 1.2.0)
#   ./release.sh --major      # Increment major (1.1.1 → 2.0.0)
################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_FILE="$SCRIPT_DIR/VERSION"
CHANGELOG_FILE="$SCRIPT_DIR/CHANGELOG.md"
BUILD_SCRIPT="$SCRIPT_DIR/build-standalone.sh"
FLOW_SH="$SCRIPT_DIR/flow.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Parse arguments for version increment
INCREMENT_TYPE=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --patch)
      INCREMENT_TYPE="patch"
      shift
      ;;
    --minor)
      INCREMENT_TYPE="minor"
      shift
      ;;
    --major)
      INCREMENT_TYPE="major"
      shift
      ;;
    --help|-h)
      echo "Usage: ./release.sh [--patch|--minor|--major]"
      echo ""
      echo "Options:"
      echo "  --patch    Increment patch version (1.1.1 → 1.1.2)"
      echo "  --minor    Increment minor version (1.1.1 → 1.2.0)"
      echo "  --major    Increment major version (1.1.1 → 2.0.0)"
      echo "  (none)     Use current VERSION file as-is"
      echo ""
      echo "Example:"
      echo "  ./release.sh --patch    # Quick patch release"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Check if VERSION file exists
if [ ! -f "$VERSION_FILE" ]; then
  echo -e "${RED}❌ VERSION file not found!${NC}"
  echo ""
  echo "Create a VERSION file with the version number (e.g., 1.1.1)"
  exit 1
fi

# Read current version from VERSION file
CURRENT_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')

if [ -z "$CURRENT_VERSION" ]; then
  echo -e "${RED}❌ VERSION file is empty!${NC}"
  exit 1
fi

# Increment version if requested
if [ -n "$INCREMENT_TYPE" ]; then
  # Parse current version (MAJOR.MINOR.PATCH)
  if [[ ! "$CURRENT_VERSION" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    echo -e "${RED}❌ Invalid version format: $CURRENT_VERSION${NC}"
    echo "Expected format: MAJOR.MINOR.PATCH (e.g., 1.1.1)"
    exit 1
  fi

  MAJOR="${BASH_REMATCH[1]}"
  MINOR="${BASH_REMATCH[2]}"
  PATCH="${BASH_REMATCH[3]}"

  case $INCREMENT_TYPE in
    patch)
      PATCH=$((PATCH + 1))
      ;;
    minor)
      MINOR=$((MINOR + 1))
      PATCH=0
      ;;
    major)
      MAJOR=$((MAJOR + 1))
      MINOR=0
      PATCH=0
      ;;
  esac

  NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"

  echo -e "${BLUE}📈 Version Increment${NC}"
  echo ""
  echo -e "Current: ${YELLOW}v${CURRENT_VERSION}${NC}"
  echo -e "New:     ${GREEN}v${NEW_VERSION}${NC} (${INCREMENT_TYPE})"
  echo ""

  # Update VERSION file
  echo "$NEW_VERSION" > "$VERSION_FILE"
  VERSION="$NEW_VERSION"

  echo -e "${GREEN}✅ Updated VERSION file${NC}"
  echo ""
else
  VERSION="$CURRENT_VERSION"
fi

echo -e "${BLUE}🚀 Flow Framework Release Script${NC}"
echo ""
echo -e "Version: ${CYAN}v${VERSION}${NC}"
echo ""

# Step 1: Build flow.sh
echo -e "${BLUE}📦 Step 1/6: Building flow.sh...${NC}"
echo ""
bash "$BUILD_SCRIPT"
echo ""

# Step 2: Prompt for changelog entry
echo -e "${BLUE}📝 Step 2/7: Update CHANGELOG.md${NC}"
echo ""
echo "Please provide release information:"
echo ""
read -p "Release title (e.g., 'Backlog Management Feature'): " RELEASE_TITLE
echo ""
echo "Enter changelog notes (one per line, end with empty line):"
echo "Example:"
echo "  - Added backlog management commands"
echo "  - Fixed command count automation"
echo ""

CHANGELOG_NOTES=""
while IFS= read -r line; do
  [ -z "$line" ] && break
  CHANGELOG_NOTES="${CHANGELOG_NOTES}- ${line}\n"
done

if [ -z "$CHANGELOG_NOTES" ]; then
  echo -e "${YELLOW}⚠️  No changelog notes provided. Using default.${NC}"
  CHANGELOG_NOTES="- Bug fixes and improvements\n"
fi

# Get current date
RELEASE_DATE=$(date +%Y-%m-%d)

# Create changelog entry
CHANGELOG_ENTRY="## Current Version

**v${VERSION}** - ${RELEASE_TITLE} (${RELEASE_DATE})

**Changes**:

${CHANGELOG_NOTES}
See the [v${VERSION} release](https://github.com/khgs2411/flow/releases/tag/v${VERSION}) for full details.

---

"

# Update CHANGELOG.md
# Remove "## Current Version" section and replace with new entry
# This preserves "Previous Versions" section
if grep -q "## Current Version" "$CHANGELOG_FILE"; then
  # Extract content after "## Current Version" up to "## Previous Versions"
  awk '/## Previous Versions/{p=1} p' "$CHANGELOG_FILE" > /tmp/changelog_tail.txt

  # Extract content before "## Current Version"
  awk '/## Current Version/{exit} {print}' "$CHANGELOG_FILE" > /tmp/changelog_head.txt

  # Rebuild CHANGELOG.md
  cat /tmp/changelog_head.txt > "$CHANGELOG_FILE"
  echo "$CHANGELOG_ENTRY" >> "$CHANGELOG_FILE"
  cat /tmp/changelog_tail.txt >> "$CHANGELOG_FILE"

  rm /tmp/changelog_head.txt /tmp/changelog_tail.txt

  echo -e "${GREEN}✅ Updated CHANGELOG.md${NC}"
else
  echo -e "${YELLOW}⚠️  CHANGELOG.md doesn't have 'Current Version' section. Skipping update.${NC}"
fi
echo ""

# Step 3: Git status check (before making changes)
echo -e "${BLUE}📊 Step 3/7: Checking git status...${NC}"
echo ""

# Check for uncommitted changes EXCLUDING the files we're about to modify
git diff-index --quiet HEAD -- ':!VERSION' ':!CHANGELOG.md' ':!flow.sh' ':!build-standalone.sh' || {
  echo -e "${YELLOW}⚠️  You have uncommitted changes (excluding release files):${NC}"
  git status --short | grep -v -E '(VERSION|CHANGELOG.md|flow.sh|build-standalone.sh)'
  echo ""
  read -p "Continue with release? (y/n): " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}❌ Release cancelled${NC}"
    exit 1
  fi
}

# Step 4: Create git commit
echo -e "${BLUE}📝 Step 4/7: Creating git commit...${NC}"
echo ""

# Stage the release files
git add VERSION CHANGELOG.md flow.sh build-standalone.sh framework/DEVELOPMENT_FRAMEWORK.md framework/SLASH_COMMANDS.md framework/EXAMPLE_PLAN.md README.md 2>/dev/null || true

# Check if there are changes to commit
if git diff --cached --quiet; then
  echo -e "${YELLOW}⚠️  No changes to commit for release files${NC}"
  echo ""
else
  git commit -m "Release v${VERSION}: ${RELEASE_TITLE}

${CHANGELOG_NOTES}
- Updated VERSION file to ${VERSION}
- Rebuilt flow.sh with new version
- Updated CHANGELOG.md with release notes
"

  echo -e "${GREEN}✅ Created commit${NC}"
  echo ""
fi

# Step 5: Create git tag
echo -e "${BLUE}🏷️  Step 5/7: Creating git tag...${NC}"
echo ""

git tag -a "v${VERSION}" -m "Release v${VERSION}: ${RELEASE_TITLE}"

echo -e "${GREEN}✅ Created tag v${VERSION}${NC}"
echo ""

# Step 6: Push to GitHub
echo -e "${BLUE}🚀 Step 6/7: Pushing to GitHub...${NC}"
echo ""

read -p "Push to GitHub? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  git push origin master
  git push origin "v${VERSION}"
  echo -e "${GREEN}✅ Pushed to GitHub${NC}"
  echo ""
else
  echo -e "${YELLOW}⚠️  Skipped GitHub push${NC}"
  echo ""
  echo "To push manually:"
  echo "  git push origin master"
  echo "  git push origin v${VERSION}"
  echo ""
fi

# Step 7: Create GitHub release
echo -e "${BLUE}🎉 Creating GitHub release...${NC}"
echo ""

read -p "Create GitHub release? (requires gh CLI) (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if command -v gh &> /dev/null; then
    # Create release notes file
    RELEASE_NOTES_FILE="/tmp/flow-release-notes-${VERSION}.md"

    echo "# v${VERSION} - ${RELEASE_TITLE}" > "$RELEASE_NOTES_FILE"
    echo "" >> "$RELEASE_NOTES_FILE"
    echo "**Release Date**: ${RELEASE_DATE}" >> "$RELEASE_NOTES_FILE"
    echo "" >> "$RELEASE_NOTES_FILE"
    echo "## Changes" >> "$RELEASE_NOTES_FILE"
    echo "" >> "$RELEASE_NOTES_FILE"
    echo -e "$CHANGELOG_NOTES" >> "$RELEASE_NOTES_FILE"
    echo "" >> "$RELEASE_NOTES_FILE"
    echo "## Installation" >> "$RELEASE_NOTES_FILE"
    echo "" >> "$RELEASE_NOTES_FILE"
    echo "\`\`\`bash" >> "$RELEASE_NOTES_FILE"
    echo "# Download and run flow.sh" >> "$RELEASE_NOTES_FILE"
    echo "wget https://github.com/khgs2411/flow/releases/download/v${VERSION}/flow.sh" >> "$RELEASE_NOTES_FILE"
    echo "chmod +x flow.sh" >> "$RELEASE_NOTES_FILE"
    echo "./flow.sh" >> "$RELEASE_NOTES_FILE"
    echo "\`\`\`" >> "$RELEASE_NOTES_FILE"

    # Create release
    gh release create "v${VERSION}" \
      --title "v${VERSION} - ${RELEASE_TITLE}" \
      --notes-file "$RELEASE_NOTES_FILE" \
      "$FLOW_SH#flow.sh"

    rm "$RELEASE_NOTES_FILE"

    echo -e "${GREEN}✅ Created GitHub release v${VERSION}${NC}"
    echo ""
    echo "Release URL: https://github.com/khgs2411/flow/releases/tag/v${VERSION}"
  else
    echo -e "${YELLOW}⚠️  gh CLI not found. Please install it or create release manually.${NC}"
    echo ""
    echo "To create release manually:"
    echo "  1. Go to: https://github.com/khgs2411/flow/releases/new"
    echo "  2. Tag: v${VERSION}"
    echo "  3. Title: v${VERSION} - ${RELEASE_TITLE}"
    echo "  4. Upload: flow.sh"
  fi
else
  echo -e "${YELLOW}⚠️  Skipped GitHub release${NC}"
  echo ""
  echo "To create release manually:"
  echo "  gh release create v${VERSION} --title \"v${VERSION} - ${RELEASE_TITLE}\" flow.sh"
fi

echo ""
echo "=================================================="
echo -e "${GREEN}✅ Release v${VERSION} Complete!${NC}"
echo "=================================================="
echo ""
echo -e "${CYAN}Summary:${NC}"
echo "  • Version: v${VERSION}"
echo "  • Tag: v${VERSION}"
echo "  • flow.sh: $(wc -c < "$FLOW_SH") bytes"
echo "  • Commit: $(git rev-parse --short HEAD)"
echo ""
echo -e "${CYAN}Distribution:${NC}"
echo "  • GitHub: flow.sh attached to release"
echo ""
echo -e "${CYAN}Next Steps:${NC}"
echo "  • Update README.md if needed (screenshots, features, etc.)"
echo "  • Announce release in project channels"
echo "  • Monitor GitHub issues for feedback"
echo ""
