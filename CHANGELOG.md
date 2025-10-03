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

**Distribution**:
- Final size: 164,792 bytes (5,011 lines)

**Technical Changes**:
- Added `/flow-plan-split` command to `framework/SLASH_COMMANDS.md` (119 lines)
- Added "Plan File Size Management" to `framework/DEVELOPMENT_FRAMEWORK.md` (154 lines)
- All edge cases handled: first split, subsequent splits, task < 4, non-complete old tasks

See the [v1.0.15 release](https://github.com/khgs2411/flow/releases/tag/v1.0.15) for full details.

---

## Previous Versions

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
