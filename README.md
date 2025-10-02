# Flow Framework
## AI in the loop

*You design the architecture and iterations. AI executes within your framework. Context never gets lost.*

*Domain-Driven Design meets Agile Iterative Philosophy*

---

> **⚠️ Important**: This framework is designed for use with [Claude Code](https://claude.ai/code). The slash commands require Claude Code's command system. The methodology and PLAN.md patterns can be used manually with any AI, but automation features require Claude Code.

---

## Table of Contents

- [🚀 Quick Start](#-quick-start-30-seconds)
- [Overview](#overview)
- [What's New](#whats-new-v10)
- [Project Structure](#project-structure)
- [How It Works](#how-it-works)
- [Installation](#installation)
  - [For End Users](#-for-end-users-using-the-framework)
  - [For Developers](#-for-developers-improving-the-framework)
- [Example Workflow](#example-workflow)
- [Slash Commands Reference](#slash-commands-reference)
  - [Planning Commands](#planning-commands-1)
  - [Structure Commands](#structure-commands-3)
  - [Brainstorming Commands](#brainstorming-commands-4)
  - [Implementation Commands](#implementation-commands-2)
  - [Navigation Commands](#navigation-commands-5)
  - [Using Flow Without Commands](#using-flow-without-slash-commands)
- [Design Decisions](#design-decisions)
- [Key Insights](#key-insights-from-development)
- [Comparison to Other Frameworks](#comparison-to-other-frameworks)
- [Future Enhancements](#future-enhancements-v2)
- [Credits](#credits)
- [License](#license)

---

## 🚀 Quick Start (30 seconds)

**Just cloned this repo? Two ways to use it:**

### Option A: Run from Flow Repo (Recommended)

```bash
# 1. Make flow.sh executable (one-time setup)
chmod +x flow.sh

# 2. Run it from YOUR project directory
cd /path/to/your/project
~/path/to/flow-repo/flow.sh

# That's it! Framework is now installed.
```

### Option B: Copy to Your Project

```bash
# 1. Copy flow.sh to your project
cp flow.sh /path/to/your/project/

# 2. Run it there
cd /path/to/your/project
chmod +x flow.sh
./flow.sh

# You can delete flow.sh after installation if you want
```

**What just happened?**
- ✅ Created `.claude/commands/` with 20 slash commands
- ✅ Created `.flow/` with framework documentation
- ✅ Your project is ready to use Flow!

**Next Steps:**
- **New project**: Run `/flow-blueprint [description]` to create your plan
- **Existing project**: Run `/flow-migrate` to convert existing docs (PRD.md, PLAN.md, TODO.md, etc.)

**Need to reinstall or update?**
```bash
# Use --force to overwrite existing files
./flow.sh --force
```

**💡 Pro Tips:**

**Starting a New Session:**
1. Run `/flow-summarize` - Get the big picture (all phases/tasks/iterations)
2. Run `/flow-status` - Verify your current position (micro view)
3. Run `/flow-verify-plan` - Ensure PLAN.md matches actual code
4. Explicitly tell the AI where you are (e.g., "We're on Iteration 5")

**For Complex Projects (10+ iterations, V1/V2 splits, 2000+ lines):**
- Add a Progress Dashboard section after Architecture in your PLAN.md
- Provides always-visible mission control with jump links
- Commands verify dashboard matches status markers (smart verification skips completed items)
- See [DEVELOPMENT_FRAMEWORK.md](framework/DEVELOPMENT_FRAMEWORK.md#progress-dashboard-required-for-complex-projects) for template

This prevents confusion in large projects and enables token-efficient verification.

---

## Overview

The Flow framework is a spec-driven iterative development methodology that combines Domain-Driven Design principles with Agile philosophy. It helps developers build complex features with minimal refactoring by:

- **Planning before coding** through structured brainstorming sessions
- **Iterating in small, testable increments** (skeleton → veins → flesh → fibers)
- **Preserving context** in a `.flow/PLAN.md` file that survives across sessions
- **Mandatory status markers** at every level (Phase/Task/Iteration/Subject) for rigorous progress tracking
- **Enforcing patterns** through slash commands that update the plan automatically
- **Mid-development adoption** via `/flow-migrate` - convert existing PRD.md/PLAN.md/TODO.md to Flow format

---

## What's New in V1.0.5 🎉

### Major Features
- ✅ **`.flow/` Directory Standard** - Flow now manages plans from `.flow/PLAN.md` (single source of truth)
- ✅ **`/flow-migrate` Command** - Convert existing PRD.md, PLAN.md, TODO.md to Flow format mid-development
- ✅ **`/flow-blueprint` Enhanced** - Always creates fresh `.flow/PLAN.md`, ignoring existing plans
- ✅ **Smart Migration Paths** - Auto-detects structured/flat/unstructured docs and migrates intelligently
- ✅ **Backup System** - Migration creates timestamped backups of original files
- ✅ **Universal Compatibility** - Works with TaskMaster AI, Spec-Kit, and custom documentation

### Migration Features
- 🔍 **Auto-discovery** - Searches for PRD.md, PLAN.md, TODO.md, DEVELOPMENT.md, etc.
- 🧠 **Structure Detection** - Recognizes phases/tasks/iterations or flat lists
- 💾 **Content Preservation** - NEVER discards original content, only enhances with Flow formatting
- 🎯 **Three Migration Paths**:
  - **Structured** (has phases/tasks) → Enhance with Flow features
  - **Flat List** (todos) → Convert to Flow hierarchy
  - **Unstructured** (notes) → Extract concepts into brainstorming subjects

### Breaking Changes
- ⚠️ **PLAN.md location changed** from project root to `.flow/PLAN.md`
- ⚠️ All slash commands now read/write `.flow/PLAN.md`
- ⚠️ Use `/flow-migrate` to move existing plans to new location

---

## What's New in V1.0 (Previous Release)

### Core Features
- ✅ **Single File Distribution** - `flow.sh` is self-contained (~63KB, no dependencies)
- ✅ **Automated Deployment** - One command (`./flow.sh`) installs everything
- ✅ **Universal Compatibility** - Pure bash, works everywhere

### Framework Structure
- ✅ **Clean Organization** - Source files in `framework/` directory
- ✅ **Build System** - `build-standalone.sh` regenerates distribution
- ✅ **Portable** - Auto-locates in `.flow/`, `.claude/`, or `~/.claude/flow/`

### Development Patterns
- ✅ **Complete Example** - Mock payment gateway project in EXAMPLE_PLAN.md
- ✅ **Bugs Discovered Pattern** - Document bugs found during brainstorming
- ✅ **Improvements Tracking** - Track what you improved over originals
- ✅ **Dynamic Subject Addition** - Add brainstorming subjects on-the-fly

---

## Project Structure

```
flow/
├── README.md                    # This file - overview and guide
├── flow.sh                      # Self-contained deployment script (distribute this!)
├── build-standalone.sh          # Builds flow.sh from source files
└── framework/                   # Source files (for development)
    ├── DEVELOPMENT_FRAMEWORK.md # Complete methodology guide
    ├── EXAMPLE_PLAN.md          # Reference example (payment gateway)
    └── SLASH_COMMANDS.md        # All 15 slash command definitions
```

**For Distribution**: Share `flow.sh` - it's self-contained with everything embedded!

**For Development**: Edit files in `framework/`, then run `./build-standalone.sh` to regenerate `flow.sh`

---

## Contents

### 1. **flow.sh** (The Distribution File) ⭐
- **Purpose**: Single-file deployment script with all framework content embedded
- **Usage**: `./flow.sh [--force]`
- **Size**: ~63KB, 2200+ lines (includes all framework content)
- **What it does**: Installs slash commands to `.claude/commands/` and framework docs to `.flow/`
- **Requirements**: None - pure bash, no dependencies
- **Distribution**: Share this single file - no source files needed!

### 2. **build-standalone.sh** (The Build Script)
- **Purpose**: Generates `flow.sh` from source files in `framework/`
- **Usage**: `./build-standalone.sh`
- **When to run**: After editing any file in `framework/` directory
- **Output**: Creates/updates `flow.sh` with latest framework content

### 3. **framework/** (The Source Files)

#### 3a. **DEVELOPMENT_FRAMEWORK.md** (The Methodology)
- **Purpose**: Complete methodology documentation
- **Audience**: Developers and AI agents
- **Sections**: Philosophy, workflow, patterns, best practices, examples

#### 3b. **EXAMPLE_PLAN.md** (The Reference)
- **Purpose**: Complete example showing Flow in action
- **Feature**: Mock "Payment Gateway Integration" project
- **Shows**: Full workflow from brainstorming → implementation → completion

#### 3c. **SLASH_COMMANDS.md** (The Command Definitions)
- **Purpose**: All 15 slash command definitions
- **Commands**: Planning (1), Structure (3), Brainstorming (4), Implementation (2), Navigation (5)

---

## How It Works

**The framework has three interconnected parts:**

1. **`flow.sh`** - Self-contained installer (what you distribute)
2. **Documentation** - Installed to `.flow/` directory in your project
3. **Slash Commands** - Installed to `.claude/commands/` directory

**When you run `flow.sh` in your project:**
- Creates `.claude/commands/` and `.flow/` directories
- Extracts 15 slash commands from embedded data
- Writes DEVELOPMENT_FRAMEWORK.md and EXAMPLE_PLAN.md to `.flow/`
- All content is embedded in flow.sh - no external files needed!

**Cross-References (the magic):**
- Framework guide references example: "See `.flow/EXAMPLE_PLAN.md`"
- Example references framework: "See `.flow/DEVELOPMENT_FRAMEWORK.md`"
- Slash commands reference framework: "Read DEVELOPMENT_FRAMEWORK.md..."
- Everything works together seamlessly!

---

## Quick Start

### 🚀 For End Users (Using the Framework)

**Two ways to get `flow.sh`:**

#### Option A: Direct Download (Recommended - No Git Needed)

```bash
# Navigate to your project directory
cd /path/to/your/project

# Download flow.sh directly
curl -O https://raw.githubusercontent.com/khgs2411/flow/master/flow.sh
chmod +x flow.sh

# Run it to install the framework
./flow.sh
```

**Options:**
- `./flow.sh` - Install framework (skips existing files)
- `./flow.sh --force` - Reinstall/update (overwrites existing files)

#### Option B: Clone Once, Copy Anywhere

```bash
# Clone the repo once (to a shared location)
git clone https://github.com/khgs2411/flow.git ~/flow-framework

# Copy flow.sh to any project
cp ~/flow-framework/flow.sh /path/to/your/project/
cd /path/to/your/project
./flow.sh
```

**Important:** You are NOT tied to the cloned repo! The `flow.sh` file is self-contained and can be copied anywhere. Your project has no connection to the Flow repo after installation.

**What gets installed:**
```
your-project/
├── .claude/commands/          # 15 slash commands
│   ├── flow-blueprint.md
│   ├── flow-phase.md
│   └── ... (13 more)
└── .flow/                     # Framework documentation
    ├── DEVELOPMENT_FRAMEWORK.md
    └── EXAMPLE_PLAN.md
```

**Next steps:**
1. Restart Claude Code (if running)
2. Run: `/flow-blueprint <your-feature-name>`
3. Read: `.flow/DEVELOPMENT_FRAMEWORK.md`
4. Reference: `.flow/EXAMPLE_PLAN.md`

---

### 🛠️ For Developers (Improving the Framework)

**If you want to modify the framework itself:**

```bash
# 1. Edit source files in framework/ directory
vim framework/DEVELOPMENT_FRAMEWORK.md
vim framework/EXAMPLE_PLAN.md
vim framework/SLASH_COMMANDS.md

# 2. Rebuild the distribution file
./build-standalone.sh

# 3. Now flow.sh has your changes embedded
# Share the updated flow.sh with others!
```


---

## Example Workflow

**Real-world scenario**: Building a real-time collaborative text editor

### 1. Create the Blueprint

```bash
/flow-blueprint Real-time collaborative text editor with conflict resolution
```

**What happens**: Creates `PLAN.md` with phases, tasks, and iteration placeholders.

### 2. Start First Iteration

```bash
/flow-brainstorm_start Conflict Resolution Architecture
```

**What happens**: Marks iteration as "In Progress", creates brainstorming section.

### 3. Add Subjects During Discussion

```bash
/flow-brainstorm_subject Data Structure (CRDT vs OT)
/flow-brainstorm_subject WebSocket vs WebRTC
/flow-brainstorm_subject Offline Support Strategy
```

**What happens**: Subjects added to "Subjects to Discuss" list with ⏳ status.

### 4. Resolve Each Subject

```bash
/flow-brainstorm_resolve Data Structure (CRDT vs OT)
```

**Prompts you for**:
- Decision: "Use CRDT (Conflict-free Replicated Data Types)"
- Rationale: "Better eventual consistency, no central server needed, proven with Yjs library"
- Action items: "Research Yjs library, prototype basic CRDT implementation, benchmark performance"

**What happens**: Subject marked ✅, decision documented with rationale and action items.

```bash
/flow-next-subject  # Shows next unresolved subject
/flow-brainstorm_resolve WebSocket vs WebRTC
# ...continue for remaining subjects
```

### 5. Handle Pre-Implementation Tasks

During brainstorming, you realize the current network layer needs refactoring:

```bash
# Document it (don't implement yet!)
# Add to PLAN.md:
### Pre-Implementation Tasks:
#### ⏳ Task 1: Refactor Network Layer
**Objective**: Extract network logic into separate module before adding WebSocket support
**Action Items**:
- [ ] Create NetworkManager interface
- [ ] Extract existing HTTP code
- [ ] Add tests for network layer
```

**Then complete the tasks** before moving forward.

### 6. Complete Brainstorming

```bash
/flow-brainstorm_complete
```

**What happens**: Checks all subjects resolved and pre-tasks done, marks iteration 🎨 Ready.

### 7. Implement

```bash
/flow-implement_start
```

**What happens**: Creates implementation section with all action items from brainstorming.

Work through the code, checking off action items as you complete them:
- [x] Research Yjs library
- [x] Prototype basic CRDT implementation
- [x] Benchmark performance
- ...

### 8. Complete Iteration

```bash
/flow-implement_complete
```

**What happens**: Marks iteration ✅ Complete, asks for verification notes, updates task/phase if all iterations done.

### 9. Move to Next Iteration

```bash
/flow-next-iteration
```

**What happens**: Shows next pending iteration or prompts to create one.

---

**The Power**: Your PLAN.md now contains complete context - all decisions, rationale, pre-tasks, implementations, and verifications. Anyone (including a different AI) can pick up from where you left off.

---

## Slash Commands Reference

Flow provides 18 slash commands organized into 5 categories. **Important**: These are convenience tools - the real power is the methodology. You can use Flow WITHOUT commands by manually following the patterns.

### Planning Commands (1)

**`/flow-blueprint <feature-name>`**
- Creates initial PLAN.md with skeleton structure
- Generates phases, tasks, and iteration placeholders
- Asks about reference implementations to analyze
- **Manual alternative**: Copy EXAMPLE_PLAN.md template, adapt to your feature

### Structure Commands (3)

**`/flow-phase <phase-name>`**
- Adds new phase to PLAN.md (e.g., "Testing", "Polish")
- **Manual**: Add `### Phase N: Name ⏳` section

**`/flow-task <task-name>`**
- Adds new task under current phase
- **Manual**: Add `#### Task N: Name ⏳` under phase

**`/flow-iteration <iteration-name>`**
- Adds new iteration under current task
- **Manual**: Add `##### Iteration N: Name ⏳` under task

### Brainstorming Commands (4)

**`/flow-brainstorm_start <topic>`**
- Begins brainstorming session for current iteration
- Marks iteration as 🚧 In Progress
- Creates "Subjects to Discuss" section
- **Manual**: Add brainstorming section with subject list

**`/flow-brainstorm_subject <subject-name>`**
- Adds subject to discussion list
- Supports dynamic subject addition during brainstorming
- **Manual**: Add `N. ⏳ Subject Name` to subject list

**`/flow-brainstorm_resolve <subject>`**
- Prompts for decision, rationale, action items
- Marks subject ✅ Complete
- Documents resolution in "Resolved Subjects"
- **Manual**: Move subject to resolved, add decision/rationale/actions

**`/flow-brainstorm_complete`**
- Checks all subjects resolved
- Verifies pre-implementation tasks done
- Marks iteration 🎨 Ready for Implementation
- **Manual**: Check subjects complete, update status to 🎨

### Implementation Commands (2)

**`/flow-implement_start`**
- Begins implementation phase
- Copies action items from brainstorming
- Marks iteration 🚧 In Progress
- **Manual**: Create implementation section, copy action items

**`/flow-implement_complete`**
- Marks iteration ✅ Complete
- Prompts for verification notes
- Auto-updates task/phase if all complete
- **Manual**: Check off items, add verification, update to ✅

### Navigation Commands (8)

**`/flow-status`**
- Shows current phase/task/iteration (micro view - "where am I now?")
- Displays progress percentage
- Suggests next command
- Detects conflicting status sections
- **Manual**: Scan PLAN.md for current 🚧 items

**`/flow-summarize`**
- Shows entire project structure (macro view - "what's the whole picture?")
- Hierarchical Phase → Task → Iteration breakdown
- Completion percentages at each level
- Compact, scannable format with grouped items
- Handles V1/V2/V3 version splits
- **Use for**: Bird's eye view, progress reports, project health check
- **Manual**: Read entire PLAN.md, create outline with percentages

**`/flow-next`**
- Auto-detects context, suggests next step
- Smart helper for "what do I do now?"
- **Manual**: Look at status markers, decide next action

**`/flow-next-subject`**
- Shows next unresolved brainstorming subject
- **Manual**: Find first ⏳ subject in list

**`/flow-next-iteration`**
- Shows next pending iteration
- **Manual**: Find next ⏳ iteration

**`/flow-rollback`**
- Undoes last PLAN.md change
- **Manual**: Git revert or manual edit

**`/flow-verify-plan`**
- Verifies PLAN.md is synced with actual project state
- Checks completed items exist in codebase
- Reports discrepancies and unreported work
- Updates PLAN.md to match reality if needed
- **Use before**: New AI session or conversation compacting
- **Manual**: Review action items, check files exist, use git status

**`/flow-compact`**
- Generates comprehensive context transfer report
- Summarizes decisions, progress, challenges, next steps
- Enables zero-context-loss handoff to new AI instance
- Focuses on current feature, not generic project info
- **Use before**: Compacting conversation or starting new session
- **Manual**: Read entire conversation, write summary notes

### Using Flow WITHOUT Slash Commands

**The methodology is the core**, not the commands. You can:

1. **Copy EXAMPLE_PLAN.md** as template
2. **Follow the patterns**:
   - Phase → Task → Iteration → Brainstorm → Implement
   - Use status markers (⏳ 🚧 🎨 ✅)
   - Document decisions with rationale
   - Handle pre-implementation tasks
3. **Reference DEVELOPMENT_FRAMEWORK.md** when stuck
4. **Update PLAN.md manually** as you work

**Commands are automation** - they enforce patterns and update PLAN.md consistently. But the real magic is:
- Planning before coding
- Documenting WHY, not just WHAT
- Context preservation in PLAN.md
- Explicit pre-implementation tasks

You can achieve all of this by manually following the framework patterns. Commands just make it faster and more consistent.

---

## Design Decisions

### Why `/flow-blueprint` instead of `/flow-init`?
- "blueprint" evokes architecture and planning
- More descriptive of what the command does (creates skeleton structure)
- Less generic than "init" (avoids conflicts)

### Why split `/flow-next` into `/flow-next-subject` and `/flow-next-iteration`?
- **Explicit is better than guessing** - user controls the flow
- `/flow-next` remains as a smart helper (context-aware suggestions)
- Clear intent: "I want to move to next subject" vs "I want to move to next iteration"

### Why mandatory framework reference in commands?
- Ensures AI understands patterns and structure
- Maintains coherence across all commands
- Allows framework to evolve (commands always read latest version)

### Why pre-implementation pattern?
- Emerged organically during real development - while brainstorming a complex feature, it became clear that existing code needed refactoring first
- Common scenario: "We can't implement this cleanly until we fix/refactor X"
- Prevents starting implementation with unresolved dependencies
- Ensures brainstorming is truly complete before coding begins

---

## Key Insights from Development

1. **The plan file is memory** - Enables resuming work across sessions, AI handoffs, and long-term projects
2. **Brainstorm before code** - Upfront design decisions drastically reduce refactoring
3. **Skeleton → Flesh** - Building incrementally with strong foundations prevents architectural rewrites
4. **Pre-implementation tasks** - Often needed, should be part of the pattern
5. **Explicit commands** - Better to have `/flow-next-subject` than AI guessing context
6. **Document bugs discovered** - Finding bugs during design prevents introducing them later
7. **Track improvements** - Documenting what you improved shows value and prevents regression
8. **Dynamic brainstorming** - Subjects emerge during discussion; framework supports adding them on-the-fly

---

## Comparison to Other Frameworks

### vs Spec-Kit (GitHub)
- Spec-Kit: Test-driven specifications
- Flow: Iterative planning with brainstorming sessions
- Synergy: Could use both (Flow for planning, Spec-Kit for testing)

### vs Traditional Agile
- Agile: Sprints, stories, backlogs
- Flow: Phases, tasks, iterations with embedded brainstorming
- Flow adds: Plan file as single source of truth, slash command automation

### vs Waterfall
- Waterfall: All planning upfront, then execution
- Flow: Planning AND execution are interleaved (brainstorm per iteration)
- Flow adds: Flexibility to discover and adapt

---

## Future Enhancements (V2)

Potential additions to consider:

- [ ] **`/flow-visualize`** - Generate visual diagram of plan structure
- [ ] **`/flow-export`** - Export plan to PDF/HTML for sharing
- [ ] **`/flow-compare`** - Compare plan vs actual implementation (drift detection)
- [ ] **`/flow-template`** - Save common patterns as reusable templates
- [ ] **`/flow-checkpoint`** - Create snapshots for experimentation
- [ ] **Multi-plan support** - Work on multiple features simultaneously
- [ ] **Team features** - Assign tasks, track who's working on what
- [ ] **Integration** - GitHub issues, Jira, Linear, etc.

---

## Credits

**Created by**: Liad Goren

**Inspired by**: Real-world experience building a complex game engine feature. The patterns emerged organically through iterative development with Claude Code, revealing what actually works when AI and humans collaborate on complex software.

**Philosophy**: Domain-Driven Design + Agile + Extreme Programming principles

**AI Partner**: Claude (Anthropic) via Claude Code

---

## License

Open for personal and commercial use. Attribution appreciated but not required.

---

**"Build the skeleton first, then add flesh."**

*- Flow Framework Manifesto*
