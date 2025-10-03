# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **Flow Framework** - a spec-driven iterative development methodology that combines Domain-Driven Design principles with Agile philosophy. The framework helps developers build complex features with minimal refactoring through structured planning and iterative implementation.

## Key Commands

### Building the Distribution
```bash
# Regenerate flow.sh from source files in framework/
./build-standalone.sh
```

### Deploying the Framework
```bash
# Install Flow framework to a project (self-contained)
./flow.sh [--force]
```

## Architecture

### Three-Part System

1. **`flow.sh`** (~63KB, 2200+ lines)
   - Self-contained deployment script
   - Contains all framework content embedded via heredocs
   - This is what gets distributed to end users
   - No external dependencies required

2. **`framework/` directory** (source files)
   - `DEVELOPMENT_FRAMEWORK.md` - Complete methodology documentation
   - `EXAMPLE_PLAN.md` - Reference example (payment gateway project)
   - `SLASH_COMMANDS.md` - All 20 slash command definitions

3. **Build system**
   - `build-standalone.sh` - Generates `flow.sh` from sources
   - Uses heredoc embedding to create self-contained script

### Distribution Model

**Key principle**: `flow.sh` is the ONLY file needed for distribution. All framework content is embedded within it.

When users run `flow.sh` in their project:
- Extracts 20 slash commands to `.claude/commands/`
- Extracts framework docs to `.flow/` directory
- Everything is self-contained - no network requests or external files needed

## Development Workflow

### Editing the Framework

1. Edit source files in `framework/` directory:
   - `DEVELOPMENT_FRAMEWORK.md` for methodology changes
   - `EXAMPLE_PLAN.md` for reference example updates
   - `SLASH_COMMANDS.md` for command definitions

2. Rebuild the distribution:
   ```bash
   ./build-standalone.sh
   ```

3. Test the generated `flow.sh` in a test project

### Build Script Mechanism

`build-standalone.sh` works by:
1. Creating shell script header with helper functions
2. Embedding `SLASH_COMMANDS.md` between `COMMANDS_DATA_EOF` heredoc markers
3. Embedding `DEVELOPMENT_FRAMEWORK.md` between `FRAMEWORK_DATA_EOF` heredoc markers
4. Embedding `EXAMPLE_PLAN.md` between `EXAMPLE_DATA_EOF` heredoc markers
5. Appending main deployment logic footer
6. Setting executable permissions on output

The extraction functions (`extract_command`, `get_framework_content`, `get_example_content`) use awk to parse heredoc content at runtime.

## Framework Philosophy

**Core Metaphor**: Building a human body
- **Skeleton** - Basic structure and foundation
- **Veins** - Core data flow and connections
- **Flesh** - Incremental complexity
- **Fibers** - Refinement and optimization

**Hierarchy**: `PHASE → TASK → ITERATION → BRAINSTORM → IMPLEMENTATION`

### Key Patterns

1. **Plan File as Memory** - `PLAN.md` preserves all context across sessions
2. **Brainstorm Before Code** - Design decisions upfront reduce refactoring
3. **Progressive Disclosure** - Focus only on what's needed now, defer complexity to V2/V3
4. **State Preservation** - Checkboxes (✅ ⏳ 🚧 🎨) track progress
5. **Dynamic Planning** - Add brainstorming subjects on-the-fly as insights emerge

## Slash Commands

All commands use `flow-` prefix to avoid conflicts:

**Planning**: `/flow-blueprint`
**Structure**: `/flow-phase`, `/flow-task`, `/flow-iteration`
**Brainstorming**: `/flow-brainstorm_start`, `/flow-brainstorm_subject`, `/flow-brainstorm_resolve`, `/flow-brainstorm_complete`
**Implementation**: `/flow-implement_start`, `/flow-implement_complete`
**Navigation**: `/flow-status`, `/flow-next`, `/flow-next-subject`, `/flow-next-iteration`, `/flow-rollback`

### Command Patterns

Every command MUST:
1. Read `DEVELOPMENT_FRAMEWORK.md` first (searches `.claude/`, project root, or `~/.claude/flow/`)
2. Find and parse `PLAN.md` to understand current state
3. Follow framework patterns exactly (status markers, section structure)
4. Update `PLAN.md` according to conventions
5. Provide clear next steps to user

## Flow Framework Integration

### Automatic Detection

**When working in ANY project, if you detect `.flow/PLAN.md` exists:**

1. **STOP** before making any structural changes to PLAN.md
2. **READ** `DEVELOPMENT_FRAMEWORK.md` from one of these locations (in order):
   - `.flow/DEVELOPMENT_FRAMEWORK.md` (project-specific)
   - `.claude/DEVELOPMENT_FRAMEWORK.md` (project root)
   - `./DEVELOPMENT_FRAMEWORK.md` (project root)
   - `~/.claude/flow/DEVELOPMENT_FRAMEWORK.md` (global installation)
3. **UNDERSTAND** the framework patterns before editing PLAN.md
4. **FOLLOW** the framework conventions exactly

### Detection Rules

```
IF file_exists('.flow/PLAN.md'):
    THEN project_uses_flow = TRUE
    THEN read_framework_guide()
    THEN follow_flow_conventions()
```

**Flow-managed projects have**:
- `.flow/PLAN.md` - Main plan file (Flow manages this)
- `.flow/DEVELOPMENT_FRAMEWORK.md` - Framework methodology docs
- `.claude/commands/flow-*.md` - 23 slash commands for Flow operations

### Framework Consultation Requirements

**Before making ANY changes to .flow/PLAN.md, consult these framework sections:**

#### For Plan Structure Changes
- **Section**: "Framework Structure" (DEVELOPMENT_FRAMEWORK.md, ~lines 105-180)
- **Learn**: PHASE → TASK → ITERATION → BRAINSTORM → IMPLEMENTATION hierarchy
- **Never**: Create wrong hierarchy (e.g., iterations directly under phases)

#### For Status Markers
- **Section**: "Status Markers" (DEVELOPMENT_FRAMEWORK.md, ~lines 1872-1968)
- **Learn**: ✅ COMPLETE, ⏳ PENDING, 🚧 IN PROGRESS, 🎨 READY, ❌ CANCELLED, 🔮 FUTURE, 🎯 ACTIVE
- **Never**: Invent new status markers or use wrong markers

#### For Brainstorming
- **Section**: "Brainstorming Session Pattern" (DEVELOPMENT_FRAMEWORK.md, ~lines 1167-1797)
- **Learn**: Subject resolution types (A: Pre-Task, B: Documentation, C: Auto-Resolved, D: Iteration Items)
- **Learn**: When to use `/flow-brainstorm-start`, `/flow-next-subject`, `/flow-brainstorm-complete`
- **Never**: Skip brainstorming for complex tasks

#### For Task Structure
- **Section**: "Task Structure Rules" (DEVELOPMENT_FRAMEWORK.md, ~lines 238-566)
- **Learn**: Golden Rule - Standalone OR Iterations, Never Both
- **Learn**: Pattern 1 (Standalone Task with action items) vs Pattern 2 (Task with iterations, NO action items)
- **Never**: Mix task action items AND iterations in same task

#### For Implementation
- **Section**: "Implementation Pattern" (DEVELOPMENT_FRAMEWORK.md, ~lines 1798-1836)
- **Learn**: Pre-implementation tasks vs iteration work
- **Learn**: When to mark iteration 🎨 READY vs 🚧 IN PROGRESS
- **Never**: Start implementation before brainstorming is ✅ COMPLETE

#### For Complete Workflow
- **Section**: "Complete Flow Workflow" (DEVELOPMENT_FRAMEWORK.md, ~lines 614-940)
- **Learn**: 11-step workflow from blueprint to completion
- **Learn**: Decision trees for common questions
- **Learn**: Command reference by workflow phase

### Quick Reference Guide

**Section**: "Quick Reference Guide" (DEVELOPMENT_FRAMEWORK.md, ~lines 3223-3602)

**Use this section for**:
- Decision Tree 4: What subject resolution type is this? (A/B/C/D)
- Decision Tree 5: What command do I run next?
- Status Marker Reference (all 7 markers with lifecycle examples)
- Command Cheat Sheet (23 commands organized by frequency)
- Common Pattern Templates (4 copy-paste ready templates)

### Common Tasks → Framework Sections

| Task | Framework Section | Lines | What to Learn |
|------|-------------------|-------|---------------|
| Creating new PLAN.md | Plan File Template | 2363-2560 | Template structure, required sections |
| Adding phase | Development Workflow | 567-613 | Phase naming, purpose, scope |
| Adding task | Task Structure Rules | 238-566 | Standalone vs iterations decision |
| Adding iteration | Development Workflow | 567-613 | Iteration goals, action items |
| Starting brainstorm | Brainstorming Session Pattern | 1167-1797 | Subject creation, resolution types |
| Resolving subject | Subject Resolution Types | 1215-1313 | Types A/B/C/D, when to use each |
| Completing iteration | Implementation Pattern | 1798-1836 | Verification, completion criteria |
| Updating status | Status Markers | 1872-1968 | Correct marker usage, lifecycle |
| Lost/confused | Complete Flow Workflow | 614-940 | Decision trees, command reference |

### AI Behavior Expectations

**When you detect Flow usage (`flow/PLAN.md` exists):**

✅ **DO**:
- Read DEVELOPMENT_FRAMEWORK.md before any PLAN.md edits
- Follow exact framework patterns (structure, markers, sections)
- Use slash commands for Flow operations (don't edit PLAN.md directly for state changes)
- Consult Quick Reference Guide for common questions
- Reference specific framework sections when explaining patterns

❌ **DON'T**:
- Edit PLAN.md structure without reading framework first
- Invent new status markers or section structures
- Mix task patterns (standalone + iterations in same task)
- Skip brainstorming for complex tasks
- Make assumptions about Flow patterns (read the framework!)

### Example: Detecting Flow and Consulting Framework

```markdown
User: "Add a new task to the PLAN.md"

AI Response:
1. [Detects .flow/PLAN.md exists]
2. [Reads DEVELOPMENT_FRAMEWORK.md]
3. [Consults "Task Structure Rules" section (lines 238-566)]
4. [Asks user]: "Should this task be:
   - **Standalone** (with direct action items, no iterations), or
   - **Task with Iterations** (no direct action items, only iterations)?

   See DEVELOPMENT_FRAMEWORK.md lines 238-566 for the Golden Rule."
5. [Based on answer, follows correct pattern from framework]
```

## Important Design Decisions

### Why Single-File Distribution?
- **Portability** - One file to share, no dependencies
- **Reliability** - No network requests, no missing files
- **Simplicity** - Users just run `./flow.sh`

### Why Separate Source Files?
- **Maintainability** - Easier to edit markdown than heredoc-embedded content
- **Version Control** - Clean diffs on source files
- **Development** - Can view/edit in proper markdown editors

### Pre-Implementation Tasks Pattern
- Discovered during real-world usage (RED plan file)
- Document during brainstorming but complete BEFORE starting main implementation
- Use case: refactoring, system-wide changes, bug fixes discovered during design

### Bugs Discovered Pattern
- Document bugs found in reference implementations during brainstorming
- Shows thorough analysis and prevents reintroducing bugs
- Include location, problem code, fix, and impact

## File Locations

- **README.md** - Overview, quick start, design decisions
- **flow.sh** - Generated distribution file (DO NOT EDIT DIRECTLY)
- **build-standalone.sh** - Build system (edit if changing build process)
- **framework/DEVELOPMENT_FRAMEWORK.md** - Complete methodology (910 lines)
- **framework/EXAMPLE_PLAN.md** - Payment gateway reference example (509 lines)
- **framework/SLASH_COMMANDS.md** - All 15 command definitions (725 lines)
- **.claude/settings.local.json** - Permissions for build script

## Testing Changes

After editing framework sources:

1. Run build: `./build-standalone.sh`
2. Check output size/lines are reasonable
3. Create test project directory
4. Run `./flow.sh` in test project
5. Verify `.claude/commands/` has 15 files
6. Verify `.flow/` has 2 documentation files
7. Test a command like `/flow-status` to ensure content is correct

## Contributing

For detailed contribution guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md). Key points:

- **For Users**: Just download and run `flow.sh` - no fork needed
- **For Contributors**: Fork the repo, edit `framework/` files (NOT `flow.sh` directly), rebuild with `./build-standalone.sh`, then submit PR
- **Commit Format**: Use `[Type]: Short description` format (Add/Fix/Update/Refactor/Docs)
- **Philosophy**: Maintain principles of plan-before-code, context preservation, iterative refinement
- **Big Changes**: Open an issue first to discuss major architectural changes

### Distribution URL

Users can download the framework directly:
```bash
wget https://raw.githubusercontent.com/khgs2411/flow/master/flow.sh
chmod +x flow.sh
./flow.sh
```

## Version History

- **V1.0** (2025-10-01) - Initial release
  - Single-file distribution
  - 20 slash commands
  - Pre-implementation tasks pattern
  - Bugs discovered pattern
  - Dynamic subject addition
  - Example PLAN.md included

## Credits

- **Created by**: Liad Goren
- **Inspired by**: Real-world usage on RED RPG skill generation system
- **Philosophy**: Domain-Driven Design + Agile + Extreme Programming
