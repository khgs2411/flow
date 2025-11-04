# Other Templates

Templates for optional Flow files: BACKLOG.md and CHANGELOG.md

## BACKLOG.md Template

Use for tracking deferred work (V2 features, future enhancements, nice-to-haves).

```markdown
# Backlog

**Purpose**: Track deferred work (V2 features, future enhancements, nice-to-haves)

---

## V2 Features

### [FEATURE_NAME]

**Why Deferred**: [REASON_FOR_V2]

**Description**: [WHAT_THIS_FEATURE_DOES]

**Dependencies**: [WHAT_NEEDS_TO_EXIST_FIRST]

**Estimated Effort**: [SMALL/MEDIUM/LARGE]

---

### [FEATURE_NAME]

**Why Deferred**: [REASON_FOR_V2]

**Description**: [WHAT_THIS_FEATURE_DOES]

**Dependencies**: [WHAT_NEEDS_TO_EXIST_FIRST]

**Estimated Effort**: [SMALL/MEDIUM/LARGE]

---

## Future Enhancements

- [ENHANCEMENT_1] - [BRIEF_DESCRIPTION]
- [ENHANCEMENT_2] - [BRIEF_DESCRIPTION]
- [ENHANCEMENT_3] - [BRIEF_DESCRIPTION]

---

## Ideas (Unvalidated)

- [IDEA_1] - [WHY_INTERESTING]
- [IDEA_2] - [WHY_INTERESTING]
- [IDEA_3] - [WHY_INTERESTING]
```

## CHANGELOG.md Template

Use for tracking project history and notable changes.

```markdown
# Changelog

All notable changes to this project will be documented in this file.

---

## [Unreleased]

### Added
- [NEW_FEATURE]

### Changed
- [MODIFICATION_TO_EXISTING]

### Fixed
- [BUG_FIX]

---

## [1.0.0] - [DATE]

### Added
- Initial project structure
- [FEATURE_1]
- [FEATURE_2]

### Phase 1 Complete
- [MILESTONE_ACHIEVEMENT]

---

## Notes

- Follow [Keep a Changelog](https://keepachangelog.com/) format
- Version numbers follow [Semantic Versioning](https://semver.org/)
```

## Usage Notes

### When to Create BACKLOG.md

**Always create** if:
- User mentions "V2", "later", "future" features
- Migration source has "deferred" or "future" sections
- User explicitly separates V1 and V2 scope

**Don't create** if:
- No V2 features mentioned
- User focused only on immediate work
- Can add later when V2 features emerge

### When to Create CHANGELOG.md

**Always create** if:
- Migrating from existing project (capture history)
- User mentions versioning strategy
- Project is production-ready or has releases

**Don't create** if:
- Brand new project (no history yet)
- User prefers Git history only
- Can add later when first milestone reached

### Populating BACKLOG.md During Migration

**Extract from source documentation**:
- Look for sections titled "V2", "Future", "Later", "Backlog"
- Look for items marked "deferred", "future", "nice-to-have"
- Look for items in comments like "// TODO: later" or "# Future:"

**Categorize into sections**:
- **V2 Features**: Well-defined features explicitly deferred
- **Future Enhancements**: Ideas with some detail but not fully scoped
- **Ideas (Unvalidated)**: Raw ideas that need validation

### Populating CHANGELOG.md During Migration

**Extract from source documentation**:
- Look for sections titled "History", "Changelog", "Releases", "Versions"
- Extract completed milestones from progress sections
- Note major architectural decisions made

**Structure entries**:
- Use semantic versioning (1.0.0, 1.1.0, etc.)
- Group by type: Added, Changed, Fixed, Removed
- Include dates when available

## Examples

### Example: BACKLOG.md for Chat App

```markdown
# Backlog

**Purpose**: Track deferred work (V2 features, future enhancements, nice-to-haves)

---

## V2 Features

### Group Chat Rooms

**Why Deferred**: V1 focuses on 1-to-1 messaging; group chat requires additional complexity

**Description**: Allow multiple users to join named chat rooms and communicate

**Dependencies**: V1 messaging system must be stable and performant

**Estimated Effort**: LARGE (requires room management, permissions, scaling considerations)

---

### File Sharing

**Why Deferred**: V1 focuses on text messaging only

**Description**: Allow users to share files (images, documents) in conversations

**Dependencies**: V1 messaging + storage solution + CDN

**Estimated Effort**: MEDIUM (file upload, storage, retrieval, preview)

---

## Future Enhancements

- Voice/video calling - WebRTC integration for audio/video chat
- Message reactions - Emoji reactions to messages (like Slack)
- Message threading - Reply to specific messages with threads
- Search functionality - Full-text search across message history

---

## Ideas (Unvalidated)

- AI-powered message translation - Translate messages between languages in real-time
- Disappearing messages - Self-destructing messages after set time
- End-to-end encryption - Encrypted messaging for privacy
```

### Example: CHANGELOG.md After Migration

```markdown
# Changelog

All notable changes to this project will be documented in this file.

---

## [Unreleased]

### In Progress
- Migrating to Flow framework for better project structure

---

## [0.3.0] - 2025-10-15

### Added
- Real-time message delivery with Socket.IO
- Online/offline status indicators
- Message history persistence to PostgreSQL

### Changed
- Switched from polling to WebSocket for better performance

### Fixed
- Race condition in message ordering
- Connection drops on mobile networks

### Phase 2 Complete
- Backend and frontend communication established
- Users can send/receive messages in real-time

---

## [0.2.0] - 2025-09-01

### Added
- Basic Express server setup
- PostgreSQL database schema
- JWT authentication

### Phase 1 Complete
- Backend infrastructure established

---

## [0.1.0] - 2025-08-15

### Added
- Initial project structure
- Development environment setup
- Basic routing and middleware

---

## Notes

- Follow [Keep a Changelog](https://keepachangelog.com/) format
- Version numbers follow [Semantic Versioning](https://semver.org/)
```
