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
   - `SLASH_COMMANDS.md` - All 15 slash command definitions

3. **Build system**
   - `build-standalone.sh` - Generates `flow.sh` from sources
   - Uses heredoc embedding to create self-contained script

### Distribution Model

**Key principle**: `flow.sh` is the ONLY file needed for distribution. All framework content is embedded within it.

When users run `flow.sh` in their project:
- Extracts 15 slash commands to `.claude/commands/`
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

## Version History

- **V1.0** (2025-10-01) - Initial release
  - Single-file distribution
  - 15 slash commands
  - Pre-implementation tasks pattern
  - Bugs discovered pattern
  - Dynamic subject addition
  - Example PLAN.md included

## Credits

- **Created by**: Liad Goren
- **Inspired by**: Real-world usage on RED RPG skill generation system
- **Philosophy**: Domain-Driven Design + Agile + Extreme Programming
