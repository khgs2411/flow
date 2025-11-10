# Flow Framework

**Iterative Design-Driven Development where humans drive, AI executes.**

_You make the decisions. AI implements within your framework. Context is never lost._

[![Version](https://img.shields.io/badge/version-1.3.0-blue.svg)](https://github.com/khgs2411/flow/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](#license)

---

## Table of Contents

- [Philosophy](#philosophy)
- [Installation](#installation)
- [Core Workflow](#core-workflow)
- [The Iteration Structure](#the-iteration-structure)
- [Core Principles](#core-principles)
- [File Structure](#file-structure)
- [Example Session](#example-session)
- [Why Flow Works](#why-flow-works)
- [Key Features](#key-features)
- [Common Use Cases](#common-use-cases)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Support](#support)

---

## Philosophy

Flow is **human-in-loop development** that leverages AI as an execution engine, not a decision maker.

**The human drives. The AI executes.**

Traditional AI: You prompt → Wait → Hope → Refactor when it fails → Lose context between sessions.

Flow: You design → AI implements → You verify → Iterate with preserved context.

---

## Installation

### Option 1: Claude Code Plugin (Recommended)

```bash
# Add Flow marketplace
/plugin marketplace add khgs2411/flow

# Install plugin
/plugin install flow@topsyde-utils
```

### Option 2: Standalone Script

```bash
# Download and run in your project
curl -O https://raw.githubusercontent.com/khgs2411/flow/master/flow.sh
chmod +x flow.sh
./flow.sh
```

Both methods install:
- **28 slash commands** in `.claude/commands/` (AI workflow helpers)
- **8 agent skills** in `.claude/skills/` (specialized AI assistants)
- **Framework reference** in `.flow/framework/` (methodology guide)
- **Examples** in `.flow/framework/examples/` (templates)

---

## Core Workflow

Flow follows a simple loop:

```
1. Install           → flow.sh or plugin
2. Blueprint         → /flow-blueprint (create project structure)
3. Start Phase/Task  → /flow-phase-start or /flow-task-start
4. Iterate:
   a. Brainstorm     → /flow-brainstorm-start
                     → /flow-brainstorm-review
                     → /flow-brainstorm-complete
      OR
   b. Implement      → /flow-implement-start (skip brainstorming)
5. Complete          → /flow-implement-complete
6. Finish Task       → /flow-task-complete (when all iterations done)
7. Finish Phase      → /flow-phase-complete (when all tasks done)
```

### Management Commands

At any point, you can:

- **Add structure**: `/flow-phase-add`, `/flow-task-add`, `/flow-iteration-add`
- **Check status**: `/flow-status`, `/flow-next`, `/flow-summarize`
- **Manage scope**: `/flow-backlog-add`, `/flow-backlog-view`, `/flow-backlog-pull`
- **Archive work**: `/flow-plan-split`, `/flow-compact`
- **Verify accuracy**: `/flow-verify-plan`

---

## The Iteration Structure

**"Build the skeleton first, then add flesh."** — Flow Framework

### Progressive Refinement

Flow uses a body-building metaphor for iterations:

- **V1 - Skeleton**: Basic structure, happy path only
- **V2 - Veins**: Core data flow, error handling
- **V3 - Flesh**: Edge cases, optimization
- **V4 - Fibers**: Polish, performance tuning

Each iteration follows the same pattern: **brainstorm** → **implement** → **complete**.

---

## Core Principles

### 1. Human-in-Loop Decision Making

**You control architecture. AI executes within your framework.**

- Humans make design decisions
- AI implements according to those decisions
- Every decision is documented with rationale
- Context never lost between sessions

### 2. Progressive Iteration

**Build incrementally with clear scope boundaries.**

- Break work into small, manageable iterations
- Each iteration: one focused goal
- Brainstorm before implementing (or skip if trivial)
- Complete one iteration before starting next

### 3. Separation of Concerns

**Dashboard (progress) vs Plan (architecture) vs Tasks (work).**

```
.flow/
├── DASHBOARD.md      → Single source of truth for current work
├── PLAN.md           → Static architecture, testing, constraints
└── phase-N/task-M.md → Detailed iterations with action items
```

- **DASHBOARD.md**: Where am I? What's next? Progress overview.
- **PLAN.md**: High-level architecture, testing strategy, DO/DON'Ts.
- **Task files**: Brainstorming, action items, implementation notes.

### 4. Scope Boundary Enforcement

**If you discover NEW work outside current scope: STOP and DISCUSS.**

Flow enforces scope boundaries:
- AI stops when discovering unplanned work
- User decides: handle now, defer, or create new iteration
- No surprise scope creep
- Explicit user approval required

### 5. Flexible Structure Management

**Add, remove, archive, defer work as project evolves.**

- Add phases/tasks/iterations dynamically
- Move work to backlog when priorities shift
- Archive completed phases to reduce noise
- Pull backlog items when ready

---

## File Structure

```
your-project/
├── .claude/
│   ├── commands/          # 28 slash commands
│   │   ├── flow-blueprint.md
│   │   ├── flow-brainstorm-start.md
│   │   ├── flow-implement-start.md
│   │   └── ... (25 more)
│   └── skills/            # 8 agent skills
│       ├── flow-navigator/
│       ├── flow-planner/
│       ├── flow-builder/
│       ├── flow-designer/
│       ├── flow-completer/
│       ├── flow-verifier/
│       ├── flow-curator/
│       └── flow-initializer/
│
└── .flow/
    ├── DASHBOARD.md       # Progress tracking (single source of truth)
    ├── PLAN.md            # Static context (architecture, scope)
    ├── phase-1/
    │   ├── task-1.md
    │   └── task-2.md
    ├── phase-2/
    │   └── task-1.md
    └── framework/         # Reference docs (AI reads these)
        ├── DEVELOPMENT_FRAMEWORK.md
        ├── SLASH_COMMANDS.md
        └── examples/
```

**Key principle**: You own `.flow/DASHBOARD.md`, `.flow/PLAN.md`, and task files. AI reads `framework/` for patterns but **never decides your architecture**.

---

## Example Session

```bash
# 1. Install
./flow.sh

# 2. Create project structure
/flow-blueprint "Payment Gateway Integration
1. Setup Stripe client
2. Implement webhook handler
3. Add error handling
Testing: Unit tests for each module"

# 3. Start first phase - this can be skipped by using /flow-task-start directly
/flow-phase-start

# 4. Start first task
/flow-task-start

# 5. Brainstorm first iteration - Optional, can skip to implementation if trivial
/flow-brainstorm-start "API design, error codes, retry strategy"

# (AI presents subjects for discussion)
/flow-next-subject
# (Discuss, document decision)
/flow-next-subject
# (Repeat until all subjects resolved)

# 6. Review decisions
/flow-brainstorm-review
# (AI categorizes pre-tasks vs implementation work)

# 7. Mark ready for implementation
/flow-brainstorm-complete

# 8. Implement
/flow-implement-start
# (Work through action items, check off as complete)

# 9. Complete iteration
/flow-implement-complete

# 10. Check status
/flow-status
# Shows: Phase 1, Task 1, Iteration 2 (next up)

# 11. Continue with next iteration...
```

---

## Why Flow Works

### Traditional AI Development Problems

- **Context loss**: AI forgets design between sessions
- **Refactoring hell**: AI decides architecture, you fix it later
- **No structure**: Everything is a prompt, no progression
- **Lost decisions**: Why did we choose X? Nobody remembers.

### How Flow Solves This

- **Persistent context**: All decisions in `.flow/PLAN.md`, never lost
- **Human-driven architecture**: You decide, AI implements
- **Structured progression**: Phases → Tasks → Iterations
- **Documented rationale**: Every decision has "why" documented
- **Scope control**: AI stops and asks when finding unplanned work
- **Flexible management**: Add, defer, archive work dynamically

---

## Key Features

- ✅ **Human-in-loop**: You make decisions, AI executes
- ✅ **Zero context loss**: Framework persists between sessions
- ✅ **Progressive refinement**: Build skeleton → veins → flesh → fibers
- ✅ **Scope boundaries**: AI stops when discovering new work
- ✅ **Dashboard-first**: Always know where you are
- ✅ **Flexible structure**: Add/remove/defer work as project evolves
- ✅ **Backlog management**: Defer low-priority work
- ✅ **Archive functionality**: Reduce noise from completed work
- ✅ **Verification**: Check plan matches codebase reality
- ✅ **28 slash commands**: Full workflow automation
- ✅ **8 agent skills**: Specialized AI assistants

---

## Common Use Cases

### Start New Project
```bash
/flow-blueprint "Your project description with phases"
/flow-phase-start
/flow-task-start
```

### Add Work Mid-Project
```bash
/flow-phase-add "New Phase Name"
/flow-task-add "New Task Name"
/flow-iteration-add "New Iteration Name"
```

### Defer Low-Priority Work
```bash
/flow-backlog-add
# (AI moves selected tasks to backlog)

/flow-backlog-view
# (See what's deferred)

/flow-backlog-pull "Task 5"
# (Bring back when ready)
```

### Clean Up Completed Work
```bash
/flow-plan-split
# (Archive old completed phases)

/flow-summarize
# (Get bird's eye view of project)
```

### Verify Accuracy
```bash
/flow-verify-plan
# (Check DASHBOARD matches task files)

/flow-status
# (See current position and progress)
```

---

## Documentation

- **[CONTRIBUTING.md](CONTRIBUTING.md)**: How to contribute to Flow
- **[CHANGELOG.md](CHANGELOG.md)**: Version history and changes
- **`.flow/framework/DEVELOPMENT_FRAMEWORK.md`**: Complete methodology (3,900 lines)
- **`.flow/framework/SLASH_COMMANDS.md`**: All 28 command definitions
- **`.flow/framework/examples/`**: Reference examples for AI learning

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- How to fork and edit framework files
- Build and test process
- Release workflow
- Coding standards

---

## Support

- **Issues**: [GitHub Issues](https://github.com/khgs2411/flow/issues)
- **Discussions**: [GitHub Discussions](https://github.com/khgs2411/flow/discussions)
- **Examples**: See `.flow/framework/examples/` after installation

---

**Flow: Iterative Design-Driven Development**

_Where humans design, AI executes, and context is never lost._
