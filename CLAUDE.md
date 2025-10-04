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
   - `SLASH_COMMANDS.md` - All 25 slash command definitions

3. **Build system**
   - `build-standalone.sh` - Generates `flow.sh` from sources
   - Uses heredoc embedding to create self-contained script

### Distribution Model

**Key principle**: `flow.sh` is the ONLY file needed for distribution. All framework content is embedded within it.

When users run `flow.sh` in their project:
- Extracts 25 slash commands to `.claude/commands/`
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

Commands are categorized into two types based on framework reading requirements:

#### Category A Commands (11 commands) - Quick Reference Required
These commands require framework knowledge to execute correctly:
- `/flow-blueprint`, `/flow-migrate`, `/flow-plan-update`
- `/flow-task-add`, `/flow-iteration-add`
- `/flow-brainstorm-start`, `/flow-brainstorm-subject`, `/flow-next-subject`, `/flow-brainstorm-review`, `/flow-brainstorm-complete`
- `/flow-verify-plan`

**Reading pattern for Category A**:
1. **Quick Reference (once per session)**: If Quick Reference (lines 1-353) is NOT already in context, read it first. If it's already been read in this session, skip to step 2.
2. **Use section index** to find relevant deep-dive section if needed
3. **Read ONLY that section** using Read(offset, limit) - never read entire 3897-line file
4. **Example**: For brainstorming, read lines 1167-1797 for Brainstorming Session Pattern

#### Category B Commands (14 commands) - NO FRAMEWORK READING REQUIRED
These commands work entirely from PLAN.md structure:
- `/flow-status` ✅ REFERENCE MODEL - Dashboard-first approach
- `/flow-summarize`, `/flow-phase-add`, `/flow-phase-start`, `/flow-phase-complete`
- `/flow-task-start`, `/flow-task-complete`
- `/flow-implement-start`, `/flow-implement-complete`
- `/flow-next`, `/flow-next-iteration`, `/flow-rollback`, `/flow-compact`, `/flow-plan-split`

**Reading pattern for Category B**:
1. **NO framework reading required** - work from PLAN.md only
2. Use Dashboard-first or grep-based approaches
3. Optional background reading if curious, but NOT required for execution

### Framework Reading Strategy (Three-Layer Approach)

**IMPORTANT**: NEVER read the entire 3897-line DEVELOPMENT_FRAMEWORK.md file. Use this three-layer strategy:

**Layer 1: Quick Reference (Read once per session if not in context)**
- Lines 1-353: Quick Reference Guide
- Contains: Decision trees, command cheat sheet, status markers, common patterns
- **Read once per session** for Category A commands (if not already in context, skip if already read)

**Layer 2: Section Index (FIND RELEVANT SECTION)**
- Use Quick Reference section index to locate relevant deep-dive section
- Example sections:
  - Framework Structure (lines 105-179)
  - Task Structure Rules (lines 238-566)
  - Brainstorming Session Pattern (lines 1167-1797)
  - Implementation Pattern (lines 1798-1836)

**Layer 3: Deep Dive (READ ONLY WHAT'S NEEDED)**
- Use Read(offset=X, limit=Y) to read ONLY the specific section
- Example: `Read(offset=1167, limit=631)` for Brainstorming Session Pattern
- Never read more than 600 lines at once

**Prohibited Pattern**:
❌ `Read("DEVELOPMENT_FRAMEWORK.md")` - This reads ALL 3897 lines (wasteful!)
✅ `Read("DEVELOPMENT_FRAMEWORK.md", offset=1, limit=353)` - Quick Reference only
✅ `Read("DEVELOPMENT_FRAMEWORK.md", offset=1167, limit=631)` - Specific section

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
- `.claude/commands/flow-*.md` - 25 slash commands for Flow operations

### Framework Consultation Requirements

**Use the three-layer reading strategy above. Quick lookup table:**

| What You Need | Read This | Lines | How to Read |
|---------------|-----------|-------|-------------|
| Plan Structure Changes | Framework Structure | 105-179 | Read(offset=105, limit=75) |
| Status Markers | Status Markers | 1872-1968 | In Quick Reference (lines 1-353) |
| Brainstorming | Brainstorming Pattern | 1167-1797 | Read(offset=1167, limit=631) |
| Task Structure | Task Structure Rules | 238-566 | Read(offset=238, limit=329) |
| Implementation | Implementation Pattern | 1798-1836 | Read(offset=1798, limit=39) |
| Complete Workflow | Complete Flow Workflow | 614-940 | Read(offset=614, limit=327) |
| Quick Decisions | Quick Reference Guide | 1-353 | Read(offset=1, limit=353) |

**Key Learning Points (from Quick Reference)**:
- **Hierarchy**: PHASE → TASK → ITERATION → BRAINSTORM → IMPLEMENTATION
- **Status Markers**: ✅ COMPLETE, ⏳ PENDING, 🚧 IN PROGRESS, 🎨 READY, ❌ CANCELLED, 🔮 FUTURE, 🎯 ACTIVE
- **Task Golden Rule**: Standalone OR Iterations, Never Both
- **Subject Resolution Types**: A (Pre-Task), B (Documentation), C (Auto-Resolved), D (Iteration Items)
- **Implementation Gate**: Brainstorming must be ✅ COMPLETE before starting implementation

### Quick Reference Guide

**Section**: "Quick Reference Guide" (DEVELOPMENT_FRAMEWORK.md, ~lines 3223-3602)

**Use this section for**:
- Decision Tree 4: What subject resolution type is this? (A/B/C/D)
- Decision Tree 5: What command do I run next?
- Status Marker Reference (all 7 markers with lifecycle examples)
- Command Cheat Sheet (25 commands organized by frequency)
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

**When you detect Flow usage (`.flow/PLAN.md` exists):**

✅ **DO**:
- Use three-layer reading strategy (Quick Reference → Section Index → Deep Dive)
- Read Quick Reference (lines 1-353) once per session for Category A commands (if not already in context)
- Use Dashboard-first/grep-based approaches for Category B commands
- Follow exact framework patterns (structure, markers, sections)
- Use slash commands for Flow operations (don't edit PLAN.md directly for state changes)
- Reference specific framework sections when explaining patterns

❌ **DON'T**:
- Read entire 3897-line DEVELOPMENT_FRAMEWORK.md file (use offset/limit!)
- Re-read Quick Reference if already in context from earlier in the session
- Read framework for Category B commands (use PLAN.md only)
- Invent new status markers or section structures
- Mix task patterns (standalone + iterations in same task)
- Skip brainstorming for complex tasks

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
- **framework/SLASH_COMMANDS.md** - All 25 command definitions
- **.claude/settings.local.json** - Permissions for build script

## Testing Changes

After editing framework sources:

1. Run build: `./build-standalone.sh`
2. Check output size/lines are reasonable
3. Create test project directory
4. Run `./flow.sh` in test project
5. Verify `.claude/commands/` has 25 files
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
  - 25 slash commands
  - Pre-implementation tasks pattern
  - Bugs discovered pattern
  - Dynamic subject addition
  - Example PLAN.md included

## Credits

- **Created by**: Liad Goren
- **Inspired by**: Real-world usage on RED RPG skill generation system
- **Philosophy**: Domain-Driven Design + Agile + Extreme Programming
