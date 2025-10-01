# Flow Framework - Domain-Driven Design with Agile Iterative Philosophy

**Version**: 1.0
**Created**: 2025-10-01
**Status**: Ready for deployment

---

## 🚀 Quick Start (30 seconds)

**Just cloned this repo? Here's how to use it:**

```bash
# Make flow.sh executable (one-time setup)
chmod +x flow.sh

# Run it in YOUR project directory
cd /path/to/your/project
~/path/to/flow-repo/flow.sh

# That's it! Framework is now installed in your project.
```

**What just happened?**
- ✅ Created `.claude/commands/` with 15 slash commands
- ✅ Created `.flow/` with framework documentation
- ✅ Your project is ready to use Flow!

**Need to reinstall or update?**
```bash
# Use --force to overwrite existing files
./flow.sh --force
```

---

## Overview

The Flow framework is a spec-driven iterative development methodology that combines Domain-Driven Design principles with Agile philosophy. It helps developers build complex features with minimal refactoring by:

- **Planning before coding** through structured brainstorming sessions
- **Iterating in small, testable increments** (skeleton → veins → flesh → fibers)
- **Preserving context** in a PLAN.md file that survives across sessions
- **Enforcing patterns** through slash commands that update the plan automatically

---

## What's New (V1.0)

✅ **Single File Distribution** - `flow.sh` is self-contained with all framework content embedded (~63KB)
✅ **Clean Structure** - Source files organized in `framework/` directory
✅ **Build System** - `build-standalone.sh` regenerates distribution from sources
✅ **Portable Framework** - Auto-locates in `.flow/`, `.claude/`, or `~/.claude/flow/`
✅ **Automated Deployment** - One command (`./flow.sh`) installs everything
✅ **Example PLAN.md** - Complete mock example showing full workflow
✅ **No Dependencies** - Universal bash script, works everywhere
✅ **Bugs Discovered Pattern** - Document bugs found during brainstorming
✅ **Improvements Tracking** - Track what you improved over originals
✅ **Dynamic Subject Addition** - Add brainstorming subjects on-the-fly

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

```bash
# 1. Start new feature
/flow-blueprint RPG skill generation engine

# 2. Begin first iteration (created by blueprint)
/flow-brainstorm_start Template Parsing Design

# 3. Add subjects to discuss
/flow-brainstorm_subject Placeholder Syntax
/flow-brainstorm_subject Mutation vs Immutable
/flow-brainstorm_subject Parser Architecture

# 4. Resolve subjects one by one
/flow-brainstorm_resolve Placeholder Syntax
# (Answer prompts for decision, rationale, action items)

/flow-next-subject  # Move to next subject
/flow-brainstorm_resolve Mutation vs Immutable
# ...continue for all subjects

# 5. Complete any pre-implementation tasks
# (Refactoring, system-wide changes, etc.)

# 6. Close brainstorming
/flow-brainstorm_complete

# 7. Begin implementation
/flow-implement_start
# (Work through action items, check them off)

# 8. Complete iteration
/flow-implement_complete

# 9. Move to next iteration
/flow-next-iteration
# ...repeat!
```

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
- Discovered during real-world usage (RED plan file)
- Common need: refactoring/setup before main work
- Ensures brainstorming fully complete before implementation starts

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
**Inspired by**: Real-world usage on RED RPG skill generation system
**Philosophy**: Domain-Driven Design + Agile + Extreme Programming principles
**AI Partner**: Claude (Anthropic) via Claude Code

---

## License

Open for personal and commercial use. Attribution appreciated but not required.

---

**"Build the skeleton first, then add flesh."**

*- Flow Framework Manifesto*
