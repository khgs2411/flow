# Changelog

All notable changes to the Flow Framework are documented in **[GitHub Releases](https://github.com/khgs2411/flow/releases)**.

## Why GitHub Releases?

- **Rich formatting** - Better display of changes with markdown support
- **Asset management** - Direct download links for each version
- **Notifications** - Users can watch/subscribe for new releases
- **Integration** - Works seamlessly with GitHub's ecosystem

## Quick Links

- **Latest Release**: [View Latest](https://github.com/khgs2411/flow/releases/latest)
- **All Releases**: [View All](https://github.com/khgs2411/flow/releases)
- **Version History**: See releases for detailed version history

## Current Version

**v1.1.0** - AI Workflow Guidance & Documentation Cleanup (2025-10-04)

**Breaking Changes**: None - fully backward compatible with v1.0.x

**Major Features**:

1. **"What's Next" Workflow Guidance** ✨
   - Added prominent "🎯 What's Next" sections to 6 key state transition commands
   - Commands now show explicit decision trees instead of vague prose
   - Prevents AI confusion about workflow continuation (e.g., review vs complete)
   - Pattern: Emoji header + conditional logic + explicit command names
   - Commands enhanced:
     - `/flow-next-subject` → Shows `/flow-brainstorm-review` after all subjects resolved
     - `/flow-brainstorm-review` → Decision tree for pre-tasks/iterations/complete
     - `/flow-brainstorm-complete` → Directs to `/flow-implement-start`
     - `/flow-implement-complete` → Decision tree for iteration-add/task-complete/status
     - `/flow-task-complete` → Decision tree for phase-complete/task-start
     - `/flow-phase-complete` → Decision tree for phase-start/project completion

2. **Repository Documentation Cleanup** 🧹
   - Removed 63,693 bytes of redundant meta-work documentation
   - Deleted: TROUBLESHOOTING.md, TESTING.md, ADVANCED_PATTERNS.md, RELEASE_NOTES_v1.0.16.md
   - Retained only GitHub Community Standards files + CHANGELOG.md + CLAUDE.md
   - Rationale: These files made sense for projects USING Flow, not for Flow framework itself

**Improvements**:
- Consolidated RELEASE_NOTES_v1.0.16.md content into CHANGELOG.md
- All v1.0.16 improvements fully integrated (Quick Reference, AI_SCAN markers, etc.)
- Improved command workflow prevents common AI mistakes through prominence

**Bug Fixes**:
- **Critical**: Fixed 7 slash commands with incorrect markdown fences (4 backticks → 3 backticks)
  - Affected commands: implement-start, migrate, phase-add, task-add, iteration-add, brainstorm-review, plan-split
  - Root cause: Build script's awk pattern failed to match 4-backtick fences, silently extracting wrong command content
  - Impact: Commands showed duplicate content from adjacent commands (e.g., implement-start showed implement-complete)
  - Fixed in framework/SLASH_COMMANDS.md, rebuilt flow.sh, redeployed all commands
- Fixed command count errors in README.md (Iteration Lifecycle 6→8, Brainstorming 4→5)
- Resolved duplicate section title confusion by renaming "Using Flow Without Slash Commands" → "Using Flow with Other AI Models"

**Impact**: Better AI workflow adherence, cleaner repository structure, maintained GitHub Community Standards compliance

See the [v1.1.0 release](https://github.com/khgs2411/flow/releases/tag/v1.1.0) for full details.

---

## Previous Versions

**v1.0.16** - Bidirectional Reference Architecture (2025-10-03)

**Major Feature**:
- **Bidirectional Reference System**: Three-layer architecture ensuring AI agents consult framework
  - PLAN.md header warnings with auto-detection rules
  - CLAUDE.md framework consultation patterns with three-layer reading strategy
  - All 25 commands reference framework sections with line numbers
  - Build-time validation of command→framework mappings

**Impact**: Prevents structural mistakes, enforces consistency, establishes single source of truth

**Quick Reference Enhancement**:
- Added 353-line Quick Reference section to DEVELOPMENT_FRAMEWORK.md (lines 1-353)
- 19 AI_SCAN section markers for programmatic navigation
- Command categorization: 11 Category A (require Quick Reference), 14 Category B (PLAN.md only)
- Token efficiency: 92% reduction (15k vs 200k tokens) for framework reading

**Documentation Improvements**:
- Updated EXAMPLE_PLAN.md with improved Progress Dashboard structure
- Simplified from 640 to 548 lines (14% reduction)
- Added "Current Work" emphasis with <!-- ESSENTIAL --> markers
- Removed redundant sections, enhanced hierarchical structure

**Command Enhancements**:
- Added tool usage guidance (Grep vs awk patterns)
- Added Dashboard update requirements to all state-changing commands
- Refined Category A reading instructions: "read once per session if not in context"

See the [v1.0.16 release](https://github.com/khgs2411/flow/releases/tag/v1.0.16) for full details.

---

## Previous Versions

**v1.0.15** - Plan File Size Management (2025-10-03)

**New Command**:
- **`/flow-plan-split`**: Archive old completed tasks to reduce PLAN.md size
  - Uses recent context window strategy (current + 3 previous tasks)
  - Creates/appends to `.flow/ARCHIVE.md` with full task content
  - Updates Progress Dashboard with 📦 ARCHIVED markers
  - Preserves full project history while improving performance

**Documentation**:
- Added "Plan File Size Management" section to DEVELOPMENT_FRAMEWORK.md
  - When to split guidelines (2000+ lines, 10+ completed tasks)
  - Recent context window explained with examples
  - ARCHIVE.md structure and Progress Dashboard with 📦 markers
  - Before/after examples showing 40% file size reduction

See the [v1.0.15 release](https://github.com/khgs2411/flow/releases/tag/v1.0.15) for full details.

**v1.0.13** - Command Fixes: Pre-Implementation Task Detection (2025-10-02)

**Critical Bug Fixes**:
- Fixed heading level patterns in `/flow-status` (was preventing ALL marker detection)
- Added pre-implementation task detection to `/flow-status` and `/flow-next`
- Implemented comprehensive decision trees for both commands
- Enhanced status reporting with progress indicators
- Framework rule now enforced: Commands check both subjects AND pre-tasks before suggesting completion

See the [v1.0.13 release](https://github.com/khgs2411/flow/releases/tag/v1.0.13) for full details.

## Version Numbering

Flow follows semantic versioning: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes to framework structure or commands
- **MINOR**: New features, new commands, significant enhancements
- **PATCH**: Bug fixes, documentation updates, minor improvements
