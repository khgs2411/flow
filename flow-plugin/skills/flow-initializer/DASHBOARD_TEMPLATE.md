# DASHBOARD.md Template

Complete template for DASHBOARD.md used during project initialization.

## Template Structure

```markdown
# [PROJECT_NAME] - Dashboard

**Last Updated**: [TIMESTAMP]
**Project**: [ONE_LINE_DESCRIPTION]
**Status**: [CURRENT_PHASE_STATUS]
**Version**: V1

---

## 📍 Current Work

- **Phase**: [Phase N - PHASE_NAME](phase-N/)
- **Task**: [Task M - TASK_NAME](phase-N/task-M.md)
- **Status**: [STATUS_EMOJI] [STATUS_TEXT]
- **Next**: [NEXT_ACTION_GUIDANCE]

---

## 📊 Progress Overview

### Phase 1: [PHASE_NAME] [STATUS_EMOJI] [STATUS]

**Goal**: [PHASE_GOAL]
**Status**: [PHASE_STATUS_DESCRIPTION]

**Tasks**:
- [STATUS_EMOJI] **Task 1**: [TASK_NAME] ([COMPLETED_ITERATIONS]/[TOTAL_ITERATIONS] iterations)
  - [BRIEF_TASK_DESCRIPTION]
- [STATUS_EMOJI] **Task 2**: [TASK_NAME] ([COMPLETED_ITERATIONS]/[TOTAL_ITERATIONS] iterations)
  - [BRIEF_TASK_DESCRIPTION]

### Phase 2: [PHASE_NAME] [STATUS_EMOJI] [STATUS]

**Goal**: [PHASE_GOAL]
**Status**: [PHASE_STATUS_DESCRIPTION]

**Tasks**:
- [STATUS_EMOJI] **Task 1**: [TASK_NAME] ([COMPLETED_ITERATIONS]/[TOTAL_ITERATIONS] iterations)
  - [BRIEF_TASK_DESCRIPTION]

---

## 📈 Completion Status

**Overall Progress**: [PERCENTAGE]%

### By Phase
- Phase 1: [PERCENTAGE]% ([COMPLETED]/[TOTAL] tasks)
- Phase 2: [PERCENTAGE]% ([COMPLETED]/[TOTAL] tasks)

### By Status
- ✅ Complete: [COUNT] tasks ([PERCENTAGE]%)
- 🚧 In Progress: [COUNT] tasks ([PERCENTAGE]%)
- ⏳ Pending: [COUNT] tasks ([PERCENTAGE]%)

---

## 💡 Key Decisions

[ARCHITECTURAL_DECISIONS_IF_ANY]

**Decision Needed**: [QUESTION]
- Option A: [OPTION_A_DESCRIPTION]
- Option B: [OPTION_B_DESCRIPTION]
- **Recommendation**: [RECOMMENDATION_WITH_REASONING]

**Resolved**:
- **[DATE]**: [DECISION_TITLE] - [DECISION_SUMMARY]

---

## 🎯 Success Criteria

**Phase 1 Complete When**:
- [CRITERION_1]
- [CRITERION_2]
- [CRITERION_3]

**Phase 2 Complete When**:
- [CRITERION_1]
- [CRITERION_2]

---

## 📚 Related Resources

- **Flow Framework**: .flow/framework/DEVELOPMENT_FRAMEWORK.md
- **Slash Commands**: .flow/framework/SLASH_COMMANDS.md
- **[EXTERNAL_RESOURCE]**: [URL]
```

## Placeholders Explained

| Placeholder | Example Value | Notes |
|------------|---------------|-------|
| `[PROJECT_NAME]` | "WebSocket Chat App" | From user input |
| `[TIMESTAMP]` | "2025-11-02T14:30:00" | ISO format |
| `[ONE_LINE_DESCRIPTION]` | "Real-time chat with Socket.IO" | Brief summary |
| `[CURRENT_PHASE_STATUS]` | "Phase 1 in progress" | Current state |
| `[PHASE_NAME]` | "Foundation", "Core Features" | From user input |
| `[STATUS_EMOJI]` | ✅ or 🚧 or ⏳ | Based on actual status |
| `[STATUS]` | "COMPLETE", "IN PROGRESS", "PENDING" | Text status |
| `[PHASE_GOAL]` | "Establish basic server infrastructure" | Why this phase exists |
| `[TASK_NAME]` | "Set up Express server" | Specific task |
| `[COMPLETED_ITERATIONS]` | "2" | Number done |
| `[TOTAL_ITERATIONS]` | "4" | Total planned |
| `[PERCENTAGE]` | "67" | Calculated percentage |
| `[NEXT_ACTION_GUIDANCE]` | "Use flow-planner to begin Task 1" | What to do next |

## Usage Notes

**MUST fill** (required):
- `[PROJECT_NAME]`
- `[TIMESTAMP]`
- `[PHASE_NAME]` for Phase 1
- `[TASK_NAME]` for Task 1

**SHOULD fill** (if available):
- `[PHASE_GOAL]` for each phase
- `[TASK_OVERVIEW]` for each task

**CAN defer** (use in Progress Overview):
- Key Decisions (if no decisions yet)
- Multiple phases (if starting with one)
- Completion Status percentages (calculate after setup)

## Example: Filled DASHBOARD.md for New Project

**User Input**: "Create Flow project for WebSocket chat app with 2 phases: 1. Backend (server + database), 2. Frontend (React UI)"

**Filled Template**:
```markdown
# WebSocket Chat App - Dashboard

**Last Updated**: 2025-11-02T14:30:00
**Project**: Real-time chat application with WebSocket support
**Status**: Phase 1 in progress
**Version**: V1

---

## 📍 Current Work

- **Phase**: [Phase 1 - Backend](phase-1/)
- **Task**: [Task 1 - Server Setup](phase-1/task-1.md)
- **Status**: ⏳ PENDING - Ready to start
- **Next**: Use flow-planner to begin Task 1

---

## 📊 Progress Overview

### Phase 1: Backend ⏳ PENDING

**Goal**: Establish server infrastructure and database
**Status**: Not started

**Tasks**:
- ⏳ **Task 1**: Server Setup (0/2 iterations)
  - Create Express server with WebSocket support
- ⏳ **Task 2**: Database Integration (0/2 iterations)
  - Set up PostgreSQL and schema

### Phase 2: Frontend ⏳ PENDING

**Goal**: Build user interface for chat
**Status**: Not started (blocked by Phase 1)

**Tasks**:
- ⏳ **Task 1**: React UI (0/3 iterations)
  - Create chat interface components

---

## 🎯 Success Criteria

**Phase 1 Complete When**:
- WebSocket server accepting connections
- Database storing messages
- Basic API endpoints working

**Phase 2 Complete When**:
- Chat UI renders messages
- Users can send/receive messages in real-time
- Message history loads from database

---

## 📚 Related Resources

- **Flow Framework**: .flow/framework/DEVELOPMENT_FRAMEWORK.md
- **Slash Commands**: .flow/framework/SLASH_COMMANDS.md
```
