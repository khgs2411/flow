# Migration Patterns

Detailed patterns for converting various documentation formats to Flow's multi-file structure.

## Pattern 1: PRD → Flow

### Source Format (PRD.md)
```markdown
# Product Requirements Document

## Overview
Build a real-time chat application...

## Goals
- Enable real-time messaging
- Support multiple users
- Persist chat history

## Requirements

### Phase 1: Backend
- [ ] Set up Express server
- [ ] Configure WebSocket
- [x] Database schema

### Phase 2: Frontend
- [ ] Chat UI
- [ ] User authentication

## Technical Design
Using Node.js with Socket.IO...

## Out of Scope
- Voice calls (V2)
- File sharing (V2)
```

### Conversion Strategy

**Extract sections**:
- Overview → PLAN.md Purpose
- Goals → PLAN.md Goals (remove checkboxes, keep text only)
- Requirements → Phase directories + task files
- Technical Design → PLAN.md Architecture
- Out of Scope → PLAN.md Scope (V2 section)

**Map structure**:
- "Phase 1: Backend" → `.flow/phase-1/`
- Tasks under Phase 1 → `phase-1/task-1.md`, `phase-1/task-2.md`, etc.
- `[x]` marker → ✅ COMPLETE status
- `[ ]` marker → ⏳ PENDING status

**Result**:
```
.flow/
├── DASHBOARD.md (shows Phase 1, Task 3 in progress)
├── PLAN.md (Purpose, Goals, Architecture, Scope with V2)
├── phase-1/
│   ├── task-1.md (Set up Express server - COMPLETE)
│   ├── task-2.md (Configure WebSocket - PENDING)
│   └── task-3.md (Database schema - COMPLETE)
└── phase-2/
    ├── task-1.md (Chat UI - PENDING)
    └── task-2.md (User authentication - PENDING)
```

## Pattern 2: TODO.md → Flow

### Source Format (TODO.md)
```markdown
# TODO

## Done
- [x] Create project structure
- [x] Set up TypeScript config

## In Progress
- [>] Implement API client
  - [x] Basic HTTP methods
  - [ ] Error handling
  - [ ] Retry logic

## Pending
- [ ] Add tests
- [ ] Write documentation
- [ ] Deploy to production

## Later
- [ ] Add caching
- [ ] Implement rate limiting
```

### Conversion Strategy

**Group into phases** (ask user if unclear):
```
Phase 1: Foundation (Done items)
Phase 2: Core Implementation (In Progress items)
Phase 3: Finalization (Pending items)
```

**Convert "In Progress" item with sub-items** → Task with iterations:
```markdown
# Task 1: Implement API Client

## Iterations

### ✅ Iteration 1: Basic HTTP methods
**Status**: ✅ COMPLETE

### 🚧 Iteration 2: Error handling
**Status**: 🚧 IN PROGRESS

### ⏳ Iteration 3: Retry logic
**Status**: ⏳ PENDING
```

**"Later" items** → BACKLOG.md

**Result**:
```
.flow/
├── DASHBOARD.md (shows Phase 2, Task 1, Iteration 2 in progress)
├── PLAN.md (minimal - fill [TBD] for Purpose/Architecture)
├── BACKLOG.md (caching, rate limiting)
├── phase-1/
│   ├── task-1.md (Project structure - COMPLETE)
│   └── task-2.md (TypeScript config - COMPLETE)
├── phase-2/
│   └── task-1.md (API client with 3 iterations, iteration 2 in progress)
└── phase-3/
    ├── task-1.md (Tests - PENDING)
    ├── task-2.md (Documentation - PENDING)
    └── task-3.md (Deploy - PENDING)
```

## Pattern 3: Flat PLAN.md → Flow

### Source Format (Single-File PLAN.md)
```markdown
# Project Plan

Purpose: Build chat app

## Phase 1
- Task 1: Server setup [DONE]
- Task 2: WebSocket integration [IN PROGRESS]
  - Iteration 1: Basic connection [DONE]
  - Iteration 2: Room support [WIP]
  - Iteration 3: Error handling [TODO]

## Phase 2
- Task 1: Frontend
- Task 2: Testing

V2: Video calls, file sharing
```

### Conversion Strategy

**Split single file into multi-file**:
- Static content → PLAN.md
- Progress tracking → DASHBOARD.md
- Tasks → phase-N/task-M.md files

**Preserve hierarchy**:
- Phase 1 → `phase-1/`
- Task 1 → `phase-1/task-1.md`
- Iterations stay within task file

**Map status markers**:
- [DONE] → ✅ COMPLETE
- [IN PROGRESS], [WIP] → 🚧 IN PROGRESS
- [TODO], no marker → ⏳ PENDING

**Result**:
```
.flow/
├── DASHBOARD.md (current: Phase 1, Task 2, Iteration 2)
├── PLAN.md (Purpose, Scope V1/V2)
├── phase-1/
│   ├── task-1.md (Server setup - COMPLETE)
│   └── task-2.md (WebSocket integration - IN PROGRESS with 3 iterations)
└── phase-2/
    ├── task-1.md (Frontend - PENDING)
    └── task-2.md (Testing - PENDING)
```

## Pattern 4: Unstructured Notes → Flow

### Source Format (DEVELOPMENT.md)
```markdown
# Development Notes

I want to build a chat app with real-time messaging.

Key features:
- Multiple users can chat
- Messages persist in database
- Use Socket.IO for real-time

Architecture ideas:
- Node.js backend
- React frontend
- PostgreSQL database

Need to figure out:
- Authentication strategy
- Scaling approach
- Testing plan
```

### Conversion Strategy

**Show preview and ask**:
```
"I found unstructured notes. I can:

A) Extract key points and suggest this structure:
   - Phase 1: Backend (Node.js + Socket.IO + PostgreSQL)
   - Phase 2: Frontend (React + real-time integration)
   - Phase 3: Production (auth + scaling + testing)

B) Create a basic single-phase plan with 5 tasks

C) Let's start fresh with blueprint instead

Which approach?"
```

**If option A** (extract and structure):
- Features → Task names
- Architecture ideas → PLAN.md Architecture section (mark as [TBD] if incomplete)
- "Need to figure out" → Brainstorming subjects or [TBD] markers

**If option B** (basic plan):
- Create Phase 1 with tasks based on main points
- Mark most fields as [TBD]

**If option C** (start fresh):
- Switch to blueprint path (get structured input from user)

**Result (Option A)**:
```
.flow/
├── DASHBOARD.md (Phase 1, Task 1 ready to start)
├── PLAN.md (Purpose: real-time chat, Architecture: Node.js + React + PostgreSQL)
├── phase-1/
│   ├── task-1.md (Backend API - Node.js + Socket.IO)
│   └── task-2.md (Database - PostgreSQL setup)
├── phase-2/
│   ├── task-1.md (Frontend - React UI)
│   └── task-2.md (Real-time integration)
└── phase-3/
    ├── task-1.md (Authentication - [TBD strategy])
    ├── task-2.md (Scaling - [TBD approach])
    └── task-3.md (Testing - [TBD plan])
```

## Pattern 5: Multi-File Project with Scattered Docs → Flow

### Source Format (Multiple Files)
```
project/
├── README.md (overview, goals)
├── ARCHITECTURE.md (technical design)
├── TODO.md (task list)
└── ROADMAP.md (phases, timeline)
```

### Conversion Strategy

**Discover all relevant files**:
```
Found multiple doc files:
1. README.md (overview, goals)
2. ARCHITECTURE.md (technical design)
3. TODO.md (12 tasks)
4. ROADMAP.md (3 phases)

Which should I use as primary source? (number or 'combine all')
```

**If "combine all"**:
- README.md Overview → PLAN.md Purpose
- README.md Goals → PLAN.md Goals
- ARCHITECTURE.md → PLAN.md Architecture
- TODO.md → Task files
- ROADMAP.md → Phase structure

**Result**:
```
.flow/
├── DASHBOARD.md (synthesized from TODO + ROADMAP)
├── PLAN.md (Purpose from README, Architecture from ARCHITECTURE.md)
├── phase-1/ (from ROADMAP Phase 1)
├── phase-2/ (from ROADMAP Phase 2)
└── phase-3/ (from ROADMAP Phase 3)
```

## Status Marker Conversion Reference

### Common Markers in Existing Docs

| Source Marker | Flow Status | Flow Emoji |
|--------------|-------------|------------|
| `[x]`, `✓`, `✅` | COMPLETE | ✅ |
| `[>]`, `WIP`, `IN PROGRESS`, `DOING` | IN PROGRESS | 🚧 |
| `[ ]`, `TODO`, `PENDING` | PENDING | ⏳ |
| `READY`, `READY TO START` | READY | 🎨 |
| `CANCELLED`, `ABANDONED`, `DROPPED` | CANCELLED | ❌ |
| `DEFERRED`, `LATER`, `V2`, `FUTURE` | Move to BACKLOG or PLAN.md V2 | 🔮 |

### Ambiguous Markers

**If unclear, ask user**:
```
"Found marker '[~]' on 3 tasks. Should this be:
A) ⏳ PENDING (not started)
B) 🚧 IN PROGRESS (working on it)
C) Something else?"
```

## Section Mapping Reference

### Source Document → Flow Files

| Source Section | Flow Destination | Notes |
|---------------|------------------|-------|
| Overview, Summary, Purpose | PLAN.md Purpose | First section |
| Goals, Objectives | PLAN.md Goals | Remove checkboxes |
| Scope, V1, V2 | PLAN.md Scope | Split into V1/V2 |
| Architecture, Design, Technical | PLAN.md Architecture | Technical details |
| Testing, QA | PLAN.md Testing Strategy | How to verify |
| Phases, Milestones | DASHBOARD.md Progress | + phase-N/ directories |
| Tasks, Action Items | phase-N/task-M.md | Individual files |
| Current Work, Status | DASHBOARD.md Current Work | Pointer to current position |
| Later, Backlog, Deferred | BACKLOG.md | Optional file |
| History, Changelog | CHANGELOG.md | Optional file |

## Common Migration Issues

### Issue 1: Deeply Nested Tasks

**Problem**: Source has 4+ levels of nesting
```
- Phase 1
  - Feature A
    - Component A1
      - Function A1a
        - Test A1a1
```

**Solution**: Flatten to Flow's 3-level hierarchy (Phase → Task → Iteration)
```
Phase 1
├── Task 1: Feature A Component A1 (with iterations)
│   ├── Iteration 1: Implement Function A1a
│   └── Iteration 2: Add Tests
```

**Ask user if unclear**: "I see deep nesting. Should I flatten to 3 levels or group differently?"

### Issue 2: Mixed Status Indicators

**Problem**: Source uses inconsistent status markers
```
- [x] Task A
- DONE: Task B
- ✅ Task C
- Task D (complete)
```

**Solution**: Normalize to Flow's status markers (✅ 🚧 ⏳)
- All completed → ✅ COMPLETE
- Report normalization: "Normalized 4 different 'complete' markers to ✅ COMPLETE"

### Issue 3: Unclear Current Position

**Problem**: Source doesn't clearly indicate where work stopped
```
- Task A (done)
- Task B (done)
- Task C
- Task D
```

**Solution**: Ask user
```
"I see Tasks A-B are complete. Which task is current:
A) Task C (next in sequence)
B) Task D (different priority)
C) Still on Task B (not actually complete)
D) No current task (plan only)"
```

### Issue 4: Scope Creep in Single Section

**Problem**: Source has 50+ tasks in flat list with no structure

**Solution**: Propose grouping
```
"Found 52 tasks in flat list. I suggest grouping into phases:

Phase 1: Foundation (Tasks 1-12) - Setup and core infrastructure
Phase 2: Features (Tasks 13-38) - Main functionality
Phase 3: Polish (Tasks 39-52) - Testing, docs, deployment

Or should I ask you to define phases differently?"
```

## Validation Checklist

After migration, verify:

- [ ] DASHBOARD.md exists with "📍 Current Work" section
- [ ] PLAN.md exists with Purpose, Scope, Architecture sections
- [ ] At least one phase directory exists (phase-1/)
- [ ] At least one task file exists (phase-1/task-1.md)
- [ ] Current work pointer is valid (points to existing phase/task/iteration)
- [ ] All status markers are Flow format (✅ 🚧 ⏳)
- [ ] Completed tasks show ✅ COMPLETE
- [ ] In-progress tasks show 🚧 IN PROGRESS
- [ ] No orphaned tasks (all tasks belong to a phase)
- [ ] Backup of source file created
- [ ] V2 items captured (in PLAN.md Scope or BACKLOG.md)

## Migration Report Template

After successful migration, report:

```
✅ Migration complete!

**Source**: [original file/files]
**Backup**: [backup location]

**Created**:
- DASHBOARD.md
  - Current work: Phase [N], Task [M], Iteration [I]
  - Total progress: [X]% complete
- PLAN.md
  - Purpose: [extracted/[TBD]]
  - Architecture: [extracted/[TBD]]
  - Scope V1: [extracted]
  - Scope V2: [N items deferred]
- [N] phase directories
- [M] task files
- BACKLOG.md ([X] deferred items)

**Status Summary**:
- ✅ [N] tasks complete
- 🚧 [M] tasks in progress
- ⏳ [K] tasks pending

**Next Steps**:
1. Review DASHBOARD.md for accuracy
2. Fill in [TBD] markers in PLAN.md if needed
3. Use `/flow-task-start` to continue current work

Questions? Use `/flow-status` to see your position.
```
