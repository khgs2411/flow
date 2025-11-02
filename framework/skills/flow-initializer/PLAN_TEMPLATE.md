# PLAN.md Template

Complete template for PLAN.md used during project initialization.

## Template Structure

```markdown
# [PROJECT_NAME]

**Flow Framework Reference**: This project uses [Flow framework](https://github.com/liadgoren/flow) - a human-in-loop development methodology combining Domain-Driven Design with Agile philosophy.

---

## Overview

### Purpose
[WHY_THIS_PROJECT_EXISTS]

### Goals
[HIGH_LEVEL_OUTCOMES_NOT_CHECKLISTS]

Examples:
- Achieve [specific outcome]
- Enable [capability]
- Deliver [value]

### Scope

**V1 (Current)**:
[CORE_FEATURES_FOR_FIRST_VERSION]

Examples:
- Basic [feature]
- Essential [capability]
- Minimal [component]

**V2 (Future)**:
[DEFERRED_FEATURES]

Examples:
- Advanced [feature]
- Enhanced [capability]
- Optional [component]

---

## Architecture

### System Design
[HIGH_LEVEL_ARCHITECTURE]

**Components**:
- **[COMPONENT_NAME]**: [RESPONSIBILITY]
- **[COMPONENT_NAME]**: [RESPONSIBILITY]

**Data Flow**:
[HOW_DATA_MOVES_THROUGH_SYSTEM]

### Key Technologies
- **[TECHNOLOGY_1]**: [WHY_CHOSEN]
- **[TECHNOLOGY_2]**: [WHY_CHOSEN]

### DO / DON'T Guidelines

**DO**:
- [BEST_PRACTICE_1]
- [BEST_PRACTICE_2]
- [BEST_PRACTICE_3]

**DON'T**:
- [ANTI_PATTERN_1]
- [ANTI_PATTERN_2]
- [ANTI_PATTERN_3]

---

## Testing Strategy

### Approach
[OVERALL_TESTING_PHILOSOPHY]

### Test Types
- **Unit Tests**: [WHAT_TO_UNIT_TEST]
- **Integration Tests**: [WHAT_TO_INTEGRATION_TEST]
- **E2E Tests**: [WHAT_TO_E2E_TEST]

### Coverage Goals
- Minimum [PERCENTAGE]% code coverage
- All [CRITICAL_PATHS] must have tests

---

## Development Phases

### Phase 1: [PHASE_NAME]
**Goal**: [PHASE_GOAL]

**Key Deliverables**:
- [DELIVERABLE_1]
- [DELIVERABLE_2]

### Phase 2: [PHASE_NAME]
**Goal**: [PHASE_GOAL]

**Key Deliverables**:
- [DELIVERABLE_1]
- [DELIVERABLE_2]

### Phase 3: [PHASE_NAME]
**Goal**: [PHASE_GOAL]

**Key Deliverables**:
- [DELIVERABLE_1]
- [DELIVERABLE_2]

---

## Notes

[ADDITIONAL_CONTEXT_IF_NEEDED]
```

## Placeholders Explained

| Placeholder | Example Value | Notes |
|------------|---------------|-------|
| `[PROJECT_NAME]` | "WebSocket Chat App" | From user input |
| `[WHY_THIS_PROJECT_EXISTS]` | "Enable real-time communication between users in a web browser" | Purpose statement |
| `[HIGH_LEVEL_OUTCOMES_NOT_CHECKLISTS]` | "Achieve sub-100ms message latency" | Goals (no checkboxes!) |
| `[CORE_FEATURES_FOR_FIRST_VERSION]` | "1-to-1 messaging, online status, message history" | V1 scope |
| `[DEFERRED_FEATURES]` | "Group chats, file sharing, voice calls" | V2 scope |
| `[COMPONENT_NAME]` | "WebSocket Server", "Message Queue" | Architecture components |
| `[TECHNOLOGY_1]` | "Socket.IO" | Tech stack |
| `[WHY_CHOSEN]` | "Real-time bidirectional communication" | Justification |
| `[BEST_PRACTICE_1]` | "Use connection pooling for database" | DO guideline |
| `[ANTI_PATTERN_1]` | "Don't store messages in server memory" | DON'T guideline |
| `[OVERALL_TESTING_PHILOSOPHY]` | "Test-driven development for business logic" | Testing approach |
| `[PHASE_GOAL]` | "Establish working real-time connection" | Why this phase |
| `[DELIVERABLE_1]` | "WebSocket server accepting connections" | Phase output |

## Usage Notes

**Use [TBD] for unknown values** - Don't guess, mark as "to be determined"

**Sections that can be [TBD] initially**:
- Architecture > System Design (will be designed during brainstorming)
- Architecture > DO/DON'T Guidelines (will emerge during development)
- Testing Strategy (can be defined in Phase 1)

**Sections that should be filled from user input**:
- Purpose (extract from project description)
- Goals (extract from user's stated objectives)
- Scope V1 (core features mentioned)
- Scope V2 (if user mentions "later" or "future" features)
- Key Technologies (if user specifies tech stack)

## Example: Filled PLAN.md

**User Input**: "WebSocket chat with Node.js and React"

```markdown
# WebSocket Chat App

**Flow Framework Reference**: This project uses [Flow framework](https://github.com/liadgoren/flow) - a human-in-loop development methodology combining Domain-Driven Design with Agile philosophy.

---

## Overview

### Purpose
Enable real-time communication between users through a web-based chat interface.

### Goals
- Achieve sub-100ms message delivery latency
- Support concurrent users without performance degradation
- Provide persistent message history

### Scope

**V1 (Current)**:
- 1-to-1 messaging
- Online/offline status indicators
- Message history persistence
- Basic authentication

**V2 (Future)**:
- Group chat rooms
- File sharing
- Voice/video calls
- Message reactions

---

## Architecture

### System Design
[TBD - Will be documented during brainstorming]

### Key Technologies
- **Node.js**: Server runtime for JavaScript backend
- **Socket.IO**: Real-time bidirectional event-based communication
- **React**: Frontend UI library for component-based interface
- **PostgreSQL**: [TBD - if mentioned, otherwise fill during design]

### DO / DON'T Guidelines

**DO**:
- [TBD - Will be defined during development]

**DON'T**:
- [TBD - Will be defined during development]

---

## Testing Strategy

[TBD - Will be defined in Phase 1]

---

## Development Phases

### Phase 1: Backend
**Goal**: Establish server infrastructure and real-time communication

### Phase 2: Frontend
**Goal**: Build user interface and client-side connection

---

## Notes

[None yet]
```
