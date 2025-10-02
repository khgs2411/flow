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
