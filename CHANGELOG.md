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

**v1.4.2** - Typo (2025-11-02)

**Changes**:

- - Typo\n
See the [v1.4.2 release](https://github.com/khgs2411/flow/releases/tag/v1.4.2) for full details.

---


## Previous Versions

**v1.2.17** - Brainstorming adjustments (2025-10-25)

**Changes**:

- - adjustments\n
See the [v1.2.17 release](https://github.com/khgs2411/flow/releases/tag/v1.2.17) for full details.

---


## Previous Versions (Continued)

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
